using System.Collections.Generic;
using UnityEngine;
using GTS.Nodes;
using GTS.Tools;
using System;
using GTS.UI.Tabs;
using GTS.UI.Inspector;

namespace GTS.Edges
{
    public class Edge : GraphObject
    {
        public event Action<Edge> Destroyed;

        [SerializeField] private Node startNode;
        [SerializeField] private Node endNode;

        public Node StartNode => startNode;
        public Node EndNode   => endNode;

        public Color EdgeColor
        {
            get { return color; }
        }

        public float EdgeScale
        {
            get { return scale; }
        }


        private LineRenderer lr;
        private EdgeCollider2D edgeCollider;

        // private const float scaleModifier = 0.1f;

        // -------------------------------------------------------
        // New: hook into ToolManager so we can toggle collider
        // -------------------------------------------------------
        private void OnEnable()
        {
            ToolManager.OnActiveToolChanged += HandleToolChanged;
            HandleToolChanged(ToolManager.ActiveTool); // apply current tool immediately
        }

        private void OnDisable()
        {
            ToolManager.OnActiveToolChanged -= HandleToolChanged;
        }

        private void HandleToolChanged(Tool tool)
        {
            // Edges should only be "clickable" when Trash is active
            if (edgeCollider != null)
            {
                edgeCollider.enabled = (tool == Tool.Trash || tool == Tool.Select);
            }
        }
        // -------------------------------------------------------

        new protected void Awake()
        {
            if (TabButton.ActiveButton == null)
            {
                Destroy(this.gameObject);
                return;
            }

            TabButton.ActiveButton.TabData.RegisterEdge(this);

            // Default edge thickness
            scale = 0.25f;
            minScale = 0.05f;
            scaleModifier = 1f;

            base.Awake();

            lr = GetComponentInChildren<LineRenderer>();
            if (lr == null)
            {
                Debug.LogWarning("Edge: No LineRenderer found in children.", this);
            }
            else
            {
                lr.positionCount = 2;
                lr.useWorldSpace = true;
            }

            edgeCollider = GetComponent<EdgeCollider2D>();
            if (edgeCollider == null)
            {
                edgeCollider = gameObject.AddComponent<EdgeCollider2D>();
            }

            // Apply initial scale and positions
            SetScale(scale);
            UpdateLineImmediate();

            // Make sure collider state matches current tool on creation
            HandleToolChanged(ToolManager.ActiveTool);
            SetLabel("");
            Inspector.ObjectSelected(this);
        }

        private void OnDestroy()
        {
            if (startNode)
            {
                startNode.Destroyed -= NodeDeleted;
            }
            if (endNode)
            {
                endNode.Destroyed -= NodeDeleted;
            }

            Destroyed?.Invoke(this);
        }

        override public void SetColor(Color c)
        {
            base.SetColor(c);
            lr.startColor = lr.endColor = color;
        }

        new protected void OnMouseDown()
        {
            base.OnMouseDown();
            // Only ever reachable if edgeCollider.enabled == true (Trash tool)
            if (ToolManager.ActiveTool == Tool.Trash)
            {
                Destroy(gameObject);
            }
        }

        private void OnMouseEnter()
        {
            // If we are in Trash mode, and the mouse button is currently held down,
            // delete this edge when the cursor sweeps over it.
            if (ToolManager.ActiveTool == Tool.Trash && Input.GetMouseButton(0))
            {
                Destroy(gameObject);
            }
        }

        public override void SetScale(float s)
        {
            base.SetScale(s);

            if (lr != null)
            {
                lr.startWidth = scale * scaleModifier;
                lr.endWidth   = scale * scaleModifier;
            }

            if (edgeCollider != null)
            {
                // Thickness for hitbox; tweak as needed
                edgeCollider.edgeRadius = scale * 0.5f * scaleModifier;
            }
        }

        public void SetEndpoints(Node a, Node b)
        {
            if (startNode)
            {
                startNode.Destroyed -= NodeDeleted;
            }
            if (endNode)
            {
                endNode.Destroyed -= NodeDeleted;
            }

            startNode = a;
            endNode   = b;

            if (startNode != null)
                startNode.Destroyed += NodeDeleted;
            if (endNode != null)
                endNode.Destroyed += NodeDeleted;

            UpdateLineImmediate();
        }

        private void NodeDeleted(Node n)
        {
            Destroy(gameObject);
        }

        private void Update()
        {
            if (startNode == null || endNode == null)
                return;

            // Only update when at least one node is moving
            if (!startNode.IsDragging && !endNode.IsDragging)
                return;

            if (lr != null)
            {
                lr.SetPosition(0, startNode.transform.position + Vector3.forward);
                lr.SetPosition(1, endNode.transform.position + Vector3.forward);
            }

            UpdateLabelPosition();
            UpdateCollider();
        }

        // Called when we need an immediate update after creating / reassigning endpoints
        public void UpdateLineImmediate()
        {
            if (startNode == null || endNode == null || lr == null)
                return;

            lr.SetPosition(0, startNode.transform.position + Vector3.forward);
            lr.SetPosition(1, endNode.transform.position + Vector3.forward);

            UpdateLabelPosition();
            UpdateCollider();
        }

        private void UpdateCollider()
        {
            if (edgeCollider == null || startNode == null || endNode == null)
                return;

            // Collider points are in local space of this GameObject
            Vector2 p0 = transform.InverseTransformPoint(startNode.transform.position);
            Vector2 p1 = transform.InverseTransformPoint(endNode.transform.position);

            edgeCollider.points = new Vector2[] { p0, p1 };
        }

        private void UpdateLabelPosition()
        {
            if (canvas == null || startNode == null || endNode == null)
                return;

            Vector3 mid = (startNode.transform.position + endNode.transform.position) * 0.5f;

            // Keep original Z so it stays on the right canvas/sorting plane
            mid.z = canvas.transform.position.z;

            canvas.transform.position = mid;
        }

    }
}

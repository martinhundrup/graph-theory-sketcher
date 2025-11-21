using System.Collections.Generic;
using UnityEngine;
using GTS.Nodes;
using GTS.Tools;
using System;
using GTS.UI.Tabs;
using GTS.UI.Inspector;
using TMPro;

namespace GTS.Edges
{
    public class Edge : GraphObject
    {
        public event Action<Edge> Destroyed;

        [SerializeField] private Node startNode;
        [SerializeField] private Node endNode;
        [SerializeField] protected Canvas weightCanvas;

        [Header("Directedness")]
        [SerializeField] private bool isDirected = false;
        [SerializeField] private Transform arrowHead;
        [SerializeField] private SpriteRenderer arrowSR;

        // How far back from the node center to place the arrow,
        // in units of endNode's lossyScale.x (tweak in inspector)
        [SerializeField] private float arrowOffsetMultiplier = 0.5f;


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

        public bool HasWeight
        {
            get;
            private set;
        } = false;

        public int Weight
        {
            get;
            set;
        } = 0;

        /// <summary>
        /// Public property for directedness. When toggled,
        /// the arrow visual is updated immediately.
        /// </summary>
        public bool IsDirected
        {
            get => isDirected;
            set
            {
                if (isDirected == value) return;
                isDirected = value;
                UpdateArrowVisual();
            }
        }

        public void ReverseEdge()
        {
            var t = startNode;
            startNode = endNode;
            endNode = t;

            // After reversing, update geometry + arrow
            UpdateLineImmediate();
        }

        private LineRenderer lr;
        private EdgeCollider2D edgeCollider;

        // -------------------------------------------------------
        // Hook into ToolManager so we can toggle collider
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
            // Edges should be "clickable" when Trash or Select is active
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
            SetWeight("");
            Inspector.ObjectSelected(this);
            Node.ScaleChanged += CheckUpdateArrowOnNodeScaleChanged;
        }

        new private void OnDestroy()
        {
            base.OnDestroy();
            if (startNode)
            {
                startNode.Destroyed -= NodeDeleted;
            }
            if (endNode)
            {
                endNode.Destroyed -= NodeDeleted;
            }

            Destroyed?.Invoke(this);
            Node.ScaleChanged -= CheckUpdateArrowOnNodeScaleChanged;
        }

        public void SetWeight(string t)
        {
            if (t == "")
            {
                weightCanvas.gameObject.SetActive(false);
                HasWeight = false;
                return;
            }

            HasWeight = true;
            Weight = int.Parse(t);
            weightCanvas.GetComponentInChildren<TextMeshProUGUI>().text = $"weight: {t}";
            weightCanvas.gameObject.SetActive(true);
        }

        public override void SetColor(Color c)
        {
            base.SetColor(c);
            if (lr != null)
            {
                lr.startColor = lr.endColor = color;
            }
            arrowSR.color = c;
        }

        new protected void OnMouseDown()
        {
            base.OnMouseDown();
            // Only ever reachable if edgeCollider.enabled == true
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

            // Optional: scale arrow with edge thickness
            if (arrowHead != null)
            {
                arrowHead.localScale = Vector3.one * (scale * 3f);
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

            UpdateVisuals();
        }

        // Called when we need an immediate update after creating / reassigning endpoints
        public void UpdateLineImmediate()
        {
            if (startNode == null || endNode == null || lr == null)
                return;

            lr.SetPosition(0, startNode.transform.position + Vector3.forward);
            lr.SetPosition(1, endNode.transform.position + Vector3.forward);

            UpdateVisuals();
        }

        private void UpdateVisuals()
        {
            UpdateSelectedArrowPosition();
            UpdateLabelPosition();
            UpdateCollider();
            UpdateArrowVisual();
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

        private void UpdateSelectedArrowPosition()
        {
            Vector3 mid = (startNode.transform.position + endNode.transform.position) * 0.5f;

            // Keep original Z so it stays on the right canvas/sorting plane
            mid.z = label.transform.position.z;

            label.transform.position = mid;

            if (selectedArrow != null)
            {
                selectedArrow.transform.position = mid + Vector3.up * 0.5f;
            }
        }

        private void UpdateLabelPosition()
        {
            if (label == null || startNode == null || endNode == null)
                return;

            Vector3 mid = (startNode.transform.position + endNode.transform.position) * 0.5f;

            // Keep original Z so it stays on the right canvas/sorting plane
            mid.z = label.transform.position.z;

            label.transform.position = mid;

            if (weightCanvas != null)
            {
                weightCanvas.transform.position = mid + Vector3.down * 0.5f;
            }
        }

        private void CheckUpdateArrowOnNodeScaleChanged(Node node)
        {
            if (node == endNode)
            {
                UpdateArrowVisual();
            }
        }

        /// <summary>
        /// Update the arrowhead to visually represent directedness
        /// from startNode -> endNode.
        /// </summary>
        private void UpdateArrowVisual()
        {
            if (arrowHead == null)
                return;

            if (!isDirected || startNode == null || endNode == null)
            {
                arrowHead.gameObject.SetActive(false);
                return;
            }

            arrowHead.gameObject.SetActive(true);

            // Base positions (same layer as line)
            Vector3 a = startNode.transform.position + Vector3.forward;
            Vector3 b = endNode.transform.position + Vector3.forward;

            Vector3 dir = (b - a).normalized;
            if (dir.sqrMagnitude <= 0.0001f)
                return;

            // Offset distance based on end node's scale
            float nodeScale = endNode.Scale * 10;
            float offset = nodeScale * arrowOffsetMultiplier;

            // Move the arrow back along the line so it's at the node's edge
            arrowHead.position = b - dir * offset;

            // 2D: Z-forward, 'up' points along the edge direction
            arrowHead.rotation = Quaternion.LookRotation(Vector3.forward, dir);
        }

    }
}

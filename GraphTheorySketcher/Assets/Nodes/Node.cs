using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using GTS.Tools;   // <-- to access ToolManager and Tool
using GTS.Edges;  // <-- to access EdgePlacer

namespace GTS.Nodes {
    public class Node : GraphObject
    {
        public static List<Node> AllNodes
        {
            get;
            private set;
        } = new List<Node>();

        public event Action Destroyed;
        private SpriteRenderer sr;
        private CircleCollider2D circleCollider2D;

        // Dragging
        private bool isDragging = false;
        private Vector3 dragOffset; // difference between node position and mouse world position

        public bool IsDragging
        {
            get {return isDragging;}
        }

        new private void Awake()
        {
            base.Awake();

            AllNodes.Add(this);
            sr = GetComponentInChildren<SpriteRenderer>();
            
            circleCollider2D = GetComponent<CircleCollider2D>();
        }

        private void OnDestroy()
        {
            AllNodes.Remove(this);
            Destroyed?.Invoke();
        }

        override public void SetScale(float s)
        {
            base.SetScale(s);
            circleCollider2D.radius = scale / 2f;
            sr.gameObject.transform.localScale = Vector3.one * s;
        }

        override public void SetColor(Color c)
        {
            base.SetColor(c);
            sr.color = c;
        }

        // ---------- Mouse / Tool Logic ----------

        private void OnMouseDown()
        {
            // Trash tool: delete node
            if (ToolManager.ActiveTool == Tool.Trash)
            {
                Destroy(this.gameObject);
                return;
            }

            // Move tool: start dragging
            if (ToolManager.ActiveTool == Tool.Move)
            {
                if (Camera.main == null)
                    return;

                // Convert mouse position to world and compute offset
                Vector3 mouseWorld = Camera.main.ScreenToWorldPoint(Input.mousePosition);
                mouseWorld.z = transform.position.z;

                dragOffset = transform.position - mouseWorld;
                isDragging = true;
                return;
            }

            // Edge tool: tell EdgePlacer we've selected a start node
            if (ToolManager.ActiveTool == Tool.EdgeCreator)
            {
                if (EdgePlacer.Instance != null)
                {
                    EdgePlacer.Instance.BeginEdgeFromNode(this);
                }
                return;
            }

            // Other tools: do nothing for now
        }

        private void OnMouseDrag()
        {
            // Only drag when move tool is active
            if (!isDragging)
                return;

            if (ToolManager.ActiveTool != Tool.Move)
                return;

            if (Camera.main == null)
                return;

            // Only move while mouse button is held down
            if (!Input.GetMouseButton(0))
                return;

            Vector3 mouseWorld = Camera.main.ScreenToWorldPoint(Input.mousePosition);
            mouseWorld.z = transform.position.z;

            transform.position = mouseWorld + dragOffset;
        }

        private void OnMouseUp()
        {
            // Only used for move tool dragging
            isDragging = false;
        }
    }
}

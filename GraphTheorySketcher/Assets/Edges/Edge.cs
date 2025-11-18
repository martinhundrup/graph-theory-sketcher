using UnityEngine;
using GTS.Nodes;
using System.Collections.Generic;

namespace GTS.Edges
{
    public class Edge : GraphObject
    {
        public static List<Edge> AllEdges
        {
            get;
            private set;
        } = new List<Edge>();

        [SerializeField] private Node startNode;
        [SerializeField] private Node endNode;

        public Node StartNode => startNode;
        public Node EndNode => endNode;

        private LineRenderer lr;

        new protected void Awake()
        {
            AllEdges.Add(this);
            scale = 0.25f;
            base.Awake();
            lr = GetComponentInChildren<LineRenderer>();
            lr.positionCount = 2;
            SetScale(scale);
            UpdateLineImmediate();
        }

        private void OnDestroy()
        {
            if (startNode)
            {
                startNode.Destroyed -= NodeDeleted;
            }
            if (endNode)
            {
                startNode.Destroyed -= NodeDeleted;
            }
            AllEdges.Remove(this);
        }

        override public void SetScale(float s)
        {
            base.SetScale(s);
            lr.startWidth = s;
            lr.endWidth   = s;
        }

        public void SetEndpoints(Node a, Node b)
        {
            if (startNode)
            {
                startNode.Destroyed -= NodeDeleted;
            }
            if (endNode)
            {
                startNode.Destroyed -= NodeDeleted;
            }

            startNode = a;
            endNode = b;
            a.Destroyed += NodeDeleted;
            b.Destroyed += NodeDeleted;
            UpdateLineImmediate();
        }

        private void NodeDeleted()
        {
            Destroy(this.gameObject);
        }

        private void Update()
        {
            if (startNode == null || endNode == null)
                return;
            
            if (!startNode.IsDragging && !endNode.IsDragging) return; // don't update when not needed
            lr.SetPosition(0, startNode.transform.position);
            lr.SetPosition(1, endNode.transform.position);
        }

        // Optional if you want to update once immediately after creating
        public void UpdateLineImmediate()
        {
            if (startNode == null || endNode == null)
                return;

            lr.SetPosition(0, startNode.transform.position);
            lr.SetPosition(1, endNode.transform.position);
        }
    }
}

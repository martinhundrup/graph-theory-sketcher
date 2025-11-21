using System.Collections;
using System.Collections.Generic;
using GTS.Nodes;
using GTS.UI.Inspector;
using GTS.UI.Tabs;
using UnityEngine;

namespace GTS.DataManagement{
    public class DataManager : MonoBehaviour
    {
        public static DataManager Instance
        {
            get;
            private set;
        }

        [SerializeField] private GameObject nodePrefab;
        [SerializeField] private GameObject edgePrefab;

        private void Awake()
        {
            if (Instance != null)
            {
                Destroy(this.gameObject);
                return;
            }

            DontDestroyOnLoad(this.gameObject);
            Instance = this;
        }

        public GameObject NodePrefab
        {
            get {return nodePrefab;}
        }

        public GameObject EdgePrefab
        {
            get {return edgePrefab;}
        }

        public static Dictionary<Node, int> ComputeDijkstraDistances()
        {
            // precon checks
            if (TabButton.ActiveButton == null) return null;
            var tabData = TabButton.ActiveButton.TabData;
            if (tabData == null) return null;
            if (Inspector.SelectedObject is not Node source) return null;

            var dist    = new Dictionary<Node, int>();
            var visited = new HashSet<Node>();

            // Initialize all nodes to "infinity"
            foreach (var node in tabData.AllNodes)
            {
                if (node == null) continue;
                dist[node] = int.MaxValue;
            }

            // Ensure source exists in the dictionary
            if (!dist.ContainsKey(source))
                dist[source] = int.MaxValue;

            // Distance to self is zero
            dist[source] = 0;

            // Standard Dijkstra (simple O(V^2 + VE) implementation)
            while (visited.Count < dist.Count)
            {
                // Pick the unvisited node with the smallest distance
                Node u = null;
                int best = int.MaxValue;

                foreach (var kvp in dist)
                {
                    if (visited.Contains(kvp.Key)) continue;
                    if (kvp.Value < best)
                    {
                        best = kvp.Value;
                        u = kvp.Key;
                    }
                }

                // No more reachable nodes
                if (u == null || best == int.MaxValue)
                    break;

                visited.Add(u);

                // Relax all outgoing edges of u
                foreach (var e in tabData.AllEdges)
                {
                    if (e == null) continue;
                    if (e.StartNode == null || e.EndNode == null) continue;

                    void Relax(Node from, Node to)
                    {
                        if (from != u || to == null) return;
                        if (!dist.ContainsKey(to)) return;

                        // If the edge is weighted, use its weight; otherwise weight = 1
                        int w   = e.HasWeight ? e.Weight : 1;
                        int du  = dist[u];
                        if (du == int.MaxValue) return; // avoid overflow from "infinity"

                        int alt = du + w;
                        if (alt < dist[to])
                            dist[to] = alt;
                    }

                    if (e.IsDirected)
                    {
                        // Directed: only from StartNode -> EndNode
                        Relax(e.StartNode, e.EndNode);
                    }
                    else
                    {
                        // Undirected: both directions
                        Relax(e.StartNode, e.EndNode);
                        Relax(e.EndNode, e.StartNode);
                    }
                }
            }

            // Unreachable nodes remain int.MaxValue
            return dist;
        }



    }
}
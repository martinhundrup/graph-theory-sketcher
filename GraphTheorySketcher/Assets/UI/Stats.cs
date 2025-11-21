using System.Collections;
using System.Collections.Generic;
using GTS.Nodes;
using GTS.UI.Tabs;
using TMPro;
using UnityEngine;

namespace GTS.UI {
    public class Stats : MonoBehaviour
    {
        public static Stats Instance
        {
            get;
            private set;
        }
        [SerializeField] private TextMeshProUGUI nText;
        [SerializeField] private TextMeshProUGUI mText;
        [SerializeField] private TextMeshProUGUI kText;

        private void Awake()
        {
            if (Instance != null)
            {
                Destroy(this.gameObject);
                return;
            }

            Instance = this;
        }

        private void OnDestroy()
        {
            if (Instance == this)
            {
                Instance = null;
            }
        }

        public static void UpdateStats()
        {
            if (!TabButton.ActiveButton) return;
            var td = TabButton.ActiveButton.TabData;
            if (Instance && Instance.isActiveAndEnabled)
            {
                Instance.StartCoroutine(Instance.UpdateStats_I(td));
            }
        }

        private void OnEnable()
        {
            if (!TabButton.ActiveButton) return;
            var td = TabButton.ActiveButton.TabData;
            StartCoroutine(UpdateStats_I(td));
        }

        private IEnumerator UpdateStats_I(TabData td)
        {
            yield return null; // let updates trigger before updating

            nText.text = $"n: {td.AllNodes.Count}";
            mText.text = $"m: {td.AllEdges.Count}";
            kText.text = $"k: {FindK(td)}";
        }

        public static int FindK(TabData td)
        {
            if (td.AllNodes.Count == 0) 
                return 0;
            if (td.AllEdges.Count == 0) 
                return td.AllNodes.Count;

            var visited = new HashSet<Node>();
            int k = 0;

            foreach (var n in td.AllNodes)
            {
                if (n == null) continue;
                if (visited.Contains(n)) continue;

                // Start a new component
                k++;

                // DFS stack
                var stack = new Stack<Node>();
                stack.Push(n);
                visited.Add(n);

                while (stack.Count > 0)
                {
                    var u = stack.Pop();

                    foreach (var e in td.AllEdges)
                    {
                        if (e == null) continue;
                        if (e.StartNode == null || e.EndNode == null) continue;

                        // Try directed or undirected movement
                        void TryVisit(Node from, Node to)
                        {
                            if (from != u) return;
                            if (to == null) return;
                            if (visited.Contains(to)) return;

                            visited.Add(to);
                            stack.Push(to);
                        }

                        if (e.IsDirected)
                        {
                            // Only Start -> End
                            TryVisit(e.StartNode, e.EndNode);
                        }
                        else
                        {
                            // Undirected: both
                            TryVisit(e.StartNode, e.EndNode);
                            TryVisit(e.EndNode, e.StartNode);
                        }
                    }
                }
            }

            return k;
        }

    }
}
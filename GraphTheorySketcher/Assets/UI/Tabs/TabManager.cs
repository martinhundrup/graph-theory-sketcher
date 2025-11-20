using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using GTS.Nodes;
using GTS.Edges;
using GTS.DataManagement;

namespace GTS.UI.Tabs
{
    public class TabManager : MonoBehaviour
    {
        public static TabManager Instance
        {
            get;
            private set;
        }

        [SerializeField] private GameObject tabPrefab;
        [SerializeField] private HorizontalLayoutGroup tabLayoutGroup;
        
        private void Awake()
        {
            if (Instance != null)
            {
                Destroy(this.gameObject);
                return;
            }

            Instance = this;
            OnAddTab(); // add starting tab
        }

        private void OnDestroy()
        {
            if (Instance == this)
            {
                Instance = null;
            }
        }

        public static void AddTab()
        {
            if (Instance)
            {
                Instance.OnAddTab();
            }
        }

        private void OnAddTab()
        {
            var tab = Instantiate(tabPrefab, tabLayoutGroup.transform).GetComponent<TabButton>();
            tab.Init("new_tab", new TabData());
            tab.OnClick();
        }

        // =====================================================================
        //  LOAD TAB FROM DISK (static entry point)
        // =====================================================================

        public static void LoadTabFromDisk()
        {
            if (Instance == null)
            {
                Debug.LogError("TabManager.LoadTabFromDisk: no TabManager instance.");
                return;
            }

            Instance.OnLoadTabFromDisk();
        }

        private void OnLoadTabFromDisk()
        {
            // 1. Ask user to choose a .gts file (ASYNC)
            FileDialogs.OpenLoadDialog(filePath =>
            {
                if (string.IsNullOrEmpty(filePath))
                    return;

                // 2. Let TabData parse the JSON from that file
                TabData.TabSaveData saveData = TabData.LoadFromFile(filePath);

                if (saveData.nodes == null || saveData.edges == null)
                {
                    Debug.LogError($"Failed to load tab from '{filePath}': nodes/edges were null.");
                    return;
                }

                // 3. Instantiate a new tab UI from the prefab
                var tabGO = Instantiate(tabPrefab, tabLayoutGroup.transform);
                var tabButton = tabGO.GetComponent<TabButton>();
                var tabData = new TabData();

                tabButton.Init(saveData.label, tabData);

                // Set tab metadata
                tabData.SetLabel(saveData.label);
                if (tabData.SelectedColorButton != null)
                {
                    tabData.SetColorIsolated(saveData.color);
                }

                // 6. Activate the new tab (reuses your existing click logic)
                tabButton.OnClick();

                // 4. Rebuild graph: nodes
                Dictionary<ulong, Node> uidMap = new Dictionary<ulong, Node>();

                foreach (var n in saveData.nodes)
                {
                    var nodeGO = Instantiate(DataManager.Instance.NodePrefab);
                    var node = nodeGO.GetComponent<Node>();

                    node.transform.position = n.position;
                    node.SetLabel(n.label);
                    node.SetColor(n.color);
                    node.SetScale(n.scale);
                    node.SetUID(n.uid);

                    uidMap[n.uid] = node;
                }

                // 5. Rebuild graph: edges
                foreach (var e in saveData.edges)
                {
                    if (!uidMap.TryGetValue(e.startUid, out var start)) continue;
                    if (!uidMap.TryGetValue(e.endUid, out var end)) continue;

                    var edgeGO = Instantiate(DataManager.Instance.EdgePrefab);
                    var edge = edgeGO.GetComponent<Edge>();

                    edge.SetEndpoints(start, end);
                    edge.SetLabel(e.label);
                    edge.SetColor(e.color);
                    edge.SetScale(e.scale);
                }

                Debug.Log("Loaded tab: " + saveData.label);
            });
        }
    }
}

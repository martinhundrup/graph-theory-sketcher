using System.Collections;
using System.Collections.Generic;
using System.IO;
using GTS.Edges;
using GTS.Nodes;
using GTS.UI.Inspector;
using GTS.UI.Tabs;
using UnityEngine;

public class TabData
{
    [System.Serializable]
    public struct NodeSaveData
    {
        public ulong uid;
        public string label;
        public Color color;
        public float scale;
        public Vector3 position;
    }

    [System.Serializable]
    public struct EdgeSaveData
    {
        public ulong startUid;
        public ulong endUid;
        public string label;
        public Color color;
        public float scale;
    }

    [System.Serializable]
    public struct TabSaveData
    {
        public string label;
        public Color color; // tab color (from SelectedColorButton)
        public List<NodeSaveData> nodes;
        public List<EdgeSaveData> edges;
    }

    public string Label
    {
        get;
        private set;
    }

    public ColorButton SelectedColorButton
    {
        get;
        private set;
    }

    public void SetColorIsolated(Color c)
    {
        Camera.main.backgroundColor = c;
    }

    public List<Node> AllNodes
    {
        get;
        private set;
    } = new List<Node>();

    public void RegisterNode(Node n)
    {
        if (!AllNodes.Contains(n))
        {
            AllNodes.Add(n);
            n.Destroyed += DeregisterNode;
        }
    }

    private void DeregisterNode(Node n)
    {
        if (AllNodes.Contains(n))
        {
            AllNodes.Remove(n);
            n.Destroyed -= DeregisterNode;
        }
    }

    public List<Edge> AllEdges
    {
        get;
        private set;
    } = new List<Edge>();

    public void RegisterEdge(Edge e)
    {
        if (!AllEdges.Contains(e))
        {
            AllEdges.Add(e);
            e.Destroyed += DeregisterEdge;
        }
    }
    
    private void DeregisterEdge(Edge e)
    {
        if (AllEdges.Contains(e))
        {
            AllEdges.Remove(e);
            e.Destroyed -= DeregisterEdge;
        }
    }

    public TabData()
    {
        TabButton.OnTabClicked += SetActiveTab;
    }

    ~TabData()
    {
        TabButton.OnTabClicked -= SetActiveTab;
    }

    public void SetLabel(string l)
    {
        Label = l;
    }

    public void SetColorButton(ColorButton cb)
    {
        SelectedColorButton = cb;
        if (!cb) return;
        Camera.main.backgroundColor = cb.Color;
    }

    public void SetActiveTab(TabButton tab)
    {    
        bool b = TabButton.ActiveButton.TabData == this;
        foreach (var n in AllNodes)
        {
            n.gameObject.SetActive(b);
        }
        foreach (var e in AllEdges)
        {
            e.gameObject.SetActive(b);
        }
    }

        public void SaveJson(string filePath)
        {
            if (string.IsNullOrEmpty(filePath))
            {
                Debug.LogError("TabData.SaveJsonToFile: filePath is null or empty");
                return;
            }

            // If user didn’t type an extension, force .gts
            string ext = Path.GetExtension(filePath);
            if (string.IsNullOrEmpty(ext))
            {
                filePath += ".gts";
            }

            File.WriteAllText(filePath, ToJSON());
            Debug.Log($"Tab saved to {filePath}");
        }

        private string ToJSON()
        {
            var data = new TabSaveData
            {
                label = this.Label,
                color = SelectedColorButton ? SelectedColorButton.Color : Color.black,
                nodes = new List<NodeSaveData>(),
                edges = new List<EdgeSaveData>()
            };

            // ---- Nodes ----
            foreach (var n in AllNodes)
            {
                if (n == null)
                    continue;

                var nodeData = new NodeSaveData
                {
                    uid      = n.UID,
                    label    = n.Label,            // from GraphObject
                    color    = n.NodeColor,        // new property
                    scale    = n.NodeScale,        // new property
                    position = n.transform.position
                };

                data.nodes.Add(nodeData);
            }

            // ---- Edges ----
            foreach (var e in AllEdges)
            {
                if (e == null || e.StartNode == null || e.EndNode == null)
                    continue;

                var edgeData = new EdgeSaveData
                {
                    startUid = e.StartNode.UID,
                    endUid   = e.EndNode.UID,
                    label    = e.Label,       // from GraphObject
                    color    = e.EdgeColor,   // new property
                    scale    = e.EdgeScale    // new property
                };

                data.edges.Add(edgeData);
            }

            // pretty-print for easier debugging in a text editor
            return JsonUtility.ToJson(data, true);
        }

    public static TabSaveData LoadFromFile(string filePath)
    {
        if (string.IsNullOrEmpty(filePath))
        {
            Debug.LogError("TabData.LoadFromFile: filePath is null or empty");
            return default;
        }

        if (!File.Exists(filePath))
        {
            Debug.LogError($"TabData.LoadFromFile: file does not exist at '{filePath}'");
            return default;
        }

        string json = File.ReadAllText(filePath);
        TabSaveData data = JsonUtility.FromJson<TabSaveData>(json);

        return data;
    }

}

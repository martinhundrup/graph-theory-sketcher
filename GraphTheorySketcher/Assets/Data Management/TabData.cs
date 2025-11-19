using System.Collections;
using System.Collections.Generic;
using GTS.Edges;
using GTS.Nodes;
using GTS.UI.Inspector;
using GTS.UI.Tabs;
using UnityEngine;

public class TabData
{
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
}

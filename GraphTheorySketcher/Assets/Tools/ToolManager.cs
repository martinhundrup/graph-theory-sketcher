using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using GTS.UI.Tabs;

namespace GTS.Tools {

    [System.Serializable]
    public enum Tool
    {
        Select, // for selecting nodes and edges
        Move, // for moving nodes and curving edges
        NodeCreator, // for creating nodes
        EdgeCreator, // for creating/drawing edges
        Trash, // deletes nodes and edges
    }

    public static class ToolManager
    {
        public static event Action<Tool> OnActiveToolChanged;

        public static Tool ActiveTool { get; private set; } = Tool.Select;

        public static void SetToolActive(Tool tool)
        {
            ActiveTool = tool;
            OnActiveToolChanged?.Invoke(tool);
        }
    }
}

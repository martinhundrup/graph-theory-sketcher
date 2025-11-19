using System.Collections;
using System.Collections.Generic;
using GTS.Tools;
using GTS.UI.Inspector;
using UnityEngine;

namespace GTS.UI {
    public class ToolBar : MonoBehaviour
    {
        public static ToolBar Instance
        {
            get;
            private set;
        }

        private void Awake()
        {
            if (Instance != null)
            {
                Destroy(this.gameObject);
                return;
            }

            SetToolActive(ToolManager.ActiveTool);
            Instance = this;
        }

        private void OnDestroy()
        {
            if (Instance == this)
            {
                Instance = null;
            }
        }

        private void Update()
        {
            if (Inspector.Inspector.TextSelected) return;

            if (Input.GetKeyDown(KeyCode.S))
            {
                ToolManager.SetToolActive(Tool.Select);
            }
            else if (Input.GetKeyDown(KeyCode.M))
            {
                ToolManager.SetToolActive(Tool.Move);
            }
            else if (Input.GetKeyDown(KeyCode.N))
            {
                ToolManager.SetToolActive(Tool.NodeCreator);
            }
            else if (Input.GetKeyDown(KeyCode.E))
            {
                ToolManager.SetToolActive(Tool.EdgeCreator);
            }
            else if (Input.GetKeyDown(KeyCode.T))
            {
                ToolManager.SetToolActive(Tool.Trash);
            }
            else if (Input.GetKeyDown(KeyCode.P))
            {
                ToolManager.SetToolActive(Tool.Pan);
            }
        }

        public void SetToolActive(Tool tool)
        {
            ToolManager.SetToolActive(tool);
        }
    }
}

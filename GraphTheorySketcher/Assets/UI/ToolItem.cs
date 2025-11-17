using System.Collections;
using System.Collections.Generic;
using GTS.Tools;
using UnityEngine;
using UnityEngine.UI;

namespace GTS.UI {
    public class ToolItem : MonoBehaviour
    {
        private Image backgroundImage;
        private Button button;
        [SerializeField] private Tool tool;
        
        private void Awake()
        {
            ToolManager.OnActiveToolChanged += ActivateTool;
            backgroundImage = GetComponent<Image>();
            button = GetComponent<Button>();
            button.onClick.AddListener(ButtonListener);
        }

        private void OnDestroy()
        {
            ToolManager.OnActiveToolChanged -= ActivateTool;
        }

        private void ButtonListener()
        {
            ToolManager.SetToolActive(tool);
        }

        private void ActivateTool(Tool t)
        {
            if (tool == t)
            {
                backgroundImage.color = Color.white;
                return;
            }

            backgroundImage.color = Color.clear;
        }
    }
}
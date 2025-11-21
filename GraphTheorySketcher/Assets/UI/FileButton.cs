using System.Collections;
using System.Collections.Generic;
using GTS.UI.Tabs;
using TMPro;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace GTS.UI
{
    public class FileButton : MonoBehaviour
    {
        private Button button;
        private Image image;
        private TextMeshProUGUI text;

        private void Awake()
        {
            image = GetComponent<Image>();
            text = GetComponentInChildren<TextMeshProUGUI>();
            button = GetComponent<Button>();
            button.onClick.AddListener(OnPointerClick);
            SetColors(false);
        }

        private void OnPointerClick()
        {
            // do something (hook up via inspector if needed)
        }

        public void SetColors(bool hovered)
        {
            image.color = hovered ? Color.white : Color.black;
            text.color  = hovered ? Color.black : Color.white;
        }

        // ---------------------------------------------------------------------
        // PUBLIC API (unchanged signature)
        // ---------------------------------------------------------------------
        public void SaveActiveGraph()
        {
            var activeTab = TabButton.ActiveButton;
            if (activeTab == null || activeTab.TabData == null)
                return;

            // Use the tab's label as the default file name
            string defaultName = activeTab.TabData.Label;

            // New: use FileDialogs.SaveGraph, which handles Editor/WebGL/standalone
            FileDialogs.SaveGraph(
                defaultName,
                () => activeTab.TabData.ToJSON(), // you implement ToJson() on TabData
                success =>
                {
                    if (!success)
                    {
                        Debug.Log("[FileButton] SaveActiveGraph: save cancelled or failed.");
                    }
                });
        }

        // Still just a thin wrapper around TabManager
        public void LoadNewGraph()
        {
            TabManager.LoadTabFromDisk();
        }
    }
}

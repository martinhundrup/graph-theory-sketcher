using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace GTS.UI.Tabs {

    public class TabButton : MonoBehaviour
    {
        public static List<TabButton> TabButtons
        {
            get;
            private set;
        } = new List<TabButton>();

        public static event Action<TabButton> OnTabClicked;
        [SerializeField] private Image outlineImage;
        [SerializeField] private Image fillImage;
        private TextMeshProUGUI text;
        public TabData TabData
        {
            get;
            private set;
        }
        
        public static TabButton ActiveButton
        {
            get;
            private set;
        }

        public bool Active
        {
            get {return ActiveButton == this;}
        }
        
        private void Awake()
        {
            TabButtons.Add(this);
            text = GetComponentInChildren<TextMeshProUGUI>();
            OnTabClicked += SetActive;
            SetActive(null);
        }

        private void OnDestroy()
        {
            OnTabClicked -= SetActive;
            TabButtons.Remove(this);
        }

        public void Init(string name, TabData tab)
        {
            text.text = name;
            TabData = tab;
        }

        private void SetActive(TabButton tb)
        {
            if (this == tb)
            {
                outlineImage.color = Color.white;
                fillImage.color = Color.black;
                text.color = Color.white;
            }
            else // set inactive
            {
                outlineImage.color = Color.clear;
                fillImage.color = Color.black;
                text.color = Color.white;
            }
        }

        public void OnClick()
        {
            ActiveButton = this;
            OnTabClicked?.Invoke(this);
        }

        public void OnHover(bool hovered)
        {
            if (Active) return; // nothing
            fillImage.color = hovered ? Color.white : Color.black;
            text.color = hovered ? Color.black : Color.white;
        }

    }
}
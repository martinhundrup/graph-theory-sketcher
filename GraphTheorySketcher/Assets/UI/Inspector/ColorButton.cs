using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace GTS.UI.Inspector {
    public class ColorButton : MonoBehaviour
    {
        public static event Action<ColorButton> OnColorClicked;
        [SerializeField] private Image outlineImage;
        [SerializeField] private Image fillImage;
        [SerializeField] private Color color;
        [SerializeField] private bool startActive = false;
        private Button button;

        public Color Color
        {
            get {return color;}
        }

        public TabData TabData
        {
            get;
            private set;
        }
        
        public static ColorButton ActiveButton
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
            fillImage.color = color;
            OnColorClicked += SetActive;
            button = GetComponent<Button>();
            button.onClick.AddListener(OnClick);
            SetActive(startActive ? this : null);
        }

        private void OnDestroy()
        {
            OnColorClicked -= SetActive;
        }

        private void SetActive(ColorButton tb)
        {
            if (this == tb)
            {
                outlineImage.color = Color.white;
            }
            else // set inactive
            {
                outlineImage.color = Color.clear;
            }
        }

        public void OnClick()
        {
            ActiveButton = this;
            OnColorClicked?.Invoke(this);
        }

        public static void SetNoneActive()
        {
            ActiveButton = null;
            OnColorClicked?.Invoke(null);
        }

    }
}
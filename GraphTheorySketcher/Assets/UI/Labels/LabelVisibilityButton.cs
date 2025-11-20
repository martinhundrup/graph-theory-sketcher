using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine;
using System;

namespace GTS.UI.Labels {
    public class LabelVisibilityButton : MonoBehaviour
    {
        [SerializeField] private Sprite visibleSprite;
        [SerializeField] private Sprite notVisibleSprite;
        [SerializeField] private Image image;
        private Image backgroundImage;
        public static bool Visibility
        {
            get;
            private set;
        } = true;
        public static event Action<bool> VisibilityToggled;
            
        private void Awake()
        {
            backgroundImage = GetComponent<Image>();
            OnHover(false);
            SetVisibility(true);
        }


        public void OnHover(bool hovered)
        {
            backgroundImage.color = hovered ? Color.white : Color.clear;
        }

        public void ToggleVisibility()
        {
            SetVisibility(!Visibility);
        }

        private void SetVisibility(bool b)
        {
            Visibility = b;
            VisibilityToggled?.Invoke(Visibility);
            image.sprite = Visibility ? visibleSprite : notVisibleSprite;
        }
    }
}
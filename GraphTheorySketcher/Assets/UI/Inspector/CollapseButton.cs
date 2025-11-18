using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace GTS.UI.Inspector {
    public class CollapseButton : MonoBehaviour
    {
        private Image backgroundImage;
        
        private void Awake()
        {
            backgroundImage = GetComponent<Image>();
            OnHover(false);
        }


        public void OnHover(bool hovered)
        {
            backgroundImage.color = hovered ? Color.white : Color.clear;
        }
    }
}
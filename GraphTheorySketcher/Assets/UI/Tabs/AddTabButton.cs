using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace GTS.UI.Tabs{
    public class AddTabButton : MonoBehaviour
    {
        private Button button;
        private Image image;
        private TextMeshProUGUI text;
        [SerializeField] private bool addTab = true;

        private void Awake()
        {
            image = GetComponent<Image>();
            text = GetComponentInChildren<TextMeshProUGUI>();
            button = GetComponent<Button>();
            button.onClick.AddListener(OnPointerClick);
            OnHovered(false);
        }

        private void OnPointerClick()
        {
            if (addTab){
                TabManager.AddTab();
            }
        }

        public void OnHovered(bool hovered)
        {
            image.color = hovered ? Color.white : Color.black;
            text.color = hovered ? Color.black : Color.white;
        }
    }
}

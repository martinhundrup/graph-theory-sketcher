using System.Collections;
using System.Collections.Generic;
using TMPro;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace GTS.UI {
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
            // do something
        }

        public void SetColors(bool hovered)
        {
            image.color = hovered ? Color.white : Color.black;
            text.color = hovered ? Color.black : Color.white;
        }

    }
}
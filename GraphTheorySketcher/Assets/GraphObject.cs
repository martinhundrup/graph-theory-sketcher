using System.Collections;
using System.Collections.Generic;
using GTS.Tools;
using GTS.UI.Inspector;
using TMPro;
using UnityEngine;

namespace GTS{

    public class GraphObject : MonoBehaviour
    {
        [SerializeField] protected float scale = 1f;
        [SerializeField] protected Color color = Color.white;


        private ColorButton selectedColorButton;
        private Canvas canvas;
        private TextMeshProUGUI text;

        public string Label
        {
            get;
            private set;
        }

        protected void Awake()
        {
            canvas = GetComponentInChildren<Canvas>();
            text = GetComponentInChildren<TextMeshProUGUI>();
        }

        protected void OnMouseDown()
        {
            if (ToolManager.ActiveTool == Tool.Select)
            {
                Inspector.ObjectSelected(this);
            }
        }

        public virtual void SetScale(float s)
        {
            scale = s;
        }

        public virtual void SetColor(Color c)
        {
            color = c;
        }

        public virtual void SetLabel(string t)
        {
            Label = t;
            text.text = t;
            canvas.gameObject.SetActive(t != "");
        }

    }
}

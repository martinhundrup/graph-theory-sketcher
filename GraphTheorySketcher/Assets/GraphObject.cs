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
        [SerializeField] protected float minScale = 0.2f;
        [SerializeField] protected float scaleModifier = 10f;

        [SerializeField] protected Canvas label;

        private TextMeshProUGUI text;

        public ColorButton SelectedColorButton
        {
            get;
            set;
        }

        public string Label
        {
            get;
            private set;
        }

        public float Scale
        {
            get {return scale;}
        }

        protected void Awake()
        {
            label = GetComponentInChildren<Canvas>();
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
            if (scale <= minScale)
            {
                scale = minScale;
            }
        }

        public virtual void SetColor(Color c)
        {
            color = c;
        }

        public virtual void SetLabel(string t)
        {
            Label = t;
            text.text = t;
            label.gameObject.SetActive(t != "");
        }

    }
}

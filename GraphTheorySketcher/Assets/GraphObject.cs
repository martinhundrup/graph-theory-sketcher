using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

namespace GTS{

    public class GraphObject : MonoBehaviour
    {
        [SerializeField] protected float scale = 1f;
        [SerializeField] protected Color color = Color.white;

        private Canvas canvas;
        private TextMeshProUGUI text;

        protected void Awake()
        {
            canvas = GetComponentInChildren<Canvas>();
            text = GetComponentInChildren<TextMeshProUGUI>();
        }
        
        public virtual void SetScale(float s)
        {
            scale = s;
        }

        public virtual void SetColor(Color c)
        {
            color = c;
        }

        public virtual void SetText(string t)
        {
            text.text = t;
            canvas.gameObject.SetActive(t != "");
        }

    }
}

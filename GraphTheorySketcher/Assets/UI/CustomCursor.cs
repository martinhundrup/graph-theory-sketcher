using UnityEngine;
using UnityEngine.UI;

namespace GTS.UI {
    public class CustomCursor : MonoBehaviour
    {
        public static CustomCursor Instance
        {
            get;
            private set;
        }

        [SerializeField] private RectTransform cursorRect;

        private void Awake()
        {
            Instance = this;
            Cursor.visible = false;
        }

        public void SetCursor(Sprite s)
        {
            this.GetComponent<Image>().sprite = s;
        }

        private void Update()
        {
            Vector2 pos;
            RectTransformUtility.ScreenPointToLocalPointInRectangle(
                cursorRect.parent as RectTransform,
                Input.mousePosition,
                null,
                out pos
            );
            cursorRect.anchoredPosition = pos;
        }
    }
}
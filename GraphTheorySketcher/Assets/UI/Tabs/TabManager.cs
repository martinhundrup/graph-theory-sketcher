using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace GTS.UI.Tabs
{
    public class TabManager : MonoBehaviour
    {
        public static TabManager Instance
        {
            get;
            private set;
        }

        [SerializeField] private GameObject tabPrefab;
        [SerializeField] private HorizontalLayoutGroup tabLayoutGroup;
        

        private void Awake()
        {
            if (Instance != null)
            {
                Destroy(this.gameObject);
                return;
            }

            Instance = this;
        }

        private void OnDestroy()
        {
            if (Instance == this)
            {
                Instance = null;
            }
        }

        public static void AddTab()
        {
            if (Instance)
            {
                Instance.OnAddTab();
            }
        }

        private void OnAddTab()
        {
            var tab = Instantiate(tabPrefab, tabLayoutGroup.transform).GetComponent<TabButton>();
            tab.Init("new_tab.gts", new TabData());
            tab.OnClick();
        }
    }
}
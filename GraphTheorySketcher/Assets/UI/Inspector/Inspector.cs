using System;
using System.Collections;
using GTS;
using GTS.DataManagement;
using GTS.UI.Inspector;
using GTS.UI.Tabs;
using TMPro;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UI;

namespace GTS.UI.Inspector {
    public class Inspector : MonoBehaviour
    {
        public static event Action<GraphObject> OnObjectSelected;
        private enum InspectorState
        {
            Expanded,
            Collapsed,
            Animating
        }

        public static GraphObject SelectedObject
        {
            get;
            private set;
        }

        public static Inspector Instance
        {
            get;
            private set;
        }

        public static bool TextSelected
        {
            get;
            set;
        } = false;

        [Header("Expanding And Collapsing")]
        [SerializeField] private GameObject collapseButton;
        [SerializeField] private GameObject expandButton;
        [SerializeField] private float expandedWidth = 300f;
        [SerializeField] private float collapsedWidth = 0f;
        [SerializeField] private float animationDuration = 0.25f;

        [Header("Fields")]
        [SerializeField] private TMP_InputField labelInputField;
        [SerializeField] private Slider scaleSlider;
        [SerializeField] private GameObject scaleSliderParent;
        
        [Header("Edges")]
        [SerializeField] private GameObject edgeContainer;
        [SerializeField] private TMP_InputField weightInputField;
        [SerializeField] private Toggle directedToggle;

        [Header("Nodes")]
        [SerializeField] private GameObject nodeContainer;
        

        private RectTransform rectTransform;
        private InspectorState state;
        private bool edittingTab = false;

        public static void ObjectSelected(GraphObject obj)
        {
            SelectedObject = obj;
            if (Instance)
            {
                OnObjectSelected?.Invoke(obj);
                Instance.Init();
            }
        }

        private void Init()
        {
            edittingTab = false;
            scaleSliderParent.SetActive(true);
            labelInputField.SetTextWithoutNotify(SelectedObject.Label);
            scaleSlider.SetValueWithoutNotify(SelectedObject.Scale);
            

            if (SelectedObject.SelectedColorButton == null)
            {
                ColorButton.SetNoneActive();
            }
            else
            {
                SelectedObject.SelectedColorButton.OnClick();
            }

            if (SelectedObject && SelectedObject is GTS.Edges.Edge)
            {
                edgeContainer.SetActive(true);
                var edge = SelectedObject as Edges.Edge;
                if (edge.HasWeight)
                {
                    weightInputField.SetTextWithoutNotify(edge.Weight.ToString());
                }
                else
                {
                    weightInputField.SetTextWithoutNotify("");
                }
                directedToggle.SetIsOnWithoutNotify(edge.IsDirected);
            }
            else
                edgeContainer.SetActive(false);

            if (SelectedObject && SelectedObject is GTS.Nodes.Node)
            {
                nodeContainer.SetActive(true);
                
            }
            else
                nodeContainer.SetActive(false);



        }

        public static void TabSelected(TabButton tab)
        {
            if (Instance) {
                Instance.Init_Tab();
            }
        }

        private void Init_Tab()
        {
            var btn = TabButton.ActiveButton;
            if (btn == null) return;
            var data = btn.TabData;
            if (data == null) return; // shouldn't be possible

            edittingTab = true;
            OnObjectSelected?.Invoke(null);
            edgeContainer.SetActive(false);
            nodeContainer.SetActive(false);


            labelInputField.SetTextWithoutNotify(data.Label);
            scaleSliderParent.SetActive(false);

            if (data.SelectedColorButton == null)
            {
                ColorButton.SetNoneActive();
            }
            else
            {
                data.SelectedColorButton.OnClick();
            }
        }

        public static void OnTabClosed()
        {
            Instance.Collapse();
        }

        private void Awake()
        {
            if (Instance != null)
            {
                Destroy(this.gameObject);
                return;
            }
            Instance = this;

            rectTransform = GetComponent<RectTransform>();
            SetWidth(expandedWidth);
            collapseButton.SetActive(true);
            expandButton.SetActive(false);
            state = InspectorState.Expanded; // default fallback

            ColorButton.OnColorClicked += OnColorClicked;

            // name 
            labelInputField.onValueChanged.AddListener(OnLabelValueChanged);
            labelInputField.onSelect.AddListener(SetTextTrue);
            labelInputField.onEndEdit.AddListener(SetTextFalse);

            // scale slider
            scaleSlider.onValueChanged.AddListener(SetObjectScale);

            // edge stuff
            edgeContainer.SetActive(false);
            weightInputField.onValueChanged.AddListener(OnWeightTextChanged);
            weightInputField.onSelect.AddListener(SetTextTrue);
            weightInputField.onEndEdit.AddListener(SetTextFalse);

            directedToggle.onValueChanged.AddListener(OnDirectedToggleValueChanged);

            // if (SelectedObject == null || TabButton.ActiveButton == null)
            // {
            //     Collapse();
            // }
        }

        private void OnDirectedToggleValueChanged(bool v)
        {
            if (SelectedObject && SelectedObject is GTS.Edges.Edge)
            {
                (SelectedObject as Edges.Edge).IsDirected = v;
            }
        }

        private void OnWeightTextChanged(string t)
        {
            if (SelectedObject && SelectedObject is GTS.Edges.Edge)
            {
                (SelectedObject as Edges.Edge).SetWeight(t);
            }
        }

        private void OnColorClicked(ColorButton btn)
        {
            if (edittingTab && TabButton.ActiveButton)
            {
                TabButton.ActiveButton.TabData.SetColorButton(btn);
                return;
            }
            if (SelectedObject == null || btn == null) return;
            SelectedObject.SetColor(btn.Color);
            SelectedObject.SelectedColorButton = btn;
        }

        private void SetObjectScale(float arg)
        {
            if (SelectedObject == null) return;
            SelectedObject.SetScale(arg);
        }

        private void SetTextTrue(string arg)
        {
            TextSelected = true;
        }

        private void SetTextFalse(string arg)
        {
            TextSelected = false;
        }

        private void OnLabelValueChanged(string arg)
        {
            if (edittingTab)
            {
                TabButton.ActiveButton.SetText(arg);
                return;
            }
            if (SelectedObject == null) return;
            SelectedObject.SetLabel(arg);
        }


        private void OnDestroy()
        {
            if (Instance == this)
            {
                Instance = null;
            }
        }

        public void Collapse()
        {
            if (state == InspectorState.Collapsed || state == InspectorState.Animating)
                return;

            StartCoroutine(Collapse_Coroutine());
        }

        public void Expand()
        {
            if (state == InspectorState.Expanded || state == InspectorState.Animating)
                return;

            StartCoroutine(Expand_Coroutine());
        }

        private IEnumerator Collapse_Coroutine()
        {
            state = InspectorState.Animating;

            float start = rectTransform.sizeDelta.x;
            float end = collapsedWidth;

            float t = 0f;
            while (t < 1f)
            {
                t += Time.deltaTime / animationDuration;

                SetWidth(Mathf.Lerp(start, end, t));
                yield return null;
            }

            SetWidth(end);
            collapseButton.SetActive(false);
            expandButton.SetActive(true);
            state = InspectorState.Collapsed;
        }

        private IEnumerator Expand_Coroutine()
        {
            state = InspectorState.Animating;

            float start = rectTransform.sizeDelta.x;
            float end = expandedWidth;

            float t = 0f;
            while (t < 1f)
            {
                t += Time.deltaTime / animationDuration;

                SetWidth(Mathf.Lerp(start, end, t));
                yield return null;
            }

            SetWidth(end);
            collapseButton.SetActive(true);
            expandButton.SetActive(false);
            state = InspectorState.Expanded;
        }

        private void SetWidth(float w)
        {
            var size = rectTransform.sizeDelta;
            size.x = w;
            rectTransform.sizeDelta = size;
        }

        private void Update()
        {

            if (TextSelected) return;
            if (Input.GetKeyDown(KeyCode.C))
            {
                Collapse();
                Expand(); // it toggles
            }
        }

        public void ReverseEdgeDirections()
        {
            if (SelectedObject && SelectedObject is GTS.Edges.Edge)
            {
                (SelectedObject as Edges.Edge).ReverseEdge();
            }
        }

        public void ShowDijkstras()
        {
            var distances = DataManager.ComputeDijkstraDistances();
            if (distances == null) return; // invalid press

            foreach (var pair in distances)
            {
                pair.Key.DisplayDistance(true, pair.Value);
            }
        }

        public void HideDijkstra()
        {
            foreach (var n in TabButton.ActiveButton.TabData.AllNodes)
            {
                n.DisplayDistance(false, 0);
            }
        }
    }
}
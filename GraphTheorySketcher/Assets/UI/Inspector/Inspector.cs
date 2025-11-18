using System;
using System.Collections;
using GTS;
using GTS.UI.Inspector;
using TMPro;
using UnityEngine;

namespace GTS.UI.Inspector {
public class Inspector : MonoBehaviour
{
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

    private RectTransform rectTransform;
    private InspectorState state;

    public static void ObjectSelected(GraphObject obj)
    {
        SelectedObject = obj;
        if (Instance)
        {
            Instance.Init();
        }
    }

    private void Init()
    {
        labelInputField.text = SelectedObject.Label;
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

        labelInputField.onValueChanged.AddListener(OnLabelValueChanged);

        labelInputField.onSelect.AddListener(SetTextTrue);
        labelInputField.onEndEdit.AddListener(SetTextFalse);
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
        }
        else if (Input.GetKeyDown(KeyCode.E))
        {
            Expand();
        }
    }
}
}
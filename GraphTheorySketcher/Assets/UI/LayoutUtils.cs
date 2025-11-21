using System.Collections;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

namespace GTS.UI
{
    public static class LayoutUtils
{
    /// Call this right after enabling your pause panel.
    public static IEnumerator EnableAndRefresh(GameObject panelRoot)
    {
        panelRoot.SetActive(true);

        // Let TMP/ContentSizeFitter compute preferred sizes.
        yield return null;                        // a frame
        yield return new WaitForEndOfFrame();     // end-of-frame layout pass

        RefreshHierarchy(panelRoot);
    }

    /// Call this if the panel is already active and you just want to force a refresh.
    public static void RefreshHierarchy(GameObject panelRoot)
    {
        // 1) Make sure canvases flush any pending changes.
        Canvas.ForceUpdateCanvases();

        // 2) Force text to compute preferred sizes (TMP in particular).
        foreach (var tmp in panelRoot.GetComponentsInChildren<TextMeshProUGUI>(true))
            tmp.ForceMeshUpdate();

        // 3) Nudge layout groups by toggling them (clears cached data safely).
        foreach (var group in panelRoot.GetComponentsInChildren<LayoutGroup>(true))
        {
            bool wasEnabled = group.enabled;
            group.enabled = false;
            group.enabled = wasEnabled;
        }

        // 4) Rebuild from the highest relevant RectTransform(s) DOWN, not every node.
        var rootRt = panelRoot.GetComponent<RectTransform>();
        if (rootRt != null)
        {
            LayoutRebuilder.MarkLayoutForRebuild(rootRt);
            Canvas.ForceUpdateCanvases(); // do a pass after marking
            LayoutRebuilder.ForceRebuildLayoutImmediate(rootRt);
        }

        // 5) If you have nested groups, rebuild each group container explicitly.
        foreach (var group in panelRoot.GetComponentsInChildren<LayoutGroup>(true))
            LayoutRebuilder.ForceRebuildLayoutImmediate(group.GetComponent<RectTransform>());

        // 6) Final canvas flush.
        Canvas.ForceUpdateCanvases();
    }
}

}

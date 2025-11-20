using System;
using System.IO;
using UnityEngine;
using SFB;   // <- make sure this is at the top

namespace GTS
{
    public static class FileDialogs
    {
        // =====================================================================
        // SAVE (always tries SFB async first, falls back to EditorUtility only if needed)
        // =====================================================================
        public static void OpenSaveDialog(string defaultName, Action<string> callback)
        {
            if (callback == null)
            {
                Debug.LogError("FileDialogs.OpenSaveDialog: callback is null");
                return;
            }

            Debug.Log($"FileDialogs.OpenSaveDialog called, defaultName = {defaultName}");

            try
            {
                // StandaloneFileBrowser works in Editor *and* builds (per README)
                StandaloneFileBrowser.SaveFilePanelAsync(
                    "Save Graph",
                    "",
                    defaultName,
                    "gts",
                    path =>
                    {
                        Debug.Log("SaveFilePanelAsync callback, raw path = " + (path ?? "NULL"));

                        if (string.IsNullOrEmpty(path))
                        {
                            callback(null);
                            return;
                        }

                        callback(path);
                    });
            }
            catch (DllNotFoundException e)
            {
#if UNITY_EDITOR
                Debug.LogWarning(
                    "StandaloneFileBrowser plugin not found in Editor, falling back to EditorUtility.\n" + e);

                string path = UnityEditor.EditorUtility.SaveFilePanel(
                    "Save Graph",
                    Application.dataPath,
                    defaultName,
                    "gts"
                );
                callback(string.IsNullOrEmpty(path) ? null : path);
#else
                Debug.LogError(
                    "StandaloneFileBrowser native plugin not found in build; save dialog unavailable.\n" + e);
                callback(null);
#endif
            }
        }

        // =====================================================================
        // LOAD (always tries SFB async first, falls back to EditorUtility only if needed)
        // =====================================================================
        public static void OpenLoadDialog(Action<string> callback)
        {
            if (callback == null)
            {
                Debug.LogError("FileDialogs.OpenLoadDialog: callback is null");
                return;
            }

            Debug.Log("FileDialogs.OpenLoadDialog called");

            try
            {
                StandaloneFileBrowser.OpenFilePanelAsync(
                    "Load Graph",
                    "",
                    "gts",
                    false,
                    paths =>
                    {
                        string path = (paths != null && paths.Length > 0) ? paths[0] : null;
                        Debug.Log("OpenFilePanelAsync callback, raw path = " + (path ?? "NULL"));

                        if (string.IsNullOrEmpty(path))
                        {
                            callback(null);
                            return;
                        }

                        callback(path);
                    });
            }
            catch (DllNotFoundException e)
            {
#if UNITY_EDITOR
                Debug.LogWarning(
                    "StandaloneFileBrowser plugin not found in Editor, falling back to EditorUtility.\n" + e);

                string path = UnityEditor.EditorUtility.OpenFilePanel(
                    "Load Graph",
                    Application.dataPath,
                    "gts"
                );
                callback(string.IsNullOrEmpty(path) ? null : path);
#else
                Debug.LogError(
                    "StandaloneFileBrowser native plugin not found in build; load dialog unavailable.\n" + e);
                callback(null);
#endif
            }
        }
    }
}

using System;
using System.IO;
using System.Runtime.InteropServices;
using UnityEngine;

namespace GTS
{
    public static class FileDialogs
    {
        // =====================================================================
        // WEBGL: JS interop (content-based save/load)
        // =====================================================================
#if UNITY_WEBGL && !UNITY_EDITOR
        [DllImport("__Internal")]
        private static extern void DownloadFile(string fileName, string mimeType, string content);

        [DllImport("__Internal")]
        private static extern void UploadFile(string gameObjectName, string methodName, string accept);

        /// <summary>
        /// Hidden receiver MonoBehaviour to get file contents back from JS via SendMessage.
        /// </summary>
        private class WebGLFileReceiver : MonoBehaviour
        {
            public static WebGLFileReceiver Instance { get; private set; }
            public Action<string> OnFileLoadedCallback;

            private void Awake()
            {
                if (Instance != null && Instance != this)
                {
                    Destroy(gameObject);
                    return;
                }

                Instance = this;
                UnityEngine.Object.DontDestroyOnLoad(gameObject);
            }

            // Called from JS: SendMessage(gameObjectName, "OnFileLoaded", fileText)
            public void OnFileLoaded(string fileContent)
            {
                var cb = OnFileLoadedCallback;
                OnFileLoadedCallback = null;

                if (cb != null)
                {
                    try
                    {
                        cb.Invoke(fileContent);
                    }
                    catch (Exception ex)
                    {
                        Debug.LogError($"[FileDialogs] Error in LoadGraph callback: {ex}");
                    }
                }
                else
                {
                    Debug.LogWarning("[FileDialogs] OnFileLoaded called with no pending callback.");
                }
            }
        }

        private static WebGLFileReceiver EnsureReceiver()
        {
            if (WebGLFileReceiver.Instance != null)
                return WebGLFileReceiver.Instance;

            var go = new GameObject("WebGLFileReceiver");
            return go.AddComponent<WebGLFileReceiver>();
        }

        private static void SaveTextWeb(string defaultName, string text, string mimeType = "application/json")
        {
            if (string.IsNullOrEmpty(defaultName))
                defaultName = "graph.gts";

            if (text == null)
                text = string.Empty;

            DownloadFile(defaultName, mimeType, text);
        }

        private static void LoadTextWeb(Action<string> callback, string acceptExtensions = ".gts,.json,.txt")
        {
            if (callback == null)
            {
                Debug.LogError("[FileDialogs] LoadTextWeb: callback is null");
                return;
            }

            var receiver = EnsureReceiver();
            receiver.OnFileLoadedCallback = callback;

            UploadFile(receiver.gameObject.name, nameof(WebGLFileReceiver.OnFileLoaded), acceptExtensions);
        }
#endif

        // =====================================================================
        // HIGH-LEVEL GRAPH API (single entry points for callers)
        // =====================================================================

        /// <summary>
        /// Save the current graph.
        /// - Editor: EditorUtility.SaveFilePanel + writes file to disk.
        /// - WebGL: triggers browser download of the returned string.
        /// - Standalone builds: NOT SUPPORTED (logs warning, returns false).
        /// </summary>
        public static void SaveGraph(string defaultName, Func<string> getContent, Action<bool> onCompleted = null)
        {
            if (getContent == null)
            {
                Debug.LogError("[FileDialogs] SaveGraph: getContent is null");
                onCompleted?.Invoke(false);
                return;
            }

#if UNITY_WEBGL && !UNITY_EDITOR
            try
            {
                string content = getContent();
                SaveTextWeb(defaultName, content, "application/json");
                onCompleted?.Invoke(true);
            }
            catch (Exception ex)
            {
                Debug.LogError($"[FileDialogs] SaveGraph (WebGL) failed: {ex}");
                onCompleted?.Invoke(false);
            }
#elif UNITY_EDITOR
            string path = UnityEditor.EditorUtility.SaveFilePanel(
                "Save Graph",
                Application.dataPath,
                defaultName,
                "gts"
            );

            if (string.IsNullOrEmpty(path))
            {
                onCompleted?.Invoke(false);
                return;
            }

            try
            {
                string content = getContent();
                File.WriteAllText(path, content);
                onCompleted?.Invoke(true);
            }
            catch (Exception ex)
            {
                Debug.LogError($"[FileDialogs] SaveGraph (Editor) failed: {ex}");
                onCompleted?.Invoke(false);
            }
#else
            Debug.LogWarning("[FileDialogs] SaveGraph is not supported in standalone builds. " +
                             "Use the WebGL build or run inside the Unity Editor.");
            onCompleted?.Invoke(false);
#endif
        }

        /// <summary>
        /// Load a graph.
        /// - Editor: EditorUtility.OpenFilePanel + reads file contents.
        /// - WebGL: browser file picker, passes selected file's text.
        /// - Standalone builds: NOT SUPPORTED (logs warning, returns null).
        /// </summary>
        public static void LoadGraph(Action<string> onLoaded)
        {
            if (onLoaded == null)
            {
                Debug.LogError("[FileDialogs] LoadGraph: onLoaded is null");
                return;
            }

#if UNITY_WEBGL && !UNITY_EDITOR
            LoadTextWeb(onLoaded, ".gts,.json,.txt");
#elif UNITY_EDITOR
            string path = UnityEditor.EditorUtility.OpenFilePanel(
                "Load Graph",
                Application.dataPath,
                "gts"
            );

            if (string.IsNullOrEmpty(path))
            {
                onLoaded(null);
                return;
            }

            try
            {
                string text = File.ReadAllText(path);
                onLoaded(text);
            }
            catch (Exception ex)
            {
                Debug.LogError($"[FileDialogs] LoadGraph (Editor) failed: {ex}");
                onLoaded(null);
            }
#else
            Debug.LogWarning("[FileDialogs] LoadGraph is not supported in standalone builds. " +
                             "Use the WebGL build or run inside the Unity Editor.");
            onLoaded(null);
#endif
        }
    }
}

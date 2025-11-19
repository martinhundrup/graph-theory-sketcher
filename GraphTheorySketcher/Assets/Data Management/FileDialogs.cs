using UnityEngine;
using System.IO;

namespace GTS {
public static class FileDialogs
{
    // SAVE dialog
    public static string OpenSaveDialog(string defaultName)
    {
#if UNITY_EDITOR
        // Editor-only dialog
        string path = UnityEditor.EditorUtility.SaveFilePanel(
            "Save Graph",
            Application.dataPath,
            defaultName,
            "gts"       // <- custom extension
        );
        return string.IsNullOrEmpty(path) ? null : path;

#elif UNITY_STANDALONE_WIN || UNITY_STANDALONE_OSX || UNITY_STANDALONE_LINUX
        var ext = new SFB.ExtensionFilter[] { new SFB.ExtensionFilter("Graph Tab", "gts") };
        string path = SFB.StandaloneFileBrowser.SaveFilePanel(
            "Save Graph",
            "",
            defaultName,
            ext
        );
        return string.IsNullOrEmpty(path) ? null : path;
#else
        Debug.LogWarning("Save dialog not supported on this platform.");
        return null;
#endif
    }

    // LOAD dialog
    public static string OpenLoadDialog()
    {
#if UNITY_EDITOR
        string path = UnityEditor.EditorUtility.OpenFilePanel(
            "Load Graph",
            Application.dataPath,
            "gts"       // <- only show .gts files
        );
        return string.IsNullOrEmpty(path) ? null : path;

#elif UNITY_STANDALONE_WIN || UNITY_STANDALONE_OSX || UNITY_STANDALONE_LINUX
        var ext = new SFB.ExtensionFilter[] { new SFB.ExtensionFilter("Graph Tab", "gts") };
        string[] paths = SFB.StandaloneFileBrowser.OpenFilePanel(
            "Load Graph",
            "",
            ext,
            false       // single selection
        );
        if (paths == null || paths.Length == 0)
            return null;

        return string.IsNullOrEmpty(paths[0]) ? null : paths[0];
#else
        Debug.LogWarning("Load dialog not supported on this platform.");
        return null;
#endif
    }
}
}
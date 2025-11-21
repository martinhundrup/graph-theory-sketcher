using TMPro;
using UnityEngine;

namespace GTS.UI
{

    [RequireComponent(typeof(TextMeshProUGUI))]
    public class ApplicationVersionDisplay : MonoBehaviour
    {
        private void Awake()
        {
            GetComponent<TextMeshProUGUI>().text = $"Sketch-O-Graph v{Application.version}";
        }
    }
}
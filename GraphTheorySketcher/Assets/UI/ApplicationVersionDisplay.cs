using TMPro;
using UnityEngine;

namespace GTS.UI
{

    [RequireComponent(typeof(TextMeshProUGUI))]
    public class ApplicationVersionDisplay : MonoBehaviour
    {
        private void Awake()
        {
            GetComponent<TextMeshProUGUI>().text = $"Graph Theory Sketcher v{Application.version}";
        }
    }
}
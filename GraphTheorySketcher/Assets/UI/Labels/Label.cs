using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace GTS.UI.Labels {
    public class Label : MonoBehaviour
    {
        private void Awake()
        {
            LabelVisibilityButton.VisibilityToggled += Toggle;
        }

        private void OnDestroy()
        {
            LabelVisibilityButton.VisibilityToggled -= Toggle;
        }

        private void Toggle(bool b)
        {
            this.gameObject.SetActive(b);
        }
    }
}

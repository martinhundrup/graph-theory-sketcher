using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace GTS.Nodes {
    public class Node : MonoBehaviour
    {
        [SerializeField] private float scale = 1f; // visual scale of the node
        [SerializeField] private Color color = Color.white; // color of the node
    }
}
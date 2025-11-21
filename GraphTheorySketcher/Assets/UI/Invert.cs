using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Invert : MonoBehaviour
{
    [SerializeField] private List<Image> images = new List<Image>();

    public void InvertColors()
    {
        foreach (var image in images)
        {
            image.color = GetInverse(image.color);
        }
    }

    private Color GetInverse(Color c)
    {
        return c == Color.white ? Color.black : Color.white;
    }
}

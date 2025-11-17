using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Appearance : MonoBehaviour
{
    [SerializeField] private GameObject gameObj;

    private void Awake()
    {
        Appear(false);
    }

    public void Appear(bool arg)
    {
        gameObj.SetActive(arg);
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace GTS.DataManagement{
    public class DataManager : MonoBehaviour
    {
        public static DataManager Instance
        {
            get;
            private set;
        }

        [SerializeField] private GameObject nodePrefab;
        [SerializeField] private GameObject edgePrefab;

        private void Awake()
        {
            if (Instance != null)
            {
                Destroy(this.gameObject);
                return;
            }

            DontDestroyOnLoad(this.gameObject);
            Instance = this;
        }

        public GameObject NodePrefab
        {
            get {return nodePrefab;}
        }

        public GameObject EdgePrefab
        {
            get {return edgePrefab;}
        }
    }
}
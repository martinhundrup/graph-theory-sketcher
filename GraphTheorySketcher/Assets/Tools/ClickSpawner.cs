using UnityEngine;
using UnityEngine.EventSystems;

namespace GTS.Tools
{
    public class ClickSpawner : MonoBehaviour
    {
        [SerializeField] private GameObject prefabToSpawn;
        [SerializeField] private Tool tool;

        void Update()
        {
            if (ToolManager.ActiveTool != tool) return;

            if (EventSystem.current.IsPointerOverGameObject())
                return; // clicking UI → ignore

            
            // Left mouse click
            if (Input.GetMouseButtonDown(0))
            {
                SpawnAtClick();
            }
        }

        private void SpawnAtClick()
        {
            if (prefabToSpawn == null || Camera.main == null)
                return;

            // Convert screen to world
            Vector3 mouseScreen = Input.mousePosition;
            Vector3 world = Camera.main.ScreenToWorldPoint(mouseScreen);

            // Zero out depth (2D)
            world.z = 0f;

            Instantiate(prefabToSpawn, world, Quaternion.identity);
        }
    }
}

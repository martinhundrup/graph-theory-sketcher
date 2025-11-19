using UnityEngine;
using GTS.Tools;
using GTS.UI.Inspector; // For Tool + ToolManager

namespace GTS
{
    [RequireComponent(typeof(Camera))]
    public class CameraViewportController : MonoBehaviour
    {
        [Header("Zoom")]
        [SerializeField] private float minZoom = 2f;
        [SerializeField] private float maxZoom = 20f;
        [SerializeField] private float zoomSpeed = 5f;

        [Header("Panning")]
        [SerializeField] private float panSpeed = 0.5f;
        [SerializeField] private Vector2 minBounds = new Vector2(-50f, -50f);
        [SerializeField] private Vector2 maxBounds = new Vector2(50f, 50f);

        private Camera cam;

        // Default state (captured on Awake)
        private Vector3 defaultPosition;
        private float defaultZoom;

        // Cached tool state
        private bool panToolActive = false;

        private void Awake()
        {
            cam = GetComponent<Camera>();
            cam.orthographic = true;

            defaultPosition = transform.position;
            defaultZoom = cam.orthographicSize;
        }

        private void OnEnable()
        {
            ToolManager.OnActiveToolChanged += HandleToolChanged;
            HandleToolChanged(ToolManager.ActiveTool);
        }

        private void OnDisable()
        {
            ToolManager.OnActiveToolChanged -= HandleToolChanged;
        }

        private void HandleToolChanged(Tool tool)
        {
            panToolActive = (tool == Tool.Pan);
        }

        private void Update()
        {
            HandleZoom();
            HandlePan();

            if (!Inspector.TextSelected && Input.GetKeyDown(KeyCode.R))
            {
                ResetViewport();
            }
        }

        private void HandleZoom()
        {
            float scroll = Input.mouseScrollDelta.y;
            if (Mathf.Approximately(scroll, 0f))
                return;

            float newSize = cam.orthographicSize - scroll * zoomSpeed;
            cam.orthographicSize = Mathf.Clamp(newSize, minZoom, maxZoom);
        }

        private void HandlePan()
        {
            if (!panToolActive)
                return;

            // Left mouse drag to pan
            if (Input.GetMouseButton(0))
            {
                // Move opposite to mouse drag to feel like dragging the canvas
                float deltaX = -Input.GetAxis("Mouse X") * panSpeed * cam.orthographicSize;
                float deltaY = -Input.GetAxis("Mouse Y") * panSpeed * cam.orthographicSize;

                Vector3 pos = transform.position;
                pos.x += deltaX;
                pos.y += deltaY;

                // Clamp to bounds
                pos.x = Mathf.Clamp(pos.x, minBounds.x, maxBounds.x);
                pos.y = Mathf.Clamp(pos.y, minBounds.y, maxBounds.y);

                transform.position = pos;
            }
        }

        public void ResetViewport()
        {
            transform.position = defaultPosition;
            cam.orthographicSize = defaultZoom;
        }
    }
}

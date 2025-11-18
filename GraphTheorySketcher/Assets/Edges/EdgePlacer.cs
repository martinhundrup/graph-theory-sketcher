using GTS.Nodes;
using GTS.Tools;
using UnityEngine;

namespace GTS.Edges
{
    public class EdgePlacer : MonoBehaviour
    {
        public static EdgePlacer Instance { get; private set; }

        [Header("Setup")]
        [SerializeField] private Edge edgePrefab;

        // Runtime state
        private Node startNode;
        private bool isDragging;

        private GameObject tempEdgeObject;
        private LineRenderer tempLineRenderer;

        private void Awake()
        {
            if (Instance != null && Instance != this)
            {
                Destroy(gameObject);
                return;
            }

            Instance = this;
        }

        private void Update()
        {
            // Only do anything when the EdgeCreator tool is active
            if (ToolManager.ActiveTool != Tool.EdgeCreator || Camera.main == null)
            {
                // If the tool switched away mid-placement, cancel
                if (isDragging)
                    CancelPlacement();

                return;
            }

            if (isDragging)
            {
                // While dragging, keep the temp edge following the cursor
                UpdateTempEdge();

                // Mouse up: try to finish edge on a second node (or cancel)
                if (Input.GetMouseButtonUp(0))
                {
                    TryCompleteEdge();
                }
            }
        }

        /// <summary>
        /// Called by Node.OnMouseDown when the Edge tool is active.
        /// </summary>
        public void BeginEdgeFromNode(Node node)
        {
            if (node == null)
                return;

            if (ToolManager.ActiveTool != Tool.EdgeCreator)
                return;

            startNode = node;
            isDragging = true;

            CreateTempEdge(startNode.transform.position);
        }

        private void UpdateTempEdge()
        {
            if (tempLineRenderer == null || startNode == null)
                return;

            Vector3 cursorWorld = GetMouseWorldPosition();

            tempLineRenderer.SetPosition(0, startNode.transform.position);
            tempLineRenderer.SetPosition(1, cursorWorld);
        }

        private void TryCompleteEdge()
        {
            Node targetNode = GetNodeUnderCursor();

            if (targetNode != null && targetNode != startNode)
            {
                CreateRealEdge(startNode, targetNode);
            }

            // Either way, stop dragging and remove temp edge
            CancelPlacement();
        }

        private void CreateRealEdge(Node a, Node b)
        {
            if (edgePrefab == null)
            {
                Debug.LogWarning("EdgePlacer: edgePrefab is not assigned.");
                return;
            }

            Edge edgeInstance = Instantiate(edgePrefab, Vector3.zero, Quaternion.identity);
            edgeInstance.SetEndpoints(a, b);
        }

        private void CreateTempEdge(Vector3 startPos)
        {
            tempEdgeObject = new GameObject("Temp Edge");
            tempLineRenderer = tempEdgeObject.AddComponent<LineRenderer>();

            tempLineRenderer.positionCount = 2;
            tempLineRenderer.useWorldSpace = true;

            // Basic defaults – tweak as needed or swap material
            tempLineRenderer.startWidth = 0.25f;
            tempLineRenderer.endWidth = 0.25f;
            tempLineRenderer.material = new Material(Shader.Find("Sprites/Default"));

            tempLineRenderer.SetPosition(0, startPos);
            tempLineRenderer.SetPosition(1, startPos);
        }

        private void CancelPlacement()
        {
            isDragging = false;
            startNode = null;

            if (tempEdgeObject != null)
            {
                Destroy(tempEdgeObject);
            }

            tempEdgeObject = null;
            tempLineRenderer = null;
        }

        private Node GetNodeUnderCursor()
        {
            Vector3 worldPos = GetMouseWorldPosition();
            Vector2 pos2D = new Vector2(worldPos.x, worldPos.y);

            RaycastHit2D hit = Physics2D.Raycast(pos2D, Vector2.zero, 0.01f);
            if (!hit)
                return null;

            Node node = hit.collider.GetComponent<Node>();
            if (node == null)
                node = hit.collider.GetComponentInParent<Node>();

            return node;
        }

        private Vector3 GetMouseWorldPosition()
        {
            Vector3 screenPos = Input.mousePosition;
            Vector3 worldPos = Camera.main.ScreenToWorldPoint(screenPos);
            worldPos.z = 0f;
            return worldPos;
        }
    }
}

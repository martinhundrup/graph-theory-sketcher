using System;
using System.Collections.Generic;

namespace GTS.Nodes
{
    public static class NodeIDGenerator
    {
        // Keeps track of IDs used this run so we never repeat in one session
        private static readonly HashSet<ulong> usedIds = new HashSet<ulong>();
        private static readonly Random rng;

        static NodeIDGenerator()
        {
            // Seed with something hard to predict so each run is different
            rng = new Random(Guid.NewGuid().GetHashCode());
        }

        /// <summary>
        /// Returns a new random 64-bit ID, guaranteed unique for this app session
        /// and astronomically unlikely to collide across sessions.
        /// </summary>
        public static ulong GetNextId()
        {
            ulong candidate;

            // Very fast in practice; collisions are insanely unlikely
            do
            {
                candidate = NextUInt64();
            }
            while (!usedIds.Add(candidate));

            return candidate;
        }

        /// <summary>
        /// Optional: call when a node is destroyed if you want to
        /// allow its ID to be reused later in the same session.
        /// </summary>
        public static void ReleaseId(ulong id)
        {
            usedIds.Remove(id);
        }

        /// <summary>
        /// Optional: clears all tracked IDs (e.g. when clearing a tab).
        /// </summary>
        public static void Reset()
        {
            usedIds.Clear();
        }

        private static ulong NextUInt64()
        {
            var buffer = new byte[8];
            rng.NextBytes(buffer);
            return BitConverter.ToUInt64(buffer, 0);
        }
    }
}

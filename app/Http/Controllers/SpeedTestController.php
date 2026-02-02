<?php

namespace App\Http\Controllers;

use App\Models\Item;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;

/**
 * SpeedTestController - Demonstrates Redis caching performance
 *
 * This controller shows the timing difference between:
 * 1. Fetching items from database directly (slow)
 * 2. Fetching items from Redis cache (fast)
 */
class SpeedTestController extends Controller
{
    /**
     * Test endpoint that compares database vs Redis performance
     *
     * Query params:
     * - cache=on|off (default: off)
     *
     * Returns JSON with:
     * - source: "database" or "redis"
     * - execution_time_ms: Time taken to fetch items (in milliseconds)
     * - items_count: Number of items retrieved
     * - cache_status: "hit" or "miss" (for Redis only)
     */
    public function test(Request $request)
    {
        // Determine if caching is enabled
        $useCache = $request->query('cache') === 'on';

        // Start the timer (using microtime for high precision)
        $startTime = microtime(true);

        if ($useCache) {
            // ========== REDIS CACHING ==========
            // Cache::remember() will:
            // 1. Check if 'items_all' key exists in Redis
            // 2. If yes, return cached data (cache hit)
            // 3. If no, execute the callback to fetch from DB, then cache for 60 seconds (cache miss)

            // Check if cache already has the data (for logging purposes)
            $cacheHit = Cache::has('items_all');

            $items = Cache::remember('items_all', 60, function () {
                // This callback only runs on cache miss
                // Fetches ALL items from database into memory
                return Item::select('id', 'name')->get();
            });

            $source = 'redis';
            $cacheStatus = $cacheHit ? 'hit' : 'miss';

        } else {
            // ========== DATABASE (NO CACHING) ==========
            // Fetch items directly from database every time
            // This will be noticeably slower, especially with large datasets

            $items = Item::select('id', 'name')->get();

            $source = 'database';
            $cacheStatus = null;
        }

        // End the timer
        $endTime = microtime(true);

        // Calculate execution time in milliseconds
        $executionTimeMs = round(($endTime - $startTime) * 1000, 2);

        // Return results as JSON
        return response()->json([
            'source' => $source,
            'cache_status' => $cacheStatus,
            'execution_time_ms' => $executionTimeMs,
            'items_count' => $items->count(),
            'message' => $useCache
                ? "Redis cache ($cacheStatus) returned {$items->count()} items in {$executionTimeMs}ms"
                : "Database query returned {$items->count()} items in {$executionTimeMs}ms",
        ]);
    }

    /**
     * Invalidate endpoint - clears the Redis cache
     *
     * After calling this, the next /test?cache=on request will experience a cache miss
     * and fetch fresh data from the database
     */
    public function invalidate()
    {
        // Clear the Redis cache key
        Cache::forget('items_all');

        return response()->json([
            'message' => 'Redis cache cleared! Next request will be a cache miss.',
            'status' => 'success',
        ]);
    }
}

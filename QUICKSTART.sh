#!/bin/bash

# ============================================================================
# RedisSpeedLab - Quick Start Guide
# ============================================================================
# This file contains all the commands needed to run and test the project

echo ""
echo "╔════════════════════════════════════════════════════════════════════════╗"
echo "║                  Redis Speed Lab - Quick Start Guide                   ║"
echo "╚════════════════════════════════════════════════════════════════════════╝"
echo ""

PROJECT_PATH="/Users/bj/Documents/Work/RedisSpeedLab"

# ============================================================================
# STEP 1: Verify Prerequisites
# ============================================================================
echo "✓ Step 1: Verifying Prerequisites"
echo ""
echo "  Required:"
echo "  - PHP 8.2+ (installed)"
echo "  - Laravel 11 (installed)"
echo "  - Redis Server"
echo "  - MySQL/SQLite"
echo ""

# ============================================================================
# STEP 2: Ensure Redis is Running
# ============================================================================
echo "✓ Step 2: Ensure Redis is Running"
echo ""
echo "  If Redis is not running, start it with:"
echo "    brew services start redis"
echo ""
echo "  Verify Redis is running:"
echo "    redis-cli ping"
echo "    # Should respond with: PONG"
echo ""

# ============================================================================
# STEP 3: Start Laravel Development Server
# ============================================================================
echo "✓ Step 3: Start Laravel Development Server"
echo ""
echo "  In a terminal, run:"
echo "    cd $PROJECT_PATH"
echo "    php artisan serve --port=8080"
echo ""
echo "  Laravel will start on: http://localhost:8080"
echo ""

# ============================================================================
# STEP 4: Test Endpoints (Run in separate terminal)
# ============================================================================
echo "✓ Step 4: Test Endpoints"
echo ""
echo "  4a) Test Database Query (No Cache):"
echo "      curl 'http://localhost:8080/test?cache=off'"
echo "      Expected: 40-60ms execution time"
echo ""
echo "  4b) Clear Redis Cache:"
echo "      curl 'http://localhost:8080/invalidate'"
echo ""
echo "  4c) Test Redis Cache - First Request (Cache Miss):"
echo "      curl 'http://localhost:8080/test?cache=on'"
echo "      Expected: ~50ms (same as database, cache miss)"
echo ""
echo "  4d) Test Redis Cache - Second Request (Cache Hit):"
echo "      curl 'http://localhost:8080/test?cache=on'"
echo "      Expected: 1-5ms (MUCH faster, cached from Redis)"
echo ""
echo "  4e) Repeat request 4d to see consistent cache hits"
echo ""

# ============================================================================
# STEP 5: Understanding the Results
# ============================================================================
echo "✓ Step 5: Understanding the Results"
echo ""
echo "  Response Format:"
echo "  {"
echo "    \"source\": \"database\" or \"redis\","
echo "    \"cache_status\": \"hit\" or \"miss\" (Redis only),"
echo "    \"execution_time_ms\": 35.81,"
echo "    \"items_count\": 10000,"
echo "    \"message\": \"...description...\""
echo "  }"
echo ""
echo "  Key Observations:"
echo "  - Database: Consistent 40-60ms"
echo "  - Redis Miss: Similar to database (fetches + caches)"
echo "  - Redis Hit: 1-5ms (20-50x FASTER!)"
echo ""

# ============================================================================
# STEP 6: Watch TTL in Action
# ============================================================================
echo "✓ Step 6: Watch TTL (Time To Live) in Action"
echo ""
echo "  1. Make a request with cache=on (cache hit, ~2ms)"
echo "     curl 'http://localhost:8080/test?cache=on'"
echo ""
echo "  2. Wait 60 seconds"
echo "     sleep 60"
echo ""
echo "  3. Make the same request again"
echo "     curl 'http://localhost:8080/test?cache=on'"
echo "     Expected: Cache miss (~50ms) because TTL expired"
echo ""

# ============================================================================
# STEP 7: Bonus - Inspect Redis directly
# ============================================================================
echo "✓ Step 7: Bonus - Inspect Redis Directly"
echo ""
echo "  Start Redis CLI:"
echo "    redis-cli"
echo ""
echo "  Common commands:"
echo "    KEYS *                  # See all keys"
echo "    GET items_all           # Get the cached items"
echo "    TTL items_all           # See seconds until expiration"
echo "    DEL items_all           # Delete the key"
echo "    FLUSHALL                # Clear all Redis data"
echo ""

# ============================================================================
# Project Files
# ============================================================================
echo "✓ Project Files"
echo ""
echo "  Controller:"
echo "    app/Http/Controllers/SpeedTestController.php"
echo "    - Implements the /test and /invalidate endpoints"
echo "    - Use Cache::remember() for caching logic"
echo ""
echo "  Model:"
echo "    app/Models/Item.php"
echo ""
echo "  Migration:"
echo "    database/migrations/2026_02_02_191630_create_items_table.php"
echo ""
echo "  Seeder:"
echo "    database/seeders/ItemSeeder.php"
echo "    - Inserts 10,000 dummy items"
echo ""
echo "  Routes:"
echo "    routes/web.php"
echo "    - GET /test (cache=on|off)"
echo "    - GET /invalidate"
echo ""

# ============================================================================
# Configuration
# ============================================================================
echo "✓ Configuration"
echo ""
echo "  Cache Driver (.env):"
echo "    CACHE_STORE=redis"
echo ""
echo "  Redis Connection (.env):"
echo "    REDIS_HOST=127.0.0.1"
echo "    REDIS_PORT=6379"
echo "    REDIS_PASSWORD=null"
echo ""
echo "  TTL:"
echo "    Hardcoded to 60 seconds in SpeedTestController"
echo "    Cache::remember('items_all', 60, ...)"
echo ""

# ============================================================================
# Learning Outcomes
# ============================================================================
echo "✓ Learning Outcomes"
echo ""
echo "  After completing this lab, you'll understand:"
echo "  ✓ How Redis caching improves performance (20-50x faster)"
echo "  ✓ The difference between cache hits and misses"
echo "  ✓ How TTL (Time To Live) works"
echo "  ✓ When caching is beneficial (large datasets, repeated queries)"
echo "  ✓ How to implement caching in Laravel with Cache::remember()"
echo ""

echo "╔════════════════════════════════════════════════════════════════════════╗"
echo "║               Ready to start? Follow the steps above!                  ║"
echo "╚════════════════════════════════════════════════════════════════════════╝"
echo ""

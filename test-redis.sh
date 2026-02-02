#!/bin/bash

# Redis Speed Lab - Testing Script
# This script demonstrates the performance difference between database and Redis caching

BASE_URL="http://localhost:8000"
CACHE_KEY="items_all"

echo "======================================="
echo "   Redis Speed Lab - Test Script"
echo "======================================="
echo ""

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test 1: Database query (no cache)
echo -e "${BLUE}TEST 1: Database Query (No Cache)${NC}"
echo "URL: $BASE_URL/test?cache=off"
echo ""
curl -s "$BASE_URL/test?cache=off" | jq '.'
echo ""
echo ""

# Test 2: Clear cache
echo -e "${BLUE}TEST 2: Clear Redis Cache${NC}"
echo "URL: $BASE_URL/invalidate"
echo ""
curl -s "$BASE_URL/invalidate" | jq '.'
echo ""
echo ""

# Test 3: Cache miss
echo -e "${BLUE}TEST 3: Redis Cache - First Request (Cache Miss)${NC}"
echo "URL: $BASE_URL/test?cache=on"
echo ""
curl -s "$BASE_URL/test?cache=on" | jq '.'
echo ""
echo ""

# Test 4: Cache hit
echo -e "${BLUE}TEST 4: Redis Cache - Second Request (Cache Hit)${NC}"
echo "URL: $BASE_URL/test?cache=on"
echo ""
curl -s "$BASE_URL/test?cache=on" | jq '.'
echo ""
echo ""

# Test 5: Compare multiple hits
echo -e "${BLUE}TEST 5: Multiple Cache Hits (runs 5 times)${NC}"
echo ""
for i in {1..5}; do
    result=$(curl -s "$BASE_URL/test?cache=on")
    time_ms=$(echo "$result" | jq '.execution_time_ms')
    status=$(echo "$result" | jq -r '.cache_status')
    echo -e "${GREEN}Run $i:${NC} ${status} - ${time_ms}ms"
    sleep 0.5
done
echo ""
echo ""

# Test 6: Show insights
echo -e "${BLUE}TEST 6: Key Insights${NC}"
echo ""
echo "1. Database query (cache=off):"
echo "   - Queries directly from MySQL"
echo "   - Typical time: 40-60ms (depends on server load)"
echo ""
echo "2. Redis cache miss (after invalidate):"
echo "   - Checks Redis, finds nothing"
echo "   - Queries database, stores in Redis for 60 seconds"
echo "   - Typical time: 40-60ms (similar to database)"
echo ""
echo "3. Redis cache hit (within 60 seconds):"
echo "   - Checks Redis, data already exists"
echo "   - Returns pre-cached data from memory"
echo "   - Typical time: 1-5ms (20-50x faster!)"
echo ""
echo "4. TTL Behavior:"
echo "   - Cache expires after 60 seconds"
echo "   - Next request will be a cache miss again"
echo "   - Try waiting 61 seconds and make another request"
echo ""
echo "======================================="
echo "   Test Complete!"
echo "======================================="

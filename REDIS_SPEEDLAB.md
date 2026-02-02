# Redis Speed Lab - Learning Project

A minimal Laravel project to demonstrate the **performance difference between database queries and Redis caching**.

## Purpose

This is a **teaching project** designed to clearly show:
- ✅ How Redis caching improves performance
- ✅ Cache hits vs cache misses
- ✅ TTL (Time To Live) behavior
- ✅ When caching makes the biggest difference (large datasets)

## Project Setup

### Prerequisites
- PHP 8.2+
- Laravel 11
- Redis server running locally
- MySQL or SQLite database

### Quick Start

```bash
# 1. Database setup (already done)
# - Table: items (10,000 records with name column)
# - Seeds inserted via ItemSeeder

# 2. Start Redis (if not running)
redis-server

# 3. Start Laravel development server
php artisan serve

# 4. Test the endpoints (see below)
```

## The Database

**Table: `items`**
- Columns: `id`, `name`, `created_at`, `updated_at`
- Records: 10,000 dummy items

Why 10,000? To make the performance difference obvious and measurable.

## Testing the Performance

### Test 1: Database Query (No Cache)

```bash
curl "http://localhost:8000/test?cache=off"
```

**Response:**
```json
{
  "source": "database",
  "cache_status": null,
  "execution_time_ms": 45.23,
  "items_count": 10000,
  "message": "Database query returned 10000 items in 45.23ms"
}
```

**Note:** First run might be ~45ms. Subsequent runs depend on MySQL query cache.

---

### Test 2: Redis Cache - Cache Miss

```bash
# First, clear the cache
curl "http://localhost:8000/invalidate"

# Then, make a request with cache enabled
curl "http://localhost:8000/test?cache=on"
```

**Response:**
```json
{
  "source": "redis",
  "cache_status": "miss",
  "execution_time_ms": 48.15,
  "items_count": 10000,
  "message": "Redis cache (miss) returned 10000 items in 48.15ms"
}
```

**Why is it slow?**
- Cache miss = Redis queries the database
- Same speed as database query (slightly slower due to serialization)

---

### Test 3: Redis Cache - Cache Hit

```bash
# Make the same request immediately (within 60 seconds)
curl "http://localhost:8000/test?cache=on"
```

**Response:**
```json
{
  "source": "redis",
  "cache_status": "hit",
  "execution_time_ms": 2.45,
  "items_count": 10000,
  "message": "Redis cache (hit) returned 10000 items in 2.45ms"
}
```

**Why is it fast?**
- Cache hit = Redis returns pre-cached data from memory
- **~20x faster** than database!

---

## The Learning Flow

### Step 1: Understand Database Performance
```bash
curl "http://localhost:8000/test?cache=off"
# Take note of execution_time_ms (typically 40-60ms)
```

### Step 2: Understand Cache Misses
```bash
curl "http://localhost:8000/invalidate"
curl "http://localhost:8000/test?cache=on"
# execution_time_ms should be similar to database (cache miss)
```

### Step 3: See Cache Hits
```bash
curl "http://localhost:8000/test?cache=on"
# execution_time_ms drops to 1-5ms (cache hit!)
```

### Step 4: Watch TTL in Action
```bash
curl "http://localhost:8000/test?cache=on"  # cache hit (2ms)
# Wait 60 seconds...
curl "http://localhost:8000/test?cache=on"  # cache miss (~45ms, TTL expired)
```

## Code Architecture

### Files Created

```
app/
├── Http/Controllers/
│   └── SpeedTestController.php     # Main logic with detailed comments
├── Models/
│   └── Item.php                    # Simple model

database/
├── migrations/
│   └── 2026_02_02_191630_create_items_table.php
└── seeders/
    └── ItemSeeder.php              # Inserts 10,000 items

routes/
└── web.php                          # Two endpoints: /test and /invalidate
```

### Key Code: The Controller

**Location:** `app/Http/Controllers/SpeedTestController.php`

```php
// Cache enabled: Uses Cache::remember()
$items = Cache::remember('items_all', 60, function () {
    return Item::select('id', 'name')->get();
});

// Cache disabled: Direct database query
$items = Item::select('id', 'name')->get();
```

**How Cache::remember() Works:**
1. Checks if `items_all` key exists in Redis
2. If yes (hit) → returns cached data instantly
3. If no (miss) → executes callback (fetches from DB), caches result for 60 seconds, then returns

## Configuration

**Redis Setup (.env)**
```env
CACHE_STORE=redis
REDIS_HOST=127.0.0.1
REDIS_PORT=6379
REDIS_PASSWORD=null
```

**TTL Configuration:**
- Hardcoded in controller: `Cache::remember('items_all', 60, ...)`
- 60 seconds is when the cache expires automatically

## Real-World Insights

### When Redis Shines
✅ Repeated access to **expensive queries**
✅ **Large datasets** (like 10,000 items)
✅ **High-traffic endpoints** (many concurrent requests)

### When Redis Helps Less
❌ Small datasets (few milliseconds difference)
❌ Rarely accessed data (cache misses are expensive)
❌ Frequently changing data (TTL becomes critical)

### The Trade-off
- **Pro:** Massive speed improvements (2-20x faster)
- **Con:** Cache must be **invalidated** when data changes
- **Solution:** Set appropriate TTL and invalidate strategically

## Testing Commands

```bash
# Start server
php artisan serve

# In another terminal:

# Test without cache
curl "http://localhost:8000/test?cache=off"

# Clear cache
curl "http://localhost:8000/invalidate"

# Test with cache (first time = miss)
curl "http://localhost:8000/test?cache=on"

# Test with cache (second time = hit)
curl "http://localhost:8000/test?cache=on"

# Peek at Redis data (optional, requires redis-cli)
redis-cli
> GET items_all
> KEYS *
> TTL items_all
```

## What You'll Learn

1. **Performance gains** from caching are real and measurable
2. **Cache strategy** matters (TTL, invalidation timing)
3. **Cache hits vs misses** have different performance profiles
4. **Monitoring** is essential (know your hit/miss ratios)
5. **Simplicity wins** in education (focus on the concept, not complexity)

## No Unnecessary Complexity

This project intentionally:
- ❌ Doesn't use Laravel caching middleware
- ❌ Doesn't have cache tags or event listeners
- ❌ Doesn't include authentication
- ❌ Doesn't have API resources or DTOs
- ✅ **Shows exactly what Redis does for performance**

## Next Steps

After understanding this project, explore:
- Cache tags for grouping invalidation
- Cache-aside patterns
- Different serialization methods
- Redis persistence (RDB, AOF)
- Advanced patterns (cache warming, preloading)

---

**Remember:** The goal is to *understand*, not just to *optimize*. 🎓

# Redis Speed Lab - Complete Instructor Guide

**A Laravel Teaching Project to Demonstrate Redis Caching Performance**

---

## The Big Picture

This project answers one fundamental question that every developer asks:

> **"Why should I use Redis caching if my database is already fast?"**

**Answer:** Because with 10,000 items:
- Database query: **40-60ms** (queries disk/storage)
- Redis cache hit: **1-5ms** (from RAM)
- **That's 20-50x faster! 🚀**

This project makes that difference **visible, measurable, and clear**.

---

## Part 1: Understanding the Architecture

### The Three Layers

```
┌─────────────────────────────────────┐
│         Your Application            │
│  (SpeedTestController)              │
└────────┬────────────────────────────┘
         │
         ├─ cache=off → Query Database (slow)
         │
         └─ cache=on  → Check Redis → If miss → Query Database
                        → If hit → Return cached (FAST!)
         │
    ┌────┴─────────────────────────┐
    │                               │
┌───▼────────┐            ┌─────────▼──┐
│  Database  │            │   Redis    │
│ (Persistent)           │ (In-Memory)│
└────────────┘            └────────────┘
```

### What Each Component Does

| Component | Purpose | Speed | Storage |
|-----------|---------|-------|---------|
| **Database** | Persistent data storage | Slow (40-60ms) | Disk |
| **Redis** | In-memory cache layer | Fast (1-5ms) | RAM |
| **Items Table** | 10,000 test records | Baseline | MySQL |
| **Cache Key** | Stores items_all | Temporary | 60 seconds |

---

## Part 2: File-by-File Breakdown

### 1. Controller: `app/Http/Controllers/SpeedTestController.php`

**Purpose:** Handles the HTTP requests and demonstrates caching

**Two Methods:**

#### Method 1: `test()` - The Main Demonstration
```php
public function test(Request $request)
{
    $useCache = $request->query('cache') === 'on';
    $startTime = microtime(true);

    if ($useCache) {
        // Redis path
        $items = Cache::remember('items_all', 60, function () {
            return Item::select('id', 'name')->get();
        });
        // ...
    } else {
        // Database path
        $items = Item::select('id', 'name')->get();
        // ...
    }

    $endTime = microtime(true);
    $executionTimeMs = round(($endTime - $startTime) * 1000, 2);
    
    return response()->json([
        'source' => $source,
        'execution_time_ms' => $executionTimeMs,
        'items_count' => $items->count(),
    ]);
}
```

**Key Teaching Points:**
- `microtime(true)` returns high-precision timing
- `Cache::remember()` is the "magic" - it handles hit/miss logic
- Response includes timing to make difference visible

#### Method 2: `invalidate()` - Cache Clearing
```php
public function invalidate()
{
    Cache::forget('items_all');
    return response()->json(['message' => 'Cache cleared!']);
}
```

**Why it matters:** Students see that cache invalidation is necessary when data changes

---

### 2. Model: `app/Models/Item.php`

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Item extends Model
{
    //
}
```

**Simplest possible:** Just a Eloquent model with no customization. Pure focus on the concept.

---

### 3. Migration: `database/migrations/2026_02_02_191630_create_items_table.php`

```php
Schema::create('items', function (Blueprint $table) {
    $table->id();
    $table->string('name');
    $table->timestamps();
});
```

**Why these columns:**
- `id`: Primary key for Eloquent
- `name`: Simple string data (e.g., "Item 1", "Item 2", etc.)
- `timestamps`: Demonstrates real model structure
- **NOT**: No unnecessary columns = focus on the concept

---

### 4. Seeder: `database/seeders/ItemSeeder.php`

```php
public function run(): void
{
    $chunk_size = 500;
    
    for ($i = 0; $i < 10000; $i += $chunk_size) {
        $items = [];
        for ($j = 0; $j < $chunk_size && ($i + $j) < 10000; $j++) {
            $items[] = [
                'name' => 'Item ' . ($i + $j + 1),
                'created_at' => now(),
                'updated_at' => now(),
            ];
        }
        Item::insert($items);
    }
}
```

**Why 10,000 items?**
- Too small (100-1000) → Timing differences aren't obvious
- Too large (100,000+) → Database becomes the bottleneck differently
- **10,000 is the "Goldilocks" zone** for cache benefit demonstration

**Why chunks of 500?**
- `insert()` is faster than `create()` (no Eloquent overhead)
- Chunks prevent memory overflow with large datasets
- Real-world pattern students should know

---

### 5. Routes: `routes/web.php`

```php
use App\Http\Controllers\SpeedTestController;

Route::get('/test', [SpeedTestController::class, 'test']);
Route::get('/invalidate', [SpeedTestController::class, 'invalidate']);
```

**Why web routes?** (not API routes)
- Simpler to test with browser/curl
- No middleware complications
- Focus on the controller logic

---

### 6. Configuration: `.env`

```env
CACHE_STORE=redis
REDIS_HOST=127.0.0.1
REDIS_PORT=6379
REDIS_PASSWORD=null
```

**Teaching moment:** Show students where these settings come from and why they matter

---

## Part 3: How It All Works - The Request Flow

### Scenario 1: Database Query (cache=off)

```
Client Request: GET /test?cache=off
    ↓
Controller.test() starts timer
    ↓
$useCache = false
    ↓
Direct database query:
    Item::select('id', 'name')->get()
    ↓
MySQL executes query (40-60ms)
    ↓
Returns 10,000 rows to PHP
    ↓
Controller stops timer, calculates 45.23ms
    ↓
Returns JSON:
{
    "source": "database",
    "execution_time_ms": 45.23,
    "items_count": 10000
}
```

---

### Scenario 2: Redis Cache - Cache Miss (after invalidate)

```
Client Request: GET /invalidate
    ↓
Controller.invalidate() calls Cache::forget('items_all')
    ↓
Redis key 'items_all' is deleted
    ↓
Client Request: GET /test?cache=on
    ↓
Controller.test() starts timer
    ↓
$useCache = true
    ↓
Cache::remember('items_all', 60, callback)
    ↓
Redis checks: Does 'items_all' key exist?
    ↓
NO (we just deleted it!) → CACHE MISS
    ↓
Execute callback (fetch from database)
    ↓
MySQL query (40-60ms)
    ↓
PHP receives 10,000 rows
    ↓
Cache stores serialized data in Redis for 60 seconds
    ↓
Controller stops timer, calculates 48.15ms
    ↓
Returns JSON:
{
    "source": "redis",
    "cache_status": "miss",
    "execution_time_ms": 48.15,
    "items_count": 10000
}
```

---

### Scenario 3: Redis Cache - Cache Hit (within 60 seconds)

```
Client Request: GET /test?cache=on
    ↓
Controller.test() starts timer (nanoseconds)
    ↓
$useCache = true
    ↓
Cache::remember('items_all', 60, callback)
    ↓
Redis checks: Does 'items_all' key exist?
    ↓
YES! (We cached it 2 seconds ago) → CACHE HIT ✨
    ↓
Redis returns pre-serialized 10,000 items from memory
    ↓
PHP deserializes data (instant)
    ↓
NO database query needed!
    ↓
Controller stops timer, calculates 2.45ms
    ↓
Returns JSON:
{
    "source": "redis",
    "cache_status": "hit",
    "execution_time_ms": 2.45,
    "items_count": 10000
}
```

**Key insight:** Same data, same amount of work, but Redis hit is **~20x faster**!

---

## Part 4: The Learning Experience

### What Students Will Observe

#### Test Sequence 1: Database Baseline
```bash
curl "http://localhost:8080/test?cache=off"
curl "http://localhost:8080/test?cache=off"
curl "http://localhost:8080/test?cache=off"
```

**Observations:**
- Always 40-60ms
- Consistent timing
- Direct correlation with database query time

**Lesson:** This is the baseline. Can we do better?

---

#### Test Sequence 2: Redis Miss vs Hit
```bash
curl "http://localhost:8080/invalidate"        # Clear cache
curl "http://localhost:8080/test?cache=on"     # First request: ~50ms (miss)
curl "http://localhost:8080/test?cache=on"     # Second: ~2ms (hit!)
curl "http://localhost:8080/test?cache=on"     # Third: ~2ms (hit!)
curl "http://localhost:8080/test?cache=on"     # Fourth: ~2ms (hit!)
```

**Observations:**
- First request after cache clear = slow (database)
- Subsequent requests = super fast (Redis)
- The overhead happens once, benefit happens many times

**Lesson:** This is why caching is powerful!

---

#### Test Sequence 3: TTL Behavior
```bash
curl "http://localhost:8080/test?cache=on"    # ~2ms (hit)
sleep 60
curl "http://localhost:8080/test?cache=on"    # ~50ms (miss, TTL expired)
```

**Observations:**
- After 60 seconds, cache expires
- Next request is slow again (cache miss)
- Then fast again (cache hit)

**Lesson:** TTL controls when data becomes "fresh"

---

### The "Aha!" Moment

When students see:
```
First request:  50ms
Second request: 2ms   ← The "aha!" moment
```

They understand:
1. **Why caching matters** (performance)
2. **How it works** (data stored in memory)
3. **The cost** (need to invalidate when data changes)

---

## Part 5: Teaching Strategies

### How to Present This Project

#### 1. **Conceptual Introduction (5 minutes)**
```
"We have 10,000 items in the database.
Every time someone visits a page that lists all items,
we query the database. That takes 50ms.

But if 100 people visit that page every second,
we're doing the same 50ms database query 100 times per second.

Redis is like a bulletin board on the wall.
We write the list there once, and everyone reads from the wall.
That takes 2ms instead of 50ms.

Let's see it in action..."
```

#### 2. **Live Demonstration (10 minutes)**
```bash
# Show them the baseline
curl "http://localhost:8080/test?cache=off"
# "50ms every time"

# Show cache miss
curl "http://localhost:8080/invalidate"
curl "http://localhost:8080/test?cache=on"
# "First time: still 50ms (Redis checked, wasn't there)"

# Show cache hit
curl "http://localhost:8080/test?cache=on"
# "Second time: 2ms! That's 25x faster!"

# Repeat a few times
for i in {1..5}; do curl "http://localhost:8080/test?cache=on"; echo ""; done
# "Every single request: 2ms"
```

#### 3. **Code Walk-Through (10 minutes)**
Show `SpeedTestController.php`:
- Explain `Cache::remember()`
- Show the timing logic
- Explain why we return the cache status
- Point out comments explaining WHY, not just WHAT

#### 4. **Interactive Experiments (10 minutes)**
Let students run their own tests:
- "Make 10 requests. How fast is the 10th?"
- "Invalidate cache. What happens to timing?"
- "Wait 61 seconds, then make a request. What changed?"

---

## Part 6: Common Questions Answered

### Q: "Why not just use database query caching?"
**A:** Databases DO have query caching, but:
- It's not persistent between restarts
- It's database-specific
- It can't be shared between servers
- Redis is explicit and controllable

### Q: "What if data changes while it's cached?"
**A:** That's called **cache invalidation**. Three strategies:
1. **TTL-based** (like here): Auto-expire after 60 seconds
2. **Event-based**: Clear cache when data changes
3. **Hybrid**: Combine both

This project uses TTL to keep it simple.

### Q: "Is 10,000 items realistic?"
**A:** For the demo, yes. In production:
- Could be millions of items
- Difference might be 500ms database vs 5ms Redis
- The ratio stays similar (50-100x improvement)

### Q: "What's the cache key?"
**A:** The string `'items_all'`. It's arbitrary. You could use:
- `'items_all'`
- `'all_products'`
- `'cache_key_12345'`

The name doesn't matter. What matters is consistency (use the same key for get/set).

### Q: "Why serialize to cache?"
**A:** Redis stores bytes. PHP needs to convert objects:
- **Serialize:** PHP data → bytes
- **Cache:** Stored in Redis
- **Deserialize:** bytes → PHP data

PHP does this automatically with `Cache::remember()`.

---

## Part 7: Troubleshooting

### "Redis connection refused"
```bash
redis-cli ping
# If no response:
brew services start redis
redis-cli ping  # Should respond: PONG
```

### "Port 8080 already in use"
```bash
php artisan serve --port=8090
# Then test with: curl "http://localhost:8090/test?cache=off"
```

### "10,000 items not seeded"
```bash
php artisan db:seed --class=ItemSeeder
php artisan tinker
>>> App\Models\Item::count();
# Should respond: 10000
```

### "Timing doesn't seem different"
**This is normal!**
- Your computer might be very fast
- Or MySQL query cache might be interfering
- Try with larger dataset or on slower machine
- The principle is still valid

---

## Part 8: Extensions for Advanced Students

### After Mastering the Basics

1. **Cache Warming**
   - Pre-load data into Redis on app start
   - Avoid the first slow request

2. **Cache Tags**
   ```php
   Cache::tags('items')->put('items_all', $data, 60);
   Cache::tags('items')->flush();  // Clear all 'items' tagged data
   ```

3. **Multiple Cache Stores**
   ```php
   Cache::store('redis')->put(...);
   Cache::store('file')->put(...);
   ```

4. **Monitor Cache Hit Ratio**
   ```php
   Redis::incr('cache_hits');
   Redis::incr('cache_misses');
   $ratio = $hits / ($hits + $misses);
   ```

5. **Cache Stampede Prevention**
   ```php
   Cache::lock('expensive_operation')->block(10, function () {
       // Only one process runs this
   });
   ```

---

## Part 9: Core Principles Summary

### The Three Rules of Caching

| Rule | Explanation | Example |
|------|-------------|---------|
| **1. Measure** | Always time before/after | Our project does this with `microtime()` |
| **2. Invalidate** | Clear when data changes | Our `/invalidate` endpoint |
| **3. Reasonable TTL** | 60 seconds good default | Not 1 second (too many misses), not 1 hour (stale data) |

---

## Part 10: Running the Complete Flow

### Full Student Experience

```bash
# 1. Start server
cd /Users/bj/Documents/Work/RedisSpeedLab
php artisan serve --port=8080

# Terminal 2: Test without cache
curl "http://localhost:8080/test?cache=off"
# Result: ~50ms

# Terminal 2: Clear Redis
curl "http://localhost:8080/invalidate"

# Terminal 2: Cache miss (first request)
curl "http://localhost:8080/test?cache=on"
# Result: ~50ms (cache miss)

# Terminal 2: Cache hit (second request)
curl "http://localhost:8080/test?cache=on"
# Result: ~2ms (cache hit!)

# Terminal 2: Run 5 more times quickly
for i in {1..5}; do curl -s "http://localhost:8080/test?cache=on" | jq '.execution_time_ms'; sleep 0.5; done
# Results: 2.15, 2.03, 1.98, 2.12, 2.09 (consistently fast)

# Terminal 2: Wait and test TTL
sleep 61
curl "http://localhost:8080/test?cache=on"
# Result: ~50ms (TTL expired, cache miss again)
```

**Total time:** 15-20 minutes  
**Learning outcome:** Complete understanding of Redis caching

---

## Conclusion

This project is intentionally **minimal** because:
- ✅ No auth complications
- ✅ No API resource formatting
- ✅ No pagination logic
- ✅ No foreign keys
- ✅ Just caching, clearly demonstrated

**The goal:** A student who completes this understands:
1. Why caching exists (speed)
2. How caching works (store → check → return)
3. When caching helps (repeated access, large data)
4. When caching fails (after invalidation, TTL expired)
5. How to implement it (Cache::remember())

That's everything they need. Everything else is optional. 🎓

---

**Created for:** Clarity and learning  
**Designed by:** A performance engineer who believes in teaching by showing  
**Time to understand:** 30 minutes  
**Time to master:** 2-3 hours of experimentation

**Now go test it!** 🚀

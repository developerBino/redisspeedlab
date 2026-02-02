# Redis Speed Lab - Quick Reference Card

## 🎯 One-Minute Summary

**Goal:** Show that Redis caching is **20-50x faster** than database queries.

**How:** Compare execution time with and without cache on 10,000 items.

---

## 🚀 Quick Start

### Terminal 1: Start Server
```bash
cd /Users/bj/Documents/Work/RedisSpeedLab
php artisan serve --port=8080
```

### Terminal 2: Run Tests

#### Test 1: Database (Slow)
```bash
curl "http://localhost:8080/test?cache=off"
# Result: {"execution_time_ms": 50.23, "source": "database"}
```

#### Test 2: Cache Miss (Still Slow)
```bash
curl "http://localhost:8080/invalidate"
curl "http://localhost:8080/test?cache=on"
# Result: {"execution_time_ms": 48.15, "cache_status": "miss"}
```

#### Test 3: Cache Hit (FAST! 🚀)
```bash
curl "http://localhost:8080/test?cache=on"
# Result: {"execution_time_ms": 2.45, "cache_status": "hit"}
```

---

## 📊 Expected Results

| Test | Speed | Why |
|------|-------|-----|
| `cache=off` | 40-60ms | Database query from disk |
| `cache=on` (miss) | 40-60ms | Database + cache (miss hits DB) |
| `cache=on` (hit) | 1-5ms | Redis memory lookup only |

**Key insight:** Cache hit is **20-50x faster!** ⚡

---

## 🔧 The Code (What to Study)

### Main Logic: `app/Http/Controllers/SpeedTestController.php`

```php
// The magic line (everything else is just timing):
$items = Cache::remember('items_all', 60, function () {
    return Item::select('id', 'name')->get();
});

// That's it! Cache::remember() handles:
// ✓ Check Redis for 'items_all' key
// ✓ Return if found (cache hit)
// ✓ Fetch from DB if missing (cache miss)
// ✓ Store in Redis for 60 seconds
```

---

## 🗄️ Database

- **Table:** `items`
- **Columns:** `id`, `name`, `created_at`, `updated_at`
- **Records:** 10,000 dummy items
- **Location:** Already seeded ✓

---

## ⚙️ Configuration

- **Redis Host:** `127.0.0.1`
- **Redis Port:** `6379`
- **Cache Driver:** Redis (`.env`: `CACHE_STORE=redis`)
- **TTL:** 60 seconds (cache expires after 60s)

---

## 🐛 Troubleshooting

### Redis not running?
```bash
redis-cli ping
# If no response:
brew services start redis
```

### Port 8080 already used?
```bash
php artisan serve --port=8090
# Then use: http://localhost:8090
```

### Database not seeded?
```bash
php artisan db:seed --class=ItemSeeder
```

---

## 🔍 Inspect Redis Directly

```bash
redis-cli

> KEYS *                  # See all keys
> GET items_all           # See cached data (will be huge!)
> TTL items_all           # Seconds until expiration
> DEL items_all           # Delete cache manually
> FLUSHALL                # Clear all Redis data
```

---

## 📈 Endpoints Summary

| Endpoint | Method | Params | Purpose |
|----------|--------|--------|---------|
| `/test` | GET | `cache=on` or `cache=off` | Compare DB vs Redis |
| `/invalidate` | GET | none | Clear Redis cache |

---

## 💡 Key Learning Points

1. **Database:** Slow (disk access = 50ms)
2. **Redis:** Fast (memory access = 2ms)
3. **Cache miss:** Same as database (fetches from DB)
4. **Cache hit:** Super fast (from memory)
5. **TTL:** Auto-expire after 60 seconds
6. **Invalidation:** Needed when data changes

---

## 🎓 The Complete Flow

```
Request /test?cache=off
  └─> Direct DB query
       └─> 50ms
       └─> Result: "database"

Request /invalidate
  └─> Cache::forget('items_all')
       └─> Redis key deleted

Request /test?cache=on
  └─> Check Redis for 'items_all'
       └─> Not found! (MISS)
       └─> Query database
       └─> Store in Redis for 60s
       └─> 50ms (same as database)
       └─> Result: "redis", "cache_status": "miss"

Request /test?cache=on (again)
  └─> Check Redis for 'items_all'
       └─> Found! (HIT) ✨
       └─> Return cached data
       └─> 2ms (MUCH faster!)
       └─> Result: "redis", "cache_status": "hit"

Wait 61 seconds...

Request /test?cache=on
  └─> Check Redis for 'items_all'
       └─> Not found! (MISS - TTL expired)
       └─> Query database again
       └─> Store in Redis for 60s
       └─> 50ms
       └─> Cycle repeats...
```

---

## 📁 Project Structure

```
app/
└── Http/Controllers/
    └── SpeedTestController.php    ← Main logic here
        
app/Models/
└── Item.php                       ← Simple model

database/
├── migrations/
│   └── create_items_table.php     ← Table structure
└── seeders/
    └── ItemSeeder.php             ← 10,000 items

routes/
└── web.php                         ← /test and /invalidate routes

.env                               ← CACHE_STORE=redis
```

---

## ⏱️ Timing Check

Run this to see the performance difference:

```bash
# Database (no cache)
time curl -s "http://localhost:8080/test?cache=off" > /dev/null

# Redis (cache hit)
time curl -s "http://localhost:8080/test?cache=on" > /dev/null
```

Compare the timings!

---

## 🎬 Demo Script (Copy & Paste)

```bash
#!/bin/bash

echo "1. Database query (slow):"
curl -s "http://localhost:8080/test?cache=off" | jq '.execution_time_ms'

echo "2. Clear cache:"
curl -s "http://localhost:8080/invalidate" > /dev/null

echo "3. Redis miss (first request, still slow):"
curl -s "http://localhost:8080/test?cache=on" | jq '.execution_time_ms'

echo "4. Redis hit (second request, FAST!):"
curl -s "http://localhost:8080/test?cache=on" | jq '.execution_time_ms'

echo "5. More cache hits (repeating fast results):"
for i in {1..3}; do
  curl -s "http://localhost:8080/test?cache=on" | jq '.execution_time_ms'
done
```

---

## 🧠 Remember

| Concept | Easy Way to Remember |
|---------|----------------------|
| Cache Hit | "Data is still fresh in Redis" → **Fast** ⚡ |
| Cache Miss | "Had to go back to database" → **Slow** 🐢 |
| TTL | "Expiration date = 60 seconds" → After that, new miss |
| Invalidate | "Clear the cache manually" → Force fresh from DB |
| Serialization | "PHP data ↔ Redis bytes" → Automatic magic |

---

## 📞 Questions to Ask Yourself

- ✓ How fast is a database query? (Answer: ~50ms)
- ✓ How fast is a Redis hit? (Answer: ~2ms)
- ✓ What happens after 60 seconds? (Answer: Cache expires, next request is slow)
- ✓ Why would you use caching? (Answer: **25x faster!**)
- ✓ What's the tradeoff? (Answer: Have to invalidate when data changes)

**If you can answer these 5 questions, you understand Redis caching.** ✅

---

## 🎓 Next Level

Once you master this:
- Learn cache tags (group invalidation)
- Learn cache warming (preload data)
- Learn cache stampede (prevent dogpiling)
- Learn distributed caching (multiple servers)

But first, master the basics with this project!

---

**Status:** Ready to learn!  
**Time to understand:** 30 minutes  
**Time to master:** 2-3 hours  

**Go run the tests!** 🚀

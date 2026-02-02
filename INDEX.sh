#!/bin/bash

# Display Redis Speed Lab Documentation Index
clear

cat << 'EOF'

╔════════════════════════════════════════════════════════════════════════════╗
║                                                                            ║
║                    ⚡ REDIS SPEED LAB - DOCUMENTATION ⚡                   ║
║                                                                            ║
║           A Laravel Teaching Project for Redis Caching Performance        ║
║                                                                            ║
╚════════════════════════════════════════════════════════════════════════════╝

📚 DOCUMENTATION FILES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. 🚀 QUICK_REFERENCE.md  (START HERE!)
   └─ One-page cheat sheet
   └─ Copy-paste test commands
   └─ Expected results
   └─ Troubleshooting tips

   👉 READ THIS FIRST if you want to get started immediately

2. 📖 PROJECT_SUMMARY.md
   └─ What was created
   └─ File structure
   └─ Configuration overview
   └─ Testing sequence

   👉 READ THIS to understand what exists

3. 🎓 INSTRUCTOR_GUIDE.md  (COMPREHENSIVE!)
   └─ Complete teaching guide (7,000+ words)
   └─ Architecture explanation
   └─ File-by-file breakdown
   └─ Request flow diagrams
   └─ Teaching strategies
   └─ Common Q&A
   └─ Extension ideas

   👉 READ THIS if you're teaching or want deep understanding

4. 📝 REDIS_SPEEDLAB.md
   └─ Detailed learning flow
   └─ Code examples
   └─ Real-world insights
   └─ Next steps

   👉 READ THIS for academic understanding

5. 📋 QUICKSTART.sh
   └─ Step-by-step command guide
   └─ All terminal commands
   └─ Expected outputs

   👉 RUN THIS to see all steps


🎯 QUICK START (5 minutes)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Terminal 1 - Start Server:
  cd /Users/bj/Documents/Work/RedisSpeedLab
  php artisan serve --port=8080

Terminal 2 - Run Tests:
  # Test 1: Database (slow)
  curl "http://localhost:8080/test?cache=off"

  # Test 2: Clear cache
  curl "http://localhost:8080/invalidate"

  # Test 3: Redis miss (still slow)
  curl "http://localhost:8080/test?cache=on"

  # Test 4: Redis hit (FAST!)
  curl "http://localhost:8080/test?cache=on"


✅ WHAT'S INSTALLED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ Laravel 11 framework
✓ 10,000 test items in database
✓ Redis configured and running
✓ SpeedTestController with /test and /invalidate endpoints
✓ Eloquent model for items
✓ Database migration and seeder
✓ Clean, well-commented code
✓ Comprehensive documentation


🔧 WHAT TO STUDY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Core Files (In order):

1. app/Http/Controllers/SpeedTestController.php
   └─ Main controller with detailed comments
   └─ Shows Cache::remember() usage
   └─ Timing logic with microtime(true)
   └─ JSON response format

2. app/Models/Item.php
   └─ Simple Eloquent model

3. database/migrations/2026_02_02_191630_create_items_table.php
   └─ Table structure with id, name, timestamps

4. database/seeders/ItemSeeder.php
   └─ Seeds 10,000 items efficiently

5. routes/web.php
   └─ /test and /invalidate endpoint definitions

6. .env
   └─ Redis configuration


📊 EXPECTED RESULTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Without Cache (cache=off):
{
  "source": "database",
  "execution_time_ms": 45.23,
  "items_count": 10000
}
Expected: 40-60ms consistently

Redis Miss (after invalidate):
{
  "source": "redis",
  "cache_status": "miss",
  "execution_time_ms": 48.15,
  "items_count": 10000
}
Expected: ~50ms (same as database, first time fetches from DB)

Redis Hit (second request):
{
  "source": "redis",
  "cache_status": "hit",
  "execution_time_ms": 2.45,
  "items_count": 10000
}
Expected: 1-5ms (20-50x faster!)


💡 KEY CONCEPTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Cache Hit:
  Data exists in Redis → Return immediately → ~2ms ⚡

Cache Miss:
  Data not in Redis → Fetch from database → Store in Redis → ~50ms

Cache Invalidation:
  Delete cached data manually → Force fresh data on next request

TTL (Time To Live):
  Cache auto-expires after 60 seconds → Next request = cache miss

Microtime:
  PHP's high-precision timing function → Measures milliseconds accurately


🧪 TESTING FLOW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Step 1: Understand Database Baseline
  curl "http://localhost:8080/test?cache=off"
  # Note execution_time_ms

Step 2: Watch Cache Miss
  curl "http://localhost:8080/invalidate"
  curl "http://localhost:8080/test?cache=on"
  # Note: cache_status = "miss", similar timing to database

Step 3: See Cache Hit
  curl "http://localhost:8080/test?cache=on"
  # Note: cache_status = "hit", much faster timing!

Step 4: Observe TTL
  # Run cache hit request now (fast)
  curl "http://localhost:8080/test?cache=on"
  # Wait 61 seconds
  sleep 61
  # Run again (slow - TTL expired)
  curl "http://localhost:8080/test?cache=on"


🐛 TROUBLESHOOTING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Redis not responding?
  redis-cli ping
  # If fails: brew services start redis

Port 8080 already in use?
  php artisan serve --port=8090
  # Then use: http://localhost:8090

Database empty?
  php artisan db:seed --class=ItemSeeder
  php artisan tinker
  >>> App\Models\Item::count();

Timing not showing much difference?
  Normal! Depends on your machine. The concept is still valid.


🚀 ADVANCED TOPICS (After Mastering Basics)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

- Cache warming (preload on startup)
- Cache tags (group invalidation)
- Cache stampede prevention
- Distributed caching
- Cache monitoring
- Different serialization methods
- Redis persistence (RDB, AOF)


📞 QUICK QUESTIONS & ANSWERS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Q: Why is cache miss slow?
A: Because it has to fetch from database AND store in Redis.
   First hit absorbs the cost of caching.

Q: When does TTL matter?
A: After 60 seconds, cache expires. Next request is slow.
   Then it caches again for another 60 seconds.

Q: What if data changes?
A: Use /invalidate to clear cache. Next request = fresh data.
   This is cache invalidation strategy.

Q: Can I change TTL?
A: Yes! Edit SpeedTestController.php line with Cache::remember()
   Change the "60" to different seconds.

Q: What's serialization?
A: Converting PHP objects to bytes (store in Redis) and back.
   Cache::remember() handles it automatically.


🎓 LEARNING GOALS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

After completing this project, you should understand:

✓ Why caching is important (performance gains are real)
✓ How caching works (store → check → return pattern)
✓ Cache hits vs misses (different performance profiles)
✓ TTL and expiration (automatic cache management)
✓ Cache invalidation (when to clear cache)
✓ Laravel's Cache::remember() (practical usage)
✓ When caching helps most (large datasets, repeated access)


🎬 DEMO VIDEO SCRIPT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

"We have 10,000 items. Every request queries the database: 50ms.

But what if 100 people visit simultaneously?
We're doing the same 50ms query 100 times.

Redis is like putting the list on a bulletin board.
Everyone reads from the board: 2ms instead of 50ms.

Let's see it in action..."

[Show: curl without cache: 50ms]
[Show: curl with cache (miss): 50ms]
[Show: curl with cache (hit): 2ms] ← "20x faster!"
[Repeat hits]
[Show: Wait 61 seconds]
[Show: Request again: 50ms] ← "TTL expired, fetches again"


📧 SUPPORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

This project includes:
- 4 documentation files (~20,000 words)
- Code with detailed comments
- Multiple examples
- Troubleshooting guide
- Teaching strategies
- 10,000 pre-seeded items
- Working Redis configuration

If something isn't clear, check the docs!


🎯 NEXT STEPS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Open QUICK_REFERENCE.md (1 page, 5 minutes)
2. Start the Laravel server
3. Run the test commands
4. Observe the timing differences
5. Read INSTRUCTOR_GUIDE.md for deep understanding
6. Experiment with the code


✨ PROJECT PHILOSOPHY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

This project intentionally:
✓ Keeps things SIMPLE (no unnecessary complexity)
✓ Shows not tells (measure, don't theorize)
✓ Focuses on the concept (caching, nothing else)
✓ Uses real tools (Laravel, Redis, HTTP)
✓ Teaches by experimentation (test and observe)


═══════════════════════════════════════════════════════════════════════════════

                         Ready to learn? Start here:

                              1. Read: QUICK_REFERENCE.md
                              2. Run: php artisan serve
                              3. Test: curl "http://localhost:8080/test?cache=off"
                              4. Observe: The timing difference
                              5. Understand: Why caching matters

                                    Happy learning! 🚀

═══════════════════════════════════════════════════════════════════════════════

EOF

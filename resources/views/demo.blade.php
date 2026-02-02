<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>⚡ Redis Speed Lab - Live Performance Demo</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            width: 100%;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
        }

        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 20px;
            text-align: center;
        }

        .header h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .header p {
            font-size: 1.1em;
            opacity: 0.95;
        }

        .content {
            padding: 40px 20px;
        }

        .controls {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .control-group {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        label {
            font-weight: 600;
            color: #333;
            font-size: 1.1em;
        }

        .button-group {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        button {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 1em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            flex: 1;
            min-width: 120px;
        }

        .btn-database {
            background: #ff6b6b;
            color: white;
        }

        .btn-database:hover {
            background: #ee5a52;
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(255, 107, 107, 0.3);
        }

        .btn-database:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
        }

        .btn-redis {
            background: #51cf66;
            color: white;
        }

        .btn-redis:hover {
            background: #40c057;
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(81, 207, 102, 0.3);
        }

        .btn-redis:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
        }

        .btn-clear {
            background: #ffd43b;
            color: #333;
        }

        .btn-clear:hover {
            background: #ffcd00;
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(255, 212, 59, 0.3);
        }

        .btn-clear:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
        }

        .results {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }

        .result-card {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 20px;
            border-left: 5px solid #667eea;
            transition: all 0.3s ease;
        }

        .result-card.database {
            border-left-color: #ff6b6b;
        }

        .result-card.redis {
            border-left-color: #51cf66;
        }

        .result-card.loading {
            background: #e8f5e9;
        }

        .result-title {
            font-size: 1.3em;
            font-weight: 700;
            margin-bottom: 15px;
            color: #333;
        }

        .result-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            font-size: 0.95em;
        }

        .result-label {
            color: #666;
            font-weight: 500;
        }

        .result-value {
            font-weight: 700;
            color: #333;
        }

        .timing {
            font-size: 2em;
            font-weight: 800;
            margin: 15px 0;
            padding: 10px;
            border-radius: 8px;
            text-align: center;
        }

        .timing.fast {
            background: #d4edda;
            color: #155724;
        }

        .timing.slow {
            background: #f8d7da;
            color: #721c24;
        }

        .loading-spinner {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid #f3f3f3;
            border-top: 3px solid #667eea;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-left: 10px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .comparison {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 12px;
            margin-top: 30px;
            text-align: center;
        }

        .comparison h3 {
            font-size: 1.5em;
            margin-bottom: 20px;
        }

        .comparison-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 20px;
        }

        .comparison-item {
            background: rgba(255, 255, 255, 0.1);
            padding: 15px;
            border-radius: 8px;
        }

        .comparison-label {
            font-size: 0.9em;
            opacity: 0.8;
            margin-bottom: 5px;
        }

        .comparison-value {
            font-size: 1.8em;
            font-weight: 800;
        }

        .speedup {
            background: rgba(255, 255, 255, 0.2);
            padding: 15px;
            border-radius: 8px;
            margin-top: 10px;
            font-size: 1.3em;
            font-weight: 700;
        }

        .stats-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 12px;
            margin-top: 20px;
        }

        .stats-section h3 {
            margin-bottom: 15px;
            color: #333;
        }

        .stat-list {
            list-style: none;
        }

        .stat-list li {
            padding: 8px 0;
            color: #666;
            border-bottom: 1px solid #e0e0e0;
        }

        .stat-list li:last-child {
            border-bottom: none;
        }

        .error {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .info-box {
            background: #d1ecf1;
            border: 1px solid #bee5eb;
            color: #0c5460;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        @media (max-width: 768px) {
            .header h1 {
                font-size: 1.8em;
            }

            .comparison-row {
                grid-template-columns: 1fr;
            }

            .controls {
                grid-template-columns: 1fr;
            }
        }

        .highlight {
            background: #fff3cd;
            padding: 2px 6px;
            border-radius: 4px;
            font-weight: 600;
        }

        .footer {
            background: #f8f9fa;
            padding: 20px;
            text-align: center;
            color: #666;
            border-top: 1px solid #e0e0e0;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>⚡ Redis Speed Lab</h1>
            <p>Live Performance Comparison: Database vs Redis Caching</p>
        </div>

        <div class="content">
            <div class="info-box">
                💡 <strong>How It Works:</strong> Compare direct database queries vs Redis cached queries. See the dramatic performance difference with 10,000 items!
            </div>

            <div class="controls">
                <div class="control-group">
                    <label>🗄️ Database Query</label>
                    <button class="btn-database" id="dbBtn" onclick="testDatabase()">
                        Test Database
                    </button>
                </div>

                <div class="control-group">
                    <label>⚡ Redis Cache</label>
                    <button class="btn-redis" id="redisBtn" onclick="testRedis()">
                        Test Redis Cache
                    </button>
                </div>

                <div class="control-group">
                    <label>🔄 Cache Management</label>
                    <button class="btn-clear" id="clearBtn" onclick="clearCache()">
                        Clear Cache
                    </button>
                </div>
            </div>

            <div id="errorMsg" class="error" style="display: none;"></div>

            <div class="results">
                <div class="result-card database" id="dbResult" style="display: none;">
                    <div class="result-title">🗄️ Database Result</div>
                    <div class="timing slow" id="dbTiming">-- ms</div>
                    <div class="result-item">
                        <span class="result-label">Source:</span>
                        <span class="result-value">MySQL Database</span>
                    </div>
                    <div class="result-item">
                        <span class="result-label">Items Fetched:</span>
                        <span class="result-value" id="dbCount">-</span>
                    </div>
                    <div class="result-item">
                        <span class="result-label">Method:</span>
                        <span class="result-value">Direct Query</span>
                    </div>
                    <div class="stats-section" style="margin-top: 15px; background: rgba(255, 107, 107, 0.1);">
                        <strong>📊 This is slow because:</strong>
                        <ul class="stat-list">
                            <li>✗ Queries disk/storage</li>
                            <li>✗ Network latency</li>
                            <li>✗ No caching</li>
                        </ul>
                    </div>
                </div>

                <div class="result-card redis" id="redisResult" style="display: none;">
                    <div class="result-title">⚡ Redis Result</div>
                    <div class="timing" id="redisTiming" style="color: inherit;">-- ms</div>
                    <div class="result-item">
                        <span class="result-label">Source:</span>
                        <span class="result-value" id="redisSource">-</span>
                    </div>
                    <div class="result-item">
                        <span class="result-label">Cache Status:</span>
                        <span class="result-value" id="cacheStatus">-</span>
                    </div>
                    <div class="result-item">
                        <span class="result-label">Items Fetched:</span>
                        <span class="result-value" id="redisCount">-</span>
                    </div>
                    <div class="stats-section" style="margin-top: 15px; background: rgba(81, 207, 102, 0.1);" id="redisStats">
                        <strong>✨ This is fast because:</strong>
                        <ul class="stat-list">
                            <li>✓ Memory lookup</li>
                            <li>✓ No disk access</li>
                            <li>✓ Pre-cached data</li>
                        </ul>
                    </div>
                </div>
            </div>

            <div class="comparison" id="comparisonBox" style="display: none;">
                <h3>📊 Performance Comparison</h3>
                <div class="comparison-row">
                    <div class="comparison-item">
                        <div class="comparison-label">Database Speed</div>
                        <div class="comparison-value" id="compDb">-</div>
                    </div>
                    <div class="comparison-item">
                        <div class="comparison-label">Redis Speed</div>
                        <div class="comparison-value" id="compRedis">-</div>
                    </div>
                    <div class="comparison-item">
                        <div class="comparison-label">Difference</div>
                        <div class="comparison-value" id="compDiff">-</div>
                    </div>
                </div>
                <div class="speedup">
                    🚀 Redis is <span id="speedupFactor">-</span>x faster than Database!
                </div>
            </div>

            <div class="stats-section">
                <h3>📈 Learning Points</h3>
                <ul class="stat-list">
                    <li><strong>🗄️ Database Query (cache=off):</strong> Direct MySQL access = 40-60ms typical</li>
                    <li><strong>⚠️ Redis Cache Miss:</strong> First request = same as database (~50ms) because it needs to fetch and cache</li>
                    <li><strong>✨ Redis Cache Hit:</strong> Subsequent requests = 1-5ms (20-50x FASTER!)</li>
                    <li><strong>⏱️ TTL (Time To Live):</strong> Cache expires after 60 seconds, then next request is a miss</li>
                    <li><strong>🔄 Cache Invalidation:</strong> Click "Clear Cache" to simulate data changes</li>
                </ul>
            </div>
        </div>

        <div class="footer">
            <p>🎓 RedisSpeedLab - Teaching Redis Caching Performance |
            <a href="https://github.com" style="color: #667eea; text-decoration: none;">View on GitHub</a></p>
        </div>
    </div>

    <script>
        const API_BASE = window.location.origin;
        let lastDbTime = null;
        let lastRedisTime = null;

        async function testDatabase() {
            const btn = document.getElementById('dbBtn');
            btn.disabled = true;
            btn.innerHTML = 'Testing... <span class="loading-spinner"></span>';

            try {
                const response = await fetch(`${API_BASE}/test?cache=off`);
                const data = await response.json();

                lastDbTime = data.execution_time_ms;

                showDatabaseResult(data);
                updateComparison();
                clearError();
            } catch (error) {
                showError(`Failed to test database: ${error.message}`);
            } finally {
                btn.disabled = false;
                btn.innerHTML = 'Test Database';
            }
        }

        async function testRedis() {
            const btn = document.getElementById('redisBtn');
            btn.disabled = true;
            btn.innerHTML = 'Testing... <span class="loading-spinner"></span>';

            try {
                const response = await fetch(`${API_BASE}/test?cache=on`);
                const data = await response.json();

                lastRedisTime = data.execution_time_ms;

                showRedisResult(data);
                updateComparison();
                clearError();
            } catch (error) {
                showError(`Failed to test Redis: ${error.message}`);
            } finally {
                btn.disabled = false;
                btn.innerHTML = 'Test Redis Cache';
            }
        }

        async function clearCache() {
            const btn = document.getElementById('clearBtn');
            btn.disabled = true;
            btn.innerHTML = 'Clearing... <span class="loading-spinner"></span>';

            try {
                const response = await fetch(`${API_BASE}/invalidate`);
                const data = await response.json();
                showSuccess('Cache cleared! Next Redis request will be a cache miss.');
                clearError();
            } catch (error) {
                showError(`Failed to clear cache: ${error.message}`);
            } finally {
                btn.disabled = false;
                btn.innerHTML = 'Clear Cache';
            }
        }

        function showDatabaseResult(data) {
            const card = document.getElementById('dbResult');
            document.getElementById('dbTiming').textContent = `${data.execution_time_ms} ms`;
            document.getElementById('dbTiming').className = 'timing slow';
            document.getElementById('dbCount').textContent = data.items_count;
            card.style.display = 'block';
        }

        function showRedisResult(data) {
            const card = document.getElementById('redisResult');
            const timing = data.execution_time_ms;
            const isFast = timing < 10;

            document.getElementById('redisTiming').textContent = `${timing} ms`;
            document.getElementById('redisTiming').className = isFast ? 'timing fast' : 'timing slow';
            document.getElementById('redisSource').textContent = data.source;
            document.getElementById('cacheStatus').textContent = data.cache_status ?
                (data.cache_status === 'hit' ? '✨ HIT (from cache)' : '⚠️ MISS (fetched from DB)') : '-';
            document.getElementById('redisCount').textContent = data.items_count;

            // Update stats message
            const statsSection = document.getElementById('redisStats');
            if (data.cache_status === 'hit') {
                statsSection.innerHTML = `<strong>✨ Cache HIT - Data from Redis Memory:</strong>
                    <ul class="stat-list">
                        <li>✓ Already in cache</li>
                        <li>✓ Ultra-fast memory access</li>
                        <li>✓ 20-50x faster than DB!</li>
                    </ul>`;
            } else {
                statsSection.innerHTML = `<strong>⚠️ Cache MISS - Had to fetch from Database:</strong>
                    <ul class="stat-list">
                        <li>✗ Not in cache yet</li>
                        <li>✗ Fetched from database</li>
                        <li>✓ Now cached for 60 seconds</li>
                    </ul>`;
            }

            card.style.display = 'block';
        }

        function updateComparison() {
            if (lastDbTime && lastRedisTime) {
                const comparison = document.getElementById('comparisonBox');
                const speedup = (lastDbTime / lastRedisTime).toFixed(1);

                document.getElementById('compDb').textContent = `${lastDbTime}ms`;
                document.getElementById('compRedis').textContent = `${lastRedisTime}ms`;
                document.getElementById('compDiff').textContent = `${(lastDbTime - lastRedisTime).toFixed(2)}ms`;
                document.getElementById('speedupFactor').textContent = speedup;

                comparison.style.display = 'block';
            }
        }

        function showError(message) {
            const errorDiv = document.getElementById('errorMsg');
            errorDiv.textContent = '❌ ' + message;
            errorDiv.style.display = 'block';
        }

        function showSuccess(message) {
            const errorDiv = document.getElementById('errorMsg');
            errorDiv.textContent = '✅ ' + message;
            errorDiv.className = 'error';
            errorDiv.style.backgroundColor = '#d4edda';
            errorDiv.style.borderColor = '#c3e6cb';
            errorDiv.style.color = '#155724';
            errorDiv.style.display = 'block';

            setTimeout(() => {
                errorDiv.style.display = 'none';
                errorDiv.className = 'error';
                errorDiv.style.backgroundColor = '#f8d7da';
                errorDiv.style.borderColor = '#f5c6cb';
                errorDiv.style.color = '#721c24';
            }, 3000);
        }

        function clearError() {
            document.getElementById('errorMsg').style.display = 'none';
        }
    </script>
</body>
</html>

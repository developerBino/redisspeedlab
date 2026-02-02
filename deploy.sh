#!/bin/bash

# Redis Speed Lab - Complete Deployment Package
# This script prepares your project for deployment

echo "🚀 Redis Speed Lab - Deployment Preparation"
echo "==========================================="
echo ""

PROJECT_DIR="/Users/bj/Documents/Work/RedisSpeedLab"
cd "$PROJECT_DIR"

# Step 1: Create necessary files
echo "✓ Step 1: Creating deployment files..."

# Create Procfile
cat > Procfile << 'EOF'
web: vendor/bin/heroku-php-apache2 public/
EOF

# Create .gitignore
cat > .gitignore << 'EOF'
node_modules/
vendor/
.env
.env.*.php
.DS_Store
.idea/
*.log
storage/logs/*.log
bootstrap/cache/*
storage/framework/*
storage/app/*
!storage/app/public
public/storage
EOF

# Create runtime.txt (PHP version)
cat > runtime.txt << 'EOF'
php-8.2
EOF

# Create .env.production
cat > .env.production << 'EOF'
APP_NAME="RedisSpeedLab"
APP_ENV=production
APP_DEBUG=false
APP_KEY=
APP_URL=https://your-app-name.railway.app

DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=redis_speedlab
DB_USERNAME=root
DB_PASSWORD=

CACHE_STORE=redis
REDIS_HOST=127.0.0.1
REDIS_PORT=6379
EOF

echo "✓ Created Procfile, .gitignore, runtime.txt, .env.production"
echo ""

# Step 2: Git initialization
echo "✓ Step 2: Initializing Git (if needed)..."
if [ ! -d ".git" ]; then
    git init
    git config user.email "developer@example.com"
    git config user.name "Developer"
    echo "✓ Git initialized"
else
    echo "✓ Git already initialized"
fi

echo ""
echo "✓ Step 3: Ready for deployment!"
echo ""

echo "📋 NEXT STEPS:"
echo "==========================================="
echo ""
echo "1. Create GitHub Repository:"
echo "   - Go to https://github.com/new"
echo "   - Create repository 'redis-speedlab'"
echo "   - DO NOT initialize with README"
echo ""
echo "2. Push to GitHub:"
echo "   git add ."
echo "   git commit -m 'Initial commit: Redis Speed Lab'"
echo "   git branch -M main"
echo "   git remote add origin https://github.com/YOUR_USERNAME/redis-speedlab.git"
echo "   git push -u origin main"
echo ""
echo "3. Deploy on Railway:"
echo "   - Go to https://railway.app"
echo "   - Click 'Start a New Project'"
echo "   - Select 'Deploy from GitHub'"
echo "   - Authorize and select 'redis-speedlab'"
echo "   - Railway will auto-detect Laravel!"
echo ""
echo "4. Configure in Railway Dashboard:"
echo "   - Set APP_KEY (generate: php artisan key:generate)"
echo "   - Ensure MySQL/Redis services are added"
echo "   - Run migrations: railway run php artisan migrate --seed"
echo ""
echo "5. Your live URL will be:"
echo "   https://redis-speedlab-production.up.railway.app"
echo ""
echo "✅ You're all set for deployment!"
echo ""

# 🚀 Deployment Guide - Free Hosting Options

## Overview

RedisSpeedLab can be deployed to several free hosting platforms. Here are the best options:

---

## ✅ Option 1: Railway (RECOMMENDED - Most Beginner Friendly)

**Why Railway:**
- Free tier: 500 hours/month (plenty for a demo)
- Built-in support for Laravel
- Built-in PostgreSQL/MySQL
- Built-in Redis
- Simple GitHub integration
- No credit card needed initially

### Steps:

1. **Push to GitHub**
```bash
cd /Users/bj/Documents/Work/RedisSpeedLab
git init
git add .
git commit -m "Initial commit: Redis Speed Lab"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/redis-speedlab.git
git push -u origin main
```

2. **Deploy on Railway**
- Go to https://railway.app
- Click "Start a New Project"
- Select "Deploy from GitHub"
- Authorize and select your `redis-speedlab` repository
- Railway automatically detects it's a Laravel project
- Click "Deploy"

3. **Configure Environment**
- Railway will create `.env` automatically
- Add to Railway variables:
  ```
  APP_DEBUG=false
  APP_ENV=production
  CACHE_STORE=redis
  ```
- Railway provides Redis automatically

4. **Run Migrations**
```bash
# In Railway dashboard, go to your project
# Open "Deployments" tab
# Find the most recent deployment
# Under "Services", click your app
# Go to "Settings"
# In the console, run:
php artisan migrate --seed
```

✅ **Live URL:** Railway gives you automatic domain like `redis-speedlab-production.up.railway.app`

---

## ✅ Option 2: Render

**Why Render:**
- Free tier web service
- PostgreSQL included
- Node.js + Python friendly
- Simple deployment

### Steps:

1. **Prepare for Render**
```bash
# Create render.yaml in project root
```

2. **Deploy**
- Go to https://render.com
- Click "New +"
- Select "Web Service"
- Connect GitHub repository
- Build Command: `composer install && php artisan migrate --seed`
- Start Command: `php artisan serve --port=10000`

---

## ✅ Option 3: Vercel (Best for Frontend)

**Why Vercel:**
- Excellent for static assets
- Free tier generous
- Great for showcasing

### Note:
Vercel is better for the frontend only. You'd need a separate backend on Railway/Render.

---

## ✅ Option 4: PythonAnywhere (Budget-Friendly)

**Pros:**
- Web apps supported
- Free tier available
- Simple setup

---

## RECOMMENDED: Railway Setup (Step-by-Step)

### Step 1: Prepare GitHub

```bash
cd /Users/bj/Documents/Work/RedisSpeedLab

# Initialize git
git init

# Create .gitignore
echo "node_modules/
vendor/
.env
storage/logs/*.log
" > .gitignore

# Create Procfile for Railway
echo "web: cd public && php -S 127.0.0.1:\$PORT" > Procfile

# Add everything
git add .
git commit -m "Redis SpeedLab - Initial deployment"
```

### Step 2: Push to GitHub

```bash
# If you haven't created repo yet
# 1. Go to github.com
# 2. Create new repository "redis-speedlab"
# 3. Don't initialize with README

git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/redis-speedlab.git
git push -u origin main
```

### Step 3: Deploy on Railway

1. Visit https://railway.app
2. Sign up (can use GitHub account)
3. Click "New Project"
4. Select "Deploy from GitHub Repo"
5. Authorize GitHub
6. Select your "redis-speedlab" repository
7. Railway auto-configures!

### Step 4: Configure Services

Railway automatically sets up:
- ✅ Web service (your Laravel app)
- ✅ PostgreSQL or MySQL
- ✅ Redis

### Step 5: Set Environment Variables

In Railway dashboard:

```
APP_NAME=RedisSpeedLab
APP_ENV=production
APP_DEBUG=false
CACHE_STORE=redis
DB_CONNECTION=mysql (or postgres)
DB_HOST=<railway-provides-this>
DB_DATABASE=<railway-provides-this>
DB_USERNAME=<railway-provides-this>
DB_PASSWORD=<railway-provides-this>
REDIS_HOST=<railway-provides-this>
REDIS_PORT=<railway-provides-this>
```

### Step 6: Run Migrations

```bash
# In Railway CLI or dashboard console
railway run php artisan migrate --seed
```

✅ Done! Your app is live!

---

## Testing Your Deployment

Once deployed:

```bash
curl https://YOUR-RAILWAY-DOMAIN.railway.app/
# Shows the demo page

curl https://YOUR-RAILWAY-DOMAIN.railway.app/test?cache=off
# JSON response with database timing

curl https://YOUR-RAILWAY-DOMAIN.railway.app/test?cache=on
# JSON response with Redis timing
```

---

## Free Tier Limits

| Service | Limit | Notes |
|---------|-------|-------|
| Railway | 500 hrs/month | Perfect for demo |
| Render | 750 hours/month | Good alternative |
| Vercel | 100GB bandwidth | Frontend only |

---

## Domain Setup (Optional)

### Railway Custom Domain
1. In Railway dashboard → Project Settings
2. Add custom domain
3. Point DNS records to Railway

Free domains:
- `.railway.app` (automatic)
- `.repl.co` (Replit)

---

## Cost Comparison

| Service | Cost | Best For |
|---------|------|----------|
| Railway | Free ($5/month after) | ⭐ Demo + Learning |
| Render | Free ($7/month after) | Alternative |
| Vercel | Free ($20/month after) | Frontend showcase |

---

## Troubleshooting Deployment

### 502 Bad Gateway
```
Rails might not have configured properly.
Solution: Check Railway logs → Usually missing migrations
Run: railway run php artisan migrate --seed
```

### Redis Connection Failed
```
Solution: Check Redis service is attached in Railway
Go to Services tab and ensure Redis is added
```

### Static Assets Not Loading
```
Solution: Run
php artisan storage:link
php artisan config:cache
php artisan route:cache
```

---

## Making it Production-Ready

Before deploying:

1. **Update .env.example** with realistic variables
2. **Create Procfile** (done above)
3. **Run tests locally**
```bash
php artisan test
```

4. **Optimize**
```bash
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

5. **Check storage**
```bash
php artisan storage:link
```

---

## Quick Deploy Commands (Railway CLI)

```bash
# Install Railway CLI
npm i -g @railway/cli

# Login
railway login

# Initialize in project
railway init

# Link to project
railway link <PROJECT_ID>

# Deploy
railway up

# View logs
railway logs

# Run migrations
railway run php artisan migrate --seed
```

---

## Success! 🎉

Your RedisSpeedLab is now live for everyone to see!

Share the link:
```
🎓 Check out Redis Speed Lab:
https://redis-speedlab-production.up.railway.app

Learn about caching performance! ⚡
```

---

## Next Steps

1. ✅ Deploy to Railway (easiest)
2. ✅ Test the live demo page
3. ✅ Share with friends
4. ✅ Monitor performance in Railway dashboard
5. ✅ Optional: Add custom domain

---

**Questions? Issues?**
- Railway Docs: https://docs.railway.app
- Laravel Deployment: https://laravel.com/docs/deployment
- Redis Caching: https://laravel.com/docs/cache

Good luck! 🚀

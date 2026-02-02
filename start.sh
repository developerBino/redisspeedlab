#!/bin/bash

# Redis SpeedLab - Railway Start Script
# This script runs migrations, seeds data, and starts the Laravel app

set -e

echo "🚀 Starting Redis SpeedLab on Railway..."

# Run migrations
echo "📦 Running database migrations..."
php artisan migrate --force

# Seed database (only if items table is empty)
echo "🌱 Seeding database..."
php artisan db:seed --force

# Clear caches
echo "🧹 Clearing caches..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Start the Laravel application
echo "⚡ Starting Laravel server..."
php artisan serve --host=0.0.0.0 --port=${PORT:-8000}

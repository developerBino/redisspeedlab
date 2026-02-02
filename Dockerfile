# Use PHP 8.3 with FPM for better compatibility
FROM php:8.3-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    sqlite3 \
    libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_sqlite

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

    # Install PHP dependencies
    # Using --ignore-platform-req=php to allow installation on PHP 8.3
    # even if some packages declare they need PHP 8.4
    RUN composer install --no-dev --optimize-autoloader --ignore-platform-req=php# Make start script executable
RUN chmod +x start.sh

# Create storage directories with proper permissions
RUN mkdir -p storage/logs storage/framework/cache storage/framework/sessions storage/framework/views
RUN chmod -R 775 storage bootstrap/cache

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Start application
CMD ["./start.sh"]

FROM php:7.4-fpm

# Install system dependencies required for PHP extensions, including GD
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libonig-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    unzip \
    zip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) pdo pdo_mysql zip fileinfo curl xml mbstring gd \
    && docker-php-ext-enable opcache gd \
    && rm -rf /var/lib/apt/lists/*

# Set working directory (adjust if needed)
WORKDIR /var/www/html

# Copy composer from official image (optional if you use composer)
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

EXPOSE 9000

CMD ["php-fpm"]
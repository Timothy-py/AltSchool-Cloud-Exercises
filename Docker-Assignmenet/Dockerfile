# Use PHP official base image
FROM php:7.4-apache

# Set the working directory inside Docker to /app
WORKDIR /app

# Copy the composer.json and composer.lock files to the container
COPY composer.json composer.lock ./

# Install the Zip extension and unzip command
RUN apt-get update && apt-get install -y \
    zip \
    unzip


# Run composer install to install dependencies
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer install --no-dev --no-autoloader --no-scripts

# Copy the rest of the application files to the container
COPY . .

# Set the Apache document root to the public directory
ENV APACHE_DOCUMENT_ROOT /app/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Run the following commands to configure the environment
RUN a2enmod rewrite
RUN chown -R www-data:www-data /app

# Expose port 80
EXPOSE 80

# Start the Apache service
CMD ["apache2-foreground"]

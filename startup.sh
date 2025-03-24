#!/bin/bash

# Stop Nginx
service nginx stop

# Check if school.sqlite exists, and create it if it doesn't
DB_PATH="/home/site/wwwroot/database/school.sqlite"
if [ ! -f "$DB_PATH" ]; then
  touch "$DB_PATH"
  chmod 666 "$DB_PATH"
  echo "Created SQLite database: $DB_PATH"
fi

# Set correct permissions
chmod -R 775 /home/site/wwwroot/storage
chmod -R 775 /home/site/wwwroot/bootstrap/cache
chown -R www-data:www-data /home/site/wwwroot/storage
chown -R www-data:www-data /home/site/wwwroot/bootstrap/cache

# Run database migrations and seeders
php /home/site/wwwroot/artisan migrate --force
php /home/site/wwwroot/artisan db:seed --force

# Clear and cache Laravel configurations
php /home/site/wwwroot/artisan cache:clear
php /home/site/wwwroot/artisan config:clear
php /home/site/wwwroot/artisan config:cache
php /home/site/wwwroot/artisan route:clear
php /home/site/wwwroot/artisan view:clear

# Copy default Nginx configuration
cp /home/site/wwwroot/default /etc/nginx/sites-available/default
ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Start Nginx
service nginx start

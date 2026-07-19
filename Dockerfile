FROM php:8.2-apache

WORKDIR /var/www/html

COPY index.php .

EXPOSE 80

CMD ["apache2-foreground"]
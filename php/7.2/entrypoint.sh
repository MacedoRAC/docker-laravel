#!/bin/sh

if [ -f ./composer.json ]; then
	if [ ! -d "./vendor" ]; then
	  composer install
	fi

	service supervisor start
	service cron start

	php artisan serve --host=0.0.0.0 --port=8000

else
	composer create-project --prefer-dist laravel/laravel new-project
fi
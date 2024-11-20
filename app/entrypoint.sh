#!/bin/sh

# Verify Postgres is healthy before applying the migrations
# and running the django dev server

if ["$DATABASE" = "postgres"]
then
    echo "Waiting for postgres..."

    while ! nc -z $SQL_HOST $SQL_PORT; do
      sleep 0.1
    done


    echo "PostgreSQL started"
fi

python manage.py flush --no-input
echo "migrate"
python manage.py migrate
echo "collectstatic running"
python manage.py collectstatic --no-input

exec "$@"
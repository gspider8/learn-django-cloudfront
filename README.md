## Startup
git clone
terraform apply
update .env.aws
```
AWS_STORAGE_BUCKET_NAME=
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
CLOUDFRONT_DOMAIN=
```
docker-compose up -d --build

to check go to 127.0.0.1:8000 and inspect the page and refresh, it should be sourced from the cloudfront module

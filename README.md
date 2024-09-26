# Django + S3

continue at https://www.youtube.com/watch?v=JQVQcNN0cXE django -v > 4.2

```shell
docker-compose exec web python manage.py collectstatic

```
terraform is up 

TODO 
- make a script to write aws credentials to ~/.aws/credentials in format: 
  ```
  [profile-name]
  aws_access_key_id=Aafhjkahlkjs
  aws_secret_access_key=faefaeafs
  ```
  - and delete on destroy
https://testdriven.io/blog/storing-django-static-and-media-files-on-amazon-s3

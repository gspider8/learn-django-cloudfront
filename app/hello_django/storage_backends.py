# --- djangoProject.storage_backends ---
from django.conf import settings
from storages.backends.s3boto3 import S3Boto3Storage


class StaticStorage(S3Boto3Storage):
    location = 'static'
    # default_acl = 'public-read'


class PublicMediaStorage(S3Boto3Storage):
    location = 'media'
    file_overwrite = False
    # default_acl = 'public-read'

class StaticCF(S3Boto3Storage):
    location = 'static'
    custom_domain = settings.CLOUDFRONT_DOMAIN

output "django-cdn-bucket_name" {
  value = module.django-cdn.bucket.bucket
}

output "django-cdn-cdn_domain" {
  value = module.django-cdn.cdn.domain_name
}

output "django-cdn-iam_credentials" {
  value = "${module.django-cdn.iam_user_access.id}, (secret)"
}
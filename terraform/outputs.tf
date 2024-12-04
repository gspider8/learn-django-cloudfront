output "bucket_credentials" {
  value = "${module.django-cdn.bucket.bucket}: ${module.django-cdn.access_key.id}, (secret)"
}

output "cloudfront_domain" {
  value = module.django-cdn.cdn.domain_name
}
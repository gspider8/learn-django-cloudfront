output "bucket_credentials" {
  value = "${module.storages[0].bucket.bucket}: ${module.storages[0].access_key.id}, (secret)"
}

output "cloudfront_domain" {
  value = aws_cloudfront_distribution.main.domain_name
}
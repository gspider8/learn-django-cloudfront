output "bucket_credentials" {
  value = "${aws_s3_bucket.main.bucket}: ${aws_iam_access_key.main.id}, (secret)"
}

output "cloudfront_domain" {
  value = aws_cloudfront_distribution.main.domain_name
}
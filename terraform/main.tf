resource "aws_cloudfront_distribution" "main" {
  origin {
    domain_name = module.storages[0].bucket.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    origin_shield {
      enabled = false  # change to true
      origin_shield_region = "us-east-1"
    }
  }
  enabled         = true
  is_ipv6_enabled = true
  default_cache_behavior {
    target_origin_id = local.s3_origin_id
    cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" # CachingDisabled
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]

    viewer_protocol_policy = "allow-all"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}



module "storages" {
  source             = "github.com/gspider8/terraform-aws-django-storages?ref=v0.0.4"
  count              = length(local.buckets)
  bucket_name        = local.buckets[count.index].name
  bucket_policy_type = local.buckets[count.index].bucket_policy
  iam_user           = local.buckets[count.index].iam_user

  tags = {
    Environment = "Dev"
    Project     = "mlehr.org"
  }
}



# module "web_server" {
#   source = "github.com/gspider8/terraform-aws-django-app_server?ref=v0.0.3"
#
#   my_ip             = var.my_ip
#   project_name      = var.project_name
#   block_volume_size = 10
#   sgs               = local.web_server_security_groups
#
#   ssh_key = {
#     name = var.public_key_name
#     public_key = file(var.public_key_path)
#   }
#
#   instance_tags = {
#     Name    = var.project_name
#     Project = var.project_name
#   }
# }
#
# output "instance_ip" {
#   value = module.web_server.instance.public_ip
# }
#
# output "instance_sshkey" {
#   value = var.public_key_name
# }
resource "aws_s3_bucket" "main" {
  bucket = local.buckets.name
}

resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}

data "aws_cloudfront_response_headers_policy" "main" {
  name = "Managed-SimpleCORS"
}

resource "aws_cloudfront_distribution" "main" {
  origin {
    domain_name = aws_s3_bucket.main.bucket_regional_domain_name
    origin_id   = local.s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.main.id

#     origin_shield {
#       enabled = false  # change to true
#       origin_shield_region = "us-east-1"
#     }
  }
  enabled         = true
  is_ipv6_enabled = true
  default_cache_behavior {
    target_origin_id = local.s3_origin_id
    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.main.id
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

resource "aws_cloudfront_origin_access_control" "main" {
  name                              = "${var.project_name}-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

data "aws_iam_policy_document" "cloudfront_orign" {
  statement {
    sid = "OAC"
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.main.arn}/*"
    ]
    condition {
      variable = "AWS:SourceArn"
      test     = "StringEquals"
      values = [
        aws_cloudfront_distribution.main.arn
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.cloudfront_orign.json
  depends_on = [aws_s3_bucket_public_access_block.main]
}
















# -- iam --
data "aws_iam_policy_document" "django_user" {
  statement {
    sid    = "1"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:ListBucketMultipartUploads",
      "s3:ListBucketVersions"
    ]
    resources = [
      aws_s3_bucket.main.arn
    ]
  }
  statement {
    sid    = "2"
    effect = "Allow"
    actions = [
      "s3:*Object*",
      "s3:ListMultipartUploadParts",
      "s3:AbortMultipartUpload"
    ]
    resources = [
      "${aws_s3_bucket.main.arn}/*"
    ]
  }
}

resource "aws_iam_user" "main" {
  name = local.buckets.iam_user.name
  path = "/users/"
#   tags = var.tags
}

resource "aws_iam_user_policy" "main" {
  user   = aws_iam_user.main.name
  policy = data.aws_iam_policy_document.django_user.json
  name   = "${local.buckets.iam_user.name}-policy"
}

resource "aws_iam_access_key" "main" {
  user  = aws_iam_user.main.name
}

# module "storages" {
#   source             = "github.com/gspider8/terraform-aws-django-storages?ref=v0.0.4"
#   count              = length(local.buckets)
#   bucket_name        = local.buckets[count.index].name
#   bucket_policy_type = local.buckets[count.index].bucket_policy
#   iam_user           = local.buckets[count.index].iam_user
#
#   tags = {
#     Environment = "Dev"
#     Project     = "mlehr.org"
#   }
# }

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
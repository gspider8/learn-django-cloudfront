resource "aws_s3_bucket" "main" {
  bucket = var.project_name

  tags = {
    Environment = "Dev"
    Project     = var.project_name
  }
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "allow_public_get_access" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.allow_public_get_access.json
}

# https://www.youtube.com/watch?v=JQVQcNN0cXE
# open to everyone or else pages won't load on the web
data "aws_iam_policy_document" "allow_public_get_access" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.main.arn}/*",
    ]
  }
}

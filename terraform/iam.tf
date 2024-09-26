# --- iam.tf ---
resource "aws_iam_user" "django" {
  name = var.project_name
  path = "/users/"

  tags = {
    Project = var.project_name
  }
}

resource "aws_iam_user_policy" "django" {
  name   = "django-storages-permission-${var.project_name}"
  user   = aws_iam_user.django.name
  policy = data.aws_iam_policy_document.django_user.json
}

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

resource "aws_iam_access_key" "django" {
  user = aws_iam_user.django.name
}

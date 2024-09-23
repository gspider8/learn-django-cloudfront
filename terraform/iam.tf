resource "aws_iam_user_group_membership" "django" {
  user   = aws_iam_user.django.name
  groups = ["Django-Static+Media-S3"]
}

resource "aws_iam_user" "django" {
  name = var.project_name
  path = "/users/"

  tags = {
    Project = var.project_name
  }
}

resource "aws_iam_access_key" "django" {
  user = aws_iam_user.django.name
}

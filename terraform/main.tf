module "django-cdn" {
#   source = "./django-cdn"
  source = "github.com/gspider8/terraform-aws-django-cdn?ref=v0.0.1"


  bucket_name = "${var.project_name}-django-cdn"
  origin_id   = "${var.project_name}-bucket"


  iam_user = {
    create = true
    name = "${var.project_name}-django-cdn-access"
  }

  tags= {
    Terraform = "True"
    Project = var.project_name
  }
}

module "web_server" {
  source = "github.com/gspider8/terraform-aws-django-app_server?ref=v0.0.3"

  my_ip             = var.my_ip
  project_name      = var.project_name
  block_volume_size = 10
  sgs               = local.web_server_security_groups

  ssh_key = {
    name = var.public_key_name
    public_key = file(var.public_key_path)
  }

  instance_tags = {
    Name    = var.project_name
    Project = var.project_name
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



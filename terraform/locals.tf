locals {
  buckets = [{
    name          = "dev-django-storages-${var.project_name}"
    bucket_policy = "public_read"
    iam_user = {
      create      = true
      name        = "dev-django-storages-${var.project_name}-access"
      policy_type = "django_user"
    }
  }]
  web_server_security_groups = {
    ipv4 = {
      local_ssh = {
        description = "SSH Access"
        from        = 22
        to          = 22
        protocol    = "tcp"
        cidr_block  = var.my_ip
      }
      local_8000 = {
        description = "App Server Access"
        from        = 8000
        to          = 8000
        protocol    = "tcp"
        cidr_block  = var.my_ip
      }
      open_http = {
        description = "Open HTTP Access"
        from        = 80
        to          = 80
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      }
      open_https = {
        description = "OPEN HTTPS Access"
        from        = 443
        to          = 443
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      }
    }
    ipv6 = {
      open_http = {
        description = "Open HTTP Access"
        from        = 80
        to          = 80
        protocol    = "tcp"
        cidr_block  = "::/0"
      }
      open_https = {
        description = "OPEN HTTPS Access"
        from        = 443
        to          = 443
        protocol    = "tcp"
        cidr_block  = "::/0"
      }
    }
    self_referential = {
      database_sg = {
        description = "Postgres Access"
        to          = 5432
        from        = 5432
        protocol    = "tcp"
      }
    }
  }
}
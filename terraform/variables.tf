variable "project_name" {
  type    = string
  default = "django-s3-cloudfront"
}

variable "my_ip" {
  type = string
  sensitive = true
}

variable "public_key_path" {
  type = string
}

variable "public_key_name" {
  type = string
}
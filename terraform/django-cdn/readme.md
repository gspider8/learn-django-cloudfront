# Django CDN Module

Limitations
  One Origin that is created by this module
  Caching is disabled (is only really acting as a proxy)

### Variables
`bucket`
```terraform
bucket = {
  name          = "${var.project_name}-django-cdn"
  bucket_policy = "public_read"
  origin_id = "${var.project_name}-bucket"
}

```
`iam_user`
```terraform
iam_user = {
  create      = true
  name        = "${var.project_name}-django-cdn-access"
}
```


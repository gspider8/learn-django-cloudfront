output "bucket_credentials" {
  value = "${module.storages[0].bucket.bucket}: ${module.storages[0].access_key.id}, (secret)"
}
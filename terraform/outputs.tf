output "instance_ip" {
  value = module.web_server.instance.public_ip
}

output "instance_sshkey" {
  value = var.public_key_name
}

output "bucket_credentials" {
  value = "${module.storages[0].bucket.bucket}: ${module.storages[0].access_key.id}, (secret)"
}
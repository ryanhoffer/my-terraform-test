# main.tf
terraform {
  required_version = ">= 1.0"
}

# A simple null resource to test with
resource "null_resource" "test" {
  triggers = {
    always_run = timestamp()
  }
  
  provisioner "local-exec" {
    command = "echo 'Terraform executed via Atlantis!!'"
  }
}

output "test_message" {
  value = "Terraform with Atlantis is working!"
}
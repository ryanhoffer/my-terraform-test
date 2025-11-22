terraform {
  required_version = ">= 1.0"
}

# Deploy website from content file
resource "null_resource" "web_server" {
  triggers = {
    content = filemd5("${path.module}/website-content.html")
    time    = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
      # Install nginx
      if ! command -v nginx &> /dev/null; then
        sudo apt update && sudo apt install -y nginx
      fi

      # Deploy the HTML content
      sudo cp website-content.html /var/www/html/index.html
      sudo systemctl restart nginx
      echo "Website deployed: $(date)"
    EOT
  }
}

output "url" {
  value = "http://YOUR_VPS_IP"
}
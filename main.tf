terraform {
  required_version = ">= 1.0"
}

# Install and configure nginx (much more reliable)
resource "null_resource" "deploy_nginx" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
      # Update and install nginx
      sudo apt update
      sudo apt install -y nginx

      # Create a custom HTML page
      sudo tee /var/www/html/index.html > /dev/null << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Terraform + Atlantis Success!</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f0f8ff; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #2c5aa0; }
        .success { color: #28a745; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🎉 Success! Website Deployed via Terraform + Atlantis</h1>
        <p class="success">This page was automatically deployed from a GitHub Pull Request!</p>
        <p><strong>Deployment Method:</strong> Terraform + Atlantis on Hostinger VPS</p>
        <p><strong>Timestamp:</strong> $(date)</p>
        <p><strong>Infrastructure as Code:</strong> Working perfectly! 🚀</p>
    </div>
</body>
</html>
EOF

      # Ensure nginx is running
      sudo systemctl start nginx
      sudo systemctl enable nginx
      
      # Allow HTTP traffic
      sudo ufw allow 'Nginx HTTP'
      
      echo "Nginx deployed and running on port 80"
    EOT
  }
}

output "website_url" {
  value = "http://82.29.197.135/"
}
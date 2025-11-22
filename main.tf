terraform {
  required_version = ">= 1.0"
}

# Deploy nginx with updated content
resource "null_resource" "web_server" {
  triggers = {
    # Change this content hash when you want to update the page
    content_hash = md5(file("${path.module}/website-content.html"))
    deployment   = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
      # Install nginx if not present
      if ! command -v nginx &> /dev/null; then
        echo "Installing nginx..."
        sudo apt update && sudo apt install -y nginx
      fi

      # Deploy the updated HTML content
      sudo tee /var/www/html/index.html > /dev/null << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Terraform + Atlantis - UPDATED!</title>
    <style>
        body { 
            font-family: 'Arial', sans-serif; 
            margin: 0; 
            padding: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .container { 
            max-width: 800px; 
            margin: 0 auto; 
            padding: 40px 20px;
            text-align: center;
        }
        h1 { 
            font-size: 2.5em; 
            margin-bottom: 20px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        .success { 
            background: rgba(255,255,255,0.1);
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
            backdrop-filter: blur(10px);
        }
        .update-note {
            background: #28a745;
            padding: 10px;
            border-radius: 5px;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Website Updated via Terraform!</h1>
        
        <div class="update-note">
            <strong>This page was updated through a GitHub Pull Request!</strong>
        </div>
        
        <div class="success">
            <p><strong>Deployment Method:</strong> Terraform + Atlantis on Hostinger VPS</p>
            <p><strong>Last Updated:</strong> ${timestamp()}</p>
            <p><strong>Update Count:</strong> This is version 2.0</p>
        </div>

        <div class="success">
            <h3>How This Works:</h3>
            <p>1. Update Terraform code in GitHub</p>
            <p>2. Create a Pull Request</p>
            <p>3. Atlantis automatically runs terraform plan</p>
            <p>4. Comment "atlantis apply" to deploy</p>
            <p>5> Website updates automatically! 🎉</p>
        </div>
    </div>
</body>
</html>
EOF

      # Ensure nginx is running
      sudo systemctl restart nginx
      
      echo "Website updated successfully at $(date)"
    EOT
  }
}

output "website_url" {
  value = "http://82.29.197.135/"
}

output "deployment_message" {
  value = "Website updated via Terraform + Atlantis workflow!"
}
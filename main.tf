terraform {
  required_version = ">= 1.0"
}

# Deploy a Node.js application
resource "null_resource" "deploy_node_app" {
  triggers = {
    app_version = "1.0.0"
  }

  provisioner "local-exec" {
    command = <<EOT
      # Create app directory
      mkdir -p /home/ubuntu/my-app
      cd /home/ubuntu/my-app

      # Create package.json
      cat > package.json << 'EOF'
      {
        "name": "my-app",
        "version": "1.0.0",
        "scripts": {
          "start": "node server.js"
        },
        "dependencies": {
          "express": "^4.18.0"
        }
      }
      EOF

      # Create server.js
      cat > server.js << 'EOF'
      const express = require('express');
      const app = express();
      const port = 3000;

      app.get('/', (req, res) => {
        res.send('Hello from Terraform + Atlantis on Hostinger VPS!');
      });

      app.listen(port, '0.0.0.0', () => {
        console.log(`App running on port ${port}`);
      });
      EOF

      # Install and start
      npm install
      npm install -g pm2
      pm2 start server.js --name "my-app"
      pm2 save
      pm2 startup
    EOT
  }
}

output "app_url" {
  value = "http://http://82.29.197.135/:3000"
}
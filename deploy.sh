#!/bin/bash

# =====================================
# VARIABLES
# =====================================

PROJECT_NAME="To-Do-List-Manager"
GITHUB_REPO="https://github.com/Pratham-ghadge/To-Do-List-Manager.git"
EC2_IP="98.94.8.144"

# =====================================
# UPDATE SERVER
# =====================================

sudo apt update && sudo apt upgrade -y

# =====================================
# INSTALL NODE + TOOLS
# =====================================

curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -

sudo apt install -y nodejs git nginx

sudo npm install -g pm2

# =====================================
# CLONE PROJECT
# =====================================

cd ~

git clone $GITHUB_REPO

cd $PROJECT_NAME

# =====================================
# BACKEND SETUP
# =====================================

cd backend

npm install

# OPTIONAL ENV UPDATE
# sed -i "s|FRONTEND_URL=.*|FRONTEND_URL=http://$EC2_IP|g" .env

# START BACKEND
pm2 start index.js --name backend

pm2 save

# =====================================
# FRONTEND SETUP
# =====================================

cd ../frontend

npm install

# REPLACE LOCALHOST API URL
grep -rl "localhost:5000" . | xargs sed -i "s|http://localhost:5000|http://$EC2_IP|g"

# BUILD FRONTEND
npm run build

# =====================================
# FIX PERMISSIONS
# =====================================

sudo chmod 755 /home/ubuntu

sudo chmod -R 755 /home/ubuntu/$PROJECT_NAME/frontend/dist

# =====================================
# NGINX CONFIG
# =====================================

sudo bash -c "cat > /etc/nginx/sites-available/todoapp" <<EOF
server {
    listen 80;

    server_name $EC2_IP;

    root /home/ubuntu/$PROJECT_NAME/frontend/dist;

    index index.html;

    location / {
        try_files \$uri \$uri/ /index.html;
    }

    location /api {
        proxy_pass http://localhost:5000;

        proxy_http_version 1.1;

        proxy_set_header Upgrade \$http_upgrade;

        proxy_set_header Connection 'upgrade';

        proxy_set_header Host \$host;

        proxy_set_header X-Real-IP \$remote_addr;

        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;

        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# =====================================
# ENABLE NGINX
# =====================================

sudo rm -f /etc/nginx/sites-enabled/default

sudo ln -sf /etc/nginx/sites-available/todoapp /etc/nginx/sites-enabled/

# =====================================
# TEST & RESTART NGINX
# =====================================

sudo nginx -t

sudo systemctl restart nginx

sudo systemctl enable nginx

# =====================================
# PM2 STARTUP
# =====================================

pm2 startup systemd -u ubuntu --hp /home/ubuntu

pm2 save

# =====================================
# DONE
# =====================================

echo "======================================="
echo "DEPLOYMENT COMPLETED"
echo "OPEN:"
echo "http://$EC2_IP"
echo "======================================="

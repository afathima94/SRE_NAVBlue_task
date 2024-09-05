#Create certs
sudo mkdir -p /etc/nginx/ssl/
cd /etc/nginx/ssl/
#Generate root ca certs
openssl genpkey -algorithm RSA -out rootCA.key
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 365 -out rootCA.crt 
# Generate client certificate
openssl genpkey -algorithm RSA -out client.key
openssl req -new -key client.key -out client.csr 
openssl x509 -req -in client.csr -CA rootCA.crt -CAkey rootCA.key -CAFin -out client.crt -days 365 -sha256
#Generate Server certs
openssl genpkey -algorithm RSA -out server.key
openssl req -new -key server.key -out server.csr 
openssl x509 -req -in server.csr -CA rootCA.crt -CAkey rootCA.key -CAFin -out server.crt -days 365 -sha256
#Copy nginx conf
sudo touch /etc/nginx/conf.d/gitea.conf
sudo chmod -R 777 /etc/nginx/conf.d/gitea.conf
sudo cat <<EOF >/etc/nginx/conf.d/gitea.conf
server {
  listen 443 ssl;
  server_name <ec2 IP>;

  ssl_certificate /etc/nginx/ssl/server.crt;
  ssl_certificate_key /etc/nginx/ssl/server.key;
  ssl_client_certificate /etc/nginx/ssl/rootCA.crt;
  ssl_verify_client on;

  location / {
    proxy_pass http://127.0.0.1:3000;
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;
  }
}
EOF
#Enable and start nginx
sudo systemctl enable nginx
sudo systemctl start nginx
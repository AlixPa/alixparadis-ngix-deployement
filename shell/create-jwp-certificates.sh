#/!/bin/sh
mkdir -p certbot/conf/live/jwp.alixparadis.com
openssl req -x509 -nodes -days 1 \
  -newkey rsa:2048 \
  -keyout certbot/conf/live/jwp.alixparadis.com/privkey.pem \
  -out certbot/conf/live/jwp.alixparadis.com/fullchain.pem \
  -subj "/CN=jwp.alixparadis.com"
docker compose up -d nginx
docker run --rm \
  -v $(pwd)/certbot/www:/var/www/certbot \
  -v $(pwd)/certbot/conf:/etc/letsencrypt \
  certbot/certbot certonly \
  --non-interactive \
  --agree-tos \
  --register-unsafely-without-email \
  --webroot -w /var/www/certbot \
  -d jwp.alixparadis.com
docker exec nginx nginx -s reload
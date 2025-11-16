#/!/bin/sh
docker compose stop
rm -rf certbot
mkdir -p certbot/conf/live/jwp.alixparadis.com
openssl req -x509 -nodes -days 1 \
  -newkey rsa:2048 \
  -keyout certbot/conf/live/jwp.alixparadis.com/privkey.pem \
  -out certbot/conf/live/jwp.alixparadis.com/fullchain.pem \
  -subj "/CN=jwp.alixparadis.com"
docker compose up -d nginx
docker compose wait nginx

TMP_FOLDER=certbot/tmp
mkdir $TMP_FOLDER
docker run --rm \
  -v $(pwd)/certbot/www:/var/www/certbot \
  -v ./$TMP_FOLDER:/etc/letsencrypt \
  certbot/certbot certonly \
  --non-interactive \
  --agree-tos \
  --register-unsafely-without-email \
  --force-renewal \
  --staging \
  --webroot -w /var/www/certbot \
  -d jwp.alixparadis.com

docker compose stop nginx
rm -rf certbot/conf
mkdir certbot/conf/
mv $TMP_FOLDER/* certbot/conf/
docker compose up -d nginx
docker compose up -d certbot
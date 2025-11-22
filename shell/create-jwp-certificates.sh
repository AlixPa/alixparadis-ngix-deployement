#/!/bin/sh
docker compose stop
mv certbot certbot_save
mkdir -p certbot/conf/live/jwp.alixparadis.com
mkdir -p certbot/conf/live/www.alixparadis.com
openssl req -x509 -nodes -days 1 \
  -newkey rsa:2048 \
  -keyout certbot/conf/live/jwp.alixparadis.com/privkey.pem \
  -out certbot/conf/live/jwp.alixparadis.com/fullchain.pem \
  -subj "/CN=jwp.alixparadis.com"
openssl req -x509 -nodes -days 1 \
  -newkey rsa:2048 \
  -keyout certbot/conf/live/www.alixparadis.com/privkey.pem \
  -out certbot/conf/live/www.alixparadis.com/fullchain.pem \
  -subj "/CN=www.alixparadis.com"
sleep 1
docker compose up -d nginx
until nc -z localhost 80; do
  echo "nginx not ready, waiting 1s"
  sleep 1
done

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
  --webroot -w /var/www/certbot \
  -d jwp.alixparadis.com \
  -d www.alixparadis.com

docker compose stop nginx
rm -rf certbot/conf
mkdir certbot/conf/
mv $TMP_FOLDER/* certbot/conf/
docker compose up -d nginx
docker compose up -d certbot
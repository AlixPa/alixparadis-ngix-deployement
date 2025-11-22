#/!/bin/sh
docker compose stop
rm -rf certbot
mkdir -p certbot/conf/live/alixparadis.com
openssl req -x509 -nodes -days 1 \
  -newkey rsa:2048 \
  -keyout certbot/conf/live/alixparadis.com/privkey.pem \
  -out certbot/conf/live/alixparadis.com/fullchain.pem \
  -subj "/CN=alixparadis.com"
sleep 1
docker compose up -d --build nginx
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
  --staging \
  --webroot -w /var/www/certbot \
  -d alixparadis.com \
  -d jwp.alixparadis.com \
  -d www.alixparadis.com

# docker compose stop nginx
# rm -rf certbot/conf
# mkdir certbot/conf/
# mv $TMP_FOLDER/* certbot/conf/
# docker compose up -d nginx
# docker compose up -d certbot
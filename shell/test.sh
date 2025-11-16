#/!/bin/sh
docker compose stop
rm -rf certbot
mkdir -p certbot/conf/live/jwp.alixparadis.com
openssl req -x509 -nodes -days 1 \
  -newkey rsa:2048 \
  -keyout certbot/conf/live/jwp.alixparadis.com/privkey.pem \
  -out certbot/conf/live/jwp.alixparadis.com/fullchain.pem \
  -subj "/CN=jwp.alixparadis.com"
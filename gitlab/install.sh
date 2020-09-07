#!/bin/bash

cd $(dirname $0)

echo "Start install gitlab..."
crontab -l > crontab.tmp
if [ "$(grep -c 'gitlab:backup:create' crontab.tmp)" -eq 0 ]
then
  echo '0   4    * * *   docker exec gitlab gitlab-rake gitlab:backup:create CRON=1' >> crontab.tmp
  crontab crontab.tmp
fi
rm crontab.tmp

read -p 'DOMAIN_NAME: ' DOMAIN_NAME
# domain_dash=${DOMAIN_NAME//./-}
gitlab_bucket=gitlab.${DOMAIN_NAME}
if [ $(aws s3api head-bucket --bucket $gitlab_bucket 2>&1|grep -c 404) -gt 0 ] 
then
  aws s3 mb s3://$gitlab_bucket
fi
sed -e "s/example.com/$DOMAIN_NAME/" gitlab.yml > docker-compose.yml

read -p 'GITLAB_EMAIL_PASSWORD: ' GITLAB_EMAIL_PASSWORD
echo "export GITLAB_EMAIL_PASSWORD=$GITLAB_EMAIL_PASSWORD" >> ~/.bashrc

echo "Setup crontab for backup..."
crontab -l > crontab.tmp
if [ "$(grep -c 'gitlab:backup:create' crontab.tmp)" -eq 0 ]
then
  echo '0   4    * * *   docker exec gitlab gitlab-rake gitlab:backup:create CRON=1' >> crontab.tmp
  crontab crontab.tmp
fi
rm crontab.tmp

crontab -l

echo "Create let's encrypt directory"
sudo mkdir -p /etc/letsencrypt

echo "=============================="
echo "Install OK"
echo "Start up: docker-compose up -d"
echo "Or edit docker-compose.yml and go"
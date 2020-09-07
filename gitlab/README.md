# GitLab

## Prepare

### Data Volume

- create > 60GB volume for store data
- format volume and mount it

```shell
$ sudo mkdir /srv/docker
$ sudo mkfs.ext4 /dev/xvdb
$ echo '/dev/xvdb /srv/docker ext4 defaults,nofail 0 2' | sudo tee -a /etc/fstab
$ sudo mount -a
```

### S3 Bucket

create `gitlab.example.com` bucket for [gitlab.yml](gitlab.yml), it should include follow subdirectory:
- artifacts
- lfs
- uploads
- backup

#### Auto delete old data
create life rule for `backup` prefix, delete s3 objects after 7days.


## Install

```sh
$ ./install.sh
```

## Restore

```sh
# aws s3 cp s3://backup.gitlab.example.com/1529946801_2018_06_26_11.0.0_gitlab_backup.tar --region cn-northwest-1 /srv/docker/gitlab/data/backups
sudo vi /srv/docker/gitlab/config/gitlab-secrets.json # $.gitlab_rails.*_key_base
docker exec -it gitlab gitlab-rake gitlab:backup:restore
docker restart gitlab
docker exec -it gitlab gitlab-ctl status
docker exec -it gitlab gitlab-rake gitlab:check SANITIZE=true
```

## SSL Certificates

### Prerequest

```
$ sudo yum install python-augeas
$ sudo yum install python-virtualenv
$ sudo yum install python-pip
$ sudo pip install virtualenv
```
or 
```
$ sudo yum install python-pip
$ sudo pip install augeas
$ sudo pip install virtualenv
```

### Install Let' encrypt

```sh
$ wget https://dl.eff.org/certbot-auto
$ chmod a+x certbot-auto
$ sudo mv certbot-auto /usr/local/bin
$ sudo chown root /usr/local/bin/certboot-auto
$ sudo chmod 755 /usr/local/bin/certboot-auto
$ certbot-auto --no-bootstrap
```

### Generate Certificate

```sh
$ certbot-auto certonly --manual --preferred-challenges "dns"  --agree-tos --no-bootstrap \
  -d *.example.com,*.dev.example.com \
  -m email@example.com \
  --cert-name example.com

$ sudo cp /etc/letsencrypt/live/example.com/fullchain.pem ~/devenv/gitlab/ssl/wildcard.example.com.crt
$ sudo cp /etc/letsencrypt/live/example.com/privkey.pem ~/devenv/gitlab/ssl/wildcard.example.com.key
```

## Upgrade Gitlab

```shell
docker pull gitlab/gitlab-ce:11.9.8-ce.0
vim docker-compose.yml
# image: gitlab/gitlab-ce:11.0.0-ce.0 => image: gitlab/gitlab-ce:11.9.8-ce.0
docker-compose down
docker-compose up -d
docker exec -it gitlab gitlab-rake db:migrate
docker restart gitlab
```
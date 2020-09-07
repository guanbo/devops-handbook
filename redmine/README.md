# Redmine

## Prepare

- buy your domain such as: `example.com`
- configure smtp server, such as: `smtp.exmail.qq.com`
- register eamil account `redmine@example.com` for send email

## Install

```sh
$ ./install.sh
```

## Retore

```sh
$ sudo aws s3 cp s3://redmine.example.com/2019-04-18 /srv/docker/mysql/
$ docker exec -t redmine_mysql mysql -uroot -p51wuzi redmine < /var/lib/mysql/2019-04-18
```

## Gitlab Commit Messages

[Referencing-issues-in-commit-messages](http://www.redmine.org/projects/redmine/wiki/RedmineSettings#Referencing-issues-in-commit-messages)

```
This commit refs:#1, #2 and rm #3
This commit Refs  #1, #2 and rm #3
This commit REFS: #1, #2 and rm #3
```

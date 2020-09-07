#!/usr/bin/sh
usermod -u 998 redmine
chown -R redmine:redmine /usr/src/redmine/tmp
/docker-entrypoint.sh rails server -b 0.0.0.0

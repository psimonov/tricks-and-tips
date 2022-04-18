#!/bin/sh

################################################# EXECUTE THIS! ###############################################################################################################
#                                                                                                                                                                             #
#   curl -fsSL https://raw.githubusercontent.com/psimonov/tricks-and-tips/master/scripts/installers/gitea.sh && chmod +x ./gitea.sh && sudo ./gitea.sh --host example.com)"   #
#                                                                                                                                                                             #
###############################################################################################################################################################################

SCRIPT_GITEA_VERSION="1.16.5"

SCRIPT_MESSAGE="Please, enter hostname in '--host' param."

if [ $# -ne 2 ]; then
  echo "$SCRIPT_MESSAGE"

  exit
fi

while [ "$1" != "" ]; do
    case $1 in
      --host )
        shift

        SCRIPT_HOST="$1"
      ;;

      *)
        echo "$SCRIPT_MESSAGE"

        exit
    esac

    shift
done

apt update
apt install nginx certbot python3-certbot-nginx -y

wget -O gitea https://dl.gitea.io/gitea/${SCRIPT_GITEA_VERSION}/gitea-${SCRIPT_GITEA_VERSION}-linux-amd64
chmod +x gitea

adduser \
   --system \
   --shell /bin/bash \
   --gecos 'Git Version Control' \
   --group \
   --disabled-password \
   --home /home/git \
   git

mkdir -p /var/lib/gitea/{custom,data,log}
chown -R git:git /var/lib/gitea/
chmod -R 750 /var/lib/gitea/
mkdir /etc/gitea
chown root:git /etc/gitea
chmod 770 /etc/gitea

export GITEA_WORK_DIR=/var/lib/gitea/

cp gitea /usr/local/bin/gitea

cat << EOF > /etc/systemd/system/gitea.service
[Unit]
Description=Gitea (Git with a cup of tea)
After=syslog.target
After=network.target
###
# Don't forget to add the database service dependencies
###
#
#Wants=mysql.service
#After=mysql.service
#
#Wants=mariadb.service
#After=mariadb.service
#
#Wants=postgresql.service
#After=postgresql.service
#
#Wants=memcached.service
#After=memcached.service
#
#Wants=redis.service
#After=redis.service
#
###
# If using socket activation for main http/s
###
#
#After=gitea.main.socket
#Requires=gitea.main.socket
#
###
# (You can also provide gitea an http fallback and/or ssh socket too)
#
# An example of /etc/systemd/system/gitea.main.socket
###
##
## [Unit]
## Description=Gitea Web Socket
## PartOf=gitea.service
##
## [Socket]
## Service=gitea.service
## ListenStream=<some_port>
## NoDelay=true
##
## [Install]
## WantedBy=sockets.target
##
###

[Service]
# Modify these two values and uncomment them if you have
# repos with lots of files and get an HTTP error 500 because
# of that
###
#LimitMEMLOCK=infinity
#LimitNOFILE=65535
RestartSec=2s
Type=simple
User=git
Group=git
WorkingDirectory=/var/lib/gitea/
# If using Unix socket: tells systemd to create the /run/gitea folder, which will contain the gitea.sock file
# (manually creating /run/gitea doesn't work, because it would not persist across reboots)
#RuntimeDirectory=gitea
ExecStart=/usr/local/bin/gitea web --config /etc/gitea/app.ini
Restart=always
Environment=USER=git HOME=/home/git GITEA_WORK_DIR=/var/lib/gitea
# If you install Git to directory prefix other than default PATH (which happens
# for example if you install other versions of Git side-to-side with
# distribution version), uncomment below line and add that prefix to PATH
# Don't forget to place git-lfs binary on the PATH below if you want to enable
# Git LFS support
#Environment=PATH=/path/to/git/bin:/bin:/sbin:/usr/bin:/usr/sbin
# If you want to bind Gitea to a port below 1024, uncomment
# the two values below, or use socket activation to pass Gitea its ports as above
###
#CapabilityBoundingSet=CAP_NET_BIND_SERVICE
#AmbientCapabilities=CAP_NET_BIND_SERVICE
###

[Install]
WantedBy=multi-user.target

EOF

cat << EOF > /etc/gitea/app.ini
APP_NAME = Gitea: Git with a cup of tea
RUN_USER = git
RUN_MODE = prod

[database]
DB_TYPE  = sqlite3
HOST     = 127.0.0.1:3306
NAME     = gitea
USER     = gitea
PASSWD   =
SCHEMA   =
SSL_MODE = disable
CHARSET  = utf8
PATH     = /var/lib/gitea/data/gitea.db
LOG_SQL  = false

[repository]
ROOT = /var/lib/gitea/data/gitea-repositories

[server]
SSH_DOMAIN       = ${SCRIPT_HOST}
DOMAIN           = localhost
HTTP_PORT        = 3000
ROOT_URL         = https://${SCRIPT_HOST}/
DISABLE_SSH      = false
SSH_PORT         = 22
LFS_START_SERVER = true
LFS_CONTENT_PATH = /var/lib/gitea/data/lfs
# LFS_JWT_SECRET   = PULa0lmjrSxbhYePLACycFJUoVZLF54nDfhK9uU3wWg
OFFLINE_MODE     = false

[mailer]
ENABLED = false

[service]
REGISTER_EMAIL_CONFIRM            = false
ENABLE_NOTIFY_MAIL                = false
DISABLE_REGISTRATION              = false
ALLOW_ONLY_EXTERNAL_REGISTRATION  = false
ENABLE_CAPTCHA                    = false
REQUIRE_SIGNIN_VIEW               = true
DEFAULT_KEEP_EMAIL_PRIVATE        = true
DEFAULT_ALLOW_CREATE_ORGANIZATION = false
DEFAULT_ENABLE_TIMETRACKING       = true
NO_REPLY_ADDRESS                  = noreply.localhost

# custom
REGISTER_MANUAL_CONFIRM = true
DEFAULT_ORG_VISIBILITY = private

[picture]
DISABLE_GRAVATAR        = false
ENABLE_FEDERATED_AVATAR = false

[openid]
ENABLE_OPENID_SIGNIN = false
ENABLE_OPENID_SIGNUP = false

[session]
PROVIDER = file

[log]
MODE      = console
LEVEL     = info
ROOT_PATH = /var/lib/gitea/log
ROUTER    = console

[security]
INSTALL_LOCK       = true
# INTERNAL_TOKEN     = eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjE2NDkxNzE2Mjl9.gof5e5MpDgMKsjDdr-5gvmHJSxJeggNqi1hzCqTKqGk
PASSWORD_HASH_ALGO = pbkdf2

[i18n]
LANGS = en-US
NAMES = English

# custom
[api]
ENABLE_SWAGGER = false

EOF

gitea generate secret INTERNAL_TOKEN
gitea generate secret JWT_SECRET

chmod 750 /etc/gitea
chmod 640 /etc/gitea/app.ini

sudo systemctl enable gitea --now

cat << EOF > /etc/nginx/sites-available/gitea.conf
server {
    server_name ${SCRIPT_HOST};

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}

EOF

ln -s /etc/nginx/sites-available/gitea.conf /etc/nginx/sites-enabled/

rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default

service nginx restart

certbot --nginx

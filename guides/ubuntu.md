# Setup Ubuntu Server 20.04 (May also be used in other releases)

## Legend

```
{user}  - username
{host}  - host
{name}  - user full name
{email} - user email
```

## Creating private/public ssh key pair (on local machine)

```
ssh-keygen -t rsa -b 4096 -C "{email}"

# send public key
cat ~/.ssh/{user}.pub | ssh root@{host} 'cat >> .ssh/authorized_keys'
```

## Start setup

```
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/psimonov/tricks-and-tips/master/scripts/setups/ubuntu.sh)"
```

## Add user

```
adduser {user}
gpasswd -a {user} sudo

su - {user}

mkdir .ssh
chmod 700 .ssh

nano .ssh/authorized_keys
chmod 600 .ssh/authorized_keys

exit

nano /etc/ssh/sshd_config ("PermitRootLogin no", "PasswordAuthentication no")

service ssh restart
```

## Firewall

```
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 25/tcp

sudo ufw show added
sudo ufw enable
```

## Date (Used in "Start setup" section)

```
sudo dpkg-reconfigure tzdata

sudo apt-get update
sudo apt-get install ntp
```

## Swap (Need to choose the right size)

```
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/psimonov/tricks-and-tips/master/scripts/setups/swap-1g.sh)"
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/psimonov/tricks-and-tips/master/scripts/setups/swap-2g.sh)"
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/psimonov/tricks-and-tips/master/scripts/setups/swap-4g.sh)"
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/psimonov/tricks-and-tips/master/scripts/setups/swap-8g.sh)"
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/psimonov/tricks-and-tips/master/scripts/setups/swap-16g.sh)"
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/psimonov/tricks-and-tips/master/scripts/setups/swap-32g.sh)"
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/psimonov/tricks-and-tips/master/scripts/setups/swap-64g.sh)"
```

## Git (Used in "Start setup" section)

```
sudo apt update
sudo apt install git

git config --global user.name "{name}"
git config --global user.email "{email}"
```

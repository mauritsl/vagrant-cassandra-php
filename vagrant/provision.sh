#!/bin/sh

# Abort provisioning if some select items are already installed. We'll assume if
# these are present, everything is. Test for modules directory in /data/claysoil and
# for nginx. This is mainly meant for Vagrant.
which apache2ctl >/dev/null &&
{ echo "Vagrant test setup already installed. If you are running on vagrant and need to test the installation script, please first issue a vagrant destroy."; exit 0; }

export DEBIAN_FRONTEND=noninteractive

apt-get update

ln -sf /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime

# Apache / PHP
apt-get install -y apache2 libapache2-mod-php5 php-apc
sed -i 's/\/var\/www/\/data\/app/g' /etc/apache2/sites-enabled/000-default
service apache2 restart

# Memcached
apt-get install -y memcached php5-memcached

# Set swappiness to 0. This will prevent swapping as much as possible.
# This setting is highly recommended when running Cassandra.
sysctl vm.swappiness=0
echo "vm.swappiness=0" >> /etc/sysctl.conf

# Cassandra
echo "deb http://www.apache.org/dist/cassandra/debian 12x main" >> /etc/apt/sources.list
echo "deb-src http://www.apache.org/dist/cassandra/debian 12x main" >> /etc/apt/sources.list
gpg --keyserver pgp.mit.edu --recv-keys F758CE318D77295D
gpg --export --armor F758CE318D77295D | sudo apt-key add -
gpg --keyserver pgp.mit.edu --recv-keys 2B5C1B00
gpg --export --armor 2B5C1B00 | apt-key add -
apt-get update
apt-get install -y cassandra
sed -i 's/listen_address: localhost/listen_address: 33.33.33.30/g' /etc/cassandra/cassandra.yaml
sed -i 's/rpc_address: localhost/rpc_address: 127.0.0.1/g' /etc/cassandra/cassandra.yaml
sed -i 's/seeds: "127.0.0.1"/seeds: "33.33.33.30"/g' /etc/cassandra/cassandra.yaml
service cassandra restart

# Chkconfig
apt-get -y install chkconfig
chkconfig cassandra on

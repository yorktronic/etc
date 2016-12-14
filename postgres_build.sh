#!/usr/bin/env bash

sudo apt-get update

# Helper tools
sudo apt-get -y install htop

# Python
sudo apt-get -y install python3
sudo apt-get -y install python-pip

# Docker
curl -fsSL https://get.docker.com/ | sh

# PostgreSQL package repo and GnuPG public key
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgd

# Update packages and install PostgreSQL
apt-get update && apt-get -y -q install python-software-properties software-properties-common \
    && apt-get -y -q install postgresql-9.3 postgresql-client-9.3 postgresql-contrib-9.3

# Switch to postgres user and create db
sudo -s
sudo -u postgres psql getmoore
/etc/init.d/postgresql start \
    && psql --command "CREATE USER pguser WITH SUPERUSER PASSWORD 'pguser';" \
    && createdb -O pguser pgdb
    && psql --command "CREATE EXTENSION adminpack;"

# Switch to root to complete config
# CHANGE LATER TO BE SECURE!
sudo -s root
echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.3/main/pg_hba.conf
echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf

# Expose port and setup data folders
# CHANGE PATHS LATER!
#EXPOSE 5432
#mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql
#VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# Define entry command
#USER postgres
#CMD ["/usr/lib/postgresql/9.3/bin/postgres", "-D", "/var/lib/postgresql/9.3/main", "-c", "config_file=/etc/postgresql/9.3/main/postgresql.conf"]
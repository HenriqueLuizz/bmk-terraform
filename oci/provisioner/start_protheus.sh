#!/usr/bin/bash

## Monta os diretorios

# mkfs -t ext4 /dev/sdb 
# mkdir /totvs
# mount /dev/sdb /totvs

sudo mkdir -p /totvs/protheus/apo
sudo mkdir -p /totvs/protheus/protheus_data/systemload
sudo mkdir -p /totvs/protheus/protheus_data/system
sudo mkdir -p /totvs/protheus/protheus_data/data

sudo mkdir -p /totvs/tec/appserver
sudo mkdir -p /totvs/tec/dbaccess
sudo mkdir -p /totvs/licenserver
sudo mkdir -p /totvs/arte
sudo mkdir -p /totvs/logs

echo '3 - start_protheus.sh' | sudo tee -a /tmp/timeline.txt

## Configura usuario Handson
sudo adduser handson
sudo usermod -aG root handson
sudo usermod -aG wheel handson
sudo mkdir -p /home/handson/.ssh
sudo echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDYTgy+GKCOoqwcz3XO23mrD4khasz0cLy8LQFnd3MjSEcZ3pXK/YCDFYqFknao/H4vvexW3gcxKLi/71nAdHwV8YwJr7l1t1l3avdQwO6KdnlfsSvd2X89SWljcq393+f5BleS9ZXnmvdF75lZPS6OHgfdxWktJTxSphudpOMA8iNXJsE2xQijlZ35qizg3gkuCYuD3HDcTXvDXjUZK4bGiAnGEPFef+6zLx431+GQTjigrUCdAYQaWlcxiNq/u/dvouHyPAmu7fJ47qReExlcqHEhLJUey5eHuowSEv9mDtkAyJXysLarO5N3NkT4C4LDoM/aS4RVfB+iBdY4Cu0v0FeAgq9wMyVVRItNbNVq6EVmA3aQe5FYG2G7bIT1L6XxPefcIekQPpUfZhIVdhu2t6MXbbJfD2PI40nIH42A9T1hvPxTys/9NXnX1iZvnWdOucpBldvwLw0WCcQqj244mkpHpxGd/BOqA5p8/XptxhWH3wJiWa2URu4BECJJ/E8= handson@bmklnx-secondary0" >> /home/handson/.ssh/authorized_keys
sudo chown -R handson:handson /home/handson/.ssh

## Install programs
sudo yum update -y
sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
sudo dnf update -y
sudo yum install -y java-11-openjdk.x86_64 nfs-utils unzip lsof bc tar wget
sudo yum install -y unixODBC.x86_64 postgresql-odbc.x86_64 libstdc++.i686 libuuid.i686
sudo dnf install -y htop nmon

## Downloads
# wget https://arte.engpro.totvs.com.br/tec/appserver/harpia/linux/64/next/appserver.tar.gz -O /tmp/appserver.tar.gz
# wget https://arte.engpro.totvs.com.br/tec/dbaccess/linux/64/next/dbaccess.tar.gz -O /tmp/dbaccess.tar.gz
# wget https://arte.engpro.totvs.com.br/tec/dbaccess/linux/64/next/dbapi.tar.gz -O /tmp/dbapi.tar.gz
# wget https://arte.engpro.totvs.com.br/protheus/padrao/next/repositorio/harpia/tttm120.rpo -O /tmp/tttm120.rpo
# wget https://arte.engpro.totvs.com.br/protheus/padrao/next/dicionario/sxs.zip -O /tmp/sxs.zip
# wget https://arte.engpro.totvs.com.br/protheus/padrao/next/dicionario/sdf.zip -O /tmp/sdf.zip
wget https://arte.engpro.totvs.com.br/framework/license/linux/64/published/installer-3.3.1.tar.gz -O /tmp/installer-3.3.1.tar.gz

## COMPARTILHAMENTO DOS DIRETORIOS
sudo chmod -R 777 /totvs/protheus/protheus_data
sudo chmod -R 777 /totvs/arte
sudo chmod -R 777 /totvs/logs

sudo systemctl start nfs-server rpcbind
sudo systemctl enable nfs-server rpcbind

sudo echo "/totvs/protheus/protheus_data 10.0.4.0/24(rw,sync,no_root_squash)" | sudo tee -a /etc/exports
sudo echo "/totvs/arte 10.0.4.0/24(rw,sync,no_root_squash)" | sudo tee -a /etc/exports
sudo echo "/totvs/logs 10.0.4.0/24(rw,sync,no_root_squash)" | sudo tee -a /etc/exports

sudo exportfs -r

## Descompactar os pacotes
# tar -zxvf /tmp/appserver.tar.gz -C /totvs/tec/appserver/
# tar -zxvf /tmp/dbaccess.tar.gz -C /totvs/tec/dbaccess/
# unzip /tmp/sxs.zip -d /totvs/protheus/protheus_data/systemload/
# unzip /tmp/sdf.zip -d /protheus/protheus_data/system/
# mv /tmp/tttm120.rpo /totvs/protheus/apo/tttm120.rpo
sudo tar -zxvf /tmp/installer-3.3.1.tar.gz -C /totvs/licensever/

## CONFIGURA PROTHEUS
sudo unzip /tmp/protheus_bundle_x64-12.1.33-lnx.top-bra.zip -d /

# Desabilita o Firewall
# sudo systemctl disable firewalld
# sudo firewall-cmd --permanent --add-service mountd
# sudo firewall-cmd --permanent --add-service rpc-bind
# sudo firewall-cmd --permanent --add-service nfs
# sudo firewall-cmd --reload

# ## Configura ODBC
# cat <<AUL >> /etc/odbc.ini
# [handson_log]
# Servername=10.174.96.5
# Username=postgres
# Password=Engpro#DBA2020
# Database=handson_log
# Driver=PostgreSQL
# Port=5432
# ReadOnly=0
# MaxLongVarcharSize=2000
# UnknownSizes=2
# UseServerSidePrepare=1
# AUL

sudo sed -i -e "s/WW/$HOSTNAME/g" /totvs/tec/appserver01/appserver.ini
sudo sed -i -e "s/WW/$HOSTNAME/g" /totvs/tec/appserver02/appserver.ini
sudo sed -i -e "s/WW/$HOSTNAME/g" /totvs/tec/appboundserver32/appserver.ini

# echo "
# COMM_PROTOCOL       DISABLED" >> /totvs/tec/appserver01/ctsrvr.cfg
# echo "
# COMM_PROTOCOL       DISABLED" >> /totvs/tec/appserver02/ctsrvr.cfg

# sudo cp /tmp/scripts/totvsdbaccess-sec.sh /etc/init.d/
# sudo cp /tmp/scripts/totvsappsec* /etc/init.d/
# sudo cp /tmp/scripts/totvsappbound32.sh /etc/init.d/
# sudo cp /tmp/scripts/start.sh /etc/init.d/
# sudo cp /tmp/scripts/stop.sh /etc/init.d/
# chmod 777 /etc/init.d/*.sh

# cd /etc/init.d/
# ./start.sh

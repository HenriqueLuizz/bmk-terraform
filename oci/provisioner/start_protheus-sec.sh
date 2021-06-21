#!/usr/bin/bash

## Monta os diretorios
sudo mkdir -p /totvs/protheus/apo
sudo mkdir -p /totvs/protheus/protheus_data
sudo mkdir -p /totvs/tec/appserver
sudo mkdir -p /totvs/tec/dbaccess

sudo mkdir /totvs/arte
sudo mkdir /totvs/logs

sudo echo '3 - start_protheus.sh' | sudo tee -a /tmp/timeline.txt

## Configura usuario Handson
sudo adduser handson
sudo usermod -aG root handson
sudo usermod -aG wheel handson
sudo mkdir -p /home/handson/.ssh
sudo echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDYTgy+GKCOoqwcz3XO23mrD4khasz0cLy8LQFnd3MjSEcZ3pXK/YCDFYqFknao/H4vvexW3gcxKLi/71nAdHwV8YwJr7l1t1l3avdQwO6KdnlfsSvd2X89SWljcq393+f5BleS9ZXnmvdF75lZPS6OHgfdxWktJTxSphudpOMA8iNXJsE2xQijlZ35qizg3gkuCYuD3HDcTXvDXjUZK4bGiAnGEPFef+6zLx431+GQTjigrUCdAYQaWlcxiNq/u/dvouHyPAmu7fJ47qReExlcqHEhLJUey5eHuowSEv9mDtkAyJXysLarO5N3NkT4C4LDoM/aS4RVfB+iBdY4Cu0v0FeAgq9wMyVVRItNbNVq6EVmA3aQe5FYG2G7bIT1L6XxPefcIekQPpUfZhIVdhu2t6MXbbJfD2PI40nIH42A9T1hvPxTys/9NXnX1iZvnWdOucpBldvwLw0WCcQqj244mkpHpxGd/BOqA5p8/XptxhWH3wJiWa2URu4BECJJ/E8= handson@bmklnx-secondary0" >> /home/handson/.ssh/authorized_keys
sudo chown -R handson:handson /home/handson/.ssh

## Install programs
sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo yum update -y
sudo yum install -y java-11-openjdk.x86_64 nfs-utils unzip lsof bc tar wget
sudo yum install -y unixODBC.x86_64 libstdc++.i686 libuuid.i686 libnsl
sudo dnf install -y htop nmon

## Downloads

## Descompactar os pacotes

## CONFIGURA PROTHEUS
sudo unzip -o /tmp/protheus_bundle_x64-12.1.33-lnx-sec.zip -d /

sudo sed -i -e "s/WW/$HOSTNAME/g" /totvs/tec/appserver01/appserver.ini
sudo sed -i -e "s/WW/$HOSTNAME/g" /totvs/tec/appserver02/appserver.ini

## COMPARTILHAMENTO DOS DIRETORIOS
sudo systemctl start nfs-server rpcbind
sudo systemctl enable nfs-server rpcbind

sudo mount 10.0.4.10:/totvs/protheus/protheus_data /totvs/protheus/protheus_data && sudo mount 10.0.4.10:/totvs/arte /totvs/arte && sudo mount 10.0.4.10:/totvs/logs /totvs/logs

sudo echo "10.0.4.10:/totvs/protheus/protheus_data /totvs/protheus/protheus_data nfs nosuid,rw,sync,hard,intr 0 0" >> /etc/fstab
sudo echo "10.0.4.10:/totvs/arte /totvs/arte nfs nosuid,rw,sync,hard,intr 0 0" >> /etc/fstab
sudo echo "10.0.4.10:/totvs/logs /totvs/logs nfs nosuid,rw,sync,hard,intr 0 0" >> /etc/fstab

# Desabilita o Firewall
# sudo systemctl disable firewalld

## Configura ODBC
sudo mkdir -p /opt/oracle/19.11
sudo wget https://download.oracle.com/otn_software/linux/instantclient/1911000/instantclient-basic-linux.x64-19.11.0.0.0dbru.zip -O /tmp/instantclient-basic-linux.x64-19.11.0.0.0dbru.zip
sudo unzip -o /tmp/instantclient-basic-linux.x64-19.11.0.0.0dbru.zip -d /opt/oracle/19.11/
sudo sh -c "echo /opt/oracle/19.11/instantclient_19_11 > /etc/ld.so.conf.d/oracle-instantclient.conf"
sudo ldconfig

# sudo mkdir -p /opt/oracle/19.11/instantclient_19_11
echo "export TNS_ADMIN=/opt/oracle/19.11/instantclient_19_11" | sudo tee -a ~/.bash_profile
sudo wget https://download.oracle.com/otn_software/linux/instantclient/1911000/oracle-instantclient19.11-basic-19.11.0.0.0-1.x86_64.rpm -O /tmp/oracle-instantclient19.11-basic-19.11.0.0.0-1.x86_64.rpm
sudo rpm -i /tmp/oracle-instantclient19.11-basic-19.11.0.0.0-1.x86_64.rpm

sudo cp -f /tmp/tnsnames.ora /opt/oracle/19.11/instantclient_19_11/tnsnames.ora

sudo cp -f /tmp/totvs*.sh /etc/init.d/
sudo cp -f /tmp/start.sh /etc/init.d/
sudo cp -f /tmp/stop.sh /etc/init.d/

sudo chmod 777 /etc/init.d/*.sh

sudo sh /etc/init.d/start.sh
echo "Finalizado"


# for i in {100..119}; do echo "Servidor - 10.0.4.${i}" && ssh -i /root/.ssh/chave_cloud_01 opc@10.0.4.${i} "cd /etc/init.d/ && sudo /bin/bash ./stop.sh"; done
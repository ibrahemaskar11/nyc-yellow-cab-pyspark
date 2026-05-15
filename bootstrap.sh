#!/usr/bin/env bash

apt-get update
apt-get install -y python3 default-jre # python3-pip
# a simple two-panel file commander
apt-get install -y mc
# uncomment one of the following for graphical desktops
# NOTE: the graphical desktop is accessible through
# the main VirtualBox window (Show button)
#
# - minimal: wm & graphical server
# apt-get install -y icewm xinit xterm python3-tk
#
# - minimal desktop env: lxqt
# apt-get install -y xinit lxqt
#
# The recommended alternative to a graphical desktop
# is: Tigervnc, the kitty terminal emulator,
# the emacs editor and fluxbox as window manager.
# (We are also installing a couple of other popular WMs for convenience.)
# Remember to install the Tigervnc client in the host OS!
apt-get install -y tigervnc-standalone-server kitty emacs fluxbox fvwm icewm
if ! grep ":10=vagrant" /etc/tigervnc/vncserver.users; then
  echo ":10=vagrant" >> /etc/tigervnc/vncserver.users
fi
# set a password for Tigervnc
mkdir /home/vagrant/.vnc
if ! [ -a /home/vagrant/.vnc/passwd ]; then 
  pass=$'bda2024\nbda2024\nn\n'
  echo "$pass" | tigervncpasswd /home/vagrant/.vnc/passwd
fi
# Create the configuration file for Tigervnc:
# Configure FVWM as WM, set the geometry of the virtual desktop,
# and confine connections to the guest OS. (We'll use a ssh tunnel
# to connect from the host OS.) 
# To launch another WM, 
# edit /home/vagrant/.vnc/config to change the session value
if ! [ -a /home/vagrant/.vnc/config ]; then
  echo session=icewm >> /home/vagrant/.vnc/config
  echo geometry=1920x1080 >> /home/vagrant/.vnc/config
  echo localhost >> /home/vagrant/.vnc/config
fi  
# change the ownership of the config and passwd file to user vagrant
chown -R vagrant.vagrant /home/vagrant/.vnc
# start the VNC server
if ! systemctl is-enabled tigervncserver@:10.service; then
  systemctl enable tigervncserver@:10.service
fi
systemctl restart tigervncserver@:10.service
# cd to the shared  directory
# *** NOTE: we must comment it out on MacOS, as of 2024-10-25
# as there is no /vagrant shared folder out-of-the-box
cd /vagrant
# python packages
pip3 install matplotlib pandas seaborn jupyter
pip3 install jupyter
# remove previous Spark version
rm -rf /usr/local/spark-3.0.0-preview2-bin-hadoop2.7
if ! [ -d /usr/local/spark-3.2.0-bin-hadoop3.2 ]; then
# current link as of 2021-11-17:
  wget https://dlcdn.apache.org/spark/spark-3.5.3/spark-3.5.3-bin-hadoop3.tgz
# wget https://www.apache.org/dyn/closer.lua/spark/spark-3.2.0/spark-3.2.0-bin-hadoop3.2.tgz
  tar -C /usr/local -xvzf spark-3.5.3-bin-hadoop3.tgz
  rm spark-3.5.3-bin-hadoop3.tgz
fi

if ! [ -d /usr/local/hadoop-3.4.0 ]; then
  wget https://dlcdn.apache.org/hadoop/common/hadoop-3.4.0/hadoop-3.4.0.tar.gz
  tar -C /usr/local -xvzf hadoop-3.4.0.tar.gz
  chown --recursive ubuntu:ubuntu /usr/local/hadoop-3.4.0
  rm hadoop-3.4.0.tar.gz
fi

if ! grep "export HADOOP_INSTALL=/usr/local/hadoop-3.4.0" /home/vagrant/.bashrc; then
  echo "export HADOOP_INSTALL=/usr/local/hadoop-3.4.0" >>  /home/vagrant/.bashrc
fi
if ! grep "export HADOOP_HOME=/usr/local/hadoop-3.4.0" /home/vagrant/.bashrc; then
  echo "export HADOOP_HOME=/usr/local/hadoop-3.4.0" >>  /home/vagrant/.bashrc
fi
if ! grep "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/" /home/vagrant/.bashrc; then
  echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/" >>  /home/vagrant/.bashrc
fi
if ! grep "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/" /usr/local/hadoop-3.4.0/etc/hadoop/hadoop-env.sh; then
  echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/" >>  /usr/local/hadoop-3.4.0/etc/hadoop/hadoop-env.sh
fi
if ! grep "export HADOOP_INSTALL=/usr/local/hadoop-3.4.0" ~/.bashrc; then
  echo "export HADOOP_INSTALL=/usr/local/hadoop-3.4.0" >>  ~/.bashrc
fi
if ! grep "export PYSPARK_PYTHON=/usr/bin/python3" /home/vagrant/.bashrc; then
  echo "export PYSPARK_PYTHON=/usr/bin/python3" >>  /home/vagrant/.bashrc
fi
if ! grep "export PYSPARK_DRIVER_PYTHON=jupyter" /home/vagrant/.bashrc; then
  echo "export PYSPARK_DRIVER_PYTHON=jupyter" >>  /home/vagrant/.bashrc
fi
if ! grep "export PYSPARK_DRIVER_PYTHON_OPTS=notebook" /home/vagrant/.bashrc; then
  echo "export PYSPARK_DRIVER_PYTHON_OPTS=notebook" >>  /home/vagrant/.bashrc
fi
# switch to user ubuntu
sudo -i -u ubuntu bash << EOF
echo "Switched to user ubuntu"
if ! ( echo exit | ssh localhost ) ; then
  echo "Creating keys and authorizing"
  ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
  chmod 0600 ~/.ssh/authorized_keys
fi
EOF
echo "Exited user ubuntu"

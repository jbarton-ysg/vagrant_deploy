# vagrant_deploy
vagrant code deploy script

This script uses this Vagrant box
https://app.vagrantup.com/emessiha/boxes/ubuntu64-java

install virtualbox and vagrant if not installed yet 
create a folder in your home directory vagrantJava

- cd vagrantJava 
- vagrant init emessiha/ubuntu64-java
- vagrant up

box should be up at localhost:8080
- vagrant halt

update VagrantFIle to match
https://github.com/jbarton-ysg/vagrant_deploy/blob/master/Vagrantfile

windows users will need to add synked folder option NFS
https://www.vagrantup.com/docs/synced-folders/nfs.html 

- vagrant up --provision

 setup vagrant ssh into vagrant box 
  - vagrant ssh
  - mv  /opt/tomcat/webapps/ROOT /opt/tomcat/webapps/tcroot
  - mysql -u remote -p password
  - create database myyesgo;
  - create database myyesgo_security;
  - create database myyesgo_integration;
  - exit
  
 run deploy script
 - cd /home/ubuntu/code/vagrant_deploy
 - ./myyesgo_vagrant.sh
  
site will be up at http://192.168.33.10:8080/ on success

if encouter errors see
- cat /opt/tomcat/logs/catalina.out
  


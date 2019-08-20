#!/bin/bash


sh /opt/tomcat/bin/shutdown.sh

# cd to root of app
cd ../myyesgo
pwd
git checkout code_deploy


# run maven build
mvn -B verify

mv myyesgo-api/target/myyesgo-api-1.0.0-SNAPSHOT.war myyesgo-api/target/myyesgo-api.war
mv myyesgo-security/target/security-rest-api-1.0.0-SNAPSHOT.war myyesgo-security/target/security-rest-api.war
mv myyesgo-integration/target/myyesgo-integration-1.0.0-SNAPSHOT.war myyesgo-integration/target/myyesgo-integration.war

sudo rm -rf /opt/tomcat/webapps/myyesgo-api
sudo rm -rf /opt/tomcat/webapps/security-rest-api
sudo rm -rf /opt/tomcat/webapps/myyesgo-integration

sudo cp myyesgo-api/target/myyesgo-api.war /opt/tomcat/webapps/
sudo cp myyesgo-security/target/security-rest-api.war /opt/tomcat/webapps/
sudo cp myyesgo-integration/target/myyesgo-integration.war /opt/tomcat/webapps/

cd myyesgo-web
rm -rf node_modules
rm -rf package-lock.json
npm install
npm run build:vagrant
rm -rf ROOT
mv build ROOT

rm -rf /opt/tomcat/webapps/ROOT

cp -r ROOT /opt/tomcat/webapps/

sh /opt/tomcat/bin/startup.sh

sleep 20

sh /opt/tomcat/bin/shutdown.sh

#rm -rf /opt/tomcat/webapps/*.war
rm -rf /opt/tomcat/logs/*

cd ../

sudo cp -r deployment/properties/vagrant/lib/*.properties /opt/tomcat/lib
sudo cp -r deployment/properties/vagrant/myyesgo-api/WEB-INF/classes/*.properties /opt/tomcat/webapps/myyesgo-api/WEB-INF/classes/
sudo cp -r deployment/properties/vagrant/security-rest-api/WEB-INF/classes/*.properties /opt/tomcat/webapps/security-rest-api/WEB-INF/classes/
sudo cp -r deployment/properties/vagrant/myyesgo-integration/WEB-INF/classes/* /opt/tomcat/webapps/myyesgo-integration/WEB-INF/classes/


sh /opt/tomcat/bin/startup.sh

#update database
cd myyesgo-database

# create databses manually for kno

#mysql --user="remote" --password="password" CREATE DATABASE "myyesgo;"
#mysql --user="remote" --password="password" CREATE DATABASE "myyesgo_security;"
#mysql --user="remote" --password="password" CREATE DATABASE "myyesgo_integration;"

mysql -u remote -p"password" myyesgo < Scripts/myyesgo.sql
mysql -u remote -p"password" myyesgo_security < Scripts/myyesgo_security.sql
mysql -u remote -p"password" myyesgo_integration < Scripts/myyesgo_integration.sql
mysql -u remote -p"password" myyesgo < Procedures/spGetHandOff.sql

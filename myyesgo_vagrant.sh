#!/bin/bash


sh /opt/tomcat/bin/shutdown.sh

# cd to root of app
cd ../myyesgo
pwd
# run maven build
mvn -B verify

mv myyesgo-api/target/myyesgo-api-1.0.0-SNAPSHOT.war /opt/tomcat/webapps/myyesgo-api.war
mv myyesgo-security/target/security-rest-api-1.0.0-SNAPSHOT.war /opt/tomcat/webapps//security-rest-api.war
mv myyesgo-integration/target/myyesgo-integration-1.0.0-SNAPSHOT.war /opt/tomcat/webapps/myyesgo-integration.war

cd myyesgo-web
rm -rf node_modules
rm -rf package-lock.json
npm install
npm run build:vagrant
mv build ROOT
cp -r ROOT /webapps



sh /opt/tomcat/bin/startup.sh

sleep 20

sh /opt/tomcat/bin/shutdown.sh

rm -rf /opt/tomcat/webapps/*.war
rm -rf /opt/tomcat/logs/*

sh /opt/tomcat/bin/startup.sh

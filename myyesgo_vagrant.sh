#!/bin/bash


sh /opt/tomcat/bin/shutdown.sh

# cd to root of app
cd ../myyesgo
pwd
# run maven build
mvn -B verify

mv myyesgo-api/target/myyesgo-api-1.0.0-SNAPSHOT.war myyesgo-api.war
mv myyesgo-security/target/security-rest-api-1.0.0-SNAPSHOT.war security-rest-api.war
mv myyesgo-integration/target/myyesgo-integration-1.0.0-SNAPSHOT.war myyesgo-integration.war

sudo cp myyesgo-api/target/myyesgo-api.war /opt/tomcat/webapps/
sudo cp myyesgo-security/target/security-rest-api.war /opt/tomcat/webapps/
sudo cp myyesgo-integration/target/myyesgo-integration.war /opt/tomcat/webapps/

cd myyesgo-web
rm -rf node_modules
rm -rf package-lock.json
npm install
npm run build:vagrant
mv build ROOT
cp -r ROOT webapps/

sh /opt/tomcat/bin/startup.sh

sleep 20

sh /opt/tomcat/bin/shutdown.sh

rm -rf /opt/tomcat/webapps/*.war
rm -rf /opt/tomcat/logs/*

sh /opt/tomcat/bin/startup.sh

#update database
cd ../myyesgo-database
mysql --user="remote" --password="password" --execute="DROP DATABASE myyesgo; CREATE DATABASE myyesgo;"
mysql --user="remote" --password="password" --execute="DROP DATABASE myyesgo_security; CREATE DATABASE myyesgo_security;"
mysql --user="remote" --password="password" --execute="DROP DATABASE myyesgo_integration; CREATE DATABASE myyesgo_integration;"

mysql -u remote -p"secret" myyesgo < Scripts/myyesgo.sql
mysql -u remote -p"secret" myyesgo_security < Scripts/myyesgo_security.sql
mysql -u remote -p"secret" myyesgo_integration < Scripts/myyesgo_integration.sql
mysql -u remote -p"secret" myyesgo < Procedures/spGetHandOff.sql

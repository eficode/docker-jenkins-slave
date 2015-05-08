#!/bin/bash

if [ ! -f /var/jenkins_home/.ssh/id_rsa ]; then
	ssh-keygen -N '' -f /var/jenkins_home/.ssh/id_rsa
fi

echo 'Connect with confiuration:'
echo ' - Master Host:    ' $MASTER_HOST
echo ' - Master Port:    ' $MASTER_PORT
echo ' - Slave Name:     ' $SLAVE_NAME
echo ' - Secret:         ' $JENKINS_SECRET
echo ' - Use SSL:        ' $JENKINS_SSL

PROTOCOL="http"
if [ "$JENKINS_SSL" == "true" ]; then
	PROTOCOL="https"
fi

SECRET=""
if [ "$JENKINS_SECRET" != "" ]; then
	SECRET="-secret $JENKINS_SECRET"
fi

if [ ! -f ~/slave.jar ]; then
	  echo wget -O /var/jenkins_home/slave.jar $PROTOCOL://$MASTER_HOST:$MASTER_PORT/jnlpJars/slave.jar --no-check-certificate
		wget -O ~/slave.jar $PROTOCOL://$MASTER_HOST:$MASTER_PORT/jnlpJars/slave.jar --no-check-certificate
fi

if [ -n "$JENKINS_SECRET" ]; then
	echo 	exec java -jar /var/jenkins_home/slave.jar -jnlpUrl $PROTOCOL://$MASTER_HOST:$MASTER_PORT/computer/$SLAVE_NAME/slave-agent.jnlp $SECRET -noCertificateCheck
	exec java -jar ~/slave.jar -jnlpUrl $PROTOCOL://$MASTER_HOST:$MASTER_PORT/computer/$SLAVE_NAME/slave-agent.jnlp $SECRET -noCertificateCheck
fi

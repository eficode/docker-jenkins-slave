#!/bin/bash

if [ ! -f /var/jenkins_home/.ssh/id_rsa ]; then
	exec ssh-keygen -N '' -f /var/jenkins_home/.ssh/id_rsa
fi

if [ $JENKINS_SSL == "true"]
	if [ ! -f ~/slave.jar ]; then
			exec wget -O ~/slave.jar https://$MASTER_HOST:$MASTER_PORT/jnlpJars/slave.jar --no-check-certificate
	fi
	if [ -n "$JENKINS_SECRET" ]; then
		exec java -jar ~/slave.jar -jnlpUrl https://$MASTER_HOST:$MASTER_PORT/computer/$SLAVE_NAME/slave-agent.jnlp -secret $JENKINS_SECRET -noCertificateCheck
	else
		exec java -jar ~/slave.jar -jnlpUrl https://$MASTER_HOST:$MASTER_PORT/computer/$SLAVE_NAME/slave-agent.jnlp
	fi
else
	if [ ! -f ~/slave.jar ]; then
			exec wget -O ~/slave.jar http://$MASTER_HOST:$MASTER_PORT/jnlpJars/slave.jar
	fi
	if [ -n "$JENKINS_SECRET" ]; then
		exec java -jar ~/slave.jar -jnlpUrl http://$MASTER_HOST:$MASTER_PORT/computer/$SLAVE_NAME/slave-agent.jnlp -secret $JENKINS_SECRET -noCertificateCheck
	else
		exec java -jar ~/slave.jar -jnlpUrl http://$MASTER_HOST:$MASTER_PORT/computer/$SLAVE_NAME/slave-agent.jnlp
	fi
fi

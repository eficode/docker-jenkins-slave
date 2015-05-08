FROM ubuntu

USER root

RUN apt-get update
RUN apt-get install -y wget git curl zip

# Install Oracle's Java 8
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
RUN apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java8-installer
RUN update-alternatives --set java /usr/lib/jvm/java-8-oracle/jre/bin/java

# Install Robot Framework with Selenium
RUN apt-get install -y python-pip
RUN pip install robotframework
RUN pip install robotframework-selenium2library

# Install PhantomJS
RUN apt-get install -y phantomjs

# Install JMeter
RUN apt-get install -y jmeter

# Install Multi Mechanize
RUN apt-get install -y python-matplotlib
RUN pip install multi-mechanize

# Install Graphviz
RUN apt-get install -y graphviz

# Install NodeJS and npm
RUN apt-get install -y nodejs npm nodejs-legacy

# Clean Up apt
RUN apt-get clean

# CREATE Jenkins User
RUN useradd -d "/var/jenkins_home" -u 1000 -m -s /bin/bash jenkins
VOLUME /var/jenkins_home

# Set Environment for connection
USER jenkins
ENV LANG C.UTF-8
ENV MASTER_HOST localhost
ENV MASTER_PORT 80
ENV SLAVE_NAME slave
ENV JENKINS_SSL false
COPY slave.sh /usr/local/bin/slave.sh
WORKDIR /var/jenkins_home

# Start Slave
ENTRYPOINT exec /usr/local/bin/slave.sh

FROM java:openjdk-8u40-jdk

USER root
RUN apt-get update
RUN apt-get install -y wget git curl zip

# Install Robot Framework with Selenium
RUN apt-get install -y python-pip
RUN pip install robotframework
RUN pip install robotframework-selenium2library

# Install PhantomJS
RUN wget -O /opt/phantomjs-1.9.8-linux-x86_64.tar.bz2 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2
WORKDIR /opt
RUN tar xvfj phantomjs-1.9.8-linux-x86_64.tar.bz2
RUN ln -s phantomjs-1.9.8-linux-x86_64 phantomjs
RUN apt-get install -y fontconfig libfreetype6
RUN rm phantomjs-1.9.8-linux-x86_64.tar.bz2
ENV PATH /opt/phantomjs/bin:$PATH

# Install JMeter
RUN apt-get install -y jmeter

# Install Multi Mechanize
RUN apt-get install -y python-matplotlib
RUN pip install multi-mechanize

# Install Graphviz
RUN apt-get install -y graphviz

# Clean Up apt
RUN rm -rf /var/lib/apt/lists/*

# CREATE Jenkins User
ENV JENKINS_HOME /var/jenkins_home
RUN useradd -d "$JENKINS_HOME" -u 1000 -m -s /bin/bash jenkins
VOLUME /var/jenkins_home

# Set Environment for connection
USER jenkins
ENV MASTER_HOST localhost
ENV MASTER_PORT 80
ENV SLAVE_NAME slave
COPY slave.sh /usr/local/bin/slave.sh
WORKDIR /var/jenkins_home

# Start Slave
ENTRYPOINT ["/usr/local/bin/slave.sh"]

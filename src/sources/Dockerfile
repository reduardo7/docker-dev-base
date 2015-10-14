FROM ubuntu:latest

# Info
  MAINTAINER Eduardo Daniel Cuomo
  LABEL version="1.0"
  LABEL description="Docker Development Base - Test"

# Variables
  ENV PATH_FILES docker-files
  ENV PATH_HOME /home

# Software
  RUN apt-get -y update
  RUN apt-get install -y git vim apache2 mysql-server php5
  RUN apt-get install -y phpmyadmin

    # Apache
      # Fix: Could not reliably determine the server's fully qualified domain name, using X.X.X.X. Set the 'ServerName' directive globally to suppress this message
      RUN echo >> /etc/apache2/apache2.conf
      RUN echo ServerName localhost >> /etc/apache2/apache2.conf

# init.sh
  WORKDIR $PATH_HOME
  COPY $PATH_FILES/init.sh $PATH_HOME/init.sh
  RUN chmod a+x $PATH_HOME/init.sh
  CMD $PATH_HOME/init.sh

# Ports
  #EXPOSE 80

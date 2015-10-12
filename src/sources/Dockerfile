FROM ubuntu:latest
MAINTAINER Eduardo Daniel Cuomo
LABEL version="1.0"
LABEL description="Test"

#ENV PATH_RES resources
#ENV PATH_HOME $PATH_RES/home

WORKDIR /home/

RUN apt-get -y update
RUN apt-get install -y git vim apache2 mysql-server php5
RUN apt-get install -y phpmyadmin

# bash-completion
RUN echo "" >> /etc/bash.bashrc
RUN echo "if ! shopt -oq posix; then" >> /etc/bash.bashrc
RUN echo "  if [ -f /usr/share/bash-completion/bash_completion ]; then" >> /etc/bash.bashrc
RUN echo "    . /usr/share/bash-completion/bash_completion" >> /etc/bash.bashrc
RUN echo "  elif [ -f /etc/bash_completion ]; then" >> /etc/bash.bashrc
RUN echo "    . /etc/bash_completion" >> /etc/bash.bashrc
RUN echo "  fi" >> /etc/bash.bashrc
RUN echo "fi" >> /etc/bash.bashrc

# init.sh
COPY init.sh /home/init.sh
RUN chmod a+x /home/init.sh

#EXPOSE 80

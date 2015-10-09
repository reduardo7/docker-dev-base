FROM ubuntu:latest

RUN apt-get -y update
RUN apt-get install -y git vim

# bash-completion
RUN echo "" >> /etc/bash.bashrc
RUN echo "if ! shopt -oq posix; then" >> /etc/bash.bashrc
RUN echo "  if [ -f /usr/share/bash-completion/bash_completion ]; then" >> /etc/bash.bashrc
RUN echo "    . /usr/share/bash-completion/bash_completion" >> /etc/bash.bashrc
RUN echo "  elif [ -f /etc/bash_completion ]; then" >> /etc/bash.bashrc
RUN echo "    . /etc/bash_completion" >> /etc/bash.bashrc
RUN echo "  fi" >> /etc/bash.bashrc
RUN echo "fi" >> /etc/bash.bashrc

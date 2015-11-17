FROM ubuntu:latest

# Info
	MAINTAINER Eduardo Daniel Cuomo
	LABEL version="1.0"
	LABEL description="Docker Development Environment Base - Test"

# Variables
	ENV PATH_FILES docker-files
	ENV PATH_HOME /home
	#ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
	ENV JAVA_HOME /usr/lib/jvm/default-java

# Install Software
	RUN apt-get -y update
	RUN apt-get install -y \
		git vim curl wget zsh unzip \
		mysql-server mysql-client \
		apache2 \
		php5 php5-mcrypt \
		mailutils sendmail \
		openjdk-7-jdk
	RUN apt-get install -y phpmyadmin
	# FakeSMTP
		RUN \
			wget -q http://nilhcem.github.com/FakeSMTP/downloads/fakeSMTP-latest.zip && \
			unzip fakeSMTP-latest.zip -d /opt && \
			rm fakeSMTP-latest.zip && \
			mv -v /opt/fakeSMTP-*.jar /opt/fakeSMTP.jar

# Configure Basic Software
	# oh-my-zsh | https://github.com/robbyrussell/oh-my-zsh
		RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
	# Java JDK
		# JAVA_HOME
			ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
	# Apache2
		EXPOSE 80
		# Fix: Could not reliably determine the server's fully qualified domain name, using X.X.X.X. Set the 'ServerName' directive globally to suppress this message
			RUN echo >> /etc/apache2/apache2.conf
			RUN echo ServerName localhost >> /etc/apache2/apache2.conf
	# PHP
		# Mods
			RUN php5enmod mcrypt
	# phpMyAdmin
		RUN sed -i "s#// \$cfg\['Servers'\]\[\$i\]\['AllowNoPassword'\] = TRUE;#\$cfg\['Servers'\]\[\$i\]\['AllowNoPassword'\] = TRUE;#g" /etc/phpmyadmin/config.inc.php
		# Apache2 Conf
			RUN ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
			RUN ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
			RUN a2enconf phpmyadmin.conf
	# FakeSMTP
		#EXPOSE 25
		RUN echo "127.0.0.1 $(cat /etc/hostname)" > /etc/hosts

# Copy Files
	COPY $PATH_FILES/* $PATH_HOME/

# Configure Software
	# Java Home
		RUN echo "export JAVA_HOME=$JAVA_HOME" >> $PATH_HOME/.zshrc
	# oh-my-zsh | https://github.com/robbyrussell/oh-my-zsh
		RUN cp -r ~/.oh-my-zsh $PATH_HOME/.oh-my-zsh
		RUN cp -v $PATH_HOME/.zshrc /root/.zshrc

# Init
	WORKDIR $PATH_HOME
		RUN bash build.sh
		RUN rm build.sh
	ENV HOME $PATH_HOME
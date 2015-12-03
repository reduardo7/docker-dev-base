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
		git vim nano curl wget unzip zsh ssh \
		mysql-server mysql-client \
		apache2 \
		php5 php5-mcrypt php5-gd php5-curl php5-xdebug \
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
		RUN mkdir -p ~/.oh-my-zsh/plugins/docker/
		RUN curl -fLo ~/.oh-my-zsh/plugins/docker/_docker https://raw.github.com/felixr/docker-zsh-completion/master/_docker
	# Java JDK
		# JAVA_HOME
			ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
	# MySQL
	# Connect: mysql -u root -h 127.0.0.1 -P 3307
		# Listenint all
			RUN sed -i '/^bind-address\s*=/c\#bind-address           = 127.0.0.1' /etc/mysql/my.cnf
		# Init DB
			RUN service mysql start \
				# ROOT
				&& mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'"
	# Apache2
		# Fix: Could not reliably determine the server's fully qualified domain name, using X.X.X.X. Set the 'ServerName' directive globally to suppress this message
			RUN echo >> /etc/apache2/apache2.conf
			RUN echo ServerName localhost >> /etc/apache2/apache2.conf
		# MODS
			RUN a2enmod headers
			RUN a2enmod expires
			RUN a2enmod rewrite
	# PHP
		# Mods
			RUN php5enmod mcrypt
		# XDEBUG
			RUN echo '[Xdebug]' >> /etc/php5/apache2/php.ini
			RUN echo 'zend_extension="/usr/lib/php5/20121212/xdebug.so"' >> /etc/php5/apache2/php.ini
			RUN echo 'xdebug.remote_enable=1' >> /etc/php5/apache2/php.ini
			RUN echo 'xdebug.remote_port="9000"' >> /etc/php5/apache2/php.ini
			RUN echo 'xdebug.profiler_enable=1' >> /etc/php5/apache2/php.ini
			RUN echo 'xdebug.profiler_output_dir="/tmp/xdebug.log"' >> /etc/php5/apache2/php.ini
			RUN echo 'xdebug.remote_host=172.17.0.1' >> /etc/php5/apache2/php.ini
	# phpMyAdmin
		RUN sed -i "s#// \$cfg\['Servers'\]\[\$i\]\['AllowNoPassword'\] = TRUE;#\$cfg\['Servers'\]\[\$i\]\['AllowNoPassword'\] = TRUE;#g" /etc/phpmyadmin/config.inc.php
		# Apache2 Conf
			RUN ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
			RUN ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
			RUN a2enconf phpmyadmin.conf
		# Session
			RUN echo "# Session Time (8 hours)" >> /etc/phpmyadmin/config.inc.php
			RUN echo "$sessionDuration = 60 * 60 * 8; // 60 * 60 * 24 * 7 = one week"etc/phpmyadmin/config.inc.php
			RUN echo "ini_set('session.gc_maxlifetime', $sessionDuration);" >> /etc/phpmyadmin/config.inc.php
			RUN echo "$cfg['LoginCookieValidity'] = $sessionDuration;" >> /etc/phpmyadmin/config.inc.php

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
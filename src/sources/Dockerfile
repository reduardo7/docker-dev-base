FROM phusion/baseimage:latest
CMD ["/sbin/my_init"]

# Info
	MAINTAINER Eduardo Daniel Cuomo
	LABEL version="1.0"
	LABEL description="Docker Development Environment Base - Test"

# Variables
	ENV PATH_FILES docker-files
	ENV PATH_HOME /home
	ENV JAVA_HOME /usr/lib/jvm/default-java
	ENV MYSQL_ROOT_PASS="root"

# Install Software
	# Configs
		# MySQL
			RUN echo "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASS" | debconf-set-selections
			RUN echo "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASS" | debconf-set-selections
		# Java
			RUN echo "debconf shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
			RUN echo "debconf shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections
		# phpMyAdmin
			RUN echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
			RUN echo "phpmyadmin phpmyadmin/app-password-confirm password $MYSQL_ROOT_PASS" | debconf-set-selections
			RUN echo "phpmyadmin phpmyadmin/mysql/admin-pass password $MYSQL_ROOT_PASS" | debconf-set-selections
			RUN echo "phpmyadmin phpmyadmin/mysql/app-pass password $MYSQL_ROOT_PASS" | debconf-set-selections
			RUN echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
	# Repos
		RUN add-apt-repository -y ppa:webupd8team/java
		RUN add-apt-repository -y ppa:pdoes/ppa
		RUN add-apt-repository -y ppa:olivier-berten/misc
	# Update
		RUN apt-get -y update
	# Install
		RUN apt-get install -y \
			git \
			vim nano curl wget unzip zsh \
			mysql-server mysql-client mysql-common \
			apache2 \
			php5 php5-mcrypt php5-gd php5-curl php5-xdebug \
			mailutils sendmail \
			#openjdk-7-jdk
			oracle-java7-installer
		# phpMyAdmin
			RUN apt-get install -y phpmyadmin
		# FakeSMTP
			RUN wget -q http://nilhcem.github.com/FakeSMTP/downloads/fakeSMTP-latest.zip
			RUN unzip fakeSMTP-latest.zip -d /opt
			RUN rm -vf fakeSMTP-latest.zip
			RUN mv -vf /opt/fakeSMTP-*.jar /opt/fakeSMTP.jar

# Configure Basic Software
	# oh-my-zsh | https://github.com/robbyrussell/oh-my-zsh
		RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
		RUN mkdir -p ~/.oh-my-zsh/plugins/docker/
		RUN curl -fLo ~/.oh-my-zsh/plugins/docker/_docker https://raw.github.com/felixr/docker-zsh-completion/master/_docker
	# Java JDK
		# JAVA_HOME
			#ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
	# MySQL
	# Connect: mysql -u root -h 127.0.0.1 -P 3307
		# Listenint all
			RUN sed -i '/^bind-address\s*=/c\#bind-address           = 127.0.0.1' /etc/mysql/my.cnf
		# Init DB
			RUN service mysql start && \
				# ROOT
				mysql -uroot -p${MYSQL_ROOT_PASS} -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'"
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
			RUN a2enconf phpmyadmin.conf
		# Session
			RUN echo "# Session Time (8 hours)" >> /etc/phpmyadmin/config.inc.php
			RUN echo "\$sessionDuration = 60 * 60 * 8; // 60 * 60 * 24 * 7 = one week" >> /etc/phpmyadmin/config.inc.php
			RUN echo "ini_set('session.gc_maxlifetime', \$sessionDuration);" >> /etc/phpmyadmin/config.inc.php
			RUN echo "\$cfg['LoginCookieValidity'] = \$sessionDuration;" >> /etc/phpmyadmin/config.inc.php

# Copy Files
	WORKDIR $PATH_HOME
	COPY $PATH_FILES/* $PATH_HOME/
	RUN echo >> $PATH_HOME/.bashrc

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

# Clean up APT when done.
RUN apt-get autoremove -y
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp

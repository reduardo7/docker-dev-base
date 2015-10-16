FROM ubuntu:latest

# Info
	MAINTAINER Eduardo Daniel Cuomo
	LABEL version="1.0"
	LABEL description="Docker Development Base - Test"

# Variables
	ENV PATH_FILES docker-files
	ENV PATH_HOME /home

# Set password to 'admin'
#	RUN printf admin\\nadmin\\n | passwd

# Install Software
	RUN apt-get -y update
	# Utils
		RUN apt-get install -y git vim curl wget
	# MySQL
		RUN apt-get install -y mysql-server mysql-client
	# Apache2
		RUN apt-get install -y apache2
		# Fix: Could not reliably determine the server's fully qualified domain name, using X.X.X.X. Set the 'ServerName' directive globally to suppress this message
			RUN echo >> /etc/apache2/apache2.conf
			RUN echo ServerName localhost >> /etc/apache2/apache2.conf
	# PHP
		RUN apt-get install -y php5 php5-mcrypt
		# Mods
			RUN php5enmod mcrypt
	# phpMyAdmin
		RUN apt-get install -y phpmyadmin
		RUN sed -i "s#// \$cfg\['Servers'\]\[\$i\]\['AllowNoPassword'\] = TRUE;#\$cfg\['Servers'\]\[\$i\]\['AllowNoPassword'\] = TRUE;#g" /etc/phpmyadmin/config.inc.php
		# Apache2 Conf
			RUN ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
			RUN ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
			RUN a2enconf phpmyadmin.conf
	# oh-my-zsh | https://github.com/robbyrussell/oh-my-zsh
		RUN apt-get install -y zsh
		RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
		COPY $PATH_FILES/zshrc /root/.zshrc

# WorkDir
	WORKDIR $PATH_HOME

# On Start | init.sh
	COPY $PATH_FILES/init.sh $PATH_HOME/init.sh
	RUN chmod a+x $PATH_HOME/init.sh
	CMD $PATH_HOME/init.sh

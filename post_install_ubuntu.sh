#!/bin/sh

DIR_BASE=/media/DADOS/Softwares/ubuntu;
DIR_PKG=$DIR_BASE/pacotes;

###
# Verifica se usuario root executa o script
##
check_root() {
	if [ "$(id -u)" != "0" ]; then
		echo "Este script deve ser executado apenas por root" 1>&2
		exit 1;
	fi
}

###
# Instala vim
# Requer root
##
install_vim() {
	sudo apt-get install vim;
	cp /usr/share/vim/vim73/vimrc_example.vim /home/anderson/.vimrc;
}

###
# Instala ssh
# Requer root
##
install_ssh() {
	sudo apt-get install ssh;
}

###
# Instala dropbox
# Requer root
# Requer restart unity
##
install_dropbox() {
	sudo dpkg -i $DIR_PKG/dropbox_1.4.0_i386.deb;
}

###
# Instala skype
# Requer root
##
install_skype() {
	sudo dpkg -i $DIR_PKG/skype-ubuntu_2.2.0.35-1_i386.deb;
}

###
# Instala team viewer
# Requer root
##
install_teamviewer() {
	sudo dpkg -i $DIR_PKG/teamviewer_linux.deb;
}

###
# Instala virtualbox
# Requer root
##
install_virtualbox() {
	sudo dpkg -i $DIR_PKG/virtualbox-4.1_4.1.14-77440~Ubuntu~oneiric_i386.deb;
}

###
# Instala chrome e plugin
# Requer root
##
install_chrome() {
	sudo dpkg -i $DIR_PKG/google-chrome-stable_current_i386.deb;
	sudo dpkg -i $DIR_PKG/google-talkplugin_current_i386.deb;
}

###
# Altera a posicao dos butoes minimizar, maximizar e fechar das janelas
##
change_buttons_position() {
	gconftool-2 --type string --set /apps/metacity/general/button_layout menu:minimize,maximize,close;
}

###
# Mostra os icones de menus
##
show_menu_icons() {
	gsettings set org.gnome.desktop.interface menus-have-icons true
}

###
# Instala noip
# Requer root
##
install_noip() {
	ARQUIVO=noip-duc-linux.tar.gz;
	sudo cp $DIR_BASE/$ARQUIVO /usr/local;
	cd /usr/local;
	sudo tar -xvzf $ARQUIVO;
	sudo rm -f $ARQUIVO;
	sudo mv noip-2.1.9-1 noip;
	cd noip;
	sudo make;
	sudo make install;
	cd ..;
	sudo chown -R anderson.anderson noip;
	NOIP_FILE=/etc/init.d/noip;
	sudo echo "#! /bin/sh" >> $NOIP_FILE;
        sudo echo "case \"\$1\" in" >> $NOIP_FILE;
        sudo echo "    start)" >> $NOIP_FILE;
        sudo echo "        echo \"Starting noip2.\"" >> $NOIP_FILE;
        sudo echo "        /usr/local/bin/noip2" >> $NOIP_FILE;
        sudo echo "    ;;" >> $NOIP_FILE;
        sudo echo "    stop)" >> $NOIP_FILE;
        sudo echo "        echo -n \"Shutting down noip2.\"" >> $NOIP_FILE;
        sudo echo "        killproc -TERM /usr/local/bin/noip2" >> $NOIP_FILE;
        sudo echo "    ;;" >> $NOIP_FILE;
        sudo echo "    *)" >> $NOIP_FILE;
        sudo echo "        echo \"Usage: \$0 {start|stop}\"" >> $NOIP_FILE;
        sudo echo "        exit 1" >> $NOIP_FILE;
        sudo echo "esac" >> $NOIP_FILE;
        sudo echo "exit 0" >> $NOIP_FILE;
	sudo chmod 755 $NOIP_FILE;
	sudo cp /etc/rc.local /etc/rc.local.bkp;
	sudo sed 's/^exit 0/\.\/etc\/init\.d\/noip start \nexit 0/g' rc.local.bkp > rc.local;
}

###
# Instala java
# Requer root
##
install_java() {
	check_root;
	ARQ=jdk-7u4-linux-i586.tar.gz;
	cp $DIR_BASE/$ARQ /usr/local;
	cd /usr/local;
	tar -xvzf $ARQ;
	mv jdk1.7.0_04 java;
	chown -R anderson.anderson java;
	rm -f $ARQ;
	#/etc/environment
	echo "JAVA_HOME=\"/usr/local/java\"" >> /etc/environment;
	#/etc/profile
	echo "export JAVA_HOME;" >> /etc/profile;
	echo "export PATH=\$PATH:\$JAVA_HOME/bin;" >> /etc/profile;
}

###
# Instala jboss
# Requer root
##
install_jboss() {
	check_root;
	ARQ=jboss-as-7.1.1.Final.zip;
	cp $DIR_BASE/$ARQ /usr/local;
	cd /usr/local;
	unzip $ARQ;
	mv jboss-as-7.1.1.Final jboss;
	chown -R anderson.anderson jboss;
	rm -f $ARQ;
	#/etc/environment
	echo "JBOSS_HOME=\"/usr/local/jboss\"" >> /etc/environment;
	#/etc/profile
	echo "export JBOSS_HOME;" >> /etc/profile;
	echo "export PATH=\$PATH:\$JBOSS_HOME/bin;" >> /etc/profile;
}

###
# Instala maven
# Requer root
##
install_maven() {
	check_root;
	ARQ=apache-maven-3.0.4-bin.tar.gz;
	cp $DIR_BASE/$ARQ /usr/local;
	cd /usr/local;
	tar -xvzf $ARQ;
	mv apache-maven-3.0.4 maven;
	chown -R anderson.anderson maven;
	rm -f $ARQ;
	#/etc/environment
	echo "MAVEN_HOME=\"/usr/local/maven\"" >> /etc/environment;
	#/etc/profile
	echo "export MAVEN_HOME;" >> /etc/profile;
	echo "export PATH=\$PATH:\$MAVEN_HOME/bin;" >> /etc/profile;
}

###
# Instala ant
# Requer root
##
install_ant() {
	check_root;
	ARQ=apache-ant-1.8.3-bin.tar.gz;
	cp $DIR_BASE/$ARQ /usr/local;
	cd /usr/local;
	tar -xvzf $ARQ;
	mv apache-ant-1.8.3 ant;
	chown -R anderson.anderson ant;
	rm -f $ARQ;
	#/etc/environment
	echo "ANT_HOME=\"/usr/local/ant\"" >> /etc/environment;
	#/etc/profile
	echo "export ANT_HOME;" >> /etc/profile;
	echo "export PATH=\$PATH:\$ANT_HOME/bin;" >> /etc/profile;
}

###
# Instala eclipse
# Requer root
##
install_eclipse() {
	check_root;
	ARQ=eclipse-jee-indigo-SR2-linux-gtk.tar.gz;
	cp $DIR_BASE/$ARQ /usr/local;
	cd /usr/local;
	tar -xvzf $ARQ;
	chown -R anderson.anderson eclipse;
	rm -f $ARQ;
	echo "#!/bin/sh" >> /usr/local/bin/eclipse;
	echo "ECLIPSE_HOME=/usr/local/eclipse;" >> /usr/local/bin/eclipse;
	echo "\$ECLIPSE_HOME/eclipse & 2>&1 > /tmp/eclipse.log;" >> /usr/local/bin/eclipse;
	chown anderson.anderson /usr/local/bin/eclipse;
	chmod 755 /usr/local/bin/eclipse;
}

###
# Instala android
# Requer root
##
install_android() {
	check_root;
	ARQ=android-sdk_r16-linux.tgz;
	cp $DIR_BASE/$ARQ /usr/local;
	cd /usr/local;
	tar -xvzf $ARQ;
	mv android-sdk-linux android;
	chown -R anderson.anderson android;
	rm -f $ARQ;
	#/etc/environment
	echo "ANDROID_HOME=\"/usr/local/android\"" >> /etc/environment;
	#/etc/profile
	echo "export ANDROID_HOME;" >> /etc/profile;
	echo "export PATH=\$PATH:\$ANDROID_HOME/tools;" >> /etc/profile;
}

###
# Cria icone do eclipse 
##
create_eclipse_icon() {
	ARQ=/home/anderson/.local/share/applications/opt_eclipse.desktop;
	echo "[Desktop Entry]" >> $ARQ;
	echo "Type=Application" >> $ARQ;
	echo "Name=Eclipse" >> $ARQ;
	echo "Comment=Eclipse Integrated Development Environment" >> $ARQ;
	echo "Icon=/usr/local/eclipse/icon.xpm" >> $ARQ;
	echo "Exec=/usr/local/bin/eclipse" >> $ARQ;
	echo "Terminal=false" >> $ARQ;
	echo "Categories=Development;IDE;Java;" >> $ARQ;
	nautilus ~/.local/share/applications;
}

###
# Instala java plugin no navegador firefox
##
install_java_plugin() {
	DIR=/usr/lib/firefox-addons/plugins;
	cd $DIR;
	sudo ln -s /usr/local/java/jre/lib/i386/libnpjp2.so .;
}

###
# Criacao de alias para atualizacao do ubuntu
##
create_alias_update_ubuntu() {
	echo "#!/bin/sh" >> /usr/local/bin/update-ubuntu;
	echo "sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y autoremove && sudo apt-get -y autoclean" >> /usr/local/bin/update-ubuntu;
	chown anderson.anderson /usr/local/bin/update-ubuntu;
	chmod 755 /usr/local/bin/update-ubuntu;
}

###
# Main
##
#check_root;
#install_vim;
#install_ssh;
#install_skype;
#install_dropbox;
#install_teamviewer;
#install_virtualbox;
#install_chrome;
#change_buttons_position;
#show_menu_icons;
#install_noip;
#install_java;
#install_jboss;
#install_maven;
#install_ant;
#install_eclipse;
#install_android;
#create_eclipse_icon;
#install_java_plugin;




















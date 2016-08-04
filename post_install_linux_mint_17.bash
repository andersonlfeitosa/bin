#!/bin/bash

##
# backup $file
#
backup_file() {
  cp $1 $1.$TIMESTAMP;
}


##
# append text parameter $1 to file parameter $2
#
append_text_to_file() {
  echo $1 >> $2;
}


##
# setting environment variables
#
confugure_profile() {
  FILE=/etc/profile;
  backup_file $FILE;
  append_text_to_file "export HOMEOFFICE_HOME=\"/home/anderson/homeoffice\";" $FILE;
  append_text_to_file "export JAVA_HOME=\"\$HOMEOFFICE_HOME/sdk/java\";" $FILE;
  append_text_to_file "export JRE_HOME=\"\$HOMEOFFICE_HOME/sdk/java\";" $FILE;
  append_text_to_file "export MAVEN_HOME=\"\$HOMEOFFICE_HOME/tools/maven\";" $FILE;
  append_text_to_file "export ANT_HOME=\"\$HOMEOFFICE_HOME/tools/ant\";" $FILE;
  append_text_to_file "export PATH=\$JAVA_HOME/bin:\$MAVEN_HOME/bin:\$ANT_HOME/bin:\$HOMEOFFICE_HOME/bash-scripts/home:\$PATH;" $FILE;
}


##
# install packages
#
install_packages() {
	sudo apt-add-repository ppa:voria/ppa
	sudo apt-get update
	sudo apt-get upgrade -y
	sudo apt-get install dos2unix -y
	sudo apt-get install curl -y
	sudo apt-get install vim -y
	sudo apt-get install exfat-fuse -y
	sudo apt-get install ubuntu-restricted-extras -y
	sudo apt-get install dconf-tools dconf-editor -y
	sudo apt-get install synaptic -y
	sudo apt-get install subversion -y
	sudo apt-get install ssh -y
	sudo apt-get install ethtool -y
	sudo apt-get install xterm -y
	sudo apt-get install p7zip-full -y
	sudo apt-get install git -y
	sudo apt-get install source-highlight -y
	sudo apt-get install ia32-libs -y
	sudo apt-get install clementine -y
	sudo apt-get install pepperflashplugin-nonfree -y
	sudo apt-get install libdvdread4 -y
	sudo apt-get install skype -y
	sudo apt-get install samsung-tools xbindkeys-config -y
	sudo apt-get install tree -y
}


##
# remove packages
#
remove_packages() {
	sudo apt-get remove icedtea* -y
	sudo apt-get remove openjdk* -y
}


##
# remove packages
#
install_java() {
	sudo update-alternatives --install "/usr/bin/java" "java" "/home/anderson/homeoffice/sdk/java/bin/java" 1
	sudo update-alternatives --set java /home/anderson/homeoffice/sdk/java/bin/java

	sudo mkdir -p /usr/lib/firefox-addons/plugins 
	sudo ln -s /home/anderson/homeoffice/sdk/jdk1.8.0_25/jre/lib/amd64/libnpjp2.so /usr/lib/firefox-addons/plugins/libnpjp2.so
}


##
# Main
#
confugure_profile
install_packages
remove_packages
install_java


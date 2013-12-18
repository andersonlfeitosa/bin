#!/bin/bash

TIMESTAMP=`date +"%Y%m%d-%H%M%S"`;

##
# proxy config: http://pac.zscaler.net/sicoob.com.br/sicoob.pac
##

##
# global variables
# make your changes here
#
GIT_DOTFILES_REPOSITORY="https://github.com/andersonlf/dotfiles.git";
GIT_BIN_REPOSITORY="https://github.com/andersonlf/bash-scripts.git";
LOGIN="anderson";

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
# configure dotfiles
#
configure_dotfiles() {
  su - $LOGIN -c "git -c http.proxy=$http_proxy -c http.sslverify=false clone $GIT_DOTFILES_REPOSITORY /home/$LOGIN/dotfiles;"
  su - $LOGIN -c "sh -x /home/$LOGIN/dotfiles/install $LOGIN dotfiles/work;"
}

##
# configure bin
#
configure_bin() {
  su - $LOGIN -c "git -c http.proxy=$http_proxy -c http.sslverify=false clone $GIT_BIN_REPOSITORY /home/$LOGIN/bin;"
}

##
# setting environment variables
#
confugure_profile() {
  FILE=/etc/profile;
  backup_file $FILE;
  append_text_to_file "export SISBRIDE_HOME=\"/home/$LOGIN/sisbride\";" $FILE;
  append_text_to_file "export JAVA_HOME=\"\$SISBRIDE_HOME/sdk/jdk1.7.0_45\";" $FILE;
  append_text_to_file "export JRE_HOME=\"\$SISBRIDE_HOME/sdk/jdk1.7.0_45\";" $FILE;
  append_text_to_file "export MAVEN_HOME=\"\$SISBRIDE_HOME/tools/apache-maven-3.1.1\";" $FILE;
  append_text_to_file "export ANT_HOME=\"\$SISBRIDE_HOME/tools/apache-ant-1.9.2\";" $FILE;
  append_text_to_file "export PATH=\$JAVA_HOME/bin:\$MAVEN_HOME/bin:\$ANT_HOME/bin:\$SISBRIDE_HOME/bin:\$PATH;" $FILE;
}

##
# setting 
#
configure_environment() {
  FILE=/etc/environment;
  backup_file $FILE;
  append_text_to_file "http_proxy=\"$http_proxy\"" $FILE;
  append_text_to_file "https_proxy=\"$https_proxy\"" $FILE;
  append_text_to_file "ftp_proxy=\"$ftp_proxy\"" $FILE;
  append_text_to_file "no_proxy=\"$no_proxy\"" $FILE;
}

##
# setting 
#
configure_network_nsswitch() {
  FILE=/etc/nsswitch.conf;
  backup_file $FILE;
  sed -i "s/dns mdns4/dns [NOTFOUND=return] mdns4/" $FILE
}

##
# export proxy variables
#
export_proxy_variables() {
  export http_proxy="http://189.8.69.36:80/"
  export https_proxy="http://189.8.69.36:80/"
  export ftp_proxy="http://189.8.69.36:80/"
  export no_proxy="localhost,127.0.0.1,.sicoob.com.br,.bancoob.com.br,.homologacao.com.br,svn.sicoob.com.br"
}

##
# configure ignore hosts gnome
#
configure_ignore_hosts_gnome() {
  gsettings set org.gnome.system.proxy ignore-hosts "['localhost', '127.0.0.0/8', '*sicoob.com.br', '*bancoob.com.br', '*bancoob.br', '*homologacao.com.br', 'jb*', 'gis*', 'sicoob*']"
}

##
# configure java oracle in system
#
configure_java_oracle() {
  sudo update-alternatives --install "/usr/bin/java" "java" "/home/anderson/sisbride/sdk/jdk1.7.0_45/bin/java" 1
  sudo update-alternatives --set java /home/anderson/sisbride/sdk/jdk1.7.0_45/bin/java
}

##
# configure java oracle in browsers
#
configure_java_oracle_browser() {
  sudo mkdir -p /usr/lib/mozilla/plugins
  sudo ln -s /home/anderson/sisbride/sdk/jdk1.7.0_45/jre/lib/amd64/libnpjp2.so /usr/lib/mozilla/plugins/libnpjp2.so
  sudo mkdir -p /usr/lib/chromium-browser/plugins
  sudo ln -s /home/anderson/sisbride/sdk/jdk1.7.0_45/jre/lib/amd64/libnpjp2.so /usr/lib/chromium-browser/plugins/libnpjp2.so
}

##
# installing packages
#
install_packages() {
  sudo apt-get update
  sudo apt-get upgrade -y
  sudo apt-get install dos2unix -y
  sudo apt-get install curl -y
  sudo apt-get install vim -y
  sudo apt-get install exfat-fuse -y
  sudo apt-get install ubuntu-restricted-extras -y
  sudo apt-get install dconf-tools dconf-editor -y
  sudo apt-get install chromium-browser -y
  sudo apt-get install synaptic -y
  sudo apt-get install subversion -y
  sudo apt-get install ssh -y
  sudo apt-get install ethtool -y
  sudo apt-get install playonlinux -y
  sudo apt-get install xterm -y
  sudo apt-get install p7zip-full -y
  sudo apt-get install git -y
  sudo apt-get install source-highlight -y
  sudo apt-get install ia32-libs -y
#  sudo apt-get install mono-complete -y
#  sudo apt-get install libxslt1-dev -y
  sudo apt-get install evolution evolution-mapi evolution-ews -y
  sudo apt-get remove icedtea* -y
}

##
# main
#
if [ `whoami` != "root" ]; then
  echo "you need to be root to execute this script";
  exit 1;
else
  export_proxy_variables
  configure_environment
  confugure_profile
  configure_network_nsswitch
  install_packages
  configure_ignore_hosts_gnome
  configure_java_oracle
  configure_java_oracle_browser
  configure_dotfiles
  configure_bin
  exit 0;
fi



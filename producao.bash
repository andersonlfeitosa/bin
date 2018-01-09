#!/bin/bash

check_root() {
  if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
    exit
  fi
}

process() {
  SERVICE_NAME=$1

  case "$SERVICE_NAME" in
    config )
      docker kill gcs-central-configuracao;
      docker rm gcs-central-configuracao;
      systemctl restart docker 
      docker rmi `docker images | grep $SERVICE_NAME | awk -F' ' '{print $3}'`
      docker run -d --name gcs-central-configuracao --restart=always -p 8888:8888 10.102.1.2:5000/gcs/diclix/central-configuracao:latest --spring.profiles.active=prd
      docker logs -f gcs-central-configuracao;
      ;;
    registro )
      docker kill gcs-central-registro;
      docker rm gcs-central-registro;
      systemctl restart docker
      docker rmi `docker images | grep $SERVICE_NAME | awk -F' ' '{print $3}'`
      docker run -d --name gcs-central-registro --restart=always -p 7777:7777 10.102.1.2:5000/gcs/diclix/central-registro:latest --spring.profiles.active=prd
      docker logs -f gcs-central-registro;
      ;;
    pessoa )
      docker kill gcs-pessoa;
      docker rm gcs-pessoa;
      systemctl restart docker
      docker rmi `docker images | grep $SERVICE_NAME | awk -F' ' '{print $3}'`
      docker run -d --name gcs-pessoa --restart=always -p 5001:5001 10.102.1.2:5000/gcs/diclix/pessoa:latest --spring.profiles.active=prd
      docker logs -f gcs-pessoa;
      ;;
    contrato )
      docker kill gcs-contrato;
      docker rm gcs-contrato;
      systemctl restart docker
      docker rmi `docker images | grep $SERVICE_NAME | awk -F' ' '{print $3}'`
      docker run -d --name gcs-contrato --restart=always -p 5002:5002 10.102.1.2:5000/gcs/diclix/contrato:latest --spring.profiles.active=prd
      docker logs -f gcs-contrato;
      ;;
    contato )
      docker kill gcs-mdm-contato; 
      docker rm gcs-mdm-contato;
      systemctl restart docker 
      docker rmi `docker images | grep $SERVICE_NAME | awk -F' ' '{print $3}'`
      docker run -d --name gcs-mdm-contato --restart=always -p 5014:5014 10.102.1.2:5000/gcs/diclix/mdm-contato:latest --spring.profiles.active=prd
      docker logs -f gcs-mdm-contato;
      ;;
    export )
      docker kill gcs-export; 
      docker rm gcs-export;
      systemctl restart docker 
      docker rmi `docker images | grep $SERVICE_NAME | awk -F' ' '{print $3}'`
      docker run -d --name gcs-export --restart=always -p 5551:5551 10.102.1.2:5000/gcs/diclix/export:latest --spring.profiles.active=prd
      docker logs -f gcs-export;
      ;;
    * )
      show_help
      ;;
  esac

}


show_help() {
  echo "USAGE: "$0" SERVICE"
  echo "SERVICE: config registro pessoa contrato contato export"
  exit 1
}


###
## Main
###
if [ $# == "1" ]
then
  check_root
  process $1
else
  show_help
fi


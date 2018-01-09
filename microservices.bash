#!/bin/bash

URL=10.102.1.2:5000/gcs/diclix/visao360
ENVIRONMENT=hom

show_help() {
  echo "USAGE: "$0" COMMAND SERVICE"
  echo "COMMAND: start stop kill rm rmi"
  echo "SERVICE: config registro pessoa contrato contato export"
  exit 1
}

check_root() {
  if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
    exit
  fi
}

get_image_name() {
  SERVICE=$1
  case "$SERVICE" in
    config )
      echo "central-configuracao"
      ;;
    registro )
      echo "central-registro"
      ;;
    pessoa )
      echo "pessoa"
      ;;
    contrato )
      echo "contrato"
      ;;
    contato )
      echo "mdm-contato"
      ;;
    parcela )
      echo "parcela"
      ;;
    sinistro )
      echo "sinistro"
      ;;
    relacionamento )
      echo "relacionamento"
      ;;
    export )
      echo "export"
      ;;
    * )
      show_help
      ;;
  esac
}

get_docker_name() {
  SERVICE=$1
  case "$SERVICE" in
    config )
      echo "gcs-central-configuracao"
      ;;
    registro )
      echo "gcs-central-registro"
      ;;
    pessoa )
      echo "gcs-pessoa"
      ;;
    contrato )
      echo "gcs-contrato"
      ;;
    contato )
      echo "gcs-mdm-contato"
      ;;
    parcela )
      echo "gcs-parcela"
      ;;
    sinistro )
      echo "gcs-sinistro"
      ;;
    relacionamento )
      echo "gcs-relacionamento"
      ;;
    export )
      echo "gcs-export"
      ;;
    * )
      show_help
      ;;
  esac
}

get_docker_port() {
  SERVICE=$1
  case "$SERVICE" in
    config )
      echo "8888"
      ;;
    registro )
      echo "7777"
      ;;
    pessoa )
      echo "5001"
      ;;
    contrato )
      echo "5002"
      ;;
    contato )
      echo "5014"
      ;;
    parcela )
      echo "5008"
      ;;
    sinistro )
      echo "5006"
      ;;
    relacionamento )
      echo "5019"
      ;;
    export )
      echo "5551"
      ;;
    * )
      show_help
      ;;
  esac
}


process_command() {
  COMMAND=$1
  case "$COMMAND" in
    start )
      process_command_start $2 "false"
      ;;
    start_full )
      process_command_start $2 "true"
      ;;
    stop )
      process_command_stop $2 "false"
      ;;
    stop_full )
      process_command_stop $2 "true"
      ;;
    kill )
      process_command_kill $2 "false"
      ;;
    kill_full )
      process_command_kill $2 "true"
      ;;
    rm )
      process_command_rm $2 "false"
      ;;
    rm_full )
      process_command_rm $2 "true"
      ;;
    rmi )
      process_command_rmi $2 "false"
      ;;
    rmi_full )
      process_command_rmi $2 "true"
      ;;
    * )
      show_help
      ;;
  esac
}

process_command_start() {
  SERVICE=$1
  FULL=$2
  DOCKER_CONTAINER=`get_docker_name $SERVICE`
  DOCKER_PORT=`get_docker_port $SERVICE`
  IMAGE_NAME=`get_image_name $SERVICE`
  PORT=`get_docker_port $SERVICE`

  if [ "$FULL" == "true" ]; then
      systemctl restart docker    
  fi

  docker stop $DOCKER_CONTAINER;
  docker rm $DOCKER_CONTAINER;
  docker rmi `docker images | grep $IMAGE_NAME | awk -F' ' '{print $3}'`

  if ([ "$ENVIRONMENT" == "hom" ] && [ "$SERVICE" == "config" ]); then
    docker run -d --name $DOCKER_CONTAINER --restart=always -p $PORT:$PORT -v /opt/microsservicos/gcs-configuracao:/opt/microsservicos/gcs-configuracao $URL/$IMAGE_NAME:latest --spring.profiles.active=$ENVIRONMENT
  else
    docker run -d --name $DOCKER_CONTAINER --restart=always -p $PORT:$PORT $URL/$IMAGE_NAME:latest --spring.profiles.active=$ENVIRONMENT
  fi
  
  docker logs -f $DOCKER_CONTAINER;
}

process_command_stop() {
  SERVICE=$1
  FULL=$2
  DOCKER_CONTAINER=`get_docker_name $SERVICE`
  DOCKER_PORT=`get_docker_port $SERVICE`
  IMAGE_NAME=`get_image_name $SERVICE`
  PORT=`get_docker_port $SERVICE`

  if [ "$FULL" == "true" ]; then
      systemctl restart docker    
  fi

  docker stop $DOCKER_CONTAINER;
  docker rm $DOCKER_CONTAINER;
}

process_command_kill() {
  SERVICE=$1
  FULL=$2
  DOCKER_CONTAINER=`get_docker_name $SERVICE`
  DOCKER_PORT=`get_docker_port $SERVICE`
  IMAGE_NAME=`get_image_name $SERVICE`
  PORT=`get_docker_port $SERVICE`

  if [ "$FULL" == "true" ]; then
      systemctl restart docker    
  fi

  docker kill $DOCKER_CONTAINER;
  docker rm $DOCKER_CONTAINER;
}

process_command_rm() {
  SERVICE=$1
  FULL=$2
  DOCKER_CONTAINER=`get_docker_name $SERVICE`
  DOCKER_PORT=`get_docker_port $SERVICE`
  IMAGE_NAME=`get_image_name $SERVICE`
  PORT=`get_docker_port $SERVICE`

  if [ "$FULL" == "true" ]; then
      systemctl restart docker    
  fi

  docker kill $DOCKER_CONTAINER;
  docker rm $DOCKER_CONTAINER;
}

process_command_rmi() {
  SERVICE=$1
  FULL=$2
  DOCKER_CONTAINER=`get_docker_name $SERVICE`
  DOCKER_PORT=`get_docker_port $SERVICE`
  IMAGE_NAME=`get_image_name $SERVICE`
  PORT=`get_docker_port $SERVICE`
  
  if [ "$FULL" == "true" ]; then
      systemctl restart docker    
  fi

  docker kill $DOCKER_CONTAINER;
  docker rm $DOCKER_CONTAINER;
  docker rmi `docker images | grep $IMAGE_NAME | awk -F' ' '{print $3}'`
}

###
## Main
###
if [ $# == "2" ]
then
  check_root
  process_command $1 $2 
else
  show_help
fi



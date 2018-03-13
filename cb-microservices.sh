#!/bin/bash

DIR=/Users/anderson.feitosa/cabal-brasil/workspace
DIR_SSR=$DIR/sippe-service-registry/target
DIR_SCC=$DIR/sippe-cloud-configuration/target


java -Duser.timezone=America/Sao_Paulo -Djava.security.egd=file:/dev/./urandom -Xmx1024m -jar $DIR_SSR/sippe-service-registry.jar > nohup.out 2>&1 &
java -Duser.timezone=America/Sao_Paulo -Djava.security.egd=file:/dev/./urandom -Xmx1024m -jar $DIR_SCC/sippe-cloud-configuration.jar > nohup.out 2>&1 &

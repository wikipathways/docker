#!/bin/bash

docker build --no-cache -t "develop" .
#docker build -t p .
sudo docker tag develop bigcatum/virtuoso-wikipathways:develop

#sudo docker tag -f p dtlfair/search
sudo docker push bigcatum/virtuoso-wikipathways:develop

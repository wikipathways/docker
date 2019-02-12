#!/bin/bash

mkdir -p dataload/data
cd dataload/data
#wget  http://data.wikipathways.org/current/rdf/wikipathways-20190110-rdf-void.ttl
#wget  http://data.wikipathways.org/current/rdf/wikipathways-20190110-rdf-gpml.zip
#wget  http://data.wikipathways.org/current/rdf/wikipathways-20190110-rdf-wp.zip
#make sure all.ttl doens't exist yet
docker stop loadVirtuoso
docker rm loadVirtuoso
rm ../all.ttl

unzip -o \*.zip
find . -name "*.ttl" -exec cat > ../all.ttl {} \;
cd ../../ 


docker build --no-cache -t "develop" .
#docker build -t p .
docker tag develop bigcatum/wikipathways-virtuoso:develop
docker run -d --env DBA_PASSWORD=dba --name loadVirtuoso --volume `pwd`/dataload/:/database/data/  bigcatum/wikipathways-virtuoso:develop

sleep 10 #dirty solution to wait for Virtuoso to fully start

docker exec -ti loadVirtuoso isql -P dba -S 1111 exec="DB.DBA.TTLP_MT (file_to_string_output ('/opt/virtuoso-opensource/database/data/all.ttl'), 'http://rdf.wikipathways.org/');"

#sudo docker tag -f p dtlfair/search
docker push bigcatum/wikipathways-virtuoso:develop

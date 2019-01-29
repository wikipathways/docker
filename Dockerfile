
FROM openlink/virtuoso-opensource-7:latest

MAINTAINER BiGCaT

ENV PORT 8890
ENV PORT 1111

#RUN apt-get update \
#    && apt-get install -y wget \
#    && apt-get install -y zip

#RUN mkdir -p /dataload/data
#WORKDIR /dataload/data
#RUN wget  http://data.wikipathways.org/current/rdf/wikipathways-20190110-rdf-void.ttl
#RUN wget  http://data.wikipathways.org/current/rdf/wikipathways-20190110-rdf-gpml.zip
#RUN wget  http://data.wikipathways.org/current/rdf/wikipathways-20190110-rdf-wp.zip
#RUN zip -d *.zip
#RUN find . -name *.ttl -exec cat > ../all.ttl {} \;
#WORKDIR /database/

EXPOSE 8890 1111

#ENTRYPOINT service apache2 start && /opt/bridgedb/bridgedb-2.3.0/startup.sh

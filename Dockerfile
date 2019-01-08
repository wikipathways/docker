
FROM openlink/virtuoso-opensource-7:latest

MAINTAINER BiGCaT

ENV PORT 8890
ENV PORT 1111

RUN apt-get update \
    && apt-get install -y wget \
    && apt-get install -y zip
RUN mkdir /dataload
RUN cd /dataload
RUN ls
RUN ls /
RUN touch a
#RUN wget http://data.wikipathways.org/current/rdf/wikipathways-20181210-rdf-wp.zip
RUN ls
RUN pwd
RUN unzip *.zip

EXPOSE 8890 1111

#ENTRYPOINT service apache2 start && /opt/bridgedb/bridgedb-2.3.0/startup.sh

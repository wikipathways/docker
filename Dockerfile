
FROM openlink/virtuoso-opensource-7:latest

MAINTAINER BiGCaT

ENV PORT 8890
ENV PORT 1111

RUN apt-get update \
    && apt-get install -y wget
RUN mkdir /dataload/ \
	&& wget http://data.wikipathways.org/current/rdf/wikipathways-20181210-rdf-wp.zip /dataload/ \
        && cd /dataload/ \
	&& unzip -d *.zip

EXPOSE 8890 1111

#ENTRYPOINT service apache2 start && /opt/bridgedb/bridgedb-2.3.0/startup.sh

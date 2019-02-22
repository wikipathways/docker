# Virtuoso docker image and loading with WikiPathways RDF

Repository for WikiPathways related Docker files.

The Docker image currently contains Virtuoso Docker only (on development) that requires manual configuration to load RDF into a docker container.
 
 
# Guideline to set up a Virtuoso SPARQL endpoint with WikiPathways RDF (on linux):

# Step 1 - Create folder to mount
Enter the terminal and create a folder to map to the docker container. We created the folder '/dataload/data' and entered it by using:
```
mkdir -p dataload/data
cd dataload/data
```

# Step 2A - Download RDF
The WikiPathways RDF has three files that need to be downloaded. Make sure that the filenames are correct, as these update monthly. In this example, we use the RDF release of February 10th, 2019. With every new release, the date in the file names are updated. Check http://data.wikipathways.org/current/rdf/ for the file names to download. Use:
```
wget  http://data.wikipathways.org/current/rdf/wikipathways-20190210-rdf-void.ttl
wget  http://data.wikipathways.org/current/rdf/wikipathways-20190210-rdf-gpml.zip
wget  http://data.wikipathways.org/current/rdf/wikipathways-20190210-rdf-wp.zip
```

# Step 2B - Unzip and concatenate files, and return to starting folder
The WP RDF and GPML RDF zip files need to be unzipped and all files need to be concatenated into one file. In this case, we call the concatenated file "all.ttl". Afterwards, exit the newly created folder:
```
unzip -o \*.zip
find . -name "*.ttl" -exec cat > ../all.ttl {} \;
cd ../../
```

# Step 3 - Run the Docker image
Use 'sudo' if necessary. Be sure to use ports 8890:8890 and 1111:1111. In this case, we named the container "loadVirtuoso". Also, this step configures the mapped local folder with the data, which is in this example "/dataload". The Docker image used  is bigcatum/wikipathways-virtuoso:develop. Do this by entering:
```
sudo docker run -d --env DBA_PASSWORD=dba -p 8890:8890 -p 1111:1111 --name loadVirtuoso --volume `pwd`/dataload/:/database/data/  bigcatum/wikipathways-virtuoso:develop
```

# Step 4 - Enter the running container
While the docker image is running in a container, the data is not yet loaded. Therefore you need to enter the it by using:

```
sudo docker exec -it loadVirtuoso  bash
```

# Step 5 - Move the all.ttl file and create a .graph file.
First, enter the "/data" folder and move the "all.ttl" file to the folder upstream by using:
```
cd data
mv all.ttl ../
cd ../
```
Second, create a ".graph" file and add the graph.iri in that file, which is "http://rdf.wikipathways.org/". Prior to that, a text editing tool needs to be installed, such as "nano". Use the commands:
```
touch all.ttl.graph
apt-get update
apt-get install nano
nano all.ttl.graph 
```
When the file is entered, write "http://rdf.wikipathways.org/" (without ") and exit the file by pressing Ctrl+X, followed by "Y" and Enter to save and return. Exit the docker container by:
```
exit
```

# Step 6 - Enter the container SQL to configure RDF loading
Enter the running docker container SQL by using: 
```
sudo docker exec -i loadVirtuoso isql 1111
```

Use the following commands to complete the loading of RDF. If errors occur, try again within a few seconds (which often works), or look at http://docs.openlinksw.com/virtuoso/errorcodes/ to find out what they mean. This whole step might take a couple of minutes.
```
log_enable(2);
DB.DBA.XML_SET_NS_DECL ('dc', 'http://purl.org/dc/elements/1.1/',2);
DB.DBA.XML_SET_NS_DECL ('cas', 'http://identifiers.org/cas/',2);
DB.DBA.XML_SET_NS_DECL ('wprdf', 'http://rdf.wikipathways.org/',2);
DB.DBA.XML_SET_NS_DECL ('prov', 'http://www.w3.org/ns/prov#',2);
DB.DBA.XML_SET_NS_DECL ('foaf', 'http://xmlns.com/foaf/0.1/',2);
DB.DBA.XML_SET_NS_DECL ('hmdb', 'http://identifiers.org/hmdb/',2);
DB.DBA.XML_SET_NS_DECL ('freq', 'http://purl.org/cld/freq/',2);
DB.DBA.XML_SET_NS_DECL ('pubmed', 'http://www.ncbi.nlm.nih.gov/pubmed/',2);
DB.DBA.XML_SET_NS_DECL ('wp', 'http://vocabularies.wikipathways.org/wp#',2);
DB.DBA.XML_SET_NS_DECL ('void', 'http://rdfs.org/ns/void#',2);
DB.DBA.XML_SET_NS_DECL ('biopax', 'http://www.biopax.org/release/biopax-level3.owl#',2);
DB.DBA.XML_SET_NS_DECL ('dcterms', 'http://purl.org/dc/terms/',2);
DB.DBA.XML_SET_NS_DECL ('rdfs', 'http://www.w3.org/2000/01/rdf-schema#',2);
DB.DBA.XML_SET_NS_DECL ('pav', 'http://purl.org/pav/',2);
DB.DBA.XML_SET_NS_DECL ('ncbigene', 'http://identifiers.org/ncbigene/',2);
DB.DBA.XML_SET_NS_DECL ('xsd', 'http://www.w3.org/2001/XMLSchema#',2);
DB.DBA.XML_SET_NS_DECL ('rdf', 'http://www.w3.org/1999/02/22-rdf-syntax-ns#',2);
DB.DBA.XML_SET_NS_DECL ('gpml', 'http://vocabularies.wikipathways.org/gpml#',2);
DB.DBA.XML_SET_NS_DECL ('skos', 'http://www.w3.org/2004/02/skos/core#',2);
log_enable(1);
grant select on "DB.DBA.SPARQL_SINV_2" to "SPARQL";
grant execute on "DB.DBA.SPARQL_SINV_IMP" to "SPARQL";
ld_dir('.', 'all.ttl', 'http://rdf.wikipathways.org');
rdf_loader_run();
```
Check the status and look if the all.ttl file is loaded by entering:
```
select * from DB.DBA.load_list;
```
If the "il_state" = 2, the loading is complete. If issues occurred in this step, have a look at http://vos.openlinksw.com/owiki/wiki/VOS/VirtBulkRDFLoader. 
Quit the SQL by entering:
```
quit;
```

# Step 7 - Enter the Virtuoso service with loaded WikiPathways RDF
The container is running with loaded RDF, available through http://localhost:8890, or enter the SPARQL endpoint directly through http://localhost:8890/sparql/.




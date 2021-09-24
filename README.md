# RDFStream2Flink-Docker
This repository contains a guide to deploy the RDFStream2Flink library with docker-compose.

## Generate queries and RDF streams from CityBench
RDFStream2Flink offers the possibility of consuming data stream from a socket. In this sense, to carry out a proof of this library, it was necessary to extend CityBench [Ali et al., 2015] to generate RDF streams through sockets. The generated streams must have the format (< s, p, o >, t) where < s, p, o > is a triple and t is the temporary part of the stream. A CityBench extension that meets these requirements is available at (https://github.com/oscarceballos/citybench-ext). It is called CityBench-Ext.

The CityBench offers a set of 13 queries to evaluate the characteristics and features of the RSP engines which are most relevant to the smart city applications requirements. These queries have a static and streaming part. We used four different queries, but we only used the streaming part of these queries. The queries Q1, Q2, Q7, and Q10 were modified omitting the static part and CQELS-QL operators that are not yet implemented in the library. Table 1 summarizes the list of queries supported and what queries were modified to be able to transform it into a DataStream API in Flink program.

![Image text](/images/queries-citybench-stream.png)

Queries Q1, Q2, Q7, and Q10 are available in the queries folder. Each folder contains the query expressed in CQELS-QL and its corresponding transformation into DataStream Flink program.

The RDF streams generated by CityBench-Ext via socket, are related with those queries that are used in inquiries available in CityBench and that they were suitable for the bookstore RDFStream2Flink. In particular, the RDF streams used are AarhusTrafficData182955, AarhusTrafficData158505, AarhusWeatherData0, AarhusParkingDataKALKVAERKSVE, Aarhus- ParkingDataSKOLEBAKKEN, AarhusPollutionData182955, AarhusPollutionData158505, and AarhusPollutionData206502.


## Steps to run RDFStream2Flink with docker-compose
1. Download rdfstream2flink-docker repository
```
git clone https://github.com/oscarceballos/rdfstream2flink-docker.git
```
2. Run the following command to deploy on docker
```
./runner-query.sh 2 queries/query1/query-1.0-SNAPSHOT.jar
```
3. Run the following command to see the query results
```
tail -f path-to-output/Query-Flink-Result
```

### References
Ali, M. I., Gao, F., and Mileo, A. (2015). Citybench: A configurable benchmark to evaluate rsp engines using smart city datasets. In Arenas, M., Corcho, O., Simperl, E., Strohmaier, M., d’Aquin, M., Srinivas, K., Groth, P., Dumontier, M., Heflin, J., Thirunarayan, K., and Staab, S., editors, The Semantic Web - ISWC 2015, pages 374–389, Cham. Springer International Publishing




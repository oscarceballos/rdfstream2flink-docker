# RDFStream2Flink-Docker
This repository contains a guide to deploy the RDFStream2Flink library with docker-compose.

## Generate queries and RDF streams from CityBench
RDFStream2Flink offers the possibility of consuming data stream from a socket. In this sense, to carry out a proof of this library, it was necessary to extend CityBench [Ali et al., 2015] to generate RDF streams through sockets. The generated streams must have the format (< s, p, o >, t) where < s, p, o > is a triple and t is the temporary part of the stream. A CityBench extension that meets these requirements is available at (https://github.com/oscarceballos/citybench-ext). It is called CityBench-Ext.

The RDF streams generated by CityBench-Ext via socket, are related with those queries that are used in inquiries available in CityBench and that they were suitable for the bookstore RDFStream2Flink. In particular, the RDF streams used are AarhusTrafficData182955, AarhusTrafficData158505, AarhusWeatherData0, AarhusParkingDataKALKVAERKSVE, Aarhus- ParkingDataSKOLEBAKKEN, AarhusPollutionData182955, AarhusPollutionData158505, and AarhusPollutionData206502.

The CityBench offers a set of 13 queries to evaluate the characteristics and features of the RSP engines which are most relevant to the smart city applications requirements. These queries have a static and streaming part. We used four different queries, but we only used the streaming part of these queries. The queries Q1, Q2, Q7, and Q10 were modified omitting the static part and CQELS-QL operators that are not yet implemented in the library. Table 1 summarizes the list of queries supported and what queries were modified to be able to transform it into a DataStream API in Flink program.

![Image text](/images/queries-citybench-stream.png)

Queries Q1, Q2, Q7, and Q10 are available in the queries folder. Each folder contains the query expressed in CQELS-QL and its corresponding transformation into DataStream Flink program.

### Query 1
The Q1 query monitors the traffic congestion from two traffic sensors located on the roads which are part of the planned journey, i.e., AarhusTrafficData182955 and AarhusTrafficData158505. The property observed is Average Speed. The keywork RANGE refers to a time-based tum- bling window which produces results every ten minutes.
```
PREFIX ses: <http://www.insight???centre.org/dataset/SampleEventService#>
PREFIX ssn : <http :// purl . oclc . org/NET/ssnx/ssn#>
PREFIX sao: <http://purl.oclc.org/NET/sao/>

SELECT ?obId1 ?v1 ?obId2 ?v2
WHERE {
  STREAM ses:TrafficData182955 [RANGE 10m]
  {
    ?obId1 a ?ob .
    ?obId1 ssn:observeProperty ses:AvgSpeed .
    ?obId1 sao:hasValue ?v1 .
    ?obId1 ssn:observedBy ses:TrafficData182955 .
  }
  
  STREAM ses:TrafficData158505 [RANGE 10m]
  {
    ?obId1 a ?ob .
    ?obId1 ssn:observeProperty ses:AvgSpeed .
    ?obId1 sao:hasValue ?v2 .
    ?obId1 ssn:observedBy ses:TrafficData158505 . 
  }
}
```

### Query 2
The Q2 query is similar to Q1 with an additional type of input streams containing weather observations for each road at the planned journey of the user, but in this case we use only one traffic sensor, i.e., AarhusTrafficData158505. The weather observations are Temperature, Humidity, and WindSpeed taken from AarhusWeatherData0 weather sensor. In the same way, the keywork RANGE refers to a time-based tumbling window which produces results every 50 seconds.
```
PREFIX ses: <http://www.insight???centre.org/dataset/SampleEventService#>
PREFIX ssn : <http :// purl . oclc . org/NET/ssnx/ssn#>
PREFIX sao: <http://purl.oclc.org/NET/sao/>

SELECT ?obId1 ?obId2 ?obId3 ?obId4 ?v1 ?v2 ?v3 ?v4
WHERE {
  STREAM ses:WeatherData0 [RANGE 50s]
  {
    ?obId1 a ?ob .
    ?obId1 ssn:observeProperty ses:Temperature .
    ?obId1 sao:hasValue ?v1 .
    ?obId1 ssn:observedBy ses:WeatherData0 .
    
    ?obId1 a ?ob .
    ?obId1 ssn:observeProperty ses:Humidity .
    ?obId1 sao:hasValue ?v2 .
    ?obId1 ssn:observedBy ses:WeatherData0 .
    
    ?obId1 a ?ob .
    ?obId1 ssn:observeProperty ses:WinSpeed .
    ?obId1 sao:hasValue ?v3 .
    ?obId1 ssn:observedBy ses:WeatherData0 .
  }
  
  STREAM ses:TrafficData158505 [RANGE 50s]
  {
    ?obId4 a ?ob .
    ?obId4 ssn:observeProperty ses:AvgSpeed .
    ?obId4 sao:hasValue ?v4 .
    ?obId4 ssn:observedBy ses:TrafficData158505 . 
  }
}
```

### Query 7
The Q7 query is a combination of travel planner and parking application, where a user wants to be notified about parking situation close to the destination. The RDF streams are taken from AarhusParkingDataKALKVAERKSVE and AarhusPark- ingDataSKOLEBAKKEN parking sensors. The keywork RANGE refers to a time-based tumbling window which produces results every 30 seconds.
```
PREFIX ses: <http://www.insight???centre.org/dataset/SampleEventService#>
PREFIX ssn : <http :// purl . oclc . org/NET/ssnx/ssn#>
PREFIX sao: <http://purl.oclc.org/NET/sao/>

SELECT ?obId1 ?v1 ?obId2 ?v2
WHERE {
  STREAM ses:ParkingDataKALKVAERKSVEJ [RANGE 30s]
  {
    ?obId1 a ?ob .
    ?obId1 ssn:observeProperty ses:ParkingVacancy-8 .
    ?obId1 sao:hasValue ?v1 .
    ?obId1 ssn:observedBy ses:ParkingDataKALKVAERKSVEJ .
  }
  
  STREAM ses:ParkingDataSKOLEBAKKEN [RANGE 30s]
  {
    ?obId1 a ?ob .
    ?obId1 ssn:observeProperty ses:ParkingVacancy-4 .
    ?obId1 sao:hasValue ?v2 .
    ?obId1 ssn:observedBy ses:ParkingDataSKOLEBAKKEN . 
  }
  
  FILTER(?v1<1 || ?v2<1)
}
```

### Query 10
The Q10 query is an analytical query executed over the pollution data streams to find out which area in the city in most polluted and how this information evolves. The data streams are taken from AarhusPollutionData182955, Aarhus- PollutionData158505, and AarhusPollutionData206502 pollution sensors. Contrary to previous queries, in this case the keywords RANGE and SLIDE refers to time-based sliding window which produces results every 30 seconds.
```
PREFIX ses: <http://www.insight???centre.org/dataset/SampleEventService#>
PREFIX ssn : <http :// purl . oclc . org/NET/ssnx/ssn#>
PREFIX sao: <http://purl.oclc.org/NET/sao/>

SELECT ?obId1 ?obId2 ?obId3 ?v1 ?v2 ?v3
WHERE {
  STREAM ses:PollutionData182955 [RANGE 3m SLIDE 30s]
  {
    ?obId1 a ?ob .
    ?obId1 ssn:observeProperty ses:CongestionLevel .
    ?obId1 sao:hasValue ?v1 .
    ?obId1 ssn:observedBy ses:PollutionData182955 .
  }
  
  STREAM ses:PollutionData158505 [RANGE 3m SLIDE 30s]
  {
    ?obId1 a ?ob .
    ?obId1 ssn:observeProperty ses:CongestionLeve .
    ?obId1 sao:hasValue ?v2 .
    ?obId1 ssn:observedBy ses:PollutionData158505 .
  }
  
  STREAM ses:PollutionData206502 [RANGE 3m SLIDE 30s]
  {
    ?obId1 a ?ob .
    ?obId1 ssn:observeProperty ses:CongestionLevel .
    ?obId1 sao:hasValue ?v3 .
    ?obId1 ssn:observedBy ses:PollutionData206502 .
  }
}
```

### Query 1A
The query Q1A is a variant of Q1 query. In this case, the query only use one traffic sensor, i.e., AarhusTrafficData182955 and the keyword is TRIPLES which refers to count-based tumbling window with a size equal to 300 elements.
```
PREFIX ses: <http://www.insight???centre.org/dataset/SampleEventService#>
PREFIX ssn : <http :// purl . oclc . org/NET/ssnx/ssn#>
PREFIX sao: <http://purl.oclc.org/NET/sao/>

SELECT ?obId1 ?v1 ?obId2 ?v2
WHERE {
  STREAM ses:TrafficData182955 [TRIPLES 300]
  {
    ?obId1 a ?ob .
    ?obId1 ssn:observeProperty ses:AvgSpeed .
    ?obId1 sao:hasValue ?v1 .
    ?obId1 ssn:observedBy ses:TrafficData182955 .
  }
}
```

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
tail -f /output/Query-Flink-Result
```



### References
Ali, M. I., Gao, F., and Mileo, A. (2015). Citybench: A configurable benchmark to evaluate rsp engines using smart city datasets. In Arenas, M., Corcho, O., Simperl, E., Strohmaier, M., d???Aquin, M., Srinivas, K., Groth, P., Dumontier, M., Heflin, J., Thirunarayan, K., and Staab, S., editors, The Semantic Web - ISWC 2015, pages 374???389, Cham. Springer International Publishing




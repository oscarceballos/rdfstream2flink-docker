#!/bin/bash

#Variables: 1->parallelism 2->path-to-jar

#Launch a cluster in the background
docker-compose up -d

sleep 40s

#Copy the .jar file to container
JOB_CLASS_NAME="rdfstream2flink.out.Query"
JOBMANAGER_CONTAINER=$(docker ps --filter name=jobmanager --format={{.ID}})
docker cp $2 "${JOBMANAGER_CONTAINER}":/job.jar

#Run the .jar file
docker exec -t -i "$JOBMANAGER_CONTAINER" flink run -p $1 -c ${JOB_CLASS_NAME} /job.jar --output /output/

#Down cluster
docker-compose down

exit

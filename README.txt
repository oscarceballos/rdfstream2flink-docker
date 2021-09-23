
--------------------------------------------------------------------------------
PASO PARA TRANSFORAR UNA CONSULTA SPARQL A UN PROGRAMA EN FLINK Y SU EJECUCIÓN
--------------------------------------------------------------------------------

1. Ubicarse en el directorio home
------------------------------------------------------
cd ~/



2. Descarge el repositorio sparql2flink desde GitHub
------------------------------------------------------
git clone https://github.com/oscarceballos/rdfstream2flink.git



3. Descomprimir en el directorio home el archivo rdfstream2flink-docker.zip



4. Ingresar al directorio rdfstream2flink-docker
------------------------------------------------------
cd rdfstream2flink-docker



5. Ejecutar el siguiente comando:
------------------------------------------------------
(Plantilla)
./mapper-query.sh <path-to-query.rq> <type-of-time> <type-of-window> <host> <port> <path-to-copy-jar>

(Ejemplo)
./mapper-query.sh query1/Query.txt E R localhost 9995 query1/



6. Ejecutar el siguiente comando:
------------------------------------------------------
(Plantilla)
./runner-query.sh <parallelism> <path-to-jar> <dataset>

(Ejemplo)
./runner-query.sh 2 queries/query1/query-1.0-SNAPSHOT.jar



7. Repetir los pasos 5 y 6 por cada consulta

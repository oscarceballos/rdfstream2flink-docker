FROM openjdk:8-jre

LABEL version=citybench-ext

WORKDIR /tmp

COPY ./files/ .

CMD ["mkdir", "-p", "/tmp/out"]

EXPOSE 5555 5556

CMD ["java", "-jar", "/tmp/citybench-ext-all-1.0.jar", "type=R", "query=Query1.txt", "useTimeStamp=true", "freq=1500", "port=5555", "out=/tmp/out/"]

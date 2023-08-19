# Kafka in Docker


In order to download the kafka zip/archive, we are using a separate shell script file and calling it from Dockerfile 
in this example. This is different from spark docker file where we download the archive  



### Building and Running container using Docker Commands

To build the container, run below command:
```
docker build -t my_kafka_image .

```
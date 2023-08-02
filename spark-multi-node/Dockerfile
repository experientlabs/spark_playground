FROM python:3.10-buster

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      sudo curl vim unzip rsync \
      openjdk-11-jdk \
      build-essential \
      software-properties-common \
      ssh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

## Download spark and hadoop dependencies and install

# Optional env variables
ENV SPARK_VERSION=3.3.1
ENV HADOOP_VERSION=3
ENV JAVA_VERSION=11
ENV SPARK_HOME=${SPARK_HOME:-"/opt/spark"}
ENV HADOOP_HOME=${HADOOP_HOME:-"/opt/hadoop"}

RUN mkdir -p ${HADOOP_HOME} && mkdir -p ${SPARK_HOME}
WORKDIR ${SPARK_HOME}


RUN curl https://dlcdn.apache.org/spark/spark-3.3.1/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -o spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
 && tar xvzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz --directory /opt/spark --strip-components 1 \
 && rm -rf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
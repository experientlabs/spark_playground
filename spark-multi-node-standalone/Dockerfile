FROM python:3.10-buster as spark-base-image

LABEL maintainer="amazon"

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
ENV SPARK_VERSION=3.4.1
ENV HADOOP_VERSION=3
ENV JAVA_VERSION=11
ENV SPARK_HOME=${SPARK_HOME:-"/home/spark"}
ENV HADOOP_HOME=${HADOOP_HOME:-"/home/hadoop"}

RUN mkdir -p ${HADOOP_HOME} && mkdir -p ${SPARK_HOME}
WORKDIR ${SPARK_HOME}

# Downalod Spark and Install
# TODO: Always test the url before building image
RUN DOWNLOAD_URL_SPARK="https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" \
    && wget --verbose -O spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz  "${DOWNLOAD_URL_SPARK}"\
    && tar -xf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C /home/spark --strip-components=1 \
    && rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz


FROM spark-base-image as pyspark
# Note:- FROM spark-base-image as pyspark is used to define a new build stage named "pyspark" that is based on a
# previously defined build stage named "spark-base." This syntax is a feature of Docker that allows you to
# create multiple intermediate images in a single Dockerfile, each with its own set of instructions and context.


# Install python deps
COPY requirements/requirements.txt .
RUN pip3 install -r requirements.txt

ENV PATH="/home/spark/sbin:/home/spark/bin:${PATH}"
ENV SPARK_HOME="/home/spark"
ENV SPARK_MASTER="spark://spark-master:7077"
ENV SPARK_MASTER_HOST spark-master
ENV SPARK_MASTER_PORT 7077
ENV PYSPARK_PYTHON python3

COPY conf/spark-defaults.conf "$SPARK_HOME/conf"

RUN chmod u+x /home/spark/sbin/* && \
    chmod u+x /home/spark/bin/*

ENV PYTHONPATH=$SPARK_HOME/python/:$PYTHONPATH

COPY entrypoint.sh .
RUN chmod u+x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
# CMD ["sh", "-c", "tail -f /dev/null"]
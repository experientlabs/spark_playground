FROM python:3.10-buster as spark-base-image

LABEL maintainer="experient-labs"

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

# Download and install Hadoop
RUN curl https://dlcdn.apache.org/hadoop/common/hadoop-3.3.1/hadoop-3.3.1.tar.gz -o hadoop-3.3.1-bin.tar.gz \
 && tar xfz hadoop-3.3.1-bin.tar.gz --directory /opt/hadoop --strip-components 1 \
 && rm -rf hadoop-3.3.1-bin.gz

FROM spark-base-image as pyspark
# Note:- FROM spark-base-image as pyspark is used to define a new build stage named "pyspark" that is based on a
# previously defined build stage named "spark-base." This syntax is a feature of Docker that allows you to
# create multiple intermediate images in a single Dockerfile, each with its own set of instructions and context.


# Install python deps
COPY requirements/requirements.txt .
RUN pip3 install -r requirements.txt

# Set JAVA_HOME environment variable
ENV JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
# Add the Spark and Hadoop bin and sbin to the PATH variable.
# Also add $JAVA_HOME/bin to the PATH
ENV PATH="$SPARK_HOME/sbin:/home/spark/bin:${PATH}"
ENV PATH="$HADOOP_HOME/bin:$HADOOP_HOME/sbin:${PATH}"
ENV PATH="${PATH}:${JAVA_HOME}/bin"

# Setup Spark related environment variables
ENV SPARK_MASTER="spark://spark-yarn-master:7077"
ENV SPARK_MASTER_HOST spark-yarn-master
ENV SPARK_MASTER_PORT 7077
ENV PYSPARK_PYTHON python3
ENV HADOOP_CONF_DIF="$HADOOP_HOME/etc/hadoop"
# Add Hadoop native library path to the dynamic link library path
ENV LD_LIBRARY_PATH="$HADOOP_HOME/lib/native:${LD_LIBRARY_PATH}"


# Set user for HDFS and Yarn (for production probably not smart to put root)
ENV HDFS_NAMENODE_USER="root"
ENV HDFS_DATANODE_USER="root"
ENV HDFS_SECONDARYNAMENODE_USER="root"
ENV YARN_RESOURCEMANAGER_USER="root"
ENV YARN_NODEMANAGER_USER="root"

# Add JAVA_HOME to haddop-env.sh . Strangely Hadoop does not read JAVA_HOME from environment.
RUN echo "export JAVA_HOME=${JAVA_HOME}" >> \
    "$HADOOP_HOME/etc/hadoop/hadoop-env.sh"

# COPY the configuration files to their locations
COPY yarn/spark-defaults.conf "$SPARK_HOME/conf/"
COPY yarn/*.xml "$HADOOP_HOME/etc/hadoop/"

# COPY conf/spark-defaults.conf "$SPARK_HOME/conf"

# Make the binaries and scripts executable and set the PYTHONPATH environment variable
RUN chmod u+x /home/spark/sbin/* && \
    chmod u+x /home/spark/bin/*

ENV PYTHONPATH=$SPARK_HOME/python/:$PYTHONPATH
#ENV PYTHONPATH=$SPARK_HOME/python/lib/py4j-0.10.9.5-src.zip:$PYTHONPATH

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
  chmod 600 ~/.ssh/authorized_keys

COPY ssh_config ~/.ssh/config

# Copy appropriate entrypoint script
COPY entrypoint-yarn.sh entrypoint.sh

EXPOSE 22

ENTRYPOINT ["./entrypoint.sh"]
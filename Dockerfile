FROM python:3.10.9-buster

###########################################
# Upgrade the packages
###########################################
# Download latest listing of available packages:
RUN apt-get -y update
# Upgrade already installed packages:
RUN apt-get -y upgrade
# Install a new package:

###########################################
# install tree package
###########################################
# Install a new package:
RUN apt-get -y install tree


#############################################
# install pipenv
############################################
ENV PIPENV_VENV_IN_PROJECT=1

# ENV PIPENV_VENV_IN_PROJECT=1 is important: it causes the resuling virtual environment to be created as /app/.venv. Without this the environment gets created somewhere surprising, such as /root/.local/share/virtualenvs/app-4PlAip0Q - which makes it much harder to write automation scripts later on.

RUN python -m pip install --upgrade pip

RUN pip install --no-cache-dir pipenv

RUN pip install --no-cache-dir jupyter

RUN pip install --no-cache-dir py4j

RUN pip install --no-cache-dir findspark


#############################################
# install java and spark and hadoop
# Java is required for scala and scala is required for Spark
############################################


# VERSIONS
ENV SPARK_VERSION=3.2.4 \
HADOOP_VERSION=3.2 \
JAVA_VERSION=11

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    "openjdk-${JAVA_VERSION}-jre-headless" \
    ca-certificates-java  \
    curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*


RUN java --version

# DOWNLOAD SPARK AND INSTALL
RUN DOWNLOAD_URL_SPARK="https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" \
    && wget --verbose -O apache-spark.tgz  "${DOWNLOAD_URL_SPARK}"\
    && mkdir -p /home/spark \
    && tar -xf apache-spark.tgz -C /home/spark --strip-components=1 \
    && rm apache-spark.tgz


# SET SPARK ENV VARIABLES
ENV SPARK_HOME="/home/spark"
ENV PATH="${SPARK_HOME}/bin/:${PATH}"

# Fix Spark installation for Java 11 and Apache Arrow library
# see: https://github.com/apache/spark/pull/27356, https://spark.apache.org/docs/latest/#downloading
RUN cp -p "${SPARK_HOME}/conf/spark-defaults.conf.template" "${SPARK_HOME}/conf/spark-defaults.conf" && \
    echo 'spark.driver.extraJavaOptions -Dio.netty.tryReflectionSetAccessible=true' >> "${SPARK_HOME}/conf/spark-defaults.conf" && \
    echo 'spark.executor.extraJavaOptions -Dio.netty.tryReflectionSetAccessible=true' >> "${SPARK_HOME}/conf/spark-defaults.conf"

############################################
# create group and user
############################################

ARG UNAME=sam
ARG UID=1000
ARG GID=1000


RUN cat /etc/passwd

# create group
RUN groupadd -g $GID $UNAME

# create a user with userid 1000 and gid 100
RUN useradd -u $UID -g $GID -m -s /bin/bash $UNAME
# -m creates home directory

# change permissions of /home/sam to 1000:100
RUN chown $UID:$GID /home/sam


###########################################
# add sudo
###########################################

RUN apt-get update --yes
RUN apt-get -y install sudo
RUN apt-get -y install vim
RUN cat /etc/sudoers
RUN echo "$UNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN cat /etc/sudoers

#############################
# spark history server
############################

# ALLOW spark history server (mount sparks_events folder locally to /home/sam/app/spark_events)

RUN echo 'spark.eventLog.enabled true' >> "${SPARK_HOME}/conf/spark-defaults.conf" && \
    echo 'spark.eventLog.dir file:///home/sam/app/spark_events' >> "${SPARK_HOME}/conf/spark-defaults.conf" && \
    echo 'spark.history.fs.logDirectory file:///home/sam/app/spark_events' >> "${SPARK_HOME}/conf/spark-defaults.conf"

RUN mkdir /home/spark/logs
RUN chown $UID:$GID /home/spark/logs

###########################################
# change working dir and user
###########################################

USER $UNAME

RUN mkdir -p /home/$UNAME/app
WORKDIR /home/$UNAME/app
CMD ["sh", "-c", "tail -f /dev/null"]
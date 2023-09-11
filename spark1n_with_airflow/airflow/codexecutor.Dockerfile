# Image used on ec2 boxes: ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20210223

FROM python:3.7.11
ENV PYTHONBUFFERED = 1

RUN apt-get update &&  \
    DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y netcat ssh iputils-ping sudo python3-pip dfault-jdk && \
    mkdir /var/run/sshd && \
    chmod 0755 /var/run/sshd && \
    ssh-keygen -A && \
    useradd -p $(openssl passwd codexecutorpwd) --create-home --shell /bin/bash --groups sudo codexecutor    

RUN mkdir -p var/lib/my-python
RUN chown -R codexecutor /var/lib/my-python
RUN service ssh start

ARG MY_JOB_ENVIRONMENT=${MY_JOB_ENVIRONMENT}
ARG SAVE_TEMP_TABLE=${SAVE_TEMP_TABLE}
ARG MY_SNOWFLAKE_WAREHOUSE_OVERRIDE=${MY_SNOWFLAKE_WAREHOUSE_OVERRIDE}
ARG MY_SNOWFLAKE_DATABASE_OVERRIDE=${MY_SNOWFLAKE_DATABASE_OVERRIDE}
ARG AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
ARG AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
ARG AWS_CLI_DOWNLOAD_PATH=${AWS_CLI_DOWNLOAD_PATH}
ARG S3_TO_DATAWAREHOUSE=${S3_TO_DATAWAREHOUSE_JAR}
RUN mkdir -p /usr/local/s3-to-dws && chown codexecutor:codexecutor /usr/local/s3-to-dwh

USER codexecutor
RUN mkdir -p /home/codexecutor/environments
RUN mkdir /home/codexecutor/.ssh && chmod 700 /home/codexecutor/.ssh
RUN echo "export MY_JOB_ENVIRONMENT=$MY_JOB_ENVIRONMENT" > home/codexecutor/.bash_profile && \
    echo "export MY_SNOWFLAKE_WAREHOUSE_OVERRIDE=$MY_SNOWFLAKE_WAREHOUSE_OVERRIDE" >> home/codexecutor/.bash_profile && \
    echo "export MY_SNOWFLAKE_DATABASE_OVERRIDE=$MY_SNOWFLAKE_DATABASE_OVERRIDE" >> home/codexecutor/.bash_profile && \
    echo "export AWS_REGION=us-east-1" >> home/codexecutor/.bash_profile && \
    echo "export SAVE_TEMP_TABLES=$SAVE_TEMP_TABLES" >> home/codexecutor/.bash_profile && \
    mkdir -p /home/codexecutor/.aws && \
    echo "[default]" >> /home/codexecutor/.aws/credentials && \
    echo "AWS_ACCESS_KEY=$AWS_ACCESS_KEY" >> /home/codexecutor/.aws/credentials && \
    echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> /home/codexecutor/.aws/credentials && \
    echo "AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN" >> /home/codexecutor/.aws/credentials
COPY setup.py /home/codexecutor/environments
COPY /var/lib/my-python/my-etl-warehouse/requirements.txt /home/codexecutor/environments
COPY aws_config /home/codexecutor/.aws/config
COPY --chown=codexecutor:codexecutor id_rsa.pub /home/codexecutor/.ssh/authorized_keys
RUN chmod 600 /home/codexecutor/.ssh/authorized_keys && \
    pip3 install virtualenv && \
    /home/codexecutor/.local/bin/virtualenv /home/codexecutor/environments/my-virtualenv-python37 && \
    pip3 install /home/codexecutor/environments && \
    pip3 install /home/codexecutor/environments/requirements.txt
COPY *.jar /usr/local/s3-to-datawarehouse

USER root
EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]

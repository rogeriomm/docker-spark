FROM ubuntu:20.04

ENV ENABLE_INIT_DAEMON true
ENV INIT_DAEMON_BASE_URI http://identifier/init-daemon
ENV INIT_DAEMON_STEP spark_master_init

ENV HADOOP_VERSION=3.3.1
ENV SPARK_VERSION=3.1.2

ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64 \
    TZ=America/Sao_Paulo

COPY wait-for-step.sh /
COPY execute-step.sh /
COPY finish-step.sh /
RUN chmod +x *.sh

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y \
      openjdk-11-jdk \
      net-tools \
      curl \
      netcat \
      gnupg \
      wget \
      vim \
      links \
      unzip \
      ack \
      locales \
      iptraf \
      tcpdump

RUN locale-gen en_US.UTF-8

ARG SPARK_PKG=spark-${SPARK_VERSION}-bin-custom-spark
#ARG SPARK_PKG=spark-${SPARK_VERSION}-bin-without-hadoop

### Install SPARK
#RUN wget https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz  \
COPY ${SPARK_PKG}.tgz .

RUN    tar -xvzf ${SPARK_PKG}.tgz \
    && mv ${SPARK_PKG} spark \
    && rm ${SPARK_PKG}.tgz \
    && cd /

### Install HADOOP
RUN curl -O https://dist.apache.org/repos/dist/release/hadoop/common/KEYS
RUN gpg --import KEYS

ENV HADOOP_URL https://www.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz

RUN set -x \
    && curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
    && curl -fSL "$HADOOP_URL.asc" -o /tmp/hadoop.tar.gz.asc \
    && gpg --verify /tmp/hadoop.tar.gz.asc \
    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz*

ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
ENV SPARK_HOME=/spark
ENV PATH=$PATH:$SPARK_HOME/bin:$HADOOP_HOME/bin

ENV SPARK_DIST_CLASSPATH="$HADOOP_HOME/etc/hadoop/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/tools/lib/*"

### Download JAVA packages
RUN cd spark ; \
    echo "System.exit(0)" > /tmp/exit.scala ; \
    ./bin/spark-shell  --packages org.apache.hadoop:hadoop-aws:$HADOOP_VERSION,org.apache.hadoop:hadoop-client:$HADOOP_VERSION,org.apache.hadoop:hadoop-common:$HADOOP_VERSION,io.delta:delta-core_2.12:1.0.0,org.apache.iceberg:iceberg-spark3-runtime:0.12.0 \
                      -i /tmp/exit.scala

#Give permission to execute scripts
RUN chmod +x /wait-for-step.sh && chmod +x /execute-step.sh && chmod +x /finish-step.sh

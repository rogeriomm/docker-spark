FROM ubuntu:20.04

LABEL maintainer="Gezim Sejdiu <g.sejdiu@gmail.com>, Giannis Mouchakis <gmouchakis@gmail.com>"

ENV ENABLE_INIT_DAEMON true
ENV INIT_DAEMON_BASE_URI http://identifier/init-daemon
ENV INIT_DAEMON_STEP spark_master_init

ENV SPARK_VERSION=3.1.1
ENV HADOOP_VERSION=3.2

COPY wait-for-step.sh /
COPY execute-step.sh /
COPY finish-step.sh /
RUN chmod +x *.sh

ENV TZ=America/Sao_Paulo

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
      ack

#COPY bde-spark.css /css/org/apache/spark/ui/static/timeline-view.css

RUN wget https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
      && tar -xvzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
      && mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} spark \
      && rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
      && cd /

#RUN apk add --no-cache curl bash openjdk11-jre python3 py-pip nss libc6-compat \
#      && ln -s /lib64/ld-linux-x86-64.so.2 /lib/ld-linux-x86-64.so.2 \
#      && chmod +x *.sh \
#      && wget https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
#      && tar -xvzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
#      && mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} spark \
#      && rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
#      #&& cd /css \
#      #&& jar uf /spark/jars/spark-core_2.11-${SPARK_VERSION}.jar org/apache/spark/ui/static/timeline-view.css \
#      && cd /

#Give permission to execute scripts
RUN chmod +x /wait-for-step.sh && chmod +x /execute-step.sh && chmod +x /finish-step.sh

# Fix the value of PYTHONHASHSEED
# Note: this is needed when you use Python 3.3 or greater
ENV PYTHONHASHSEED 1

# Decide: Install conda to manage python and R packages. Maybe adjust the packages in pip_packages.txt or conda_packages.txt
ARG miniconda_version="py38_4.8.3"
ARG miniconda_sha256="879457af6a0bf5b34b48c12de31d4df0ee2f06a8e68768e5758c3293b2daf688"
# Install python and R packages via conda
COPY conda_packages.txt /conda_packages.txt
# Some python packages are not available via conda, so we are using pip
COPY pip_packages.txt /pip_packages.txt
RUN set -ex && \
    wget -nv https://repo.anaconda.com/miniconda/Miniconda3-${miniconda_version}-Linux-x86_64.sh -O miniconda.sh && \
    echo "${miniconda_sha256} miniconda.sh" > anaconda.sha256 && \
    sha256sum --strict -c anaconda.sha256 && \
    bash miniconda.sh -b -p /opt/conda && \
    export PATH=/opt/conda/bin:$PATH && \
    conda config --set always_yes yes --set changeps1 no && \
    conda info -a && \
    conda config --add channels conda-forge && \
    #conda install -y --quiet --file /conda_packages.txt && \
    conda update -n base -c defaults conda && \
    conda update --all && \
    conda install -y --file /conda_packages.txt && \
    python -m pip install --upgrade pip && \
    pip install -q -r /pip_packages.txt  && \
    # Cleanup
    rm -v miniconda.sh anaconda.sha256  && \
    # Cleanup based on https://github.com/ContinuumIO/docker-images/commit/cac3352bf21a26fa0b97925b578fb24a0fe8c383
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete &&  \
    conda clean -ay
    # Allow to modify conda packages. This allows malicious code to be injected into other interpreter sessions, therefore it is disabled by default
    # chmod -R ug+rwX /opt/conda


FROM openjdk:8u212-jre-slim

ENV ZOOKEEPER_HOME=/opt/zookeeper
ENV ZOOKEEPER_VERSION=3.6.0
ENV ZOOKEEPER_FILENAME=apache-zookeeper-${ZOOKEEPER_VERSION}-bin
ENV ZOOKEEPER_MIRROR=https://downloads.apache.org
ENV ZOOKEEPER_DOWNLOAD_URL=${ZOOKEEPER_MIRROR}/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/${ZOOKEEPER_FILENAME}.tar.gz

RUN apt-get update && apt-get install -y curl && \
  curl -SL ${ZOOKEEPER_DOWNLOAD_URL} | tar -xzC /tmp/ && \
  mv /tmp/${ZOOKEEPER_FILENAME} ${ZOOKEEPER_HOME} && \
  mv ${ZOOKEEPER_HOME}/conf/zoo_sample.cfg ${ZOOKEEPER_HOME}/conf/zoo.cfg 

ENV PATH=${PATH}:${ZOOKEEPER_HOME}/bin

EXPOSE 2181

CMD ["zkServer.sh",  "start-foreground"]

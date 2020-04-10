FROM openjdk:8u212-jre-slim

ENV ZOOKEEPER_HOME=/opt/zookeeper
ENV PATH=${PATH}:${ZOOKEEPER_HOME}/bin

COPY zookeeper-files ${ZOOKEEPER_HOME}

EXPOSE 2181

CMD ["zkServer.sh",  "start-foreground"]

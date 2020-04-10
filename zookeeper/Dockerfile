FROM openjdk:8u212-jre-slim

ENV KAFKA_HOME=/opt/kafka
ENV PATH=${PATH}:${KAFKA_HOME}/bin

COPY kafka-files ${KAFKA_HOME}

EXPOSE 2181

CMD ["zookeeper-server-start.sh", "/opt/kafka/config/zookeeper.properties"]

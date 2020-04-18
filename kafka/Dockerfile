FROM openjdk:8u212-jre-slim

ENV KAFKA_HOME=/opt/kafka
ENV KAFKA_VERSION=2.5.0
ENV KAFKA_FILENAME=kafka_2.12-2.5.0
ENV KAFKA_MIRROR=https://kozyatagi.mirror.guzel.net.tr
ENV KAFKA_DOWNLOAD_URL=${KAFKA_MIRROR}/apache/kafka/${KAFKA_VERSION}/${KAFKA_FILENAME}.tgz

RUN apt-get update && apt-get install -y curl && \
  curl -SL ${KAFKA_DOWNLOAD_URL} | tar -xzC /tmp/ && \
  mv /tmp/${KAFKA_FILENAME} ${KAFKA_HOME}

ENV PATH=${PATH}:${KAFKA_HOME}/bin

COPY start-kafka.sh /usr/bin/

RUN chmod +x /usr/bin/start-kafka.sh

VOLUME ["/tmp/kafka-logs"]
EXPOSE 9092

CMD ["start-kafka.sh"]

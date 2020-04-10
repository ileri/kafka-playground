FROM openjdk:8u212-jre-slim

ENV KAFKA_HOME=/opt/kafka
ENV PATH=${PATH}:${KAFKA_HOME}/bin

COPY start-kafka.sh /usr/bin/
COPY kafka-files /opt/kafka

RUN chmod +x /usr/bin/start-kafka.sh

VOLUME ["/tmp/kafka-logs"]
EXPOSE 9092

CMD ["start-kafka.sh"]

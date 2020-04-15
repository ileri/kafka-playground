class KafkaConsumerJob < ApplicationJob
  queue_as :default

  KAFKA_URL = ENV['KAFKA_URL'] || 'localhost:9092'
  GROUP_ID = ENV['KAFKA_GROUP_ID'] || 'ruby-consumer'
  TOPIC_NAME = ENV['KAFKA_TOPIC_NAME'] || 'time-log'
  VERBOSE = %w[true yes 1].include? ENV['KAFKA_CONSUMER_VERBOSE'].to_s.downcase
  TIMEOUT = ENV['KAFKA_CONNECT_TIMEOUT'] || 30

  def perform
    @kafka = Kafka.new(KAFKA_URL)
    return unless connected_in_timeout?(TIMEOUT)

    consumer = @kafka.consumer(group_id: GROUP_ID)
    consumer.subscribe TOPIC_NAME

    consumer.each_message do |message|
      Message.create(content: message.value)
    end
  end

  def connected_in_timeout?(timeout)
    1.upto(timeout) do |retry_count|
      begin
        @kafka.has_topic? TOPIC_NAME
        return true
      rescue Kafka::ConnectionError
        logger.warn "Connection failed  ##{retry_count} ( URL: #{KAFKA_URL} )"
        sleep 1
      end
    end
    false
  end
end

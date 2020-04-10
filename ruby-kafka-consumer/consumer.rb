#!/usr/bin/env ruby

# frozen_string_literal: true

require 'kafka'

KAFKA_URL = ENV['KAFKA_URL'] || 'localhost:9092'
GROUP_ID = ENV['KAFKA_GROUP_ID'] || 'ruby-consumer'
TOPIC_NAME = ENV['KAFKA_TOPIC_NAME'] || 'time-log'
VERBOSE = %w[true yes 1].include? ENV['KAFKA_CONSUMER_VERBOSE'].to_s.downcase
TIMEOUT = ENV['KAFKA_CONNECT_TIMEOUT'] || 30

def connect_in_timeout(client, timeout)
  1.upto(timeout) do |retry_count|
    begin
      client.topics
      return nil
    rescue Kafka::ConnectionError
      warn "Connection failed. ( #{retry_count} )"
      sleep 1
    end
  end
  exit(1)
end

def main
  kafka = Kafka.new(KAFKA_URL)
  connect_in_timeout(kafka, TIMEOUT)

  consumer = kafka.consumer(group_id: GROUP_ID)
  consumer.subscribe TOPIC_NAME

  consumer.each_message do |message|
    warn "#{message.offset}, Key: #{message.key}, Value: #{message.value}"
  end
end

main if $PROGRAM_NAME == __FILE__

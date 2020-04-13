#!/usr/bin/env ruby

# frozen_string_literal: true

require 'kafka'
require 'listen'

KAFKA_URL = ENV['KAFKA_URL'] || 'localhost:9092'
TOPIC_NAME = ENV['KAFKA_TOPIC_NAME'] || 'time-log'
VERBOSE = %w[true yes 1].include? ENV['KAFKA_PRODUCER_VERBOSE'].to_s.downcase
TIMEOUT = ENV['KAFKA_CONNECT_TIMEOUT'] || 30

LISTEN_DIR = ENV['LISTEN_DIR'] || '/LFS'

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

def create_topic!(client, topic_name)
  client.create_topic(topic_name) unless client.topics.include?(topic_name)
rescue Kafka::TopicAlreadyExists
  warn "Topic already exists: #{topic_name}"
end

def main
  kafka = Kafka.new(KAFKA_URL)
  connect_in_timeout kafka, TIMEOUT
  create_topic! kafka, TOPIC_NAME
  producer = kafka.async_producer

  listener = Listen.to(LISTEN_DIR) do |_, added, _|
    if added.any?
      added.each { |e| producer.produce(e, topic: TOPIC_NAME) }
      producer.deliver_messages
    end
  end
  listener.start
  sleep
end

main if $PROGRAM_NAME == __FILE__

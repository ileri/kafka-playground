class NewFileListenerConsumer < Racecar::Consumer
  subscribes_to ENV['KAFKA_TOPIC_NAME'] || 'new-files'

  def process(message)
    Message.create(content: message.value)
  end
end

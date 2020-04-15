namespace :consumer do
  desc 'Starts Kafka Consumer Job'
  task start: :environment do
    KafkaConsumerJob.perform_later
  end
end

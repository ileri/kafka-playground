FROM ruby:2.7.1-slim

RUN apt-get update && apt-get install build-essential -y

WORKDIR /producer

COPY .ruby-version Gemfile Gemfile.lock ./
RUN bundle install

COPY . ./

CMD ["bundle", "exec", "ruby", "producer.rb"]

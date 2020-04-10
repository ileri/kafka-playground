FROM ruby:2.7.0-slim

WORKDIR /producer

COPY .ruby-version Gemfile Gemfile.lock ./
RUN bundle install

COPY . ./

CMD ["bundle", "exec", "ruby", "producer.rb"]
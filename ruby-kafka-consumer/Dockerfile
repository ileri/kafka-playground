FROM ruby:2.7.1-slim

WORKDIR /consumer

COPY .ruby-version Gemfile Gemfile.lock ./
RUN bundle install

COPY . ./

CMD ["bundle", "exec", "ruby", "consumer.rb"]

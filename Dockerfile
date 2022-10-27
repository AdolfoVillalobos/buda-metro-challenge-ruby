FROM ruby:2.7

RUN mkdir /app
WORKDIR /app

ADD . /app

RUN bundle install

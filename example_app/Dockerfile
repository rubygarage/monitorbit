FROM ruby:2.6.4-alpine

RUN apk add build-base tzdata git postgresql-dev nodejs yarn imagemagick

ENV APP_DIR /app

WORKDIR $APP_DIR

COPY Gemfile $APP_DIR
COPY Gemfile.lock $APP_DIR

RUN gem i bundler -v $(tail -1 Gemfile.lock | tr -d ' ')

RUN bundle --jobs=$(nproc)

COPY package.json $APP_DIR

RUN yarn

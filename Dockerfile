FROM ruby:2.5-slim

RUN apt-get update
RUN apt-get install -y --no-install-recommends postgresql-client \
  build-essential patch ruby-dev zlib1g-dev liblzma-dev libpq-dev \
  curl
RUN rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY Gemfile* ./
RUN bundle install
COPY . .

EXPOSE 3000

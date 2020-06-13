FROM ruby:alpine
RUN sed -i 's/http\:\/\/dl-cdn.alpinelinux.org/http\:\/\/mirror.clarkson.edu/g' /etc/apk/repositories
RUN apk add --update build-base tzdata

WORKDIR /usr/src/app
COPY Gemfile* ./
ENV BUNDLE_PATH /gems
RUN bundle check || bundle
COPY . ./

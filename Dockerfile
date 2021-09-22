FROM ruby:2.7.1

RUN apt-get update

WORKDIR /usr/src/app

COPY . .

RUN gem install bundler:2.2.15 && \
    bundle install && \
    rake install:local

CMD ["/bin/bash"]
################################################################################
# BASE
################################################################################
FROM ruby:3.4-slim AS base

ARG UID=1000
ARG GID=1000

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  build-essential \
  libssl-dev \
  libtool \
  libyaml-dev

RUN groupadd -g ${GID} -o app
RUN useradd -m -d /app -u ${UID} -g ${GID} -o -s /bin/bash app

ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true
ENV BUNDLE_PATH /app/vendor/bundle

# Change to app and back so that bundler created files in /gmes are owned by the
# app user
USER app
RUN gem install bundler
USER root

WORKDIR /app

CMD ["sh", "-c", "bin/rails s"]

################################################################################
# DEVELOPMENT                                           								       # 
################################################################################
FROM base AS development

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  vim-tiny

USER app

################################################################################
# PRODUCTION                                                                   #
################################################################################
FROM base AS production

ENV RAILS_ENV production
ENV BUNDLE_WITHOUT=development:test

COPY --chown=${UID}:${GID} . /app

USER app

RUN bundle install

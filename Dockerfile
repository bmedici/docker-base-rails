# Docker headers
FROM ruby:2.6.3-alpine3.10
MAINTAINER Bruno MEDICI <opensource@bmconseil.com>

# Environment
ENV LANG=C.UTF-8
ENV LANG=C.UTF-8
ENV RAILS_ENV production 
ENV RACK_ENV production
# ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true


# Work dir
ENV INSTALL_PATH /app/
RUN mkdir -p              $INSTALL_PATH
WORKDIR                   $INSTALL_PATH


# Dependencies
RUN \
  # update packages
  apk update && \
  apk upgrade && \

  bundle config --global build.nokogiri --use-system-libraries && \
  apk --no-cache add make g++ && \
  apk --no-cache add ruby ruby-dev ruby-bundler ruby-json ruby-irb ruby-rake ruby-bigdecimal && \
  apk --no-cache add libxml2-dev libxslt-dev && \
  apk --no-cache add mysql-dev && \
  apk --no-cache add nodejs && \
  apk --no-cache add ca-certificates git && \
  apk --no-cache add bzip2-dev && \
  apk --no-cache add yarn && \
  apk --no-cache add tzdata && \
  apk --no-cache add libressl-dev && \
  apk --no-cache add libc6-compat && \

  # clear after installation
  rm -rf /var/cache/apk/*

# Yarn
RUN yarn add --dev webpack webpack-dev-server


# Bundler and basic gems
ADD Gemfile Gemfile.lock  $INSTALL_PATH
RUN gem install bundler && bundle config git.allow_insecure true && bundle install --system --without="development test" -j4

FROM ruby:3.0.4

EXPOSE 4567

RUN apt-get update -qq && \
    apt-get install -y nodejs

RUN adduser middleman
USER middleman
WORKDIR /home/middleman

COPY --chown=middleman Gemfile Gemfile.lock ./
RUN bundle install

COPY --chown=middleman . ./

ENTRYPOINT [ "bundle", "exec" ]
CMD [ "middleman", "server", "--bind-address", "0.0.0.0", "--port", "4567" ]

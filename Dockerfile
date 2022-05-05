ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION:-2.7.4}

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		postgresql-client \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /myapp
COPY Gemfile* ./
RUN bundle update --bundler
RUN bundle install
COPY . .

EXPOSE 3000
ARG RAILS_ENV
ENV RAILS_ENV=${RAILS_ENV:-docker}
CMD ["sh", "/myapp/init.sh"]

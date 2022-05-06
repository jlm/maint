ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION:-2.7.4}

RUN apt update \
	&& apt install -y --no-install-recommends \
		postgresql-client \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash \
    && apt install -y nodejs \
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

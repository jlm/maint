FROM ruby:2.7.1

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		postgresql-client \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle update --bundler
RUN bundle install
COPY . .

EXPOSE 3000
ENV RAILS_ENV=docker
CMD ["sh", "/usr/src/app/init.sh"]

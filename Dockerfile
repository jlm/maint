ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION:-2.7.8}

ARG NODE_MAJOR=20
RUN apt update \
	&& apt install -y --no-install-recommends \
		postgresql-client \
        ca-certificates \
        curl \
        gnupg \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    && apt update \
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

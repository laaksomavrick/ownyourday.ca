FROM ruby:3.1.2 AS builder

WORKDIR /builder

ARG RAILS_MASTER_KEY
ARG PORT
ARG RAILS_ENV="production"

ENV RAILS_ENV="${RAILS_ENV}" \
    PORT="${PORT}" \
    RAILS_MASTER_KEY=${RAILS_MASTER_KEY}

RUN apt-get update \
  && apt-get install -y --no-install-recommends libpq-dev

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs "$(nproc)"

COPY . .

RUN if [ "${RAILS_ENV}" != "development" ]; then \
  SECRET_KEY_BASE=dummyvalue rails assets:precompile; fi

FROM ruby:3.1.2 AS app

WORKDIR /app

ARG UID=1000
ARG GID=1000

ARG RAILS_MASTER_KEY
ARG PORT
ARG RAILS_ENV="production"

#RUN groupadd -g "${GID}" ruby \
#  && useradd --create-home --no-log-init -u "${UID}" -g "${GID}" ruby \
#  && chown ruby:ruby -R /app
#
#USER ruby

ENV RAILS_ENV="${RAILS_ENV}" \
    PORT="${PORT}" \
#    USER="ruby" \
    RAILS_MASTER_KEY=${RAILS_MASTER_KEY}

#COPY --chown=ruby:ruby --from=builder /usr/local/bundle /usr/local/bundle
#COPY --chown=ruby:ruby --from=builder /builder/public /public
#COPY --chown=ruby:ruby --from=builder /builder ./

COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /builder/public /public
COPY --from=builder /builder ./

ENTRYPOINT ["/app/bin/docker-entrypoint-web"]

EXPOSE ${PORT}

CMD PORT=${PORT} rails s

.PHONY: up
up:
	@docker-compose -f docker-compose.local.yml up -d

.PHONY: down
down:
	@docker-compose -f docker-compose.local.yml down

.PHONY: serve
serve:
	@bin/dev

.PHONY: migrate
migrate:
	@bundler exec rails db:migrate

.PHONY: seed
seed:
	@bundler exec rails db:seed:replant

.PHONY: test
test:
	@bundler exec rspec

.PHONY: format
format:
	@bundler exec rubocop -A && pnpm run format && pnpm run lint

.PHONY: check-format
check-format:
	@bundler exec rubocop --fail-level=warning

.PHONY: build
build:
	@docker build --build-arg RAILS_MASTER_KEY=$(cat config/master.key) -f Dockerfile -t ownyourday:latest .

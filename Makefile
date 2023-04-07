.PHONY: up
up:
	@docker-compose -f docker-compose.local.yml up -d

.PHONY: serve
serve:
	@bundler exec rails s

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
	@bundler exec rubocop -A

.PHONY: check-format
check-format:
	@bundler exec rubocop --fail-level=warning

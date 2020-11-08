RUN := docker-compose run --rm app
CHANGED := git diff origin/main... --name-only --diff-filter=d

run:
	$(RUN)
test:
	$(RUN) bundle exec rspec $(filter-out $@,$(MAKECMDGOALS))
rubocop:
	$(RUN) bundle exec rubocop --force-exclusion `$(CHANGED)`
bash:
	$(RUN) sh
stop:
	docker-compose stop
clean:
	docker-compose down

RUN := docker-compose run --rm app

run:
	$(RUN)
test:
	$(RUN) bundle exec rspec $(filter-out $@,$(MAKECMDGOALS))
rubocop:
	$(RUN) bundle exec rubocop $(filter-out $@,$(MAKECMDGOALS))
bash:
	$(RUN) sh
stop:
	docker-compose stop
clean:
	docker-compose down

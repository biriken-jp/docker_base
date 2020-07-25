#!make
DOCKER_DIR=./docker
-include .env
export
DC=docker-compose
STAGE=local
all:
# Docker
build:
	@$(DC) build
up:
	@$(DC) up -d
down:
	@$(DC) down
restart:
	@$(DC) restart
reload:
	@$(DC) down
	@$(DC) up -d
ps:
	@$(DC) ps
exec:
	@$(DC) exec $(NAME) bash
clean:
	@docker image prune
	@docker volume prune
drop:
	@docker ps -aq | xargs docker rm
	@docker images -aq | xargs docker rmi

# インストール設定
make_setting_file:
	@cp .env-$(STAGE) .env
	@cp docker-compose-$(STAGE).yml docker-compose.yml

install:
	@make make_setting_file

	@$(DC) up -d

	@make composer C="install"
	@make yarn
	@make install_$(STAGE)

install_local:
	@make artisan_ C="key:generate"
	@make yarn_run_dev
	@make composer C="db_r_s"


# 開発
# PHP
composer:
	@$(DC) run --rm composer $(C)
artisan_:
	@$(DC) run --rm artisan $(C)

# node
npm:
	@$(DC) exec node npm $(C)
yarn:
	@$(DC) exec node yarn $(C)
yarn_run_prod:
	@$(DC) exec node yarn run prod
yarn_run_dev:
	@$(DC) exec node yarn run dev
yarn_run_watch:
	@$(DC) exec node yarn watch
yarn_run_watch_poll:
	@$(DC) exec node yarn run watch-poll

##########################
### PHP test
##########################
test:
	docker-compose run --rm php-cli ./vendor/bin/phpcbf --standard=/var/www/html/ruleset.xml
	docker-compose run --rm php-cli ./vendor/bin/phpcs --standard=/var/www/html/ruleset.xml
	docker-compose run --rm php-cli ./vendor/bin/phpunit

phpcs:
	docker-compose run --rm php-cli ./vendor/bin/phpcs --standard=/var/www/html/ruleset.xml

phpcbf:
	docker-compose run --rm php-cli ./vendor/bin/phpcbf --standard=/var/www/html/ruleset.xml


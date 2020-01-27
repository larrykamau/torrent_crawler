.PHONY: help
PROJECT_NAME ?= torrentscraper-backend
DOCKER_DEV_COMPOSE_FILE := docker/dev/docker-compose.yml
DOCKER_TEST_COMPOSE_FILE := docker/test/docker-compose.yml
DOCKER_TEST_DIR := docker/test
TARGET_MAX_CHAR_NUM=10

# a variable that stores application's container id if the container is running
CONTAINER_ID := $(shell docker-compose -f docker/dev/docker-compose.yml ps -q app)
ifeq ($(CONTAINER_ID),)
	CONTAINER := $(shell docker-compose -f docker/dev/docker-compose.yml ps -q app)
else
	CONTAINER := $(shell docker ps -q --no-trunc | grep $$(docker-compose -f docker/dev/docker-compose.yml ps -q app))
endif

# function that displays an error to user if the application is not running
define container_err
	${INFO} "Please execute \"make start\" on a different terminal tab before running \"make migrate\""
endef

## Show help
help:
	@echo ''
	@echo 'Usage:'
	@echo '${YELLOW} make ${RESET} ${GREEN}<target> [options]${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		message = match(lastLine, /^## (.*)/); \
		if (message) { \
			command = substr($$1, 0, index($$1, ":")-1); \
			message = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${YELLOW}%-$(TARGET_MAX_CHAR_NUM)s${RESET} %s\n", command, message; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
	@echo ''

## Start local development server containers
start:
	${INFO} "Creating postgresql database volume"
	@ docker volume create --name=torrentscraper_data > /dev/null
	@ echo "  "
	@ ${INFO} "Building required docker images"
	@ docker-compose -f $(DOCKER_DEV_COMPOSE_FILE) build app
	@ ${INFO} "Build Completed successfully"
	@ echo " "
	@ ${INFO} "Starting local development server"
	@ docker-compose -f $(DOCKER_DEV_COMPOSE_FILE) up

## Stop local development server containers
stop:
	${INFO} "Stop development server containers"
	@ docker-compose -f $(DOCKER_DEV_COMPOSE_FILE) down -v
	${INFO} "All containers stopped successfully"

## Run torrentscraper local test suites
test:
	@ ${INFO} "Building required docker images"
	@ docker-compose -f $(DOCKER_TEST_COMPOSE_FILE) build test
	${INFO} "Running local torrentscraper test suites"
	@ docker-compose -f $(DOCKER_TEST_COMPOSE_FILE) run --rm test tox
	${INFO} "Stop and remove docker containers"
	@ docker-compose -f $(DOCKER_TEST_COMPOSE_FILE) down
	${SUCCESS} "Docker containers stopped and removed successfully"

## Remove all development containers and volumes
clean:
	${INFO} "Cleaning your local environment"
	${INFO} "Note all ephemeral volumes will be destroyed"
	@ docker-compose -f $(DOCKER_DEV_COMPOSE_FILE) down -v
	@ docker-compose -f $(DOCKER_TEST_COMPOSE_FILE) down -v
	@ docker volume rm torrentscraper_data
	@ docker images -q -f label=application=$(PROJECT_NAME) | xargs -I ARGS docker rmi -f ARGS
	${INFO} "Removing dangling images"
	@ docker images -q -f dangling=true -f label=application=$(PROJECT_NAME) | xargs -I ARGS docker rmi -f ARGS
	@ docker system prune
	${INFO} "Clean complete"

## [ service ] Ssh into service container
ssh:
ifeq ($(CONTAINER),)
	$(call container_err)
else
	${INFO} "Open app container terminal"
	@ docker-compose -f $(DOCKER_DEV_COMPOSE_FILE) exec app sh
endif

## run migrations, the application needs to be running using make start
migrate:
ifeq ($(CONTAINER),)
	$(call container_err)
else
	${INFO} "Running torrentscraper migrations"
	@docker-compose -f $(DOCKER_DEV_COMPOSE_FILE) exec app python3 manage.py makemigrations && python3 manage.py migrate
	${SUCCESS} "Migration executed successfully"
endif

# COLORS
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
NC := "\e[0m"
RESET  := $(shell tput -Txterm sgr0)
# Shell Functions
INFO := @bash -c 'printf "\n"; printf $(YELLOW); echo "===> $$1"; printf "\n"; printf $(NC)' SOME_VALUE
SUCCESS := @bash -c 'printf "\n"; printf $(GREEN); echo "===> $$1"; printf "\n"; printf $(NC)' SOME_VALUE

# Substitute your own docker index username, if you like.
DOCKER_USER=internavenue
DOCKER_REPO_NAME=centos-jenkins

# Change this to suit your needs.
CONTAINER_NAME:=lon-dev-jenkins1
LOG_DIR:=/srv/docker/lon-dev-jenkins1/log
LIB_DIR:=/srv/docker/lon-dev-jenkins1/lib
CACHE_DIR:=/srv/docker/lon-dev-jenkins1/cache
VAGRANT_DIR:=/srv/docker/vagrant_drive
RUNNING:=$(shell docker ps | grep "$(CONTAINER_NAME) " | cut -f 1 -d ' ')
ALL:=$(shell docker ps -a | grep "$(CONTAINER_NAME) " | cut -f 1 -d ' ')

# Because of a bug, the container has to run as privileged,
# otherwise you end up with "could not open session" error.
DOCKER_RUN_COMMON=--name="$(CONTAINER_NAME)" \
        --privileged \
	-P \
	-v $(LIB_DIR):/var/lib/jenkins \
	-v $(CACHE_DIR):/var/cache/jenkins/war \
	-v $(LOG_DIR):/var/log \
	$(DOCKER_USER)/$(DOCKER_REPO_NAME)

all: build

dir:
	mkdir -p $(LOG_DIR)
	mkdir -p $(LIB_DIR)
	mkdir -p $(CACHE_DIR)

build:
	docker build -t="$(DOCKER_USER)/$(DOCKER_REPO_NAME)" .

run: clean dir
	docker run -d $(DOCKER_RUN_COMMON)

bash: clean dir
	docker run --privileged -t -i $(DOCKER_RUN_COMMON) /bin/bash

# Removes existing containers.
clean:
ifneq ($(strip $(RUNNING)),)
	docker stop $(RUNNING)
endif
ifneq ($(strip $(ALL)),)
	docker rm $(ALL)
endif

# Deletes the directories.
deepclean: clean
	sudo rm -rf $(LOG_DIR)/*
	sudo rm -rf $(LIB_DIR)/*
	sudo rm -rf $(CACHE_DIR)/*

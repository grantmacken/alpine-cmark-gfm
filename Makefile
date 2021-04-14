SHELL=/bin/bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --silent
###################################
include .env
ENV_ALPINE = $(shell grep -oP 'FROM_ALPINE=\K(.+)' .env)
DF_ALPINE = $(shell grep -oP 'FROM alpine:\K(.+)' Dockerfile)
###############################################
# https://github.com/commonmark/cmark/releases
###############################################
.PHONY: build
build:
	@#export DOCKER_BUILDKIT=1;
	@#if [[ '$(ENV_ALPINE)' = '$(DF_ALPINE)' ]] 
	#then 
	#echo 'FROM_ALPINE_TAG: $(ENV_ALPINE) '
	#else 
	#echo ' - updating Dockerfile to Alpine tag: $(ENV_ALPINE) '
	#sed -i 's/alpine:$(DF_ALPINE)/alpine:$(ENV_ALPINE)/g' Dockerfile 
	#docker pull alpine:$(ENV_ALPINE)
	#fi
	@docker buildx build --output "type=image,push=false" \
  --tag docker.pkg.github.com/$(REPO_OWNER)/$(REPO_NAME)/$(PKG_NAME):$(CMARK_VER) \
  --tag $(DOCKER_IMAGE):$(CMARK_GFM_RELEASE) \
  --build-arg CMARK_GFM_RELEASE='$(CMARK_GFM_RELEASE)' \
.

.PHONY: run
run:
	@echo 'hello world' | docker run --rm --interactive \
  docker.pkg.github.com/$(REPO_OWNER)/$(REPO_NAME)/$(PKG_NAME):$(CMARK_VER)


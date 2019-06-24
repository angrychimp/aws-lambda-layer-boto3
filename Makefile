.PHONY: publish, build, rebuild, clean

-include vars.txt

BUCKET_NAME ?= lambda-layer-build-bucket
LAYER_NAME ?= boto3-layer
RUNTIMES ?= python3.6 python3.7
BOTO3_VERSION ?= $(shell curl -s https://pypi.org/pypi/boto3/json | python -c "from __future__ import print_function; import sys; import json; print(json.loads(sys.stdin.read())['info']['version'])")
REQUIRE_REBUILD := $(shell [ -z $(docker image ls | grep build-boto3-randy-layer) ] && echo build-image)

$(LAYER_NAME).zip: build

clean:
	-rm -v *.zip requirements.txt
	-docker image rm build-$(LAYER_NAME)-layer

requirements:
	@echo "boto3==$(BOTO3_VERSION)" > requirements.txt

publish: 
	aws s3 cp $(LAYER_NAME).zip s3://$(BUCKET_NAME)/
	aws lambda publish-layer-version \
          --layer-name $(LAYER_NAME) \
          --description "boto3 v$(BOTO3_VERSION)" \
          --content S3Bucket=$(BUCKET_NAME),S3Key=$(LAYER_NAME).zip \
          --compatible-runtimes $(RUNTIMES)

rebuild: requirements build-image build

build-image:
	docker build -t build-$(LAYER_NAME)-layer .

build: requirements $(REQUIRE_REBUILD)
	@docker run --rm -iv$(PWD):/host build-$(LAYER_NAME)-layer sh -c "/var/task/prep.sh && chown -v $(shell id -u):$(shell id -g) /tmp/build.zip && cp -va /tmp/build.zip /host/$(LAYER_NAME).zip"
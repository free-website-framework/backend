include build.env
export

IMAGE_TAG := $(shell git rev-parse --short HEAD)

AWS_ACCOUNT_ID := $(shell aws sts get-caller-identity --query Account --output text)
ECR_URL := $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com
IMAGE_URI := $(ECR_URL)/$(ECR_REPOSITORY)

.PHONY: login push

login:
	aws ecr get-login-password --region $(AWS_REGION) | \
	docker login --username AWS --password-stdin $(ECR_URL)

build:
	docker build \
	--platform $(PLATFORM) \
	--provenance=false \
	--build-arg PYTHON_VERSION=$(PYTHON_VERSION) \
	-t $(IMAGE_URI):$(IMAGE_TAG) .

push: login build
	docker push $(IMAGE_URI):$(IMAGE_TAG)

lambda: push
	aws lambda update-function-code \
	--function-name $(LAMBDA_FUNCTION_NAME) \
	--image-uri $(IMAGE_URI):$(IMAGE_TAG)

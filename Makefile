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

push: login
	IMAGE_URI=$(IMAGE_URI) \
	IMAGE_TAG=$(IMAGE_TAG) \
	PLATFORM=$(PLATFORM) \
	PYTHON_VERSION=$(PYTHON_VERSION) \
	docker buildx bake --push

lambda: push
	aws lambda update-function-code \
	--function-name $(LAMBDA_FUNCTION_NAME) \
	--image-uri $(IMAGE_URI):$(IMAGE_TAG)

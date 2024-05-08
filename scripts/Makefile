BUILD_DIR := /Users/marwanekoutar/Documents/school/BP/Vapor-VS-Hummingbird-On-AWS-Lambda/.aws-sam/build
SWIFT_DOCKER_IMAGE := vapor-vs-hummingbird-on-aws-lambda
VOLUME_MOUNT := /Users/marwanekoutar/Documents/school/BP/Vapor-VS-Hummingbird-On-AWS-Lambda
CONTAINER_DIR := /tmp/VaporApp
HUMMINGBIRDLAMBDA_DIR := ../project/HummingbirdLambda
VAPOR_BUILD_SCRIPT := scripts/vapor.sh

.PHONY: build-HummingbirdApp build-VaporApp

build-HummingbirdApp:
	docker inspect $(SWIFT_DOCKER_IMAGE) >/dev/null 2>&1 || docker build -t $(SWIFT_DOCKER_IMAGE) .;
	cd $(HUMMINGBIRDLAMBDA_DIR) && \
	swift package --disable-sandbox plugin archive --base-docker-image $(SWIFT_DOCKER_IMAGE) --disable-docker-image-update --output-path $(BUILD_DIR);
	rm -rf $(BUILD_DIR)/HummingbirdApp/bootstrap $(BUILD_DIR)/HummingbirdApp/HummingbirdApp;

build-VaporApp:
	docker inspect $(SWIFT_DOCKER_IMAGE) >/dev/null 2>&1 || docker build -t $(SWIFT_DOCKER_IMAGE) .;
	docker run \
			--rm \
			-v $(VOLUME_MOUNT):$(CONTAINER_DIR) \
			-w $(CONTAINER_DIR) \
			--name $(SWIFT_DOCKER_IMAGE) \
			$(SWIFT_DOCKER_IMAGE) \
			/bin/sh -c "chmod +x $(VAPOR_BUILD_SCRIPT) && $(VAPOR_BUILD_SCRIPT)";

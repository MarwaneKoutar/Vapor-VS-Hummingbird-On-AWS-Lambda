BUILD_DIR := /Users/marwanekoutar/Documents/school/BP/Vapor-VS-Hummingbird-On-AWS-Lambda/.aws-sam/build
SWIFT_DOCKER_IMAGE := swift-lambda-builder-workaround
VOLUME_MOUNT := /Users/marwanekoutar/Documents/school/BP/Vapor-VS-Hummingbird-On-AWS-Lambda/project/VaporLambda

.PHONY: build-HummingbirdApp build-VaporApp

build-HummingbirdApp:
	cd project/HummingbirdLambda && \
	swift package --disable-sandbox plugin archive --base-docker-image $(SWIFT_DOCKER_IMAGE) --disable-docker-image-update --output-path $(BUILD_DIR);

build-VaporApp:
	echo "Building VaporApp";
	docker build -t $(SWIFT_DOCKER_IMAGE)-vapor .; \
	docker run \
			-v ./project/VaporLambda:/tmp/VaporApp \
			-w /tmp/VaporApp \
			-d \
			--name $(SWIFT_DOCKER_IMAGE)-vapor \
			$(SWIFT_DOCKER_IMAGE)-vapor \
			/bin/sh -c "cd project/VaporLambda && swift build --product VaporApp -c release && cd ../.. && chmod +x scripts/package.sh && scripts/package.sh VaporApp" && \
	docker wait $(SWIFT_DOCKER_IMAGE)-vapor && \
	docker cp $(SWIFT_DOCKER_IMAGE)-vapor:/tmp/VaporApp/.aws-sam/build/VaporApp/VaporApp.zip $(BUILD_DIR)/VaporApp && \
	docker rm $(SWIFT_DOCKER_IMAGE)-vapor

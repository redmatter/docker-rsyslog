.PHONY: build

build:
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $(shell pwd):/build -it redmatter/dockerize


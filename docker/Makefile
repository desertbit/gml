VERSION = v0.1.0
CROSSBUILD_IMAGES = linux linux-static win64 win64-static

$(CROSSBUILD_IMAGES): %: generate
	docker build --pull --no-cache ./ -f .$@.dockerfile.gen -t desertbit/gml:$@-$(VERSION)

generate:
	go run scripts/generate.go ./ $(VERSION)

.PHONY: $(CROSSBUILD_IMAGES)
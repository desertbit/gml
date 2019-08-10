CROSSBUILD_IMAGES = linux android windows windows_64_shared windows_32_shared

$(CROSSBUILD_IMAGES): %: generate
	docker build --no-cache ./ -f $@/Dockerfile -t desertbit/gml:$@

generate:
	go run generate.go

.PHONY: $(CROSSBUILD_IMAGES)
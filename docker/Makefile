CROSSBUILD_IMAGES = linux android windows windows_64_static windows_32_static

$(CROSSBUILD_IMAGES): %: generate
	docker build ./ -f $@/Dockerfile -t desertbit/gml:$@

generate:
	go run generate.go

.PHONY: $(CROSSBUILD_IMAGES)
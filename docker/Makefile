CROSSBUILD_IMAGES = linux-x86_64-shared

$(CROSSBUILD_IMAGES): %:
	docker build $@ -t desertbit/gml:$@

.PHONY: $(CROSSBUILD_IMAGES)
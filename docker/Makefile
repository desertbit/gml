CROSSBUILD_IMAGES = linux windows_64_static

$(CROSSBUILD_IMAGES): %:
	awk '/import common.base/{system("cat common/base");next}1' $@/Dockerfile.in > $@/Dockerfile
	cp -f common/entrypoint.sh $@/entrypoint.sh
	docker build $@ -t desertbit/gml:$@
	rm -f $@/Dockerfile
	rm -f $@/entrypoint.sh

.PHONY: $(CROSSBUILD_IMAGES)
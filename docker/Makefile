CROSSBUILD_IMAGES = linux windows_64_static

$(CROSSBUILD_IMAGES): %:
	echo "# This file is auto-generated." > $@/Dockerfile
	awk '/import common.base/{system("cat common/base");next}1' $@/Dockerfile.in >> $@/Dockerfile
	docker build ./ -f $@/Dockerfile -t desertbit/gml:$@

.PHONY: $(CROSSBUILD_IMAGES)
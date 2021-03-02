
#export RELEASE = 16.04
#export RELEASE = 19.10
export RELEASE = 20.04

image:
	@echo Building urlview for "'"$$RELEASE"'"...
	docker build --build-arg RELEASE -t build-urlview .

explore:
	docker run --rm -it build-urlview

copies: image
	container=$$(docker create build-urlview) \
	&& docker cp $$container:/urlview-0.9/urlview . \
	&& docker cp $$container:out.tar . \
	&& tar xf out.tar \
	&& rm out.tar \
	&& docker rm -v $$container

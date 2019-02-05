
image:
	docker build -t build-urlview .

explore:
	docker run --rm -it build-urlview

copies: image
	container=$$(docker create build-urlview) \
	&& docker cp $$container:/urlview-0.9/urlview . \
	&& docker cp $$container:/urlview_0.9-20.1_amd64.deb . \
	&& docker rm -v $$container


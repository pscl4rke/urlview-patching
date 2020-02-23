
image:
	docker build -t build-urlview .

explore:
	docker run --rm -it build-urlview

copies: image
	container=$$(docker create build-urlview) \
	&& docker cp $$container:/urlview-0.9/urlview . \
	&& docker cp $$container:out.tar . \
	&& tar xf out.tar \
	&& rm out.tar \
	&& docker rm -v $$container


ARG RELEASE
FROM ubuntu:${RELEASE}

RUN sed -i 's/# deb-src /deb-src /' /etc/apt/sources.list \
 && apt-get update \
 && apt-get install -y tzdata \
 && apt-get install -y devscripts build-essential gcc fakeroot --no-install-recommends \
 && apt-get install -y dpkg-dev --no-install-recommends \
 && apt-get source urlview \
 && apt-get build-dep -y urlview --no-install-recommends

WORKDIR urlview-0.9
RUN sed -i 's|Package: urlview|Package: urlview-patched|' debian/control \
 && sed -i '/^Depends:/ a Provides: urlview' debian/control \
 && sed -i '/^Depends:/ a Conflicts: urlview' debian/control \
 && sed -i 's|debian/urlview/|debian/urlview-patched/|g' debian/rules \
 && cat debian/control \
 && dch -n "Fix Metadata."

COPY thepatch.diff /thepatch.diff
RUN cat /thepatch.diff | patch -p1
RUN dch -n "Apply thepatch."

RUN debuild -us -uc

# Wrap up in a tar so we don't need to care exactly which version is
# used in the filename:
RUN cd / && tar cf out.tar *.deb

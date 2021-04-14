# syntax=docker/dockerfile:experimental
FROM alpine:latest as bld
ARG CMARK_GFM_RELEASE

WORKDIR = /home
ADD https://github.com/github/cmark-gfm/archive/refs/tags/${CMARK_GFM_RELEASE}.tar.gz ./cmark-gfm.tar.gz

RUN  apk add --virtual .build-deps build-base cmake \
    && tar -zxvf ./cmark-gfm.tar.gz -C /tmp \
    && cd /tmp/cmark-gfm-${CMARK_GFM_RELEASE} \
    && cmake \
    && make install \
    && cd /home \
    && apk del .build-deps \
    && echo '---------------------------'

FROM alpine:latest
COPY --from=bld /usr/local /usr/local
ENTRYPOINT ["/usr/local/bin/cmark-gfm"]


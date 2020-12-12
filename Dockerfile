# Use latest alpine base image
FROM alpine:latest

# Install curl
RUN apk add --no-cache curl bash tzdata

# Set version label
LABEL build_version="nettest, Version: 1.0.00, Build-date: 2020.12.11"
LABEL maintainer=labmaster-kc

# Copy convert shell scripts to /opt
COPY nettest_script /opt/

# Set scripts as executable
RUN chmod +rxxx /opt/nettest_script

# Set default docker variables
ENV NET_CHECK=${NET_CHECK:-900}
ENV TZ=${TZ:-America/New_York}

ENV DOMAIN=${DOMAIN:-NULL}
ENV SUB_DOMAIN=${SUB_DOMAIN:-@}
ENV API_KEY=${API_KEY:-NULL}
ENV API_SECRET=${API_SECRET:-NULL}
ENV PUID=${PUID:-0}
ENV PGID=${PGID:-0}

#CMD /opt/nettest_script ${DOMAIN} ${SUB_DOMAIN} ${API_KEY} ${DNS_CHECK} ${TIME_ZONE} ${PUID} ${PGID} ${API_SECRET}
CMD /opt/nettest_script ${NET_CHECK} ${TZ}

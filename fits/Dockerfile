FROM ghcr.io/lehigh-university-libraries/scyllaridae:main@sha256:e962c522e49dd48afc11792b89505895ab29a37044ea95591881e299f856c27e

RUN apk update && apk upgrade && \
    apk add openjdk17-jre-headless

# Set JAVA_HOME environment variable (optional, but good practice)
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin

WORKDIR /app

RUN curl -LO https://github.com/harvard-lts/fits/releases/download/1.6.0/fits-1.6.0.zip

# Unzip fits, but don't clobber the Dockerfile.
RUN unzip -n fits-1.6.0.zip -d . && rm fits-1.6.0.zip

ENV JAVA_OPTS="-Xmx2g -Djava.awt.headless=true" \
    SKIP_JWT_VERIFY=true

COPY scyllaridae.yml .
COPY cmd.sh .
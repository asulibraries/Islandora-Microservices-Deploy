FROM islandora/scyllaridae:main@sha256:5b57f5a361caeb554cc631f8874ec5199156069918db5cca4e8f933f3d6b10d9

RUN apk update && apk upgrade && \
    apk add --no-cache 'openjdk17-jre-headless>=17.0.21.1_p2-r0'

# Set JAVA_HOME for Alpine OpenJDK 17.
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk
ENV PATH="${JAVA_HOME}/bin:${PATH}"

WORKDIR /app

RUN curl -LO https://github.com/harvard-lts/fits/releases/download/1.6.0/fits-1.6.0.zip

# Unzip FITS, but don't clobber the Dockerfile.
RUN unzip -n fits-1.6.0.zip -d . && rm fits-1.6.0.zip

# Scyllaridae runs FITS as an unprivileged user. Keep logs out of
# the derivative output by writing them to a known writable location.
RUN sed -i \
        's#fileName="./fits.log"#fileName="/tmp/fits.log"#' \
        /app/log4j2.xml && \
    grep -q 'fileName="/tmp/fits.log"' /app/log4j2.xml

ENV JAVA_OPTS="-Xmx2g -Djava.awt.headless=true" \
    SKIP_JWT_VERIFY=true

COPY scyllaridae.yml .
COPY cmd.sh .


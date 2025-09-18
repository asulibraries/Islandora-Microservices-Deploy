# Build Alpaca with our local patch
FROM openjdk:11 AS build
WORKDIR /app

RUN git clone https://github.com/Islandora/Alpaca.git .

COPY alpaca-asu.patch .

RUN git apply alpaca-asu.patch
RUN chmod +x gradlew
ENV GRADLE_USER_HOME=/app/.gradle
RUN ./gradlew --stacktrace  clean build shadowJar --no-daemon

# Build the Alpaca image
FROM openjdk:11
WORKDIR /app

COPY --from=build /app/islandora-alpaca-app/build/libs/islandora-alpaca-*-all.jar alpaca.jar

COPY alpaca.properties .

ENV ALPACA_LOG_LEVEL=INFO

ENTRYPOINT ["java", "-jar", "/app/alpaca.jar", "-c", "/app/alpaca.properties"]

# Stage 1: Build the application
FROM openjdk:11 AS build
WORKDIR /app
#COPY gradlew .
#COPY gradle gradle
#COPY build.gradle .
#COPY gradle.properties .
#COPY settings.gradle .
#COPY islandora* .

COPY Alpaca/. .

COPY alpaca-asu.patch .

RUN git apply alpaca-asu.patch
RUN chmod +x gradlew
ENV GRADLE_USER_HOME=/app/.gradle
RUN ./gradlew --stacktrace  clean build shadowJar --no-daemon

# Stage 2: Create the final image
FROM openjdk:11
WORKDIR /app

COPY --from=build /app/islandora-alpaca-app/build/libs/islandora-alpaca-*-all.jar alpaca.jar

COPY alpaca.properties .

EXPOSE 8080

ENV ALPACA_LOG_LEVEL=DEBUG

ENTRYPOINT ["java", "-jar", "/app/alpaca.jar", "-c", "/app/alpaca.properties"]

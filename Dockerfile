FROM openjdk:17-slim as build

WORKDIR /app

COPY . .



RUN mkdir -p /root/.gradle
RUN echo "systemProp.http.proxyHost=krmp-proxy.9rum.cc\nsystemProp.http.proxyPort=3128\nsystemProp.https.proxyHost=krmp-proxy.9rum.cc\nsystemProp.https.proxyPort=3128" > /root/.gradle/gradle.properties
RUN chmod +x gradlew





# List output to verify
RUN ls /app/build/libs/

FROM openjdk:17-slim
ARG JAR_FILE=build/libs/item-service-0.0.1-SNAPSHOT.jar
ADD ${JAR_FILE} docker-springboot.jar
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/docker-springboot.jar"]
EXPOSE 8080/tcp
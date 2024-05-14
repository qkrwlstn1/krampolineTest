# 공식 Gradle 이미지를 사용하여 애플리케이션을 빌드합니다.
FROM gradle:8.5-jdk17 AS build

# 컨테이너 내부 작업 디렉토리를 설정합니다.
WORKDIR /home/gradle/project

# Gradle wrapper 및 build.gradle 파일을 컨테이너로 복사합니다.
COPY gradle /home/gradle/project/gradle
COPY gradlew /home/gradle/project/gradlew
COPY build.gradle /home/gradle/project/
COPY settings.gradle /home/gradle/project/

# 나머지 소스 코드를 컨테이너로 복사합니다.
COPY src /home/gradle/project/src

# Gradle을 사용하여 애플리케이션을 빌드합니다.
RUN ./gradlew build

# 애플리케이션을 실행하기 위해 최소한의 JDK 이미지를 사용합니다.
FROM openjdk:17-jdk-slim

# 컨테이너 내부 작업 디렉토리를 설정합니다.
WORKDIR /app

# 빌드 단계에서 생성된 jar 파일을 최종 단계로 복사합니다.
COPY --from=build /home/gradle/project/build/libs/*.jar app.jar

# 애플리케이션이 실행될 포트를 노출합니다.
EXPOSE 8080

# 애플리케이션을 실행하기 위한 명령을 정의합니다.
CMD ["java", "-jar", "app.jar"]
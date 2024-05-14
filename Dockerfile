# 빌드 단계: OpenJDK 17-slim 이미지를 사용하여 빌드 환경 설정
FROM openjdk:17-slim as build

# 작업 디렉토리 설정
WORKDIR /app

# 현재 디렉토리의 모든 파일을 컨테이너의 작업 디렉토리에 복사
COPY . .

# Gradle 설정을 위한 디렉토리 생성
RUN mkdir -p /root/.gradle

# 프록시 설정을 Gradle 설정 파일에 추가
RUN echo "systemProp.http.proxyHost=krmp-proxy.9rum.cc\nsystemProp.http.proxyPort=3128\nsystemProp.https.proxyHost=krmp-proxy.9rum.cc\nsystemProp.https.proxyPort=3128" > /root/.gradle/gradle.properties

# Gradle Wrapper 파일에 실행 권한 부여
RUN chmod +x ./gradlew

# Gradle 빌드를 실행하여 테스트를 제외한 빌드 수행
RUN ./gradlew build -x test

# 빌드 결과를 확인하기 위해 출력 파일 목록을 표시
RUN ls /app/build/libs/

# 런타임 단계: OpenJDK 17-slim 이미지를 사용하여 런타임 환경 설정
FROM openjdk:17-slim

# Docker 볼륨을 생성하여 데이터를 영구적으로 저장
VOLUME /tmp

# 빌드 단계에서 생성된 JAR 파일을 런타임 환경으로 복사
COPY --from=build /app/build/libs/*.jar /app/boot.jar

# 애플리케이션을 실행하기 위한 엔트리포인트 설정
ENTRYPOINT ["java", "-jar", "/app/boot.jar"]

# 컨테이너가 사용하는 포트 8080을 외부에 노출
EXPOSE 8080/tcp
FROM maven:3.9-eclipse-temurin-17 as build
WORKDIR /app

# Stage 1: 의존성만 다운로드 (캐시 레이어)
COPY pom.xml .
COPY .mvn .mvn
RUN mvn dependency:go-offline -B

# Stage 2: 소스 코드 빌드
COPY src ./src
RUN mvn clean package -DskipTests -B

# Stage 3: 실행 이미지
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
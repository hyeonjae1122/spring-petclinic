FROM maven:3.9-eclipse-temurin-25 AS build
WORKDIR /app
# Set Maven options for more memory
ENV MAVEN_OPTS="-Xmx1024m"
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:25-jre-jammy
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]

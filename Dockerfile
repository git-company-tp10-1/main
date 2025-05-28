FROM maven:3-eclipse-temurin-21-alpine as maven_build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn package -DskipTests

FROM eclipse-temurin:21-alpine
WORKDIR /app

COPY --from=maven_build /app/target/*.jar /app/Backend.jar
CMD ["java", "-jar", "/app/Backend.jar"]
EXPOSE 8080
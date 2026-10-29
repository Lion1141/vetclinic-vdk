# Build stage
FROM eclipse-temurin:21-jdk-alpine AS build
WORKDIR /app
COPY . .
RUN chmod +x mvnw
RUN ./mvnw -pl apps/sync-svc -am clean package -DskipTests

# Runtime stage
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

ARG JAR_FILE=apps/sync-svc/target/*.jar
COPY --from=build /app/${JAR_FILE} app.jar

EXPOSE 8083

ENTRYPOINT ["java", "-jar", "app.jar"]

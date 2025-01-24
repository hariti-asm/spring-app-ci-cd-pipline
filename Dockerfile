FROM maven:3-jdk-8-alpine AS build
WORKDIR /usr/src/app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

FROM openjdk:8-jre-alpine
WORKDIR /app
COPY --from=build /usr/src/app/target/*.jar app.jar
ENV PORT=8082
EXPOSE $PORT
CMD ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "-Dserver.port=${PORT}", "app.jar"]
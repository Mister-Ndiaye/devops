FROM maven:3.8-jdk-11 as builder
WORKDIR /opt/app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY ./src ./src
RUN  mvn clean install -Djar.finalName=notification -Dmaven.test.skip=true
# no alpine version for openjdk official images
FROM openjdk:11-jre-slim
WORKDIR /app
COPY --from=builder /opt/app/target/*.jar /app/notification.jar
ENTRYPOINT ["java","-jar","/app/notification.jar"]


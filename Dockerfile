# Step 1: Build the artifact
FROM maven:3.8.3-openjdk-8 AS builder

WORKDIR /code

COPY . /code

# Build the artifact
RUN mvn clean package

# Step 2: Create the final image
FROM openjdk:8-jre-alpine

WORKDIR /app

COPY --from=builder /code/target/*.jar /app/app.jar

CMD ["java", "-jar", "app.jar"]

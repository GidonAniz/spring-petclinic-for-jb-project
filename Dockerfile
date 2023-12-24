# Step 2: Build the artifact
FROM maven:3.8.3-openjdk-8 AS builder

WORKDIR /code

COPY . /code

# Build the artifact
RUN ./mvnw package

# Step 3: Create the final image
FROM openjdk:8-jre-alpine

WORKDIR /code

COPY --from=builder /code/target/*.jar /code

CMD ["java", "-jar", "code/*.jar"]

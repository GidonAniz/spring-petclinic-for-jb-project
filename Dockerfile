# Use an official Maven image as the base image
FROM maven:3.8.4-openjdk-11 AS builder

# Set the working directory in the container
WORKDIR /app

# Copy the pom.xml file to the container
COPY pom.xml .

# Copy the rest of the application code to the container
COPY src/ src/

# Build the application
RUN mvn clean install

# Use an official OpenJDK image as the base image for the final image
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file from the builder stage to the container
COPY --from=builder /app/target/your-application.jar .

# Specify the default command to run on container startup
CMD ["java", "-jar", "your-application.jar"]

FROM maven:3.8.4 AS maven_build

# Install Helm dependencies
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get install -y openssl

# Install Helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Set the working directory in the container
WORKDIR /code

# Copy the Project Object Model (POM) file
COPY pom.xml .

# Copy the Maven wrapper configuration
COPY .mvn .mvn

# Copy the source code
COPY src src

# Build the artifact
RUN mvn package

# Use an official OpenJDK runtime as a base image for the final stage
FROM openjdk:8

# Set the working directory in the container
WORKDIR /code

# Copy the JAR file from the Maven build stage
COPY --from=maven_build /code/target/*.jar /code/

# Install Helm in the final image
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get install -y openssl && \
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Define the default command to run the application
CMD ["java", "-jar", "/code/*.jar"]

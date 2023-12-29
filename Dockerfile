# Use an official Maven image for the Maven build stage
FROM maven:3.8.4 AS maven_build

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

# Use an official Docker image with Helm and Kubernetes tools for the final stage
FROM alpine:latest

# Install Helm and kubectl
RUN apk --no-cache add bash curl
RUN curl -LO https://get.helm.sh/helm-v3.7.0-linux-amd64.tar.gz \
    && tar -zxvf helm-v3.7.0-linux-amd64.tar.gz \
    && mv linux-amd64/helm /usr/local/bin/helm \
    && rm -rf linux-amd64 helm-v3.7.0-linux-amd64.tar.gz

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.22.2/bin/linux/amd64/kubectl \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/kubectl

# Set the working directory in the container
WORKDIR /code

# Copy the JAR file from the Maven build stage
COPY --from=maven_build /code/target/*.jar /code/

# Define the default command to run the application
CMD ["java", "-jar", "/code/*.jar"]

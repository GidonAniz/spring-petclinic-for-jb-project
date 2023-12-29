# Use an official OpenJDK runtime as a base image
FROM openjdk:8

# Set the working directory in the container
WORKDIR /code

# Copy the Maven wrapper files (mvnw and mvnw.cmd)
COPY mvnw .
COPY mvnw.cmd .

# Copy the Project Object Model (POM) file
COPY pom.xml .

# Copy the source code
COPY src src

# Build the artifact
RUN .mvnw package

# Create the final image
FROM openjdk:8

# Set the working directory in the container
WORKDIR /code

# Copy the JAR file from the previous stage
COPY --from=0 /code/target/*.jar /code/

# Define the default command to run the application
CMD ["java", "-jar", "/code/*.jar"]

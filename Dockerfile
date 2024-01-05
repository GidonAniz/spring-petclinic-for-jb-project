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

# Use an official OpenJDK image for the final stage
FROM openjdk:8-jre-alpine

# Set the working directory in the container
WORKDIR /code

# Copy the compiled classes and resources from the Maven build stage
COPY --from=maven_build /code/target/classes /code/classes

# Define the default command to run the application
CMD ["java", "-cp", "/code/classes", "com.your.gidon.petclinic"]

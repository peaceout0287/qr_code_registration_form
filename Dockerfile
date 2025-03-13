# Stage 1: Build the application
FROM maven:3.9.6-eclipse-temurin-21 AS build

# Set working directory inside the container
WORKDIR /app

# Copy project files into the container
COPY . .

# Build the WAR or JAR file
RUN mvn clean package -DskipTests

# Stage 2: Run the application with OpenJDK 21
FROM eclipse-temurin:21-jdk

# Set working directory
WORKDIR /app

# Copy the built JAR file from the previous stage
COPY --from=build /app/target/*.jar app.jar

# Expose the port the application runs on
EXPOSE 8080

# Pass database connection as environment variables
ENV SPRING_DATASOURCE_URL=jdbc:mysql://mysql:3306/brr
ENV SPRING_DATASOURCE_USERNAME=root
ENV SPRING_DATASOURCE_PASSWORD=12345

# Command to run the application
CMD ["java", "-jar", "app.jar"]



FROM eclipse-temurin:17-jre-jammy

# Add a non-root user for security
# RUN groupadd -r spring && useradd -r -g spring spring

# Set working directory
# WORKDIR /app

# Define build argument for JAR file
ARG JAR=target/*.jar

# Copy the JAR file
COPY ${JAR} java-spring-app.jar

# Set ownership to non-root user
# RUN chown spring:spring /app/java-spring-app.jar

# Switch to non-root user
#USER spring

# Configure JVM options for containers
ENTRYPOINT ["java", "-jar", "/java-spring-app.jar"]

# Expose the port on which the Spring Boot application will listen for requests
EXPOSE 8080
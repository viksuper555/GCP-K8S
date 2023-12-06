### Start of builder image
FROM openjdk:17-alpine as builder

# Set working dir inside the build image
WORKDIR temp

# Could be set to different jar file location
ARG JAR_FILE=target/*.jar

# Copy fat jar file to current image builder
COPY ${JAR_FILE} application.jar

# Extract the jar file layers
RUN java -Djarmode=layertools -jar application.jar extract


#### Start of app image
FROM openjdk:17-alpine

# Set working dir inside the app image
WORKDIR app

# Copy all layers from builder stage to current image
COPY --from=builder temp/dependencies/ ./
COPY --from=builder temp/snapshot-dependencies/ ./
COPY --from=builder temp/spring-boot-loader/ ./
COPY --from=builder temp/application/ ./

# Expose current application to port 8080
EXPOSE 8080

# Run the application with JVM configs if any
ENTRYPOINT ["sh", "-c", "java -server org.springframework.boot.loader.JarLauncher ${0} ${@}"]

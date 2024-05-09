# Use a base image with Maven already installed
FROM maven:3.8.3-openjdk-8 as builder

# Set the working directory in the builder stage
WORKDIR /app

# Copy only the necessary files to the container
COPY ./pom.xml ./server/ ./webapp/ ./ 

# Download dependencies and plugins needed for building
RUN mvn dependency:go-offline package

# Second stage: Runtime stage
FROM tomcat:latest

# Set the working directory in the runtime stage
WORKDIR /usr/local/tomcat/webapps

# Copy the built WAR file from the builder stage
COPY --from=builder /app/webapp/target/webapp.war .

# Modify Tomcat configuration
RUN sed -i 's/port="8080"/port="4287"/' ${CATALINA_HOME}/conf/server.xml

# Clean up unnecessary files
RUN rm -rf /app

# Expose the modified Tomcat port
EXPOSE 4287

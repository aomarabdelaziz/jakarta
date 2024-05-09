# Use a temporary builder stage to copy files from the volume
# Use a base image with Maven already installed
FROM maven:3.8.3-openjdk-8 as builder

# Set the working directory in the builder stage
WORKDIR /app

# Copy the pom.xml file to the container
COPY ./pom.xml ./

# Copy the rest of the project files to the container
COPY ./server ./server 
COPY ./webapp ./webapp

# Download dependencies and plugins needed for building
RUN mvn dependency:go-offline 

RUN mvn package


# Second stage: Runtime stage
FROM tomcat:latest

# Copy files from the temporary builder stage
COPY --from=builder /app/webapp/*.war /usr/local/tomcat/webapps/

# Modify Tomcat configuration
RUN sed -i 's/port="8080"/port="4287"/' ${CATALINA_HOME}/conf/server.xml

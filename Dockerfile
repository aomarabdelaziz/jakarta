# Use a temporary builder stage to copy files from the volume
# Use a base image with Maven already installed
FROM maven:3.8.3 as builder

# Set up non-root user
ARG USER_ID=1000
ARG GROUP_ID=1000

# Create a non-root user with the specified user ID and group ID
RUN groupadd -g $GROUP_ID maven-nonroot && \
    useradd -u $USER_ID -g $GROUP_ID -m maven-nonroot

# Set the working directory in the builder stage
WORKDIR /app

RUN chown -R maven-nonroot:maven-nonroot /app

# Switch to the non-root user
USER maven-nonroot

# Copy the pom.xml file to the container
COPY ./pom.xml ./

# Copy the rest of the project files to the container
COPY ./server ./server 
COPY ./webapp ./webapp

# Download dependencies and plugins needed for building
RUN mvn dependency:go-offline 

RUN mvn package


# Second stage: Runtime stage
FROM tomcat:8-alpine

# Copy files from the temporary builder stage
COPY --from=builder /app/webapp/target/webapp.war /usr/local/tomcat/webapps/

# Modify Tomcat configuration
RUN sed -i 's/port="8080"/port="4287"/' ${CATALINA_HOME}/conf/server.xml

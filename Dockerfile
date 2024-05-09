# Use a temporary builder stage to copy files from it
FROM maven:3.8.3 as builder

ARG USER_ID=1000
ARG GROUP_ID=1000

RUN groupadd -g ${GROUP_ID} maven && \
    useradd -u ${USER_ID} -g maven -s /bin/bash maven

# Copy the settings.xml file into the container
COPY settings.xml /usr/share/maven/conf/settings.xml

# Create directory for cached repositories
RUN mkdir -p /home/maven/.m2/repository

# Set permissions for the user
RUN chown -R maven:maven /home/maven/.m2


# Set the working directory in the builder stage
WORKDIR /app

# Copy the pom.xml file to the container
COPY ./pom.xml ./

# Copy the rest of the project files to the container
COPY ./server ./server 
COPY ./webapp ./webapp

RUN mvn package


# Second stage: Runtime stage
FROM tomcat:8-alpine

# Copy files from the temporary builder stage
COPY --from=builder /app/webapp/target/webapp.war /usr/local/tomcat/webapps/

# Modify Tomcat configuration
RUN sed -i 's/port="8080"/port="4287"/' ${CATALINA_HOME}/conf/server.xml

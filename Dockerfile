# Use a temporary builder stage to copy files from the volume
FROM busybox AS builder
VOLUME /shared-data
WORKDIR /shared-data
COPY . .

# Second stage: Runtime stage
FROM tomcat:latest

# Copy files from the temporary builder stage
COPY --from=builder /shared-data/*.war /usr/local/tomcat/webapps/

# Modify Tomcat configuration
RUN sed -i 's/port="8080"/port="4287"/' ${CATALINA_HOME}/conf/server.xml

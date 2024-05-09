# Second stage: Runtime stage
FROM tomcat:latest
VOLUME /shared-data

RUN sed -i 's/port="8080"/port="4287"/' ${CATALINA_HOME}/conf/server.xml
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps
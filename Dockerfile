FROM tomcat:latest
RUN sed -i 's/port="8080"/port="4287"/' ${CATALINA_HOME}/conf/server.xml
COPY ./webapp/target/*.war /usr/local/tomcat/webapps
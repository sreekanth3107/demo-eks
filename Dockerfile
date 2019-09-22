FROM tomcat:8
MAINTAINER kishan <kishanbommi@gmail.com>

# Debugging tools: A few ways to handle debugging tools.
# Trade off is a slightly more complex volume mount vs keeping the image size down.
#RUN apt-get update && \
#  apt-get install -y \
#    net-tools \
#    tree \
#    vim && \
#  rm -rf /var/lib/apt/lists/* && apt-get clean && apt-get purge
COPY demo.war /usr/local/tomcat/webapps/demo.war
COPY manager.xml /usr/local/tomcat/conf/Catalina/localhost/manager.xml
RUN rm -rf /usr/local/tomcat/conf/tomcat-users.xml
COPY tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml
RUN echo "export JAVA_OPTS=\"-Dapp.env=staging\"" > /usr/local/tomcat/bin/setenv.sh
EXPOSE 8080
CMD ["catalina.sh", "run"]

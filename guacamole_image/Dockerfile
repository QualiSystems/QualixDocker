FROM guacamole/guacamole:1.2.0

LABEL maintainer="Support@quali.com" url="https://support.quali.com"


ENV GUACAMOLE_HOME /opt/guacamole/.guacamole
ENV GUACAMOLE_PROPERTIES guacamole.properties

# ARG of the JAR version
ARG JAR_VERSION=3.2.0
ENV VERSION qualix-${JAR_VERSION}
ENV QUALIX_S3_AUTH_FILE ${VERSION}.tar.gz
ENV QUALIX_S3_URL https://quali-dev-binaries.s3.amazonaws.com/${QUALIX_S3_AUTH_FILE}

ENV QUALIX_AUTH_PACK_NAME guacamole-auth-quali-${VERSION}

ENV KEYSTORE_PASS 123123
ENV GUACAMOLE_WAR_NAME remote
ENV CERT_LOC /usr/share/tomcat
##########################################################################################################################################


######################## create Certificate ##############################################################################################
WORKDIR ${CERT_LOC}
RUN keytool -genkeypair -noprompt -alias Tomcat -keyalg RSA -dname "CN=quali, OU=quali, O=quali, L=quali, S=quali, C=IL" -keystore .keystore -storepass ${KEYSTORE_PASS} -keypass ${KEYSTORE_PASS} -validity 365000
WORKDIR /usr/local/tomcat/conf

RUN sed -i '/<Service name="Catalina">/a <Connector port="8443" protocol="org.apache.coyote.http11.Http11Protocol" maxThreads="150" SSLEnabled="true" scheme="https" secure="true" keystoreFile="'${CERT_LOC}'/.keystore" keystorePass="'${KEYSTORE_PASS}'" clientAuth="false" sslProtocol="TLS" />' server.xml
##########################################################################################################################################


######################## Get quali qualix package from S3 #################################################################################
RUN mkdir -p ${GUACAMOLE_HOME}/extensions 

## For PRODUCTION!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
RUN echo ${QUALIX_S3_URL}
RUN wget -O ${QUALIX_S3_AUTH_FILE} ${QUALIX_S3_URL}
RUN tar -xzf ${QUALIX_S3_AUTH_FILE}
## For DEBUG!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# COPY qualix-1.0.0.tar.gz /tmp
# RUN tar -xzf /tmp/qualix-1.0.0.tar.gz
## For DEBUG!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!



RUN unzip -o guacamole-auth-quali-${JAR_VERSION}/guacamole-auth-quali-${JAR_VERSION}.jar guacamole-legacy-urls-0.9.9.jar -d ${GUACAMOLE_HOME}/extensions/
RUN cp guacamole-auth-quali-${JAR_VERSION}/guacamole-auth-quali-${JAR_VERSION}.jar ${GUACAMOLE_HOME}/extensions/
RUN rm -rf  guacamole-auth-quali-${JAR_VERSION}
# RUN cp ${QUALIX_AUTH_PACK_NAME}/${QUALIX_AUTH_PACK_NAME}.jar ${GUACAMOLE_HOME}/extensions/
# RUN rm -r ${QUALIX_AUTH_PACK_NAME}

ENV redirect '<% response.sendRedirect("/remote"); %>'
RUN sed -i '1s|^|'"$redirect"'\n|' /usr/local/tomcat/webapps/ROOT/index.jsp
##########################################################################################################################################



######################## Copy configuration ##############################################################################################
RUN echo "auth-provider: net.sourceforge.guacamole.net.auth.quali.QualiProvider"  > ${GUACAMOLE_HOME}/${GUACAMOLE_PROPERTIES}
RUN mkdir -p ${GUACAMOLE_HOME}/files/
RUN chmod -R 777 ${GUACAMOLE_HOME}/
RUN chmod -R 777 ${GUACAMOLE_HOME}/files/
##########################################################################################################################################

RUN  mv /opt/guacamole/guacamole.war /opt/guacamole/${GUACAMOLE_WAR_NAME}.war
RUN ln -s /opt/guacamole/${GUACAMOLE_WAR_NAME}.war /usr/local/tomcat/webapps/${GUACAMOLE_WAR_NAME}.war

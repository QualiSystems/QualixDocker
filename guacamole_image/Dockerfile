FROM guacamole/guacamole:1.0.0

LABEL maintainer="Support@quali.com" url="https://support.quali.com"

######################## ENV VARS ##############################################################################################
ENV GUACAMOLE_HOME_DIR=/opt/guacamole/.guacamole

ENV QUALIX_S3_AUTH_FILE="qualix-0.9.10.tar.gz"
ENV QUALIX_S3_URL=https://s3.amazonaws.com/quali-prod-binaries/${QUALIX_S3_AUTH_FILE}

ENV QUALIX_GUACAMOLE_VERSION="0.9.10-incubating"
ENV QUALIX_AUTH_PACK_NAME=guacamole-auth-quali-${QUALIX_GUACAMOLE_VERSION}
##########################################################################################################################################


######################## create Certificate ##############################################################################################
RUN keytool -genkey -alias tomcat -keyalg RSA -validity 3650 -storepass changeit -keypass changeit -dname "C=US, ST=California, L=Santa Clara, O=Quali"
##########################################################################################################################################


######################## Get quali qualix package from S3 #################################################################################
RUN mkdir -p ${GUACAMOLE_HOME_DIR}/extensions 
RUN wget -qO- ${QUALIX_S3_URL} | tar -xzf - 
RUN cp ${QUALIX_AUTH_PACK_NAME}/${QUALIX_AUTH_PACK_NAME}.jar ${GUACAMOLE_HOME_DIR}/extensions/
RUN rm -r ${QUALIX_AUTH_PACK_NAME}
##########################################################################################################################################



######################## Copy configuration ##############################################################################################
RUN echo "auth-provider: net.sourceforge.guacamole.net.auth.quali.QualiProvider"  > /opt/guacamole/guacamole.properties

##########################################################################################################################################

RUN touch a.txt

EXPOSE 8090 8443

FROM guacamole/guacd

LABEL maintainer="Support@Quali.com" url="https://support.quali.com"

#The default value is info (optional value: debug)
ENV GUACD_LOG_LEVEL=info 
 
RUN touch a.txt
# guacd port
# IMPORTANT >>> DONT EXPOSE IN PRODUCTION
# EXPOSE 4822
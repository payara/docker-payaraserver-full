FROM java:8-jdk

ENV PAYARA_PKG https://s3-eu-west-1.amazonaws.com/payara.co/Payara+Downloads/Payara+4.1.1.163/payara-4.1.1.163.zip
ENV PAYARA_VERSION 163
ENV PKG_FILE_NAME payara-full-$PAYARA_VERSION.zip
ENV PAYARA_PATH /opt/payara41

RUN \
 apt-get update && \ 
 apt-get install -y unzip 

RUN wget --quiet -O /opt/$PKG_FILE_NAME $PAYARA_PKG
RUN unzip -qq /opt/$PKG_FILE_NAME -d /opt

RUN mkdir -p $PAYARA_PATH/deployments
RUN useradd -b /opt -m -s /bin/bash payara && echo payara:payara | chpasswd
RUN chown -R payara:payara /opt

# Default payara ports to expose
EXPOSE 4848 8009 8080 8181 1527

USER payara
WORKDIR $PAYARA_PATH


# set credentials to admin/admin 

RUN echo 'AS_ADMIN_PASSWORD=\n\
AS_ADMIN_NEWPASSWORD=admin\n\
EOF\n'\
>> /opt/tmpfile

RUN echo 'AS_ADMIN_PASSWORD=admin\n\
EOF\n'\
>> /opt/pwdfile

RUN \
 $PAYARA_PATH/bin/asadmin start-domain && \
 $PAYARA_PATH/bin/asadmin --user admin --passwordfile=/opt/tmpfile change-admin-password && \
 $PAYARA_PATH/bin/asadmin --user admin --passwordfile=/opt/pwdfile enable-secure-admin && \
 $PAYARA_PATH/bin/asadmin restart-domain

RUN rm /opt/tmpfile

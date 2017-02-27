FROM java:8-jdk

ENV PAYARA_PKG https://s3-eu-west-1.amazonaws.com/payara.fish/Payara+Downloads/Payara+4.1.1.171.0.1/payara-4.1.1.171.0.1.zip
ENV PAYARA_VERSION 171
ENV PKG_FILE_NAME payara-full-$PAYARA_VERSION.zip
ENV PAYARA_PATH /opt/payara41
ENV ADMIN_USER admin
ENV ADMIN_PASSWORD admin


RUN \
 apt-get update && \ 
 apt-get install -y unzip 

RUN wget --quiet -O /opt/$PKG_FILE_NAME $PAYARA_PKG
RUN unzip -qq /opt/$PKG_FILE_NAME -d /opt

RUN mkdir -p $PAYARA_PATH/deployments
RUN useradd -b /opt -m -s /bin/bash -d $PAYARA_PATH payara && echo payara:payara | chpasswd
RUN chown -R payara:payara /opt

# Default payara ports to expose
EXPOSE 4848 8009 8080 8181 1527

USER payara
WORKDIR $PAYARA_PATH


# set credentials to admin/admin 

RUN echo 'AS_ADMIN_PASSWORD=\n\
AS_ADMIN_NEWPASSWORD='$ADMIN_PASSWORD'\n\
EOF\n'\
>> /opt/tmpfile

RUN echo 'AS_ADMIN_PASSWORD='$ADMIN_PASSWORD'\n\
EOF\n'\
>> /opt/pwdfile

RUN \
 $PAYARA_PATH/bin/asadmin start-domain && \
 $PAYARA_PATH/bin/asadmin --user $ADMIN_USER --passwordfile=/opt/tmpfile change-admin-password && \
 $PAYARA_PATH/bin/asadmin --user $ADMIN_USER --passwordfile=/opt/pwdfile enable-secure-admin && \
 $PAYARA_PATH/bin/asadmin restart-domain

# cleanup
RUN rm /opt/tmpfile
RUN rm /opt/$PKG_FILE_NAME

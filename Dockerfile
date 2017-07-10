FROM java:8

WORKDIR /opt

EXPOSE 1389 1636 4444
COPY opendj.zip /var/tmp/
COPY base.ldif /var/tmp/

RUN unzip /var/tmp/opendj.zip -d /opt/ && rm -fr /var/tmp/opendj.zip

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

RUN /opt/opendj/setup --cli -p 1389 --ldapsPort 1636 --enableStartTLS --generateSelfSignedCertificate  --baseDN "dc=test,dc=com" -h localhost --rootUserPassword password --acceptLicense --no-prompt --doNotStart

RUN /opt/opendj/bin/import-ldif --backendID userRoot --ldifFile /var/tmp/base.ldif

CMD ["/opt/opendj/bin/start-ds", "--nodetach"]

ARG DEBIAN_VERSION=buster-slim

FROM debian:${DEBIAN_VERSION}
LABEL maintainer="seba5zer@gmail.com"

ARG SOAPUI_VERSION=5.6.0

RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates wget && \
    wget -O /tmp/SoapUI-x64-${SOAPUI_VERSION}.sh https://s3.amazonaws.com/downloads.eviware/soapuios/${SOAPUI_VERSION}/SoapUI-x64-${SOAPUI_VERSION}.sh && \
    chmod +x /tmp/SoapUI-x64-${SOAPUI_VERSION}.sh && \
    apt-get remove -y wget

RUN mkdir /usr/share/man/man1/ && \
    apt-get install --no-install-recommends -y openjdk-11-jre && \
    /tmp/SoapUI-x64-${SOAPUI_VERSION}.sh -q && \
    ln -s /usr/local/SmartBear/SoapUI-${SOAPUI_VERSION}/bin/SoapUI-${SOAPUI_VERSION} /usr/local/bin/soapui

ENTRYPOINT ["soapui"]

#RUN apt-get install --no-install-recommends -y xmlbeans


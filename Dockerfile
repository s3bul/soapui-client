ARG DEBIAN_VERSION=buster-slim

FROM debian:${DEBIAN_VERSION}
LABEL maintainer="seba5zer@gmail.com"

ARG SOAPUI_VERSION=5.6.0

ENV SOAPUI_VERSION=${SOAPUI_VERSION}
ENV SOAPUI_DIR=/usr/local/SmartBear/SoapUI-${SOAPUI_VERSION}

RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates wget && \
    wget -O /tmp/SoapUI-x64-${SOAPUI_VERSION}.sh https://s3.amazonaws.com/downloads.eviware/soapuios/${SOAPUI_VERSION}/SoapUI-x64-${SOAPUI_VERSION}.sh && \
    chmod +x /tmp/SoapUI-x64-${SOAPUI_VERSION}.sh && \
    apt-get remove -y wget && \
    mkdir -p /usr/share/man/man1 && \
    apt-get install --no-install-recommends -y openjdk-11-jre libcanberra-gtk3-module && \
    /tmp/SoapUI-x64-${SOAPUI_VERSION}.sh -q && \
    ln -s ${SOAPUI_DIR}/bin/SoapUI-${SOAPUI_VERSION} /usr/local/bin/soapui && \
    mkdir -p ${SOAPUI_DIR}/logs && \
    echo "-Dsoapui.logroot=${SOAPUI_DIR}/logs/" >> \
    ${SOAPUI_DIR}/bin/SoapUI-${SOAPUI_VERSION}.vmoptions

COPY ./docker-entrypoint.sh ${SOAPUI_DIR}/bin

ARG APP_USER=app
ARG APP_USER_ID=1000

ENV APP_USER=${APP_USER}
ENV APP_USER_ID=${APP_USER_ID}
ENV HOME_APP=/home/${APP_USER}

RUN adduser -q --uid ${APP_USER_ID} --disabled-password ${APP_USER} && \
    addgroup ${APP_USER} root && \
    addgroup root ${APP_USER} && \
    chmod g+rwxs ${HOME_APP} ${SOAPUI_DIR}/logs && \
    mkdir -p ${HOME_APP}/.soapuios/plugins ${HOME_APP}/.soapuios/config && \
    cp -r /root/.soapuios/plugins ${HOME_APP}/.soapuios && \
    chown -R ${APP_USER}:0 ${HOME_APP}

USER ${APP_USER}:0

WORKDIR ${SOAPUI_DIR}

ENTRYPOINT ["bin/docker-entrypoint.sh"]

CMD ["run"]

VOLUME ["${HOME_APP}/.soapuios/config"]

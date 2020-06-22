FROM frolvlad/alpine-java:jdk8-full AS builder
MAINTAINER Marcio Bigolin

ENV ANDROID_SDK_ROOT    /opt/android-sdk
ENV PATH            ${PATH}:${ANDROID_SDK_ROOT}/tools/bin:${ANDROID_SDK_ROOT}/platform-tools
ENV SDK_UPDATE      "platform-tools" "platforms;android-28" "platforms;android-27" "build-tools;30.0.0" "extras;google;google_play_services"

RUN apk --update add npm curl gradle git

RUN curl -SLO "https://dl.google.com/android/repository/commandlinetools-linux-6514223_latest.zip" \
    && mkdir -p "${ANDROID_SDK_ROOT}" \
    && unzip "commandlinetools-linux-6514223_latest.zip" -d "${ANDROID_SDK_ROOT}" \
    && rm -Rf "commandlinetools-linux-6514223_latest.zip" 

RUN echo y | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --install ${SDK_UPDATE} 

RUN npm install -g cordova

RUN cd /tmp && \
    cordova create fakeapp && \
    cd /tmp/fakeapp && \
    cordova platform add android && \
    cordova build android && \
    cd && \
    rm -rf /tmp/fakeapp

ARG USER_ID
ARG GROUP_ID

#https://vsupalov.com/docker-shared-permissions/
#RUN addgroup --gid $GROUP_ID -S user
#RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user
#USER user

VOLUME ["/data"]
WORKDIR /data

EXPOSE 8000 3000 3001 5037

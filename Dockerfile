FROM alpine:latest
 
MAINTAINER Marcio Bigolin

ENV JAVA_HOME       /usr/lib/jvm/java-1.8-openjdk
ENV ANDROID_HOME    /opt/android-sdk
ENV GRADLE_HOME     /opt/gradle
ENV PATH            ${PATH}:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${GRADLE_HOME}/bin:${JAVA_HOME}/bin
ENV SDK_VERSION     30.0.3
ENV SDK_UPDATE      "platform-tools" "platforms;android-28" "platforms;android-27"

RUN apk --update add openjdk8 npm curl

RUN  curl -SLO "https://dl.google.com/android/repository/platform-tools_r${SDK_VERSION}-linux.zip" \
    && curl -SLO "https://dl.google.com/android/repository/commandlinetools-linux-6514223_latest.zip" \
    && mkdir -p "${ANDROID_HOME}" \
    && unzip "commandlinetools-linux-6514223_latest.zip" -d "${ANDROID_HOME}" \
    && unzip "platform-tools_r${SDK_VERSION}-linux.zip" -d "${ANDROID_HOME}" \
    && rm -Rf "platform-tools_r${SDK_VERSION}-linux.zip" \
    && rm -Rf "commandlinetools-linux-6514223_latest.zip" 

RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} --install ${SDK_UPDATE} 

RUN npm install -g cordova

RUN cd /tmp && \
    cordova create fakeapp && \
    cd /tmp/fakeapp && \
    cordova platform add android && \
    cd && \
    rm -rf /tmp/fakeapp

VOLUME ["/data"]
WORKDIR /data

EXPOSE 8000

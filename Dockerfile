# Compiles and installs an fdroid environment

FROM ubuntu:16.10
MAINTAINER mabako

# Enable i386 arch (for android SDK)
RUN dpkg --add-architecture i386
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
  && apt-get -y install software-properties-common \
  && add-apt-repository ppa:cwchien/gradle \
  && apt-get update \
  && apt-get install -q -y python3 python3-dev python3-pil python3-libcloud python3-paramiko python3-pip python3-pyasn1 python3-pyasn1-modules python3-requests python3-venv python3-yaml \
                           aapt openjdk-8-jdk openjdk-8-jre-headless zipalign git gradle-2.14.1 maven wget lib32stdc++6 lib32z1 \
  && rm -rf /var/lib/apt/lists/*

# Install the android SDK
ENV ANDROID_HOME /android-sdk
RUN wget https://dl.google.com/android/android-sdk_r24.3.4-linux.tgz \
  && tar xzf android-sdk_r24.3.4-linux.tgz \
  && mv android-sdk-linux $ANDROID_HOME \
  && rm android-sdk_r24.3.4-linux.tgz

# Add the SDK paths to $PATH
ENV PATH "$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"

#--------
# platform-tools
RUN echo y | android update sdk --no-ui --filter platform-tools

# build tools for all desired android versions
RUN echo y | android update sdk --no-ui --filter build-tools-25.0.2,android-25

# support libraries to build
RUN echo y | android update sdk --no-ui --filter extra-android-m2repository

#--------
# Install fdroidserver, and remove all git metadata/files
RUN git clone https://gitlab.com/fdroid/fdroidserver.git /fdroidserver --depth 1 && rm -rf /fdroidserver/.git
ENV PATH "$PATH:/fdroidserver"

VOLUME [/fdroid]

WORKDIR /fdroid
ENTRYPOINT ["fdroid"]

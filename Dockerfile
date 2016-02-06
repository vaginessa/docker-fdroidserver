# Compiles and installs an fdroid environment

FROM ubuntu:15.10
MAINTAINER mabako

# Enable i386 arch (for android SDK)
RUN dpkg --add-architecture i386
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
  && apt-get -y install software-properties-common \
  && apt-get install -q -y android-libhost android-libhost-dev \
  && apt-get install -q -y python2.7 python-imaging python-libcloud python-magic python-paramiko python-pyasn1 python-pyasn1-modules python-requests python-yaml \
                           aapt openjdk-7-jdk openjdk-7-jre-headless zipalign git gradle maven wget lib32stdc++6 lib32z1 \
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
RUN echo y | android update sdk --no-ui --filter build-tools-23.0.2,android-23

# support libraries to build
RUN echo y | android update sdk --no-ui --filter extra-android-support,extra-android-m2repository

# android native development kit
RUN wget https://dl.google.com/android/ndk/android-ndk-r10e-linux-x86_64.bin \
  && chmod a+x android-ndk-r10e-linux-x86_64.bin \
  && ./android-ndk-r10e-linux-x86_64.bin \
  && rm ./android-ndk-r10e-linux-x86_64.bin

ENV ANDROID_NDK /android-ndk-r10e
ENV PATH "$PATH:$ANDROID_NDK"

#--------
# Install fdroidserver, and remove all git metadata/files
RUN git clone https://gitlab.com/fdroid/fdroidserver.git /fdroidserver --depth 1 && rm -rf /fdroidserver/.git
ENV PATH "$PATH:/fdroidserver"

VOLUME [/fdroid]

WORKDIR /fdroid
ENTRYPOINT ["fdroid"]

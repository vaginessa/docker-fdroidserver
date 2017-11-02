# Compiles and installs an fdroid environment

FROM ubuntu:17.10
MAINTAINER mabako

# Enable i386 arch (for android SDK)
RUN dpkg --add-architecture i386
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
  && apt-get -y install software-properties-common \
  && apt-get update \
  && apt-get install -q -y python3 python3-dev python3-pil python3-libcloud python3-paramiko python3-pip python3-pyasn1 python3-pyasn1-modules python3-requests python3-venv python3-yaml \
                           aapt openjdk-8-jdk openjdk-8-jre-headless zipalign git gradle maven wget lib32stdc++6 lib32z1 \
  && rm -rf /var/lib/apt/lists/*

# Install the android SDK
ENV ANDROID_HOME /android-sdk
RUN wget https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip \
  && unzip sdk-tools-linux-3859397.zip \
  && mkdir $ANDROID_HOME \
  && mv tools $ANDROID_HOME/tools \
  && rm sdk-tools-linux-3859397.zip

# Add the SDK paths to $PATH
ENV PATH "$PATH:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"
# ENV USE_SDK_WRAPPER=yes

# install all SDK parts
RUN yes | sdkmanager --licenses
RUN touch ~/.android/repositories.cfg \
  && sdkmanager platform-tools tools "build-tools;25.0.2"

#--------
# Install fdroidserver, and remove all git metadata/files
RUN git clone https://gitlab.com/fdroid/fdroidserver.git /fdroidserver --depth 1 && rm -rf /fdroidserver/.git

ENV PATH "$PATH:/fdroidserver"

VOLUME [/fdroid]

WORKDIR /fdroid
ENTRYPOINT ["fdroid"]

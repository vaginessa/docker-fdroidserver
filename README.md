# fdroidserver docker container

    docker run \
      -v ~/fdroid/config.py:/fdroid/config.py \
      -v ~/fdroid/fdroid-icon.png:/fdroid/fdroid-icon.png \
      -v ~/fdroid/metadata/:/fdroid/metadata/ \
      -v ~/fdroid/my-keystore.jks:/fdroid/my-keystore.jks \
      -v ~/fdroid/repo:/fdroid/repo \
      fdroid build org.example


# fdroidserver docker container

### build the latest version as unsigned apk
    docker run \
      -v ~/fdroid/config.py:/fdroid/config.py \
      -v ~/fdroid/metadata/:/fdroid/metadata/ \
      -v ~/fdroid/unsigned:/fdroid/unsigned \
      fdroid build -l org.example

### build the latest version as signed apk

Will only build if the file does not exist in the repo yet.

    docker run \
      -v ~/fdroid/config.py:/fdroid/config.py \
      -v ~/fdroid/sg-icon.png:/fdroid/sg-icon.png \
      -v ~/fdroid/metadata/:/fdroid/metadata/ \
      -v ~/fdroid/steamgifts-android.jks:/fdroid/steamgifts-android.jks \
      -v ~/fdroid/repo:/fdroid/repo \
      --entrypoint sh \
      fdroid \
      -c "fdroid build -l org.example && fdroid publish && fdroid update"

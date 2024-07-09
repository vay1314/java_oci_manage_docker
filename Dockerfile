FROM openjdk:20-ea-11-jdk-slim-bullseye
LABEL maintainer="VAY1314 <blog@vay1314.top>"

RUN apt-get update && apt-get install -y wget procps curl jq

WORKDIR /app

RUN VERSION=$(curl -s https://api.github.com/repos/semicons/java_oci_manage/releases/latest | jq -r .tag_name | sed 's/v//') \
  && echo "最新版本: $VERSION" \
  && wget -O gz_client_bot.tar.gz https://github.com/semicons/java_oci_manage/releases/download/v${VERSION}/gz_client_bot.tar.gz \
  && tar -zxvf gz_client_bot.tar.gz --exclude=client_config \
  && tar -zxvf gz_client_bot.tar.gz --skip-old-files client_config \
  && rm -rf gz_client_bot.tar.gz \
  && chmod +x sh_client_bot.sh

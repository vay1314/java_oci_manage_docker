FROM debian:stable-slim
LABEL maintainer="VAY1314 <blog@vay1314.top>"

RUN apt-get update && apt-get install -y wget procps curl jq tzdata bash

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /app

ARG TARGETARCH

RUN VERSION=$(curl -s https://api.github.com/repos/semicons/java_oci_manage/releases/latest | jq -r .tag_name | sed 's/v//') \
  && echo "当前版本: $VERSION" \
  && if [ "$TARGETARCH" = "amd64" ]; then \
       wget -O gz_client_bot.tar.gz https://github.com/semicons/java_oci_manage/releases/download/v${VERSION}/gz_client_bot_x86.tar.gz; \
     else \
       wget -O gz_client_bot.tar.gz https://github.com/semicons/java_oci_manage/releases/download/v${VERSION}/gz_client_bot_aarch.tar.gz; \
     fi \
  && tar -zxvf gz_client_bot.tar.gz --exclude=client_config \
  && tar -zxvf gz_client_bot.tar.gz --skip-old-files client_config \
  && rm -rf gz_client_bot.tar.gz \
  && touch log_r_client.log \
  && chmod +x r_client \
  && chmod +x sh_client_bot.sh

ENTRYPOINT ["/bin/bash", "-c", "bash /app/sh_client_bot.sh > /proc/1/fd/1 2>/proc/1/fd/2"]

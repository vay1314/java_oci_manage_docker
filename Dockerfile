FROM debian:stable-slim
LABEL maintainer="VAY1314 <blog@vay1314.top>"

RUN apt-get update && apt-get install -y wget procps curl jq tzdata bash

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /app

RUN VERSION=$(curl -s https://api.github.com/repos/semicons/java_oci_manage/releases/latest | jq -r .tag_name | sed 's/v//') \
  && echo "当前版本: $VERSION" \
  && wget -O sh_client_bot.sh https://github.com/semicons/java_oci_manage/releases/download/v${VERSION}/sh_client_bot.sh \
  && chmod +x sh_client_bot.sh

ENTRYPOINT ["/bin/bash", "-c", "bash /app/sh_client_bot.sh > /proc/1/fd/1 2>/proc/1/fd/2"]
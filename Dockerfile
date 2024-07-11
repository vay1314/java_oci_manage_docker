FROM openjdk:20-ea-jdk-slim
LABEL maintainer="VAY1314 <blog@vay1314.top>"

RUN apt-get update && apt-get install -y wget procps curl jq openjdk-17-jdk

WORKDIR /app

RUN VERSION=$(curl -s https://api.github.com/repos/semicons/java_oci_manage/releases/latest | jq -r .tag_name | sed 's/v//') \
  && echo "最新版本: $VERSION" \
  && wget -O gz_client_bot.tar.gz https://github.com/semicons/java_oci_manage/releases/download/v${VERSION}/gz_client_bot.tar.gz \
  && tar -zxvf gz_client_bot.tar.gz --exclude=client_config \
  && tar -zxvf gz_client_bot.tar.gz --skip-old-files client_config \
  && rm -rf gz_client_bot.tar.gz \
  && chmod +x sh_client_bot.sh
  
# ENTRYPOINT ["/bin/sh", "-c", "sh /app/sh_client_bot.sh > /proc/1/fd/1 2>/proc/1/fd/2"]

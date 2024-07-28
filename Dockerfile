# Common base image and initial setup
FROM debian:stable-slim AS base
LABEL maintainer="VAY1314 <blog@vay1314.top>"

RUN apt-get update && apt-get install -y wget procps curl jq tzdata bash
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
WORKDIR /app

# Stage for ARM64 architecture
FROM base AS arm64
RUN VERSION=$(curl -s https://api.github.com/repos/semicons/java_oci_manage/releases/latest | jq -r .tag_name | sed 's/v//') \
  && echo "当前版本: $VERSION" \
  && wget -O gz_client_bot.tar.gz https://github.com/semicons/java_oci_manage/releases/download/v${VERSION}/gz_client_bot_aarch.tar.gz \
  && tar -zxvf gz_client_bot.tar.gz --exclude=client_config \
  && tar -zxvf gz_client_bot.tar.gz --skip-old-files client_config \
  && rm -rf gz_client_bot.tar.gz \
  && touch log_r_client.log \
  && chmod +x r_client \
  && chmod +x sh_client_bot.sh

# Stage for AMD64 architecture
FROM base AS amd64
COPY check_cpu_features.sh /app/check_cpu_features.sh
RUN chmod +x /app/check_cpu_features.sh
ENTRYPOINT ["/bin/bash", "-c", "/app/check_cpu_features.sh"]

# Final stage to select the correct stage based on the target architecture
FROM arm64 AS final_arm64
FROM amd64 AS final_amd64

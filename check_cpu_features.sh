#!/bin/bash

# 获取 CPU 特性
cpu_flags=$(lscpu | grep Flags | awk '{for (i=2; i<=NF; i++) print $i}')

# 定义需要的高级特性
required_flags="avx avx2 sse4_2"

# 检查 CPU 是否支持所有高级特性
supports_advanced_features=true
for flag in $required_flags; do
   if [[ ! "$cpu_flags" == *"$flag"* ]]; then
    supports_advanced_features=false
    break
    fi
done

# 下载相应的包
if [ "$supports_advanced_features" = true ]; then
  DOWNLOAD_URL="https://github.com/semicons/java_oci_manage/releases/latest/download/gz_client_bot_x86.tar.gz"
else
  DOWNLOAD_URL="https://github.com/semicons/java_oci_manage/releases/latest/download/gz_client_bot_x86_compatible.tar.gz"
fi

wget -O gz_client_bot.tar.gz $DOWNLOAD_URL
tar -zxvf gz_client_bot.tar.gz --exclude=client_config
tar -zxvf gz_client_bot.tar.gz --skip-old-files client_config
rm -rf gz_client_bot.tar.gz
touch log_r_client.log
chmod +x r_client
chmod +x sh_client_bot.sh
bash /app/sh_client_bot.sh > /proc/1/fd/1 2>/proc/1/fd/2
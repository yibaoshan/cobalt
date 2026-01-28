#!/usr/bin/env bash
# convert_cookies.sh - 将 Netscape 格式的 cookies.txt 转换为 Cobalt JSON 格式
# 用法: bash convert_cookies.sh youtube_cookies.txt

set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "用法: bash convert_cookies.sh <cookies.txt>"
    echo "示例: bash convert_cookies.sh youtube_cookies.txt"
    exit 1
fi

input_file="$1"
output_file="cookies.json"

if [[ ! -f "$input_file" ]]; then
    echo "[错误] 文件不存在: $input_file"
    exit 1
fi

echo "正在转换 $input_file -> $output_file ..."

echo '{"youtube":[' > "$output_file"

first=true
while IFS=$'\t' read -r domain flag path secure expiration name value; do
    # 跳过注释行和空行
    [[ -z "$domain" || "$domain" =~ ^# ]] && continue

    # 添加逗号分隔符
    if [ "$first" = true ]; then
        first=false
    else
        echo ',' >> "$output_file"
    fi

    # 转换 secure 标志
    secure_bool="false"
    if [[ "$secure" == "TRUE" ]]; then
        secure_bool="true"
    fi

    # 转换为 JSON（不换行）
    printf '{"name":"%s","value":"%s","domain":"%s","path":"%s","secure":%s,"httpOnly":true}' \
        "$name" "$value" "$domain" "$path" "$secure_bool" >> "$output_file"

done < "$input_file"

echo ']}' >> "$output_file"

echo "✓ 转换完成: $output_file"
echo ""
echo "下一步:"
echo "1. 检查文件内容: cat $output_file"
echo "2. 部署到服务器: bash ops/deploy.sh"

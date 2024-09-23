#!/bin/bash

set -e  # エラー時にスクリプトを終了する

# 環境変数からクラスター名とサービス名を取得
cluster_name=$1
service_name=$2

# ECSタスクARNを取得
task_arn=$(aws ecs list-tasks --cluster "$cluster_name" --service-name "$service_name" --query "taskArns[0]" --output text)
if [ -z "$task_arn" ]; then
  echo "Error: Task ARN not found" >&2
  exit 1
fi

# taskIdを取得（ARNの最後の部分を抽出）
task_id=$(echo "$task_arn" | awk -F'/' '{print $NF}')  # ARNの最後のスラッシュ以降を抽出
echo "Task ID: $task_id" >&2  # デバッグ出力

# ENI IDを取得
eni_id=$(aws ecs describe-tasks --cluster "$cluster_name" --tasks "$task_id" --query "tasks[0].attachments[0].details[?name=='networkInterfaceId'].value" --output text)
if [ -z "$eni_id" ]; then
  echo "Error: ENI ID not found" >&2
  exit 1
fi

# パブリックIPを取得
public_ip=$(aws ec2 describe-network-interfaces --network-interface-ids "$eni_id" --query "NetworkInterfaces[0].Association.PublicIp" --output text)
if [ -z "$public_ip" ]; then
  echo "Error: Public IP not found" >&2
  exit 1
fi

# 結果をJSON形式で出力
echo "{\"public_ip\": \"$public_ip\"}"

# 事前に環境変数を設定。
terraform init \
                -backend-config="bucket=${TERRAFROM_STATE_S3_BUCKET}" \
                -backend-config="key=dev/terraform.tfstate" \
                -backend-config="region=ap-northeast-1" \
                -backend-config="dynamodb_table=${TERRAFROM_STATE_DYNAMODB_TABLE}" \
                -backend-config="encrypt=true"

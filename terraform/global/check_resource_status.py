# なければ作るって感じにしたかったけど失敗。
# 2回以上実行時に並列実行とかで、どちらもないときに2つ作っちゃうとかを解決できなかったので、没
# 動的に状況に合わせて立ち上げるか立ち上げないか決めるというのはterraform planに対して荷が重い。applyしっぱなしなら良いけどテスト実行のようなdestroyする環境には向いていない
# シングルトンにしたいサービスはglobalで1回確実に立ち上げ、その後はそれを読みに行く構成に変更

# #!/usr/bin/env python3
# import sys
# import json
# import subprocess
#
# # 入力データを受け取る（リソース名とリソースタイプ）
# input = json.load(sys.stdin)
# resource_name = input["resource_name"]
# resource_type = input["resource_type"]
#
# if resource_type == "ecs_cluster":
#     command = [
#         "aws", "ecs", "describe-clusters",
#         "--clusters", resource_name,
#         "--query", "clusters[0].{Status:status, ID:clusterArn}",
#         "--output", "json"
#     ]
# elif resource_type == "vpc":
#     command = [
#         "aws", "ec2", "describe-vpcs",
#         "--filters", f"Name=tag:Name,Values={resource_name}",
#         "--query", "Vpcs[0].{Status:State, ID:VpcId}",
#         "--output", "json"
#     ]
# else:
#     print(json.dumps({"status": "INACTIVE", "resource_id": None}))
#     sys.exit(1)
#
# result = subprocess.run(command, capture_output=True, text=True)
#
# if result.returncode != 0 or result.stdout.strip() == "" or "null" in result.stdout:
#     print(json.dumps({"status": "INACTIVE", "resource_id": None}))
# else:
#     output = json.loads(result.stdout)
#     status = "ACTIVE" if output.get("Status", "INACTIVE") != "INACTIVE" else "INACTIVE"
#
#     print(json.dumps({"status": status, "resource_id": output.get("ID", None)}))

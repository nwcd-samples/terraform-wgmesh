#/bin/bash
terraform destroy

# Add peers
wg-meshconf delpeer zhy 
wg-meshconf delpeer bjs
#wg-meshconf delpeer aliyun

#ssh root@47.101.44.228 "systemctl stop wg-quick@wg0"

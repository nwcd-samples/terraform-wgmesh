#/bin/bash
terraform apply
sleep 10s

# Add peers
wg-meshconf addpeer zhy --address 192.168.10.1/24 --allowedips $(terraform output -raw public_subnet_cidr_zhy) --endpoint $(terraform output -raw public_ip_addr_zhy) --postup "iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o ens5 -j MASQUERADE" --postdown "iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o ens5 -j MASQUERADE"
wg-meshconf addpeer bjs --address 192.168.20.1/24 --allowedips $(terraform output -raw public_subnet_cidr_bjs) --endpoint $(terraform output -raw public_ip_addr_bjs) --postup "iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o ens5 -j MASQUERADE" --postdown "iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o ens5 -j MASQUERADE"
#wg-meshconf addpeer aliyun --address 192.168.30.1/24 --allowedips 10.7.1.209/24 --endpoint 47.101.44.228 --postup "iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE" --postdown "iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE"

# Generate wg peer configuration files
wg-meshconf genconfig

# Copy wg peer configuration files to peer hosts & start wg
scp -i ~/zhy.pem output/zhy.conf ubuntu@$(terraform output -raw public_ip_addr_zhy):~
ssh -i ~/zhy.pem ubuntu@$(terraform output -raw public_ip_addr_zhy) "sudo cp zhy.conf /etc/wireguard/wg0.conf & sudo systemctl start wg-quick@wg0"

scp -i ~/bjs.pem output/bjs.conf ubuntu@$(terraform output -raw public_ip_addr_bjs):~
ssh -i ~/bjs.pem ubuntu@$(terraform output -raw public_ip_addr_bjs) "sudo cp bjs.conf /etc/wireguard/wg0.conf & sudo systemctl start wg-quick@wg0"

#scp -i ~/aliyunsh.pem output/aliyun.conf ecs-user@47.101.44.228:~
#ssh -i ~/aliyunsh.pem ecs-user@47.101.44.228 "sudo cp aliyun.conf /etc/wireguard/wg0.conf & sudo systemctl start wg-quick@wg0"

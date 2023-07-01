1. Architecture Overview - Multi-Cloud云服务器Mesh网络

以亚马逊云科技宁夏区域、北京区域和其他公有云的3台云服务器为例，介绍如何搭建Multi-Cloud云服务器的Mesh网络，其中WireGuard conf配置文件可以通过wg-meshconf自动产生。
![Architecture Overview](https://github.com/jasonliu929/terraform-wgmesh4gcr/blob/main/images/overview.png)

2. Mesh网络配置自动化 - Bastion 环境配置

2.1 准备一台Bastion云服务器，用来运行Terraform脚本，以在宁夏、北京区域自动创建VPC和云服务器，以及生成多个WireGuard Peer节点的配置文件，并推送到Peer节点。
安装wg-meshconf, 用于生成多个peer节点的配置文件：wg0.conf

$ sudo apt install python3-pip -y

$ sudo -u ubuntu pip install --user -U wg-meshconf -i https://pypi.tuna.tsinghua.edu.cn/simple

2.2 安装Terraform for Ubuntu, 其他系统版本可以参考：https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

$ sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

$ wget -O- https://apt.releases.hashicorp.com/gpg | \\

gpg --dearmor | \\

sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

$ echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list    #Add the official HashiCorp repository to your system.

$ sudo apt update                 #Download the package information from HashiCorp

$ sudo apt-get install terraform        #Install Terraform from the new repository

$ export AWS_ACCESS_KEY_ID=AKI....FWL

$ export AWS_SECRET_ACCESS_KEY=axc.....ay2



3. Mesh网络配置自动化 - Terraform

TerraformTF配置文件主要包括：main.tf, outputs.tf, variables.tf, versions.tf

其中main.tf 定义了VPC, security groups, EC2，用于分别在宁夏、北京区域创建VPC，EC2实例，并安装WireGuard。variables.tf 定义了配置使用的变量，例如区域、CIDR 块、子网数等。 

4. Mesh网络配置自动化 - wg-meshconf

bootstrap.sh脚本主要用于实现：

(1) apply terraform 配置

(2) 通过wg-meshconf 产生3个wireguard peer的conf配置文件, 具体wg-mesh介绍可以参考：https://github.com/k4yt3x/wg-meshconf

(3) 将conf配置文件分别复制到3个peer节点的相关路径：/etc/wireguard/wg0.conf，然后启动WireGuard服务

5. Mesh网络配置验证

通过wg-meshconf 可以查看3个Peer的相关配置, 然后3个peer都可以ping 其它2个Peer的私网IP
![Architecture Overview](https://github.com/jasonliu929/terraform-wgmesh4gcr/blob/main/images/validation.png)

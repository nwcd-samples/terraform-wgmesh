provider "aws" {
  region  = var.region-1
}


data "aws_availability_zones" "available_zhy" {}

module "vpc_zhy" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name                 = "vpc-zhy"
  cidr                 = var.vpc_cidr_block_region_1
  azs                  = data.aws_availability_zones.available_zhy.names
	private_subnets = slice(var.private_subnet_cidr_blocks_region_1, 0, var.private_subnet_count)
  public_subnets  = slice(var.public_subnet_cidr_blocks_region_1, 0, var.public_subnet_count)
	enable_nat_gateway 		= true
  enable_dns_hostnames 	= true
  enable_dns_support   	= true
}

resource "aws_security_group" "wgsg_zhy" {
  name   = "wgsg_zhy"
  vpc_id = module.vpc_zhy.vpc_id

  ingress {
    from_port   = 51820
    to_port     = 51820
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8 
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
	

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc_zhy.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu_region_1" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20230302"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

resource "aws_instance" "wg_peer_zhy" {
  ami           = data.aws_ami.ubuntu_region_1.id
  instance_type = var.ins_type
  key_name      = var.key_region_1
	vpc_security_group_ids = [aws_security_group.wgsg_zhy.id]
	subnet_id							= module.vpc_zhy.public_subnets[0]
	associate_public_ip_address = true
	monitoring		= true
  user_data     = <<EOF
#!/bin/bash
sudo apt-get update
sudo apt install wireguard -y
sudo echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sudo sysctl -p
EOF

  root_block_device {
      volume_type = "gp3"
      volume_size = 8
  }

  tags = {
    Name = "wg_peer_zhy"
  }
}

resource "aws_instance" "wg_peer_zhy_ins" {
  ami           = data.aws_ami.ubuntu_region_1.id
  instance_type = var.ins_type
  key_name      = var.key_region_1
	vpc_security_group_ids = [aws_security_group.wgsg_zhy.id]
	subnet_id							= module.vpc_zhy.private_subnets[0]
	associate_public_ip_address = false
	monitoring		= true

  root_block_device {
      volume_type = "gp3"
      volume_size = 8
  }

  tags = {
    Name = "wg_peer_zhy_ins"
  }
}

data "aws_subnet" "public_subnet_zhy" {
	id = aws_instance.wg_peer_zhy.subnet_id
}

provider "aws" {
	alias		= "bjs"
  region  = var.region-2
}


data "aws_availability_zones" "available_bjs" {
	provider			= aws.bjs
}


module "vpc_bjs" {
	providers = {
		aws = aws.bjs
	}

  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name                 = "vpc-bjs"
  cidr                 = var.vpc_cidr_block_region_2
  azs                  = data.aws_availability_zones.available_bjs.names
	private_subnets = slice(var.private_subnet_cidr_blocks_region_2, 0, var.private_subnet_count)
  public_subnets  = slice(var.public_subnet_cidr_blocks_region_2, 0, var.public_subnet_count)
	enable_nat_gateway 		= true
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_security_group" "wgsg_bjs" {
	provider			= aws.bjs
  name   = "wgsg_bjs"
  vpc_id = module.vpc_bjs.vpc_id

  ingress {
    from_port   = 51820
    to_port     = 51820
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.6.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu_region_2" {
		provider			= aws.bjs
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20230302"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

resource "aws_instance" "wg_peer_bjs" {
	provider			= aws.bjs
  ami           = data.aws_ami.ubuntu_region_2.id
  instance_type = var.ins_type
  key_name      = var.key_region_2
  //key_name      = "bjs"
	vpc_security_group_ids = [aws_security_group.wgsg_bjs.id]
	subnet_id							= module.vpc_bjs.public_subnets[0]
  associate_public_ip_address = true
	monitoring		= true
  user_data     = <<EOF
#!/bin/bash
sudo apt-get update
sudo apt install wireguard -y
sudo echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sudo sysctl -p
EOF

  root_block_device {
      volume_type = "gp3"
      volume_size = 8
  }

  tags = {
    Name = "wg_peer_bjs"
  }
}

resource "aws_instance" "wg_peer_bjs_ins" {
	provider			= aws.bjs
  ami           = data.aws_ami.ubuntu_region_2.id
  instance_type = var.ins_type
  key_name      = var.key_region_2
	vpc_security_group_ids = [aws_security_group.wgsg_bjs.id]
	subnet_id							= module.vpc_bjs.private_subnets[0]
	associate_public_ip_address = false
	monitoring		= true

  root_block_device {
      volume_type = "gp3"
      volume_size = 8
  }

  tags = {
    Name = "wg_peer_bjs_ins"
  }
}

data "aws_subnet" "public_subnet_bjs" {
	provider			= aws.bjs
	id = aws_instance.wg_peer_bjs.subnet_id
}

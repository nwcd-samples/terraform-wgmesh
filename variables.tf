variable "region-1" {
  description = "The 1st region Terraform deploys your instances"
  type        = string
  default     = "cn-northwest-1"
}

variable "region-2" {
  description = "The 2nd region Terraform deploys your instances"
  type        = string
  default     = "cn-north-1"
}

variable "vpc_cidr_block_region_1" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.5.0.0/16"
}

variable "public_subnet_cidr_blocks_region_1" {
  description = "Available cidr blocks for public subnets"
  type        = list(string)
  default = [
    "10.5.1.0/24",
    "10.5.2.0/24",
    "10.5.3.0/24",
    "10.5.4.0/24",
    "10.5.5.0/24",
    "10.5.6.0/24",
    "10.5.7.0/24",
    "10.5.8.0/24",
  ]
}

variable "private_subnet_cidr_blocks_region_1" {
  description = "Available cidr blocks for private subnets"
  type        = list(string)
  default = [
    "10.5.101.0/24",
    "10.5.102.0/24",
    "10.5.103.0/24",
    "10.5.104.0/24",
    "10.5.105.0/24",
    "10.5.106.0/24",
    "10.5.107.0/24",
    "10.5.108.0/24",
  ]
}

variable "vpc_cidr_block_region_2" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.6.0.0/16"
}

variable "public_subnet_cidr_blocks_region_2" {
  description = "Available cidr blocks for public subnets"
  type        = list(string)
  default = [
    "10.6.1.0/24",
    "10.6.2.0/24",
    "10.6.3.0/24",
    "10.6.4.0/24",
    "10.6.5.0/24",
    "10.6.6.0/24",
    "10.6.7.0/24",
    "10.6.8.0/24",
  ]
}

variable "private_subnet_cidr_blocks_region_2" {
  description = "Available cidr blocks for private subnets"
  type        = list(string)
  default = [
    "10.6.101.0/24",
    "10.6.102.0/24",
    "10.6.103.0/24",
    "10.6.104.0/24",
    "10.6.105.0/24",
    "10.6.106.0/24",
    "10.6.107.0/24",
    "10.6.108.0/24",
  ]
}

variable "public_subnet_count" {
  description = "Number of public subnets."
  type        = number
  default     = 2
}

variable "private_subnet_count" {
  description = "Number of private subnets."
  type        = number
  default     = 2
}

variable "ins_type" {
  description = "Instance Type"
  type        = string
  default     = "c6i.xlarge"
}

variable "key_region_1" {
  description = "Key for region 1"
  type        = string
  default     = "zhy"
}

variable "key_region_2" {
  description = "Key for region 1"
  type        = string
  default     = "bjs"
}



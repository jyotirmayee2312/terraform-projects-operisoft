variable "key_pair_name" {
  type    = string
  default = "jyoti-key-pair"  # Set your default key pair name here
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"  # Set the default CIDR block for VPC
}

variable "subnet_cidr_block" {
  type    = string
  default = "10.0.1.0/24"  # Set the default CIDR block for Subnet
}

variable "ami_id" {
  type    = string
  default = "ami-0287a05f0ef0e9d9a"  # Set your default AMI ID here
}

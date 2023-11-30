resource "tls_private_key" "example" {
  algorithm = "RSA"
}

resource "aws_key_pair" "example" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.example.public_key_openssh
}

resource "local_file" "private_key" {
  filename        = "jyoti.pem"  # Specify the desired filename
  content         = tls_private_key.example.private_key_pem
  file_permission = "0600"  # Set the desired file permissions
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_route_table" "r" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id        = aws_subnet.main.id
  route_table_id   = aws_route_table.r.id
}

resource "aws_security_group" "example" {
  name        = "example"
  description = "Example security group"
  vpc_id      = aws_vpc.main.id

  # Ingress rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.example.id]
  key_name               = aws_key_pair.example.key_name

  tags = {
    Name = "my_ec2_instance"
  }
}

resource "aws_eip" "example_eip" {
  instance = aws_instance.example.id
  vpc      = true  # Allocate the Elastic IP in the same VPC as the EC2 instance
}

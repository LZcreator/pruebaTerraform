virginia_cidr = "10.10.0.0/16"

# practica parte 1
# public_subnet  = "10.10.0.0/24"
# private_subnet = "10.10.1.0/24"

subnets = ["10.10.0.0/24", "10.10.1.0/24"]

# parte 2
tags = {
  "env"     = "dev"
  "owner"   = "yasmin"
  "cloud"   = "aws"
  "IAC"     = "terraform"
  "project" = "cerberus"
  "region"  = "virginia"
}

sg_ingress_cidr = "0.0.0.0/0"

ec2_specs = {
  "ami"           = "ami-085386e29e44dacd7"
  "instance_type" = "t2.micro"
}

# enable_monitoring = true
# enable_monitoring = 1

ingress_ports_list = [22, 80, 443]
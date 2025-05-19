resource "aws_vpc" "vpc_virginia" {
  cidr_block = var.virginia_cidr
  # parte 2: sacamos los tags los creamos en variables y los declaramos en terraform.tfvars y los ponemos por defecto en providers, para que siempre se añadan eses que son comunes en todos
  tags = {
    Name = "VPC_VIRGINIA-${local.sufix}"
    #   name = "prueba"
    #   env  = "Dev"
  }
}

# practica parte 1
# resource "aws_subnet" "public_subnet" {
#   vpc_id                  = aws_vpc.vpc_virginia.id
#   cidr_block              = var.public_subnet
#   map_public_ip_on_launch = true #para que la subnet sea publica hay que poner esta linea a true porque por defecto viene en false
# }

# resource "aws_subnet" "private_subnet" {
#   vpc_id     = aws_vpc.vpc_virginia.id
#   cidr_block = var.private_subnet
# }

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc_virginia.id
  cidr_block              = var.subnets[0]
  map_public_ip_on_launch = true #para que la subnet sea publica hay que poner esta linea a true porque por defecto viene en false
  tags = {
    Name = "Public_subnet-${local.sufix}"
    #   name = "prueba"
    #   env  = "Dev"
  }

}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpc_virginia.id
  cidr_block = var.subnets[1]
  tags = {
    Name = "Private_subnet_1-${local.sufix}"
    #   name = "prueba"
    #   env  = "Dev"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_virginia.id
  tags = {
    Name = "igw_vpc_virginia-${local.sufix}"
  }
}

resource "aws_route_table" "public_crt" {
  vpc_id = aws_vpc.vpc_virginia.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_crt-${local.sufix}"
  }
}

resource "aws_route_table_association" "crta_public_subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_crt.id
}

resource "aws_security_group" "sg_public_instance" {
  name        = "Public Instance SG"
  description = "Allow SSH inbound traffic and all egress traffic"
  vpc_id      = aws_vpc.vpc_virginia.id

  dynamic "ingress" {
    for_each = var.ingress_ports_list
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.sg_ingress_cidr]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "Public_Instance_SG-${local.sufix}"
  }
}

module "mybucket" {
  source      = "./modulos/s3"
  bucket_name = "lz-terraform-state-ylema-20250519"
}

output "s3_arn" {
  value = module.mybucket.s3_bucket_arn
}

# module "terraform_state_backend" {
#   source      = "cloudposse/tfstate-backend/aws"
#   version     = "1.5.0"
#   namespace   = "example"
#   stage       = "prod"
#   name        = "terraformyasminlz"
#   environment = "us-east-1"
#   attributes  = ["state"]

#   terraform_backend_config_file_path = "."
#   terraform_backend_config_file_name = "backend.tf"
#   force_destroy                      = false
# }
variable "instancias" {
  description = "Nombre de las instancias"
  # type        = set(string)
  type    = list(string)
  default = ["apache"] # ["apache", "mysql", "jumpserver"]
}

resource "aws_instance" "public_instance" {
  # for_each               = var.instancias
  # count                  = length(var.instancias)
  for_each               = toset(var.instancias)
  ami                    = var.ec2_specs.ami
  instance_type          = var.ec2_specs.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = data.aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]
  user_data              = file("scripts/userdata.sh")

  tags = {
    "Name" = "${each.value}-${local.sufix}"
    # "Name" = var.instancias[count.index]
  }
}

# resource "aws_instance" "monitoring_instance" {
#   #count                  = var.enable_monitoring ? 1 : 0
#   count                  = var.enable_monitoring == 1 ? 1 : 0
#   ami                    = var.ec2_specs.ami
#   instance_type          = var.ec2_specs.instance_type
#   subnet_id              = aws_subnet.public_subnet.id
#   key_name               = data.aws_key_pair.key.key_name
#   vpc_security_group_ids = [aws_security_group.sg_public_instance.id]
#   user_data              = file("scripts/userdata.sh")

#   tags = {
#     "Name" = "Monitoreo-${local.sufix}"
#   }
# }
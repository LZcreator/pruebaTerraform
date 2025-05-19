variable "virginia_cidr" {
  description = "CIDR Virginia"
  type        = string
  sensitive   = false # si lo tenemos en true no se vera el valor
}

# practica parte 1
# variable "public_subnet" {
#   description = "CIDR public subnet"
#   type        = string
# }

# variable "private_subnet" {
#   description = "CIDR private subnet"
#   type        = string
# }

variable "subnets" {
  description = "lista de subnets"
  type        = list(string)
}

# parte 2
variable "tags" {
  description = "tags del proyecto"
  type        = map(string)
}

variable "sg_ingress_cidr" {
  description = "CIDR for ingree traffic"
  type        = string
}

variable "ec2_specs" {
  description = "Parametros de la instancia"
  type        = map(string)
}

# variable "enable_monitoring" {
#   description = "Habilita el despliegue de un servidor de monitoreo"
#   type        = number
#   # type        = bool
# }

variable "ingress_ports_list" {
  description = "lista de puertos de ingress"
  type        = list(number)
}
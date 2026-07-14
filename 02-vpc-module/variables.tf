variable "aws_region" {
  description = "Region de AWS donde se despliega la infraestructura."
  type        = string
  default     = "eu-west-1"
}

variable "project_name" {
  description = "Prefijo usado en nombres y tags de los recursos."
  type        = string
  default     = "lemoncode-m6"

  validation {
    condition     = length(var.project_name) <= 32
    error_message = "project_name no puede exceder 32 caracteres."
  }
}

variable "vpc_cidr" {
  description = "Bloque CIDR de la VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDRs de las subnets publicas (una por AZ). El modulo las reparte por AZ."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "instance_type" {
  description = "Tipo de instancia EC2."
  type        = string
  default = "t3.micro"
}

variable "ssh_allowed_cidr" {
  description = <<-EOT
    CIDR autorizado para SSH (puerto 22). Si se deja como null, el codigo detecta
    automaticamente tu IP publica via checkip.amazonaws.com y la usa como /32.
  EOT
  type        = string
  default     = null
}

variable "auto_deploy_nginx" {
  description = "Si es true, el user_data levanta tambien un NGINX en el puerto 80."
  type        = bool
  default     = false
}

variable "aws_region" {
  description = "Region de AWS donde se despliega la infraestructura."
  type        = string
  default     = "eu-west-1" # Irlanda: cercana a Espana, barata y con AMIs free-tier disponibles.
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

variable "subnet_cidr" {
  description = "Bloque CIDR de la subnet publica (debe estar contenido en vpc_cidr)."
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "Tipo de instancia EC2."
  type        = string
  # El tipo elegible para el free tier depende del tipo de cuenta:
  #   - Cuentas NUEVAS (modelo de creditos, desde 15-07-2025): la API solo deja
  #     lanzar tipos free-tier-eligible; en eu-west-1 eso es t3.micro (NO t2.micro).
  #   - Cuentas legacy (750 h/mes): en eu-west-1 la cubierta es t2.micro.
  # Comprueba cual te aplica con:
  #   aws ec2 describe-instance-types --filters "Name=free-tier-eligible,Values=true" \
  #     --query "InstanceTypes[].InstanceType" --region eu-west-1 --output text
  # Default t3.micro: cubre el caso mas comun hoy (cuentas nuevas).
  default = "t3.micro"
}

variable "ssh_allowed_cidr" {
  description = <<-EOT
    CIDR autorizado para SSH (puerto 22). Si se deja como null, el codigo detecta
    automaticamente tu IP publica via checkip.amazonaws.com y la usa como /32.
    Para fijarla a mano: "203.0.113.10/32".
  EOT
  type        = string
  default     = null
}

variable "auto_deploy_nginx" {
  description = <<-EOT
    Si es true, el user_data ademas de instalar Docker levanta un contenedor NGINX
    en el puerto 80 automaticamente (util para ver HTTP sin entrar por SSH).
    El enunciado pide hacerlo a mano por SSH, asi que el valor por defecto es false.
  EOT
  type        = bool
  default     = false
}

# ──────────────────────────────────────────────────────────────────────────
# Refactor de la red con el VPC Module oficial
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
#
# Este unico bloque sustituye a network.tf de la fase 1
# ──────────────────────────────────────────────────────────────────────────

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0" # v6.x es la linea actual (verificada en el registry).

  name = "${var.project_name}-vpc"
  cidr = var.vpc_cidr

  azs            = slice(data.aws_availability_zones.available.names, 0, length(var.public_subnet_cidrs))
  public_subnets = var.public_subnet_cidrs

  enable_nat_gateway = false

  map_public_ip_on_launch = true

  enable_dns_support   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    Tier = "public"
  }
}

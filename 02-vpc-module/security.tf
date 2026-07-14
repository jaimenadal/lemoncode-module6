data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
}

locals {
  ssh_cidr = coalesce(
    var.ssh_allowed_cidr,
    "${trimspace(data.http.my_ip.response_body)}/32"
  )
}

resource "aws_security_group" "web" {
  name        = "${var.project_name}-web-sg"
  description = "Permite HTTP desde cualquier IP y SSH solo desde la IP autorizada"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "${var.project_name}-web-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.web.id
  description       = "HTTP desde cualquier IP"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.web.id
  description       = "SSH solo desde la IP autorizada"
  cidr_ipv4         = local.ssh_cidr
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.web.id
  description       = "Permitir todo el trafico de salida"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

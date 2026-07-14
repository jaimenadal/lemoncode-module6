# ──────────────────────────────────────────────────────────────────────────
# Instancia EC2 en la subnet publica, con free tier AMI
# ──────────────────────────────────────────────────────────────────────────

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.al2023.id
  instance_type = var.instance_type

  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]

  key_name = aws_key_pair.ec2.key_name

  user_data = templatefile("${path.module}/user-data.sh.tftpl", {
    auto_deploy_nginx = var.auto_deploy_nginx
  })

  root_block_device {
    volume_type = "gp3"
    volume_size = 8
  }

  tags = {
    Name = "${var.project_name}-web"
  }
}

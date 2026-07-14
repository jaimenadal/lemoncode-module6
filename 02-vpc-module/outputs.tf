# ──────────────────────────────────────────────────────────────────────────
#  Output con la IP publica + ayudas para conectar y servir HTTP
# ──────────────────────────────────────────────────────────────────────────

output "instance_public_ip" {
  description = "IP publica de la instancia EC2 desplegada."
  value       = aws_instance.web.public_ip
}

output "ssh_command" {
  description = "Comando listo para conectar por SSH a la instancia."
  value       = "ssh -i ${var.project_name}-key.pem ec2-user@${aws_instance.web.public_ip}"
}

output "http_url" {
  description = "URL para comprobar el servicio HTTP una vez levantado NGINX."
  value       = "http://${aws_instance.web.public_ip}"
}

output "deploy_nginx_command" {
  description = "Comando a ejecutar DENTRO de la instancia (por SSH) para servir en el puerto 80."
  value       = "docker run -d --name nginx -p 80:80 nginx:1.27-alpine"
}

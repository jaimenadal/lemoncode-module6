# Lemoncode DevOps · Módulo 6 — Infraestructura como Código (Terraform + AWS)

Solución en Terraform para el ejercicio de IaC del Módulo 6. Provisiona una VPC
pública en AWS, una subnet pública con salida a internet, security groups, un par
de claves SSH y una instancia EC2 con Docker. Viene en dos fases:

- **`01-recursos-base/`** — puntos **1–7** del ejercicio: cada recurso de red
  escrito a mano (VPC, internet gateway, subnet, tabla de rutas, security group,
  key pair, EC2 con `user_data` que instala Docker, outputs).
- **`02-vpc-module/`** — punto **8**: la red refactorizada sobre el
  [VPC Module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
  oficial (fijado a `~> 6.0`). Mismo security group, key pair, EC2 y outputs.

Ambas fases son módulos raíz independientes: entra en una con `cd` y ejecútala.

## Requisitos

- Terraform `>= 1.6` (u OpenTofu `>= 1.6`; el HCL es compatible).
- Credenciales de AWS configuradas (`aws configure` o variables de entorno).

## Desplegar

```bash
cd 01-recursos-base          # o 02-vpc-module
cp terraform.tfvars.example terraform.tfvars   # opcional, edita lo que quieras
terraform init
terraform apply
```

Tras el `apply`, Terraform imprime la IP pública y comandos listos para usar:

```bash
ssh -i lemoncode-m6-key.pem ec2-user@<IP_PUBLICA>     # conectar (punto 5)
docker run -d --name nginx -p 80:80 nginx:1.27-alpine # servir en :80 (punto 7)
```

Luego abre `http://<IP_PUBLICA>`. Para levantar NGINX automáticamente sin SSH,
pon `auto_deploy_nginx = true`.

## Destruir (importante)

```bash
terraform destroy
```

## Avisos de coste (léelos antes de aplicar del punto 5 en adelante)

Los puntos 1–4 son gratuitos. A partir del punto 5 (EC2) puedes incurrir en
gastos.

Haz siempre `terraform destroy` al terminar para evitar sorpresas.

## Mapa ejercicio → fichero

| Punto | Qué | Fichero fase 1 | Fase 2 |
|---|---|---|---|
| 1 | VPC + internet gateway | `network.tf` | `main.tf` (módulo) |
| 2 | Subnet + tabla de rutas + asociación | `network.tf` | `main.tf` (módulo) |
| 3 | Security groups (80 todos, 22 tu IP) | `security.tf` | `security.tf` |
| 4 | Key pair | `keypair.tf` | `keypair.tf` |
| 5 | EC2 en la subnet, AMI free tier | `compute.tf` | `compute.tf` |
| 6 | `user_data` instala Docker | `user-data.sh.tftpl` | igual |
| 7 | Output IP pública + servir NGINX | `outputs.tf` | igual |
| 8 | Refactor sobre VPC Module | — | `main.tf` |













# Proyecto 5: Terraform VPC - Infrastructure as Code

**Infraestructura de red completa en AWS usando Terraform como Infrastructure as Code.**

---

## 📋 Descripción General

Este proyecto implementa una **Virtual Private Cloud (VPC)** en AWS completamente gestionada por Terraform. Se crea una arquitectura de red empresarial con subnets públicas y privadas, gateways de acceso a internet, rutas de tráfico y grupos de seguridad.

**Objetivo:** Aprender Infrastructure as Code (IaC) con Terraform y crear la base de red para desplegar aplicaciones en AWS.

---

## 🎯 ¿Qué se espera que pase?

Cuando ejecutes `terraform apply`:

1. ✅ **VPC se crea** con CIDR 10.0.0.0/16
2. ✅ **4 Subnets se crean:**
   - 2 públicas (acceso directo a internet)
   - 2 privadas (sin acceso directo a internet)
3. ✅ **Internet Gateway se crea** para tráfico entrante desde internet
4. ✅ **NAT Gateway se crea** para tráfico saliente desde subnets privadas
5. ✅ **Route Tables se crean** para dirigir el tráfico
6. ✅ **Security Groups se crean** para controlar acceso
7. ✅ **Outputs se muestran** con IDs de recursos creados

**Resultado:** Una infraestructura de red lista para desplegar aplicaciones (EC2, RDS, ECS, etc.)

---

## 🏗️ Arquitectura

```
                    Internet (0.0.0.0/0)
                           ↓
                   [Internet Gateway]
                           ↓
              ┌────────────────────────┐
              │   VPC (10.0.0.0/16)    │
              │                        │
    ┌─────────────────────────────────────────────┐
    │                                             │
    │  PUBLIC SUBNETS (acceso a internet)         │
    │  ├─ 10.0.1.0/24 (us-east-1a)                │
    │  └─ 10.0.2.0/24 (us-east-1b)                │
    │                                             │
    │  PRIVATE SUBNETS (sin acceso directo)       │
    │  ├─ 10.0.10.0/24 (us-east-1a)               │
    │  └─ 10.0.11.0/24 (us-east-1b)               │
    │         ↓                                   │
    │    [NAT Gateway]                            │
    │         ↓                                   │
    │    (tráfico saliente)                       │
    │                                             │
    └─────────────────────────────────────────────┘
```

---

## 📦 Estructura del Proyecto

```
proyecto5-terraform-vpc/
├── main.tf                 # Recursos principales (VPC, Subnets, IGW, NGW, etc)
├── variables.tf            # Declaración de variables
├── outputs.tf              # Valores que se muestran después de apply
├── terraform.tfvars        # Valores específicos de variables
├── providers.tf            # Configuración del provider AWS
├── .gitignore              # Archivos a ignorar en Git
└── README.md               # Este archivo
```

---

## 🚀 Uso Rápido

### Prerequisitos

- **Terraform** 1.0+ ([Descargar](https://www.terraform.io/downloads))
- **AWS CLI** configurado con credenciales
- **Cuenta AWS** activa

### Instalación y Despliegue

```bash
# 1. Clona el repositorio
git clone https://github.com/Ferdev49/proyecto5-terraform-vpc.git
cd proyecto5-terraform-vpc

# 2. Inicializa Terraform
terraform init

# 3. Revisa qué se va a crear
terraform plan

# 4. Crea la infraestructura
terraform apply

# 5. Ve los outputs
terraform output

# 6. Destruye (para evitar costos)
terraform destroy
```

---

## 📊 Componentes Creados

### VPC (Virtual Private Cloud)

```hcl
CIDR: 10.0.0.0/16
Region: us-east-1
DNS: Habilitado
```

**Propósito:** Aislamiento de red, rango privado de IPs para tu infraestructura.

---

### Subnets Públicas

```
Subnet 1: 10.0.1.0/24 (us-east-1a)
Subnet 2: 10.0.2.0/24 (us-east-1b)
```

**Propósito:** Alojar recursos que necesitan acceso directo a internet (web servers, NAT gateways, etc).

---

### Subnets Privadas

```
Subnet 1: 10.0.10.0/24 (us-east-1a)
Subnet 2: 10.0.11.0/24 (us-east-1b)
```

**Propósito:** Alojar recursos que NO necesitan acceso directo a internet (bases de datos, aplicaciones internas, etc).

---

### Internet Gateway (IGW)

```
Permite comunicación entre:
VPC ↔ Internet (0.0.0.0/0)
```

**Propósito:** Dar acceso a internet a los recursos en subnets públicas.

---

### NAT Gateway

```
Ubicado en: Subnet pública (10.0.1.0/24)
IP Elástica: Asignada automáticamente
Propósito: Permitir que recursos privados salgan a internet
           sin exponer sus IPs privadas
```

**¿Por qué?** Los recursos privados pueden descargar actualizaciones, consultar APIs externas, etc., sin ser accesibles desde internet.

---

### Route Tables

#### Route Table Pública
```
Destino        Gateway
0.0.0.0/0      Internet Gateway
```
**Efecto:** Todo tráfico a internet va por IGW

#### Route Table Privada
```
Destino        Gateway
0.0.0.0/0      NAT Gateway
```
**Efecto:** Todo tráfico a internet va por NAT Gateway

---

### Security Groups

#### Grupo Público
```
Ingress (entrante):
- Puerto 80 (HTTP):    0.0.0.0/0
- Puerto 443 (HTTPS):  0.0.0.0/0
- Puerto 22 (SSH):     0.0.0.0/0

Egress (saliente):
- Todo permitido
```

#### Grupo Privado
```
Ingress (entrante):
- Desde Security Group Público (puerto 0-65535)

Egress (saliente):
- Todo permitido
```

---

## 🔧 Variables Configurables

Edita `terraform.tfvars` para personalizar:

```hcl
aws_region = "us-east-1"              # Región AWS
environment = "dev"                   # Ambiente (dev/staging/prod)
project_name = "proyecto5"            # Nombre del proyecto

vpc_cidr = "10.0.0.0/16"              # CIDR de VPC
public_subnet_1_cidr = "10.0.1.0/24"  # CIDR subnet pública 1
public_subnet_2_cidr = "10.0.2.0/24"  # CIDR subnet pública 2
private_subnet_1_cidr = "10.0.10.0/24" # CIDR subnet privada 1
private_subnet_2_cidr = "10.0.11.0/24" # CIDR subnet privada 2

enable_nat_gateway = true             # Crear NAT Gateway (costo)
```

---

## 📤 Outputs

Después de `terraform apply`, ves:

```bash
vpc_id = "vpc-0c5e70f629615f4"
vpc_cidr = "10.0.0.0/16"

public_subnet_1_id = "subnet-04..."
public_subnet_2_id = "subnet-06..."

private_subnet_1_id = "subnet-0dc..."
private_subnet_2_id = "subnet-08..."

internet_gateway_id = "igw-0fe..."

nat_gateway_id = "nat-0e3..."
nat_gateway_ip = "54.157.82.163"

public_security_group_id = "sg-074..."
private_security_group_id = "sg-02c..."
```

Estos IDs los usas en próximos proyectos para crear EC2, RDS, etc.

---

## 💰 Costos

**Estimado mensual:**
- VPC: $0 (gratuito)
- NAT Gateway: ~$32/mes (si está en uso)
- Data transfer: ~$0.05 por GB

**Recomendación:** Ejecuta `terraform destroy` cuando no uses la infraestructura.

---

## 🔍 Debugging

### Ver los logs de Terraform

```bash
terraform plan -out=tfplan
terraform show tfplan
```

### Ver estado actual

```bash
terraform state list
terraform state show aws_vpc.main
```

### Refrescar estado

```bash
terraform refresh
```

---

## 🎓 Conceptos Aprendidos

1. **Infrastructure as Code (IaC):** Infraestructura definida como código
2. **Terraform Workflow:** init → plan → apply → destroy
3. **VPC:** Red virtual privada en AWS
4. **Subnets:** Segmentación de la VPC
5. **Routing:** Cómo se dirige el tráfico
6. **NAT Gateway:** Acceso a internet desde privadas
7. **Security Groups:** Firewall a nivel de recurso
8. **Outputs:** Valores útiles después del apply

---

## 📚 Recursos Adicionales

- [Terraform AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices)


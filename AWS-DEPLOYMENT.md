# Guía de Despliegue en AWS EC2

## 📋 Prerrequisitos

- Cuenta de AWS
- Key pair (.pem) para acceso SSH
- Conocimientos básicos de terminal/SSH

## 🚀 Paso a Paso para Desplegar en AWS

### 1. Crear Instancia EC2

1. **Acceder a la consola de AWS**
   - Ir a EC2 Dashboard
   - Click en "Launch Instance"

2. **Configurar la instancia**
   - **Nombre**: `backend-star-wars-server`
   - **AMI**: Amazon Linux 2023 (recomendado)
   - **Tipo de instancia**: t2.micro (elegible para free tier)
   - **Key pair**: Seleccionar o crear nuevo key pair
   - **Storage**: 8 GB (suficiente para el proyecto)

3. **Configurar Security Group**
   ```
   Reglas de entrada:
   - SSH (22) - Tu IP
   - HTTP (80) - Anywhere (0.0.0.0/0)
   - Custom TCP (3000) - Anywhere (0.0.0.0/0)
   ```

### 2. Conectar a la Instancia

```bash
# Cambiar permisos del archivo .pem
chmod 400 tu-key.pem

# Conectar via SSH
ssh -i "tu-key.pem" ec2-user@tu-ip-publica-ec2
```

### 3. Instalar Docker y Docker Compose

```bash
# Actualizar el sistema
sudo yum update -y

# Instalar Docker
sudo yum install docker -y

# Iniciar Docker
sudo systemctl start docker
sudo systemctl enable docker

# Agregar usuario al grupo docker
sudo usermod -a -G docker ec2-user

# Cerrar sesión y volver a conectar para aplicar cambios
exit
ssh -i "tu-key.pem" ec2-user@tu-ip-publica-ec2

# Instalar Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verificar instalación
docker --version
docker-compose --version
```

### 4. Instalar Git y Clonar Repositorio

```bash
# Instalar Git
sudo yum install git -y

# Clonar tu repositorio
git clone https://github.com/tu-usuario/tu-repositorio.git
cd tu-repositorio/BACK-NEST/backend-star-wars-01
```

### 5. Construir y Ejecutar con Docker

```bash
# Construir la imagen
docker build -t backend-star-wars .

# Ejecutar con docker-compose
docker-compose up -d

# Verificar que esté funcionando
docker-compose ps
docker-compose logs backend
```

### 6. Verificar Funcionamiento

```bash
# Probar desde el servidor
curl http://localhost:3000/saludar

# Probar desde internet
curl http://tu-ip-publica:3000/saludar
```

## 🔧 Configuraciones Adicionales

### Variables de Entorno

Crear archivo `.env` en el servidor:

```bash
nano .env
```

Contenido:
```env
NODE_ENV=production
PORT=3000
```

### Configurar Nginx (Opcional)

Si quieres usar nginx como reverse proxy:

```bash
# Crear archivo de configuración nginx
nano nginx.conf
```

Contenido:
```nginx
events {
    worker_connections 1024;
}

http {
    upstream backend {
        server backend:3000;
    }

    server {
        listen 80;
        server_name tu-dominio.com;  # o tu IP pública
        
        location / {
            proxy_pass http://backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
}
```

Ejecutar con nginx:
```bash
docker-compose --profile with-nginx up -d
```

## 📊 Monitoreo y Mantenimiento

### Comandos Útiles

```bash
# Ver logs en tiempo real
docker-compose logs -f backend

# Reiniciar servicios
docker-compose restart

# Actualizar aplicación
git pull origin main
docker-compose build
docker-compose up -d

# Verificar uso de recursos
docker stats
```

### Backup y Restauración

```bash
# Hacer backup de la aplicación
tar -czf backup-$(date +%Y%m%d).tar.gz tu-repositorio/

# Restaurar desde backup
tar -xzf backup-YYYYMMDD.tar.gz
```

## 🔒 Seguridad

### Configuraciones Recomendadas

1. **Firewall**:
   ```bash
   # Instalar firewall
   sudo yum install firewalld -y
   sudo systemctl start firewalld
   sudo systemctl enable firewalld
   
   # Configurar reglas
   sudo firewall-cmd --permanent --add-port=22/tcp
   sudo firewall-cmd --permanent --add-port=80/tcp
   sudo firewall-cmd --permanent --add-port=3000/tcp
   sudo firewall-cmd --reload
   ```

2. **Actualizaciones automáticas**:
   ```bash
   sudo yum install yum-cron -y
   sudo systemctl enable yum-cron
   sudo systemctl start yum-cron
   ```

## 💰 Optimización de Costos

### Free Tier
- Usar t2.micro (elegible para free tier)
- 750 horas/mes gratis el primer año
- 30 GB de almacenamiento EBS gratis

### Buenas Prácticas
- Parar la instancia cuando no la uses
- Monitorear el uso para evitar cargos inesperados
- Usar CloudWatch para alertas

## 🚨 Troubleshooting

### Problemas Comunes

1. **No se puede conectar por SSH**:
   - Verificar security group (puerto 22 abierto)
   - Verificar permisos del archivo .pem (chmod 400)

2. **Docker no funciona**:
   - Verificar que el usuario esté en el grupo docker
   - Reiniciar la sesión SSH

3. **Aplicación no responde**:
   - Verificar logs: `docker-compose logs backend`
   - Verificar puertos: `netstat -tlnp`

4. **No se puede acceder desde internet**:
   - Verificar security group (puerto 3000 abierto)
   - Verificar que el contenedor esté ejecutándose

### URLs de Acceso

- **Directa**: `http://tu-ip-publica:3000`
- **Con nginx**: `http://tu-ip-publica`
- **Endpoints**:
  - `http://tu-ip-publica:3000/saludar`
  - `http://tu-ip-publica:3000/products/123`

## 📞 Soporte

Si tienes problemas:
1. Revisar logs del contenedor
2. Verificar configuración de security groups
3. Comprobar que Docker esté funcionando
4. Verificar conectividad de red
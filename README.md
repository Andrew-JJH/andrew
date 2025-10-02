# Backend Star Wars API

API REST desarrollada con NestJS para gestionar información relacionada con Star Wars.

## 🚀 Características

- **Framework**: NestJS
- **Lenguaje**: TypeScript
- **Contenedorización**: Docker
- **Endpoints**: API REST

## 📋 Endpoints Disponibles

- `GET /saludar` - Endpoint de saludo
- `POST /` - Crear nuevo elemento
- `GET /products/:productId` - Obtener producto por ID

## 🛠️ Desarrollo Local

### Prerrequisitos

- Node.js 18+
- npm

### Instalación

```bash
# Clonar el repositorio
git clone <tu-repositorio>
cd backend-star-wars-01

# Instalar dependencias
npm install

# Ejecutar en modo desarrollo
npm run start:dev
```

La aplicación estará disponible en `http://localhost:3000`

### Scripts Disponibles

```bash
npm run start:dev    # Ejecutar en modo desarrollo
npm run build        # Construir para producción
npm run start:prod   # Ejecutar en modo producción
npm run test         # Ejecutar tests
```

## 🐳 Docker

### Construcción y Ejecución

```bash
# Construir imagen Docker
docker build -t backend-star-wars .

# Ejecutar contenedor
docker run -p 3000:3000 backend-star-wars
```

### Docker Compose

```bash
# Ejecutar con docker-compose
docker-compose up -d

# Ejecutar con nginx (opcional)
docker-compose --profile with-nginx up -d

# Detener servicios
docker-compose down
```

### 1. Preparación de la instancia EC2

```bash
# Conectar a la instancia EC2
ssh -i "tu-key.pem" ec2-user@tu-ip-publica

# Actualizar sistema
sudo yum update -y

# Instalar Docker
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user

# Instalar Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### 2. Desplegar la aplicación

```bash
# Clonar el repositorio
git clone <tu-repositorio>
cd backend-star-wars-01

# Construir y ejecutar
docker-compose up -d
```

### 3. Configurar Security Group

En la consola de AWS, asegúrate de que el Security Group permita:
- Puerto 22 (SSH)
- Puerto 3000 (API)
- Puerto 80 (HTTP) si usas nginx

### 4. Acceder a la aplicación

```
http://tu-ip-publica:3000/saludar
```

## 🔧 Configuración de Producción

### Variables de Entorno

Crear archivo `.env`:

```env
NODE_ENV=production
PORT=3000
```

### Nginx (Opcional)

Para usar nginx como reverse proxy, crear `nginx.conf`:

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
        
        location / {
            proxy_pass http://backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
}
```

## 📝 Estructura del Proyecto

```
src/
├── app.controller.ts    # Controlador principal
├── app.service.ts       # Servicio principal
├── app.module.ts        # Módulo principal
└── main.ts             # Punto de entrada
```

## 🚀 Comandos Útiles para GitHub

```bash
# Inicializar repositorio Git
git init
git add .
git commit -m "Initial commit"

# Conectar con repositorio remoto
git remote add origin <tu-repositorio-github>
git push -u origin main
```

## 📊 Monitoreo y Logs

```bash
# Ver logs de la aplicación
docker-compose logs -f backend

# Verificar estado de contenedores
docker-compose ps

# Acceder al contenedor
docker-compose exec backend sh
```

## 🔒 Seguridad

- La aplicación se ejecuta con un usuario no-root
- Incluye healthcheck para verificar el estado de la aplicación
- Security groups configurados adecuadamente en AWS

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la licencia UNLICENSED.

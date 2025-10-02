# Dockerfile para NestJS Backend
FROM node:18-alpine AS build

# Establecer directorio de trabajso
WORKDIR /app

# Copiar package.json y package-lock.json
COPY package*.json ./

# Instalar TODAS las dependencias (incluyendo devDependencies para el build)
RUN npm ci && npm cache clean --force

# Copiar código fuente
COPY . .

# Construir la aplicación
RUN npm run build

# Etapa de producción
FROM node:18-alpine AS production

# Establecer directorio de trabajo
WORKDIR /app

# Copiar package.json
COPY package*.json ./

# Instalar solo dependencias de producción
RUN npm ci --only=production && npm cache clean --force

# Copiar la aplicación construida desde la etapa de build
COPY --from=build /app/dist ./dist

# Crear usuario no-root para seguridad
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nestjs -u 1001

# Cambiar propiedad de archivos al usuario nestjs
USER nestjs

# Exponer puerto
EXPOSE 3000

# Comando para ejecutar la aplicación
CMD ["node", "dist/main"]
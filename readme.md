# Orchestration - Aura Microservices

Este directorio contiene la configuración de Docker Compose y scripts para orquestar todos los microservicios del proyecto Aura.

## 🚀 Inicio Rápido

### Prerrequisitos

- Docker y Docker Compose instalados en tu máquina

### Iniciar Todos los Servicios

Desde el directorio `orchestration`:

```bash
./start.sh
```

Este comando:
- Construye las imágenes Docker de todos los servicios
- Inicia PostgreSQL, RabbitMQ y todos los microservicios
- Los servicios quedan corriendo en segundo plano

### Detener Todos los Servicios

```bash
./stop.sh
```

## 📋 Servicios Incluidos

El `docker-compose.yml` orquesta los siguientes servicios:

- **PostgreSQL** (`db`): Base de datos compartida
- **RabbitMQ** (`rabbitmq`): Sistema de mensajería
- **Auth Service**: Autenticación y gestión de usuarios
- **Gateway**: API Gateway
- **Messaging Service**: Servicio de mensajería
- **Notifications Service**: Servicio de notificaciones
- **Social Service**: Servicio social

## 🔧 Comandos Útiles

Ver el estado de los servicios:
```bash
docker-compose ps
```

Ver logs de todos los servicios:
```bash
docker-compose logs -f
```

Ver logs de un servicio específico:
```bash
docker-compose logs -f auth-service
```

Reconstruir un servicio específico:
```bash
docker-compose up -d --build auth-service
```

## 📁 Archivos Importantes

- `docker-compose.yml`: Configuración de todos los servicios
- `init-postgres.sql`: Script de inicialización de bases de datos
- `start.sh`: Script para iniciar todos los servicios
- `stop.sh`: Script para detener todos los servicios
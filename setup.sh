#!/bin/bash

# =================================================================
# Script de Orquestación - Setup Global y RabbitMQ Auth
# =================================================================

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Iniciando Setup de Orquestación...${NC}\n"

# --- 1. Verificaciones Globales ---
echo -e "${YELLOW}--- 1. Verificando Herramientas Globales ---${NC}"

check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo -e "${RED}❌ $1 no está instalado.${NC}"
        return 1
    else
        echo -e "${GREEN}✅ $1 está instalado.${NC}"
        return 0
    fi
}

check_command "docker" || exit 1
check_command "npm" || echo -e "${YELLOW}⚠️ npm no encontrado, pero continuaremos con RabbitMQ.${NC}"

# Verificar permisos de Docker
if ! docker ps > /dev/null 2>&1; then
    echo -e "${RED}❌ No tienes permisos para ejecutar Docker.${NC}"
    echo -e "${YELLOW}ℹ️  Por favor ejecuta este script con sudo:${NC}"
    echo -e "   ${GREEN}sudo ./orquestacion/setup.sh${NC}"
    exit 1
fi

echo ""

# --- 2. Setup RabbitMQ Auth ---
echo -e "${YELLOW}--- 2. Configurando Autenticación de RabbitMQ ---${NC}"

# Resolver directorio del script para usar rutas absolutas
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
RABBITMQ_DIR="$SCRIPT_DIR/../rabbitmq"
RABBITMQ_CONTAINER="rabbitmq"

# Verificar si el directorio existe
if [ ! -d "$RABBITMQ_DIR" ]; then
    echo -e "${RED}❌ No se encontró el directorio $RABBITMQ_DIR${NC}"
    exit 1
fi

echo "Entrando a $RABBITMQ_DIR..."
cd "$RABBITMQ_DIR" || exit 1

# Asegurar que RabbitMQ esté corriendo
echo "Verificando estado de RabbitMQ..."
if ! docker ps | grep -q "$RABBITMQ_CONTAINER"; then
    echo "RabbitMQ no está corriendo. Iniciando..."
    docker compose up -d
    echo "Esperando a que RabbitMQ inicie (10s)..."
    sleep 10
else
    echo -e "${GREEN}✅ RabbitMQ ya está corriendo.${NC}"
fi

# Función para crear usuario y asignar permisos
create_rabbitmq_user() {
    local user=$1
    local pass=$2
    
    echo "Configurando usuario: $user"
    
    # Crear usuario (ignorar error si ya existe)
    docker exec "$RABBITMQ_CONTAINER" rabbitmqctl add_user "$user" "$pass" 2>/dev/null
    if [ $? -eq 0 ]; then
         echo -e "${GREEN}  ✅ Usuario '$user' creado.${NC}"
    else
         echo -e "${YELLOW}  ⚠️ El usuario '$user' ya existe o hubo un error (se intentará actualizar permisos).${NC}"
         # Intentar cambiar password por si acaso (opcional, aquí solo aseguramos existencia)
         docker exec "$RABBITMQ_CONTAINER" rabbitmqctl change_password "$user" "$pass" 2>/dev/null
    fi

    # Asignar permisos (vhost: /, configure: .*, write: .*, read: .*)
    docker exec "$RABBITMQ_CONTAINER" rabbitmqctl set_permissions -p / "$user" ".*" ".*" ".*"
    echo -e "${GREEN}  ✅ Permisos asignados a '$user'.${NC}"
    
    # Asignar tag management (opcional, para que puedan entrar al UI si se desea)
    # docker exec "$RABBITMQ_CONTAINER" rabbitmqctl set_user_tags "$user" management
}

# Crear usuarios para los microservicios
create_rabbitmq_user "auth_user" "auth_pass"
create_rabbitmq_user "social_user" "social_pass"
create_rabbitmq_user "notifications_user" "notifications_pass"

echo ""
echo -e "${GREEN}🎉 Setup de RabbitMQ completado.${NC}"
echo -e "${BLUE}ℹ️  Actualiza tus archivos .env con las siguientes credenciales:${NC}"
echo -e "   - Auth Service:        amqp://auth_user:auth_pass@localhost:5672"
echo -e "   - Social Service:      amqp://social_user:social_pass@localhost:5672"
echo -e "   - Notifications:       amqp://notifications_user:notifications_pass@localhost:5672"

echo ""
echo -e "${BLUE}🚀 Setup Finalizado.${NC}"

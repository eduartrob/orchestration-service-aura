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

# Verificar si se está ejecutando como root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}❌ Por favor, ejecuta este script como root (sudo).${NC}"
  exit 1
fi

# --- 1. Verificaciones e Instalaciones Globales ---
echo -e "${YELLOW}--- 1. Verificando e Instalando Herramientas Globales ---${NC}"

install_docker() {
    echo -e "${YELLOW}🛠️  Instalando Docker...${NC}"
    apt-get update
    apt-get install -y ca-certificates curl gnupg
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg

    echo \
      "deb [arch=\"$(dpkg --print-architecture)\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      \"$(. /etc/os-release && echo "$VERSION_CODENAME")\" stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Docker instalado correctamente.${NC}"
    else
        echo -e "${RED}❌ Error instalando Docker.${NC}"
        exit 1
    fi
}

install_node() {
    echo -e "${YELLOW}🛠️  Instalando Node.js y npm...${NC}"
    # Usando NodeSource para una versión reciente (ej. 20)
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt-get install -y nodejs
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Node.js y npm instalados correctamente.${NC}"
    else
        echo -e "${RED}❌ Error instalando Node.js.${NC}"
        exit 1
    fi
}

if ! command -v docker &> /dev/null; then
    install_docker
else
    echo -e "${GREEN}✅ Docker ya está instalado.${NC}"
fi

if ! command -v npm &> /dev/null; then
    install_node
else
    echo -e "${GREEN}✅ npm ya está instalado.${NC}"
fi

echo ""

# --- 1.1 Pausa para configuración manual (.env) ---
echo -e "${YELLOW}--- 1.1 Configuración Manual ---${NC}"
echo -e "${BLUE}ℹ️  El script se pausará ahora.${NC}"
echo -e "Por favor, asegúrate de cargar tus archivos ${GREEN}.env${NC} y cualquier otra configuración necesaria en el directorio del proyecto."
echo -e "Puedes usar 'scp' o un cliente SFTP para transferir los archivos."
echo -e "Presiona [ENTER] cuando estés listo para continuar..."
read -r

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
    echo "Esperando a que RabbitMQ inicie (15s)..."
    sleep 15
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
         # Intentar cambiar password por si acaso
         docker exec "$RABBITMQ_CONTAINER" rabbitmqctl change_password "$user" "$pass" 2>/dev/null
    fi

    # Asignar permisos (vhost: /, configure: .*, write: .*, read: .*)
    docker exec "$RABBITMQ_CONTAINER" rabbitmqctl set_permissions -p / "$user" ".*" ".*" ".*"
    echo -e "${GREEN}  ✅ Permisos asignados a '$user'.${NC}"
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

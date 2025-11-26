#!/bin/bash

# =================================================================
# Script de Orquestación - Setup Global
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

# --- 1. Actualización del Sistema ---
echo -e "${YELLOW}--- 1. Actualizando el Sistema ---${NC}"
apt-get update
apt-get upgrade -y
echo -e "${GREEN}✅ Sistema actualizado.${NC}"
echo ""

# --- 2. Verificaciones e Instalaciones Globales ---
echo -e "${YELLOW}--- 2. Verificando e Instalando Herramientas Globales ---${NC}"

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
echo -e "${GREEN}🎉 Setup Global Finalizado.${NC}"
echo -e "${BLUE}ℹ️  Ahora puedes ejecutar tus servicios manualmente.${NC}"

#!/bin/bash

# ============================================================================
# Script de Instalación Rápida - Aura Orchestration
# ============================================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}    🚀 Aura Orchestration - Instalación Rápida             ${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""

# Función para instalar Docker si no existe
install_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${BLUE}🐳 Docker no encontrado. Instalando Docker...${NC}"
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        rm get-docker.sh
        
        # Agregar usuario actual al grupo docker
        sudo usermod -aG docker $USER
        
        echo -e "${GREEN}✅ Docker instalado correctamente${NC}"
        echo -e "${YELLOW}⚠️  Se ha agregado tu usuario al grupo 'docker'.${NC}"
        echo -e "${YELLOW}    Para aplicar los cambios de grupo sin reiniciar, el script continuará...${NC}"
    else
        echo -e "${GREEN}✅ Docker ya está instalado${NC}"
    fi
}

# Ejecutar instalación de dependencias
install_docker

# Repositorio de orchestration
# Repositorio de orchestration
ORCHESTRATION_REPO="https://github.com/eduartrob/orchestration-service-aura.git"
ORCHESTRATION_DIR="orchestration"

# Clonar repositorio de orchestration
if [ -d "$ORCHESTRATION_DIR" ]; then
    echo -e "${YELLOW}⚠️  El directorio 'orchestration' ya existe${NC}"
    read -p "¿Deseas eliminarlo y clonar nuevamente? (s/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        echo -e "${BLUE}🗑️  Eliminando directorio existente...${NC}"
        rm -rf "$ORCHESTRATION_DIR"
    else
        echo -e "${BLUE}📂 Usando directorio existente${NC}"
    fi
fi

if [ ! -d "$ORCHESTRATION_DIR" ]; then
    echo -e "${BLUE}📦 Clonando repositorio de orchestration...${NC}"
    git clone "$ORCHESTRATION_REPO" "$ORCHESTRATION_DIR"
    echo -e "${GREEN}✅ Repositorio clonado${NC}"
fi

echo ""

# Entrar al directorio de orchestration
cd "$ORCHESTRATION_DIR"

echo -e "${GREEN}📋 Otorgando permisos de ejecución...${NC}"

# Dar permisos a los scripts
chmod +x scripts/setup-master.sh
chmod +x scripts/start.sh
chmod +x scripts/stop.sh

echo -e "${GREEN}✅ Permisos otorgados${NC}"
echo ""

echo -e "${BLUE}🚀 Iniciando configuración maestro...${NC}"
echo ""

# Ejecutar setup maestro
./scripts/setup-master.sh

echo ""
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}    ✅ Instalación completada                               ${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}📋 Para iniciar todos los servicios:${NC}"
echo -e "   ${GREEN}cd orchestration${NC}"
echo -e "   ${GREEN}./scripts/start.sh${NC}"
echo ""

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

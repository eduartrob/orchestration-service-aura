#!/bin/bash

# ============================================================================
# Script de Instalación Rápida - Aura Orchestration
# ============================================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}    🚀 Aura Orchestration - Instalación Rápida             ${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""

# Directorio actual
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$SCRIPT_DIR"

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
echo -e "   ${GREEN}./scripts/start.sh${NC}"
echo ""

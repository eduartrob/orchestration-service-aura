#!/bin/bash

# ============================================================================
# Script de Setup Maestro - Aura Microservices
# ============================================================================

set -e

# --- Colores ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}    🚀 Setup Maestro - Aura Microservices                   ${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""

# Directorio base (el padre de orchestration)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# SCRIPT_DIR = .../orchestration/scripts
# Queremos llegar a .../ (el padre de orchestration)
BASE_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

cd "$BASE_DIR"

echo -e "${YELLOW}📍 Directorio base para clonar: ${BASE_DIR}${NC}"
echo ""

# Definir repositorios y sus carpetas destino
declare -A REPOS=(
    ["auth-service"]="https://github.com/eduartrob/auth-service-aura.git"
    ["gateway-service"]="https://github.com/eduartrob/gateway-service-aura.git"
    ["messaging-service"]="https://github.com/eduartrob/messaging-service-aura.git"
    ["notifications-service"]="https://github.com/eduartrob/notifications-service-aura.git"
    ["social-service"]="https://github.com/eduartrob/social-service-aura.git"
)

# --- Paso 1: Clonar repositorios ---
echo -e "${BLUE}━━━ Paso 1/2: Clonando Repositorios ━━━${NC}"
echo ""

for SERVICE in "${!REPOS[@]}"; do
    REPO_URL="${REPOS[$SERVICE]}"
    
    if [ -d "$SERVICE" ]; then
        echo -e "${GREEN}✅ $SERVICE ya existe, omitiendo...${NC}"
    else
        echo -e "${YELLOW}📦 Clonando $SERVICE...${NC}"
        git clone "$REPO_URL" "$SERVICE"
        echo -e "${GREEN}✅ $SERVICE clonado${NC}"
    fi
    echo ""
done

echo -e "${GREEN}✅ Todos los repositorios están listos${NC}"
echo ""

# --- Paso 2: Configurar .env para cada servicio ---
echo -e "${BLUE}━━━ Paso 2/2: Configurando Variables de Entorno ━━━${NC}"
echo ""

configure_env() {
    local SERVICE=$1
    
    echo -e "${YELLOW}═══════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}📝 Configurando .env para: ${SERVICE}${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════${NC}"
    echo ""
    
    if [ -f "$SERVICE/.env" ]; then
        echo -e "${YELLOW}⚠️  El archivo .env ya existe en $SERVICE${NC}"
        read -p "¿Deseas sobrescribirlo? (s/n): " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Ss]$ ]]; then
            echo -e "${BLUE}⏭️  Omitiendo configuración de $SERVICE${NC}"
            echo ""
            return
        fi
    fi
    
    echo -e "${GREEN}Por favor, pega el contenido del archivo .env${NC}"
    echo -e "${GREEN}Cuando termines, presiona Ctrl+D (o Ctrl+Z en Windows)${NC}"
    echo -e "${BLUE}───────────────────────────────────────────────${NC}"
    
    # Leer contenido del .env desde la entrada estándar
    cat > "$SERVICE/.env"
    
    echo -e "${BLUE}───────────────────────────────────────────────${NC}"
    echo -e "${GREEN}✅ .env configurado para $SERVICE${NC}"
    echo ""
}

# Configurar .env para cada servicio
for SERVICE in "${!REPOS[@]}"; do
    configure_env "$SERVICE"
done

echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}    ✅ ¡Setup Completado Exitosamente!                      ${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}📋 Próximos pasos:${NC}"
echo -e "   1. Ejecutar: ${YELLOW}cd orchestration${NC}"
echo -e "   2. Iniciar servicios: ${YELLOW}./start.sh${NC}"
echo ""

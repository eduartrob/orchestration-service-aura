#!/bin/bash

# ============================================================================
# AURA Platform - Pre-download NLP Models
# Downloads shared Hugging Face models ONCE before starting services
# ============================================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}    🧠 AURA - Descarga de Modelos NLP                       ${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$SCRIPT_DIR/.."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Docker no está corriendo. Por favor inicia Docker primero.${NC}"
    exit 1
fi

echo -e "${BLUE}📦 Creando volumen nlp_models si no existe...${NC}"
docker volume create nlp_models 2>/dev/null || true

echo -e "${BLUE}🧠 Descargando modelo NLP pysentimiento/robertuito-sentiment-analysis...${NC}"
echo -e "${YELLOW}   (Esto puede tomar varios minutos la primera vez, ~2GB)${NC}"
echo ""

# Run a temporary container to download the model
docker run --rm \
    -v nlp_models:/models \
    -e TRANSFORMERS_CACHE=/models \
    -e HF_HOME=/models \
    python:3.11-slim \
    bash -c "
        pip install --quiet transformers torch sentencepiece && \
        python -c \"
from transformers import pipeline
print('📥 Descargando modelo...')
pipe = pipeline('sentiment-analysis', model='pysentimiento/robertuito-sentiment-analysis')
print('✅ Modelo descargado correctamente')
# Test rápido
result = pipe('Me siento muy feliz hoy')
print(f'🧪 Test: Me siento muy feliz hoy → {result}')
\"
    "

echo ""
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}    ✅ Modelos NLP descargados correctamente               ${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}📋 Ahora puedes iniciar los servicios:${NC}"
echo -e "   ${GREEN}./scripts/start.sh${NC}"
echo ""

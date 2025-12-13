#!/bin/bash

# ============================================================================
# AURA Platform - Actualización Limpia en EC2
# Borra todo y comienza de cero con los nuevos Dockerfiles optimizados
# ============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}    🔄 AURA Platform - Actualización Limpia EC2            ${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""

# ============================================================================
# PASO 1: Detener y limpiar Docker
# ============================================================================
echo -e "${YELLOW}⏹️  Paso 1/5: Deteniendo contenedores...${NC}"

# Detener todos los contenedores
docker stop $(docker ps -aq) 2>/dev/null || echo "No hay contenedores corriendo"

# Eliminar todos los contenedores
docker rm -f $(docker ps -aq) 2>/dev/null || echo "No hay contenedores que eliminar"

# Eliminar imágenes de AURA (para forzar rebuild)
echo -e "${YELLOW}🗑️  Eliminando imágenes AURA antiguas...${NC}"
docker images | grep -E "(aura|orchestration)" | awk '{print $3}' | xargs -r docker rmi -f 2>/dev/null || echo "No hay imágenes AURA"

# Limpiar caché de builds (opcional pero recomendado para limpieza limpia)
echo -e "${YELLOW}🧹 Limpiando caché de Docker...${NC}"
docker builder prune -f 2>/dev/null || true

echo -e "${GREEN}✅ Docker limpiado${NC}"
echo ""

# ============================================================================
# PASO 2: Directorio base
# ============================================================================
echo -e "${YELLOW}📂 Paso 2/5: Configurando directorios...${NC}"

# Directorio base donde clonaremos los repos
BASE_DIR="/home/ubuntu/aura-services"

# Si existe, eliminar
if [ -d "$BASE_DIR" ]; then
    echo -e "${YELLOW}⚠️  Eliminando directorio existente: $BASE_DIR${NC}"
    rm -rf "$BASE_DIR"
fi

mkdir -p "$BASE_DIR"
cd "$BASE_DIR"

echo -e "${GREEN}✅ Directorio preparado: $BASE_DIR${NC}"
echo ""

# ============================================================================
# PASO 3: Clonar todos los repositorios
# ============================================================================
echo -e "${YELLOW}📦 Paso 3/5: Clonando repositorios actualizados...${NC}"

REPOS=(
    "orchestration-service-aura"
    "auth-service-aura"
    "social-service-aura"
    "messaging-service-aura"
    "notifications-service-aura"
    "clustering-service-aura"
    "chatbot-service-aura"
    "gateway-service-aura"
)

for repo in "${REPOS[@]}"; do
    echo -e "${BLUE}📥 Clonando $repo...${NC}"
    git clone "https://github.com/eduartrob/${repo}.git" --depth 1
done

echo -e "${GREEN}✅ Todos los repositorios clonados${NC}"
echo ""

# ============================================================================
# PASO 4: Configurar archivos .env
# ============================================================================
echo -e "${YELLOW}⚙️  Paso 4/5: Configurando archivos .env...${NC}"

# Crear .env para auth-service
cat > auth-service-aura/.env << 'EOF'
DATABASE_URL=postgresql://postgres:postgres@db:5432/aura_auth?schema=public
JWT_SECRET=pezcadofrito.1
PORT=3001
EOF

# Crear .env para social-service
cat > social-service-aura/.env << 'EOF'
PORT=3002
DB_DIALECT=postgres
PG_USER=postgres
PG_PASSWORD=postgres
PG_DATABASE=aura_social
PG_HOST=db
PG_PORT=5432
JWT_SECRET=pezcadofrito.1
EOF

# Crear .env para messaging-service
cat > messaging-service-aura/.env << 'EOF'
PORT=3003
DATABASE_URL=postgresql://postgres:postgres@db:5432/aura_messaging?schema=public
JWT_SECRET=pezcadofrito.1
EOF

# Crear .env para notifications-service
cat > notifications-service-aura/.env << 'EOF'
PORT=3004
DATABASE_URL=postgresql://postgres:postgres@db:5432/aura_notifications?schema=public
JWT_SECRET=pezcadofrito.1
EOF

# Crear .env para gateway-service
cat > gateway-service-aura/.env << 'EOF'
PORT=3000
AUTH_URL=http://auth-service:3001
POSTS_URL=http://social-service:3002
CHAT_URL=http://messaging-service:3003
NOTIFICATIONS_URL=http://notifications-service:3004
EOF

echo -e "${GREEN}✅ Archivos .env configurados${NC}"
echo ""

# ============================================================================
# PASO 5: Pre-descargar modelos NLP y arrancar servicios
# ============================================================================
echo -e "${YELLOW}🚀 Paso 5/5: Iniciando servicios...${NC}"

cd orchestration-service-aura

# Crear volumen para modelos NLP si no existe
echo -e "${BLUE}🧠 Creando volumen para modelos NLP...${NC}"
docker volume create nlp_models 2>/dev/null || true

# Construir y arrancar servicios
echo -e "${BLUE}🔨 Construyendo imágenes (esto puede tomar varios minutos la primera vez)...${NC}"
docker compose build --no-cache

echo -e "${BLUE}🚀 Iniciando servicios...${NC}"
docker compose up -d

echo ""
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}    ✅ ¡Actualización Completada!                          ${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}📋 Estado de los servicios:${NC}"
docker compose ps
echo ""
echo -e "${BLUE}📋 Para ver logs:${NC}"
echo -e "   ${GREEN}docker compose logs -f${NC}"
echo ""
echo -e "${BLUE}📋 Para pre-descargar modelos NLP (opcional, acelera primer uso):${NC}"
echo -e "   ${GREEN}./scripts/download-models.sh${NC}"
echo ""

#!/bin/bash

# ============================================================================
# AURA Platform - Complete Cleanup Script
# Stops and removes ALL Docker containers, networks, and volumes
# ============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${RED}════════════════════════════════════════════════════════════${NC}"
echo -e "${RED}    🗑️  AURA Platform - Complete Cleanup                     ${NC}"
echo -e "${RED}════════════════════════════════════════════════════════════${NC}"
echo ""

# Stop all running containers
echo -e "${YELLOW}⏹️  Stopping all running containers...${NC}"
docker stop $(docker ps -aq) 2>/dev/null || echo "No containers to stop"

# Remove all containers
echo -e "${YELLOW}🗑️  Removing all containers...${NC}"
docker rm -f $(docker ps -aq) 2>/dev/null || echo "No containers to remove"

# Remove AURA-specific images (optional)
echo -e "${YELLOW}🗑️  Removing AURA images...${NC}"
docker images | grep -E "(orchestration|aura)" | awk '{print $3}' | xargs -r docker rmi -f 2>/dev/null || echo "No AURA images to remove"

# Prune unused networks
echo -e "${YELLOW}🌐 Pruning unused networks...${NC}"
docker network prune -f 2>/dev/null || true

# Prune unused volumes (WARNING: This deletes data!)
read -p "¿Eliminar volúmenes de PostgreSQL? (¡PERDERÁS DATOS!) (s/n): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Ss]$ ]]; then
    echo -e "${RED}🗑️  Removing volumes...${NC}"
    docker volume prune -f 2>/dev/null || true
    docker volume rm $(docker volume ls -q | grep -E "(postgres|aura)") 2>/dev/null || echo "No volumes to remove"
else
    echo -e "${GREEN}⏭️  Keeping volumes${NC}"
fi

echo ""
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}    ✅ Cleanup Complete!                                    ${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}Now run: ./scripts/start.sh${NC}"

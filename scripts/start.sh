#!/bin/bash

# Start the Docker stack
echo "🚀 Starting Aura Microservices..."
echo ""

# Check if docker compose (plugin) is available, otherwise fall back to docker-compose
if docker compose version >/dev/null 2>&1; then
    DOCKER_COMPOSE_CMD="docker compose"
else
    DOCKER_COMPOSE_CMD="docker-compose"
fi

# Use --progress=plain for cleaner terminal output
$DOCKER_COMPOSE_CMD -f docker-compose.yml up -d --build --progress=plain

echo ""
echo "✅ Services started! Check status with 'docker-compose ps'"


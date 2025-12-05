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

# Build and start services
$DOCKER_COMPOSE_CMD -f docker-compose.yml up -d --build

echo ""
echo "✅ Services started!"
echo ""
echo "📋 Check status with: $DOCKER_COMPOSE_CMD ps"
echo "📜 View logs with:    $DOCKER_COMPOSE_CMD logs -f"


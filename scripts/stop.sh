#!/bin/bash

# Stop the Docker stack
echo "Stopping Aura Microservices..."
# Check if docker compose (plugin) is available, otherwise fall back to docker-compose
if docker compose version >/dev/null 2>&1; then
    DOCKER_COMPOSE_CMD="docker compose"
else
    DOCKER_COMPOSE_CMD="docker-compose"
fi

$DOCKER_COMPOSE_CMD -f docker-compose.yml down

echo "Services stopped."

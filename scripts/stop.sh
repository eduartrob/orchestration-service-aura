#!/bin/bash

# Stop the Docker stack
echo "Stopping Aura Microservices..."
docker-compose -f docker-compose.yml down

echo "Services stopped."

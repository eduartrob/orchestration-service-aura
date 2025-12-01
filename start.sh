#!/bin/bash

# Start the Docker stack
echo "Starting Aura Microservices..."
docker-compose -f docker-compose.yml up -d --build

echo "Services started! Check status with 'docker-compose ps'"

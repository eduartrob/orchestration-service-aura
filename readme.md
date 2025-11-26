# Orchestration Service

Este directorio contiene scripts y documentación para orquestar el despliegue y configuración de los microservicios del proyecto Aura.

## Setup Automatizado

Sigue estos pasos para configurar tu entorno e instalar dependencias globales.

### 1. Conexión al Servidor

Conéctate a tu instancia EC2 (o servidor remoto) por SSH.

### 2. Descarga y Ejecución

Descarga y ejecuta el script de configuración. Estos comandos descargarán el script, le darán permisos de ejecución y lo iniciarán.

```bash
wget https://raw.githubusercontent.com/eduartrob/orchestration-service-aura/main/setup.sh
chmod +x setup.sh
sudo ./setup.sh
```

> **Nota:** Es importante ejecutar el script con `sudo` para permitir la instalación de paquetes globales y la actualización del sistema.

### 3. ¿Qué hace el script?

1.  **Actualización del Sistema:** Ejecuta `apt-get update` y `upgrade` para asegurar que el servidor esté al día.
2.  **Instalación de Dependencias:** Verifica e instala automáticamente Docker, Docker Compose y Node.js si no están presentes.

### 4. Pasos Siguientes

Una vez finalizado el setup, deberás:

1.  Clonar tus repositorios de microservicios.
2.  Configurar los archivos `.env` manualmente.
3.  Ejecutar cada servicio según sea necesario (ej. `docker compose up` o `npm run dev`).
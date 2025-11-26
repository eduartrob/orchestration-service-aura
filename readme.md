# Orchestration Service

Este directorio contiene scripts y documentación para orquestar el despliegue y configuración de los microservicios del proyecto Aura.

## Setup Automatizado

Sigue estos pasos para configurar tu entorno, instalar dependencias y preparar RabbitMQ.

### 1. Conexión al Servidor

Conéctate a tu instancia EC2 (o servidor remoto) por SSH.

### 2. Descarga y Ejecución

Descarga y ejecuta el script de configuración. Estos comandos descargarán el script, le darán permisos de ejecución y lo iniciarán.

```bash
wget https://raw.githubusercontent.com/eduartrob/orchestration-service-aura/main/setup.sh
chmod +x setup.sh
sudo ./setup.sh
```

> **Nota:** Es importante ejecutar el script con `sudo` para permitir la instalación de paquetes globales como Docker.

### 3. Instrucciones del Script

Sigue las instrucciones interactivas del script:

1.  **Instalación de Dependencias:** El script verificará e instalará automáticamente todas las dependencias necesarias (Docker, Docker Compose, Node.js, etc.) si no están presentes.
2.  **Carga de Configuración:** El script hará una pausa y te pedirá que cargues tus archivos `.env` (y cualquier otro archivo de configuración necesario) en el directorio del proyecto.
    *   Puedes usar `scp` o un cliente SFTP (como FileZilla) para subir estos archivos desde tu máquina local.
3.  **Configuración de RabbitMQ:** Una vez reanudado, el script levantará el contenedor de RabbitMQ y configurará automáticamente los usuarios y permisos necesarios para los microservicios.
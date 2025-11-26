mi-proyecto-infra/
├── docker-compose.yml      <-- El archivo que conecta Gateway, Auth, BD, etc.
├── setup-server.sh         <-- El script que instala Docker y prepara el EC2
├── .env.example            <-- Las variables de entorno de TODOS los servicios
├── nginx.conf              <-- (Opcional) Configuración global de proxy reverso
└── prometheus/             <-- (Opcional) Configuración de monitoreo
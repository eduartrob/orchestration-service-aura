CREATE DATABASE aura_auth;
CREATE DATABASE aura_messaging;
CREATE DATABASE aura_notifications;
CREATE DATABASE aura_social;

GRANT ALL PRIVILEGES ON DATABASE aura_auth TO postgres;
GRANT ALL PRIVILEGES ON DATABASE aura_messaging TO postgres;
GRANT ALL PRIVILEGES ON DATABASE aura_notifications TO postgres;
GRANT ALL PRIVILEGES ON DATABASE aura_social TO postgres;

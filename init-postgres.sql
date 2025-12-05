-- ============================================
-- AURA Platform - PostgreSQL Initialization
-- Creates all databases and required extensions
-- ============================================

-- aura_auth is created by POSTGRES_DB env var

-- Create additional databases
CREATE DATABASE aura_messaging;
CREATE DATABASE aura_notifications;
CREATE DATABASE aura_social;

-- Grant privileges on all databases
GRANT ALL PRIVILEGES ON DATABASE aura_auth TO postgres;
GRANT ALL PRIVILEGES ON DATABASE aura_messaging TO postgres;
GRANT ALL PRIVILEGES ON DATABASE aura_notifications TO postgres;
GRANT ALL PRIVILEGES ON DATABASE aura_social TO postgres;

-- Connect to aura_messaging and create extensions
\c aura_messaging;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- Connect to aura_social and create extensions
\c aura_social;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- Connect to aura_notifications and create extensions
\c aura_notifications;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Connect to aura_auth and create extensions
\c aura_auth;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Log completion
DO $$
BEGIN
  RAISE NOTICE '✅ PostgreSQL inicializado correctamente para AURA Platform';
  RAISE NOTICE '   Bases de datos: aura_auth, aura_messaging, aura_notifications, aura_social';
  RAISE NOTICE '   Extensiones: uuid-ossp, pg_trgm';
END $$;

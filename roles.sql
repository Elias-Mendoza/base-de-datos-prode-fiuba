-- Creación de roles

CREATE ROLE administrador LOGIN PASSWORD 'admin123';

CREATE ROLE usuario LOGIN PASSWORD 'usuario123';


-- Permisos para administrador

GRANT ALL PRIVILEGES
ON ALL TABLES IN SCHEMA public
TO administrador;

GRANT ALL PRIVILEGES
ON ALL SEQUENCES IN SCHEMA public
TO administrador;

GRANT ALL PRIVILEGES
ON SCHEMA public
TO administrador;


-- Permisos de lectura necesarios

GRANT SELECT ON paises TO usuario;
GRANT SELECT ON equipos TO usuario;
GRANT SELECT ON torneos TO usuario;
GRANT SELECT ON partidos TO usuario;


-- Permisos sobre pronósticos

GRANT SELECT, INSERT
ON pronosticos_deportivos
TO usuario;

-- Registro de ingresos
GRANT SELECT, INSERT
ON ingresos
TO usuario;

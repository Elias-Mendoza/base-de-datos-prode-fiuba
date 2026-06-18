CREATE TABLE paises (
    codigo_iso CHAR(3) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE usuarios (
    dni INTEGER PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_registro DATE NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    codigo_iso CHAR(3) NOT NULL,

    CONSTRAINT fk_usuario_pais
        FOREIGN KEY (codigo_iso)
        REFERENCES paises(codigo_iso),

    CONSTRAINT chk_email
        CHECK (email LIKE '%@%.%' )
);

CREATE TABLE ingresos (
    dni INTEGER,
    fecha DATE,
    hora TIME,

    PRIMARY KEY (dni, fecha, hora),

    CONSTRAINT fk_ingreso_usuario
        FOREIGN KEY (dni)
        REFERENCES usuarios(dni)
        ON DELETE CASCADE
);

CREATE TABLE equipos (
    nombre VARCHAR(100) PRIMARY KEY,
    codigo_iso CHAR(3) NOT NULL,

    CONSTRAINT fk_equipo_pais
        FOREIGN KEY (codigo_iso)
        REFERENCES paises(codigo_iso)
);

CREATE TABLE torneos (
    anio INTEGER,
    nombre VARCHAR(100),
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,

    PRIMARY KEY (anio, nombre),

    CONSTRAINT chk_fechas_torneo
        CHECK (fecha_fin >= fecha_inicio)
);

CREATE TABLE partidos (
    fecha DATE,
    hora TIME,
    estadio VARCHAR(100),

    goles_equipo1 INTEGER,
    goles_equipo2 INTEGER,

    equipo1 VARCHAR(100) NOT NULL,
    equipo2 VARCHAR(100) NOT NULL,

    anio_torneo INTEGER NOT NULL,
    nombre_torneo VARCHAR(100) NOT NULL,

    PRIMARY KEY (fecha, hora, estadio),

    CONSTRAINT fk_partido_equipo1
        FOREIGN KEY (equipo1)
        REFERENCES equipos(nombre),

    CONSTRAINT fk_partido_equipo2
        FOREIGN KEY (equipo2)
        REFERENCES equipos(nombre),

    CONSTRAINT fk_partido_torneo
        FOREIGN KEY (anio_torneo, nombre_torneo)
        REFERENCES torneos(anio, nombre)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT chk_equipos_distintos
        CHECK (equipo1 <> equipo2),

    CONSTRAINT chk_goles_partido_1
        CHECK (goles_equipo1 >= 0),

    CONSTRAINT chk_goles_partido_2
        CHECK (goles_equipo2 >= 0)
);

CREATE TABLE pronosticos_deportivos (
    dni INTEGER,
    fecha DATE,
    hora TIME,
    estadio VARCHAR(100),
    fecha_admision DATE,

    goles_equipo1 INTEGER NOT NULL,
    goles_equipo2 INTEGER NOT NULL,

    PRIMARY KEY (
        dni,
        fecha,
        hora,
        estadio,
        fecha_admision
    ),

    CONSTRAINT fk_pronostico_usuario
        FOREIGN KEY (dni)
        REFERENCES usuarios(dni)
        ON DELETE CASCADE,

    CONSTRAINT fk_pronostico_partido
        FOREIGN KEY (fecha, hora, estadio)
        REFERENCES partidos(fecha, hora, estadio)
        ON DELETE CASCADE,

    CONSTRAINT chk_goles_pronostico_1
        CHECK (goles_equipo1 >= 0),

    CONSTRAINT chk_goles_pronostico_2
        CHECK (goles_equipo2 >= 0)
);

CREATE INDEX idx_usuario_pais
ON usuarios(codigo_iso);

CREATE INDEX idx_ingreso_usuario
ON ingresos(dni);

CREATE INDEX idx_equipo_pais
ON equipos(codigo_iso);

CREATE INDEX idx_partido_torneo
ON partidos(anio_torneo, nombre_torneo);

CREATE INDEX idx_pronostico_usuario
ON pronosticos_deportivos(dni);

CREATE INDEX idx_pronostico_partido
ON pronosticos_deportivos(fecha, hora, estadio);

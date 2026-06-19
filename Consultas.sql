-- Registrar un Usuario
INSERT INTO usuarios (
    dni,
    nombre,
    apellido,
    fecha_registro,
    email,
    codigo_iso
)
VALUES (
    111,
    'Carlos',
    'Sanchez',
    CURRENT_DATE,
    'carlos@gmail.com',
    'ARG'
);


-- Registrar un Torneo
INSERT INTO torneos(
    anio,
    nombre,
    fecha_inicio,
    fecha_fin
)
VALUES(
    2026,
    'Copa America',
    '2026-06-01',
    '2026-07-15'
);


-- Registrar un equipo
INSERT INTO equipos(nombre, codigo_iso)
VALUES('Racing Club', 'ARG');


-- Registrar un Pronostico Deportivo
INSERT INTO pronosticos_deportivos(
    dni,
    fecha,
    hora,
    estadio,
    fecha_admision,
    goles_equipo1,
    goles_equipo2
)
VALUES(
    101,
    '2025-03-10',
    '19:30',
    'Allianz Parque',
    CURRENT_DATE,
    2,
    1
);


-- Registrar un resultado de un Partido
UPDATE partidos
SET goles_equipo1 = 3, goles_equipo2 = 2
WHERE fecha = '2025-03-10'
AND hora = '19:30'
AND estadio = 'Allianz Parque';


-- Listar todos los usuarios de la aplicación
SELECT dni, nombre, apellido
FROM Usuarios;


-- Listar los resultados de todos los partidos del torneo
SELECT T.nombre, T.anio, P.equipo1, P.equipo2, P.goles_equipo1, P.goles_equipo2
FROM partidos P
JOIN torneos T
ON T.anio = P.anio_torneo
AND T.nombre = P.nombre_torneo
ORDER BY T.anio, T.nombre, P.fecha;


-- Listar los aciertos por usuario
SELECT U.dni, U.nombre, U.apellido, COUNT(*) AS cantidad_aciertos
FROM usuarios U
JOIN pronosticos_deportivos PD
ON PD.dni = U.dni
JOIN partidos P
ON P.fecha = PD.fecha
AND P.hora = PD.hora
AND P.estadio = PD.estadio
WHERE PD.goles_equipo1 = P.goles_equipo1
AND PD.goles_equipo2 = P.goles_equipo2
GROUP BY U.dni, U.nombre, U.apellido
ORDER BY cantidad_aciertos DESC;


-- Contabilizar la cantidad de usuarios agrupados por país
SELECT P.nombre, COUNT(*) AS cantidad_usuarios
FROM paises P
JOIN usuarios U
ON U.codigo_iso = P.codigo_iso
GROUP BY P.nombre
ORDER BY cantidad_usuarios DESC;


-- Actualizar el nombre de un torneo
UPDATE torneos
SET nombre = 'Libertadores'
WHERE anio = 2024
AND nombre = 'Copa Libertadores';


-- Eliminar un torneo
DELETE FROM torneos
WHERE anio = 2025
AND nombre = 'Copa Libertadores';


-- Desregistrar un usuario de la aplicación
DELETE FROM usuarios
WHERE dni = 108;


-- Mostrar los torneos más populares según cantidad de usuarios pronosticadores
SELECT T.anio, T.nombre, COUNT(DISTINCT PD.dni) AS cantidad_pronosticadores
FROM torneos T
JOIN partidos P
ON P.anio_torneo = T.anio
AND P.nombre_torneo = T.nombre
JOIN pronosticos_deportivos PD
ON PD.fecha = P.fecha
AND PD.hora = P.hora
AND PD.estadio = P.estadio
GROUP BY T.anio, T.nombre
ORDER BY cantidad_pronosticadores DESC;



-- Contabilizar la cantidad de veces que ingresa a la aplicación cada usuario
SELECT i.dni ,u.nombre , u.apellido, COUNT (i.dni) AS cantidad_ingresos
FROM ingresos AS i
JOIN usuarios AS u ON u.dni = i.dni
GROUP BY i.dni , u.nombre , u.apellido
ORDER BY cantidad_ingresos DESC;

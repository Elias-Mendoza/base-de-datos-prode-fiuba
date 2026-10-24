# Sistema de Pronósticos Deportivos (PRODE) - Base de Datos Relacional

Proyecto integral de diseño, normalización e implementación SQL desarrollado para la materia **Base de Datos (75.15 / 95.05 - FIUBA)**, correspondiente al 1º Cuatrimestre de 2026.

El sistema modela una plataforma de torneos deportivos donde los usuarios registrados ingresan pronósticos de partidos y consultan métricas analíticas de aciertos, popularidad de competencias y actividad dentro de la aplicación.

---

## 📌 Estructura del Repositorio

* `tablas.sql`: Definición del esquema DDL (Data Definition Language) con creación de tablas, claves primarias, claves foráneas, restricciones de integridad (`CHECK`, `UNIQUE`) e índices de optimización.
* `datos.sql`: Script DML con la carga de datos de prueba para validar restricciones y consultas analíticas.
* `roles.sql`: Configuración de seguridad, creación de roles (`administrador`, `usuario`) y asignación granular de privilegios (`GRANT`).
* `consultas.sql`: Consultas DML avanzadas que resuelven los requerimientos del sistema (cálculo de aciertos, popularidad de torneos y auditoría de accesos).
* `documentacion/`: Documento explicativo con el Diagrama Entidad-Relación (DER) y la justificación formal del pasaje al Modelo Relacional.

---

## 📐 Modelo Entidad-Relación (DER)

Decisiones de diseño aplicadas en el esquema:

1. **Usuarios y Países:** Cada usuario se identifica por su `DNI`, registrando obligatoriamente su correo electrónico (con validación de formato mediante `CHECK`) y su país de origen asociado mediante clave foránea al código ISO de 3 caracteres.
2. **Historial de Ingresos:** Se modela como una entidad débil dependiente de `Usuario`, identificada por la clave compuesta `(dni, fecha, hora)`.
3. **Torneos y Equipos:** Los torneos cuentan con clave primaria compuesta `(anio, nombre)` para admitir ediciones anuales. Los equipos se identifican por su nombre y se asocian a su país de origen.
4. **Partidos y Restricción de Contienda:** Se identifican unívocamente por la terna `(fecha, hora, estadio)`. La participación de exactamente dos equipos se modela mediante dos claves foráneas (`equipo1` y `equipo2`) con una restricción `CHECK (equipo1 <> equipo2)`, evitando sobrecargas de tablas intermedias.
5. **Pronósticos Deportivos:** Entidad débil identificada por el usuario que realiza la predicción, el partido correspondiente y la fecha de admisión: `(dni, fecha, hora, estadio, fecha_admision)`.

---

## 🗃️ Esquema Relacional (MR)

* **PAISES** (codigo_iso, nombre)
  * PK: `codigo_iso`
* **USUARIOS** (dni, nombre, apellido, fecha_registro, email, codigo_iso)
  * PK: `dni`
  * UK: `email`
  * FK: `codigo_iso` -> **PAISES**(`codigo_iso`)
* **INGRESOS** (dni, fecha, hora)
  * PK: `(dni, fecha, hora)`
  * FK: `dni` -> **USUARIOS**(`dni`) ON DELETE CASCADE
* **EQUIPOS** (nombre, codigo_iso)
  * PK: `nombre`
  * FK: `codigo_iso` -> **PAISES**(`codigo_iso`)
* **TORNEOS** (anio, nombre, fecha_inicio, fecha_fin)
  * PK: `(anio, nombre)`
* **PARTIDOS** (fecha, hora, estadio, goles_equipo1, goles_equipo2, equipo1, equipo2, anio_torneo, nombre_torneo)
  * PK: `(fecha, hora, estadio)`
  * FK: `equipo1` -> **EQUIPOS**(`nombre`)
  * FK: `equipo2` -> **EQUIPOS**(`nombre`)
  * FK: `(anio_torneo, nombre_torneo)` -> **TORNEOS**(`anio, nombre`) ON UPDATE CASCADE ON DELETE CASCADE
* **PRONOSTICOS_DEPORTIVOS** (dni, fecha, hora, estadio, fecha_admision, goles_equipo1, goles_equipo2)
  * PK: `(dni, fecha, hora, estadio, fecha_admision)`
  * FK: `dni` -> **USUARIOS**(`dni`) ON DELETE CASCADE
  * FK: `(fecha, hora, estadio)` -> **PARTIDOS**(`fecha, hora, estadio`) ON DELETE CASCADE

---

## 🚀 Despliegue y Ejecución

Entorno sugerido: **PostgreSQL 14+** junto con un cliente como **DBeaver** o la consola `psql`.

Orden de ejecución de scripts:

1. Creación de Tablas e Índices:
   psql -U postgres -d prode_db -f tablas.sql

2. Carga Inicial de Datos:
   psql -U postgres -d prode_db -f datos.sql

3. Configuración de Seguridad y Roles:
   psql -U postgres -d prode_db -f roles.sql

4. Ejecución de Consultas y Reportes:
   psql -U postgres -d prode_db -f consultas.sql

---

## 🔍 Consultas Analíticas Destacadas

Entre los requerimientos implementados en `consultas.sql` se destacan:

* **Ranking de Aciertos:** Cuantificación exacta de predicciones donde coinciden ambos marcadores entre el pronóstico del usuario y el resultado final del partido:

SELECT U.dni, U.nombre, U.apellido, COUNT(*) AS cantidad_aciertos
FROM usuarios U
JOIN pronosticos_deportivos PD ON PD.dni = U.dni
JOIN partidos P ON P.fecha = PD.fecha AND P.hora = PD.hora AND P.estadio = PD.estadio
WHERE PD.goles_equipo1 = P.goles_equipo1 
  AND PD.goles_equipo2 = P.goles_equipo2
GROUP BY U.dni, U.nombre, U.apellido
ORDER BY cantidad_aciertos DESC;

* **Torneos Más Populares:** Agrupamiento y conteo de participantes únicos (`COUNT(DISTINCT)`) que registraron al menos un pronóstico en partidos de cada certamen:

SELECT T.anio, T.nombre, COUNT(DISTINCT PD.dni) AS cantidad_pronosticadores
FROM torneos T
JOIN partidos P ON P.anio_torneo = T.anio AND P.nombre_torneo = T.nombre
JOIN pronosticos_deportivos PD ON PD.fecha = P.fecha AND PD.hora = P.hora AND PD.estadio = P.estadio
GROUP BY T.anio, T.nombre
ORDER BY cantidad_pronosticadores DESC;

* **Métricas de Tráfico y Acceso:** Auditoría de frecuencia de ingresos por usuario a la aplicación:

SELECT i.dni, u.nombre, u.apellido, COUNT(i.dni) AS cantidad_ingresos
FROM ingresos AS i
JOIN usuarios AS u ON u.dni = i.dni
GROUP BY i.dni, u.nombre, u.apellido
ORDER BY cantidad_ingresos DESC;

---

## 🔒 Control de Acceso y Permisos (RBAC)

Se estructuró la seguridad mediante dos perfiles definidos en `roles.sql`:
* `administrador`: Privilegios totales de DDL y DML sobre el esquema público, tablas y secuencias.
* `usuario`: Acceso restringido de solo lectura (`SELECT`) a entidades públicas (países, equipos, torneos y partidos), con permisos de inserción y consulta (`SELECT`, `INSERT`) limitados a sus pronósticos deportivos y registros de ingresos.

---

## 👥 Autores

* Elias Edgar Mendoza
* Reginaldo Salvattore Hinojosa Baldera
* Martin Facundo Limardo
* Christian Tomás Porco
* Juan Ruben Claros

*Facultad de Ingeniería, Universidad de Buenos Aires (FIUBA)*

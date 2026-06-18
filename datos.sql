INSERT INTO paises (codigo_iso, nombre) VALUES
('ARG', 'Argentina'),
('BRA', 'Brasil'),
('URU', 'Uruguay'),
('CHI', 'Chile'),
('PAR', 'Paraguay');

INSERT INTO usuarios
(
    dni,
    nombre,
    apellido,
    fecha_registro,
    cantidad_ingresos,
    email,
    codigo_iso
)
VALUES
(101, 'Juan', 'Perez', '2024-01-10', 'juan@gmail.com', 'ARG'),
(102, 'Maria', 'Lopez', '2024-01-15', 'maria@gmail.com', 'ARG'),
(103, 'Pedro', 'Gomez', '2024-02-01', 'pedro@gmail.com', 'URU'),
(104, 'Ana', 'Fernandez', '2024-02-15', 'ana@gmail.com', 'BRA'),
(105, 'Lucas', 'Martinez', '2024-03-01', 'lucas@gmail.com', 'CHI'),
(106, 'Sofia', 'Ruiz', '2024-03-10', 'sofia@gmail.com', 'PAR'),
(107, 'Martin', 'Diaz', '2024-04-01', 'martin@gmail.com', 'ARG'),
(108, 'Valentina', 'Castro', '2024-04-15', 'valentina@gmail.com', 'BRA');

INSERT INTO ingresos (dni, fecha, hora) VALUES
(101, '2025-12-01', '10:30:00'),
(101, '2026-04-02', '14:15:00'),
(102, '2026-04-05', '09:00:00'),
(104, '2026-05-10', '20:45:00'),
(104, '2026-05-11', '21:00:00'),
(105, '2026-06-01', '18:30:00'),
(107, '2026-01-02', '10:30:00'),
(108, '2026-03-15', '01:30:00');

INSERT INTO equipos (nombre, codigo_iso) VALUES
('River Plate', 'ARG'),
('Boca Juniors', 'ARG'),
('Flamengo', 'BRA'),
('Palmeiras', 'BRA'),
('Nacional', 'URU'),
('Colo Colo', 'CHI'),
('Olimpia', 'PAR'),
('Cerro Porteno', 'PAR');

INSERT INTO torneos
(
    anio,
    nombre,
    fecha_inicio,
    fecha_fin
)
VALUES
(2024, 'Copa Libertadores', '2024-01-01', '2024-12-01'),
(2024, 'Copa Sudamericana', '2024-02-01', '2024-11-30'),
(2025, 'Copa Libertadores', '2025-01-01', '2025-12-01');

INSERT INTO partidos
(
    fecha,
    hora,
    estadio,
    goles_equipo1,
    goles_equipo2,
    equipo1,
    equipo2,
    anio_torneo,
    nombre_torneo
)
VALUES
(
    '2024-04-10',
    '18:00',
    'Monumental',
    2,
    1,
    'River Plate',
    'Boca Juniors',
    2024,
    'Copa Libertadores'
),
(
    '2024-05-15',
    '20:00',
    'Maracana',
    3,
    0,
    'Flamengo',
    'Nacional',
    2024,
    'Copa Libertadores'
),
(
    '2024-06-20',
    '21:00',
    'Defensores del Chaco',
    1,
    1,
    'Olimpia',
    'Colo Colo',
    2024,
    'Copa Sudamericana'
),
(
    '2024-07-15',
    '19:00',
    'La Nueva Olla',
    0,
    2,
    'Cerro Porteno',
    'Palmeiras',
    2024,
    'Copa Sudamericana'
),
(
    '2025-03-10',
    '19:30',
    'Allianz Parque',
    2,
    2,
    'Palmeiras',
    'River Plate',
    2025,
    'Copa Libertadores'
);

INSERT INTO pronosticos_deportivos
(
    dni,
    fecha,
    hora,
    estadio,
    fecha_admision,
    goles_equipo1,
    goles_equipo2
)
VALUES

(101,'2024-04-10','18:00','Monumental','2024-04-01',2,1),
(102,'2024-04-10','18:00','Monumental','2024-04-02',1,0),
(103,'2024-04-10','18:00','Monumental','2024-04-03',2,1),
(104,'2024-04-10','18:00','Monumental','2024-04-04',3,1),

(101,'2024-05-15','20:00','Maracana','2024-05-01',3,0),
(104,'2024-05-15','20:00','Maracana','2024-05-02',3,0),
(105,'2024-05-15','20:00','Maracana','2024-05-03',2,0),

(107,'2024-06-20','21:00','Defensores del Chaco','2024-06-01',1,1),
(101,'2024-06-20','21:00','Defensores del Chaco','2024-06-02',0,0),

(108,'2024-07-15','19:00','La Nueva Olla','2024-07-01',0,2),
(102,'2024-07-15','19:00','La Nueva Olla','2024-07-02',1,2),

(102,'2025-03-10','19:30','Allianz Parque','2025-03-01',2,2),
(104,'2025-03-10','19:30','Allianz Parque','2025-03-02',1,1),
(107,'2025-03-10','19:30','Allianz Parque','2025-03-03',2,2);


CREATE TABLE teachers (
    id_teacher SERIAL PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    identification VARCHAR(20) UNIQUE, -- opcional: cédula/pasaporte
    email VARCHAR(100),
    phone VARCHAR(20)
);

CREATE TABLE subjects (
    id_subject SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    is_practical BOOLEAN DEFAULT FALSE -- ejemplo: soldadura, arranque de viruta
);

CREATE TABLE grades (
    id_grade SERIAL PRIMARY KEY,
    level INT NOT NULL, -- Ejemplo: 6, 7, 8, 9, 10, 1 (para 1ro BGU/MEC)
    type VARCHAR(20) NOT NULL, -- BASICA, BGU, MEC
    description VARCHAR(50) -- Ejemplo: "1ro de Bachillerato Técnico"
);

CREATE TABLE parallels (
    id_parallel SERIAL PRIMARY KEY,
    id_grade INT NOT NULL REFERENCES grades(id_grade),
    name VARCHAR(5) NOT NULL -- Ejemplo: "A", "B"
);

CREATE TABLE teacher_subjects (
    id_teacher_subject SERIAL PRIMARY KEY,
    id_teacher INT NOT NULL REFERENCES teachers(id_teacher),
    id_subject INT NOT NULL REFERENCES subjects(id_subject)
);

CREATE TABLE course_assignments (
    id_assignment SERIAL PRIMARY KEY,
    id_teacher_subject INT NOT NULL REFERENCES teacher_subjects(id_teacher_subject),
    id_parallel INT NOT NULL REFERENCES parallels(id_parallel),
    weekly_hours INT NOT NULL -- número de horas asignadas por semana
);

CREATE TABLE schedules_types (
    id_schedules_types SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE, -- 'BASICA', 'BGU', 'MECA', etc.
    description VARCHAR(100)
);


CREATE TABLE time_slots (
    id_slot SERIAL PRIMARY KEY,
    slot_number INT NOT NULL, -- orden del bloque (1,2,3...)
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    is_break BOOLEAN DEFAULT FALSE, -- recreo o descanso largo
    description VARCHAR(50), -- opcional: "recreo", "descanso corto"
     id_schedules_types INT NOT NULL REFERENCES schedules_types(id_schedules_types)
);

CREATE TABLE grade_time_slots (
    id_grade INT NOT NULL REFERENCES grades(id_grade),
    id_slot INT NOT NULL REFERENCES time_slots(id_slot),
    PRIMARY KEY (id_grade, id_slot)
);



CREATE TABLE schedule (
    id_schedule SERIAL PRIMARY KEY,
    id_assignment INT NOT NULL REFERENCES course_assignments(id_assignment),
    day_of_week INT NOT NULL CHECK (day_of_week BETWEEN 1 AND 6), -- 1=Lunes ... 6=Sábado
    id_slot INT NOT NULL REFERENCES time_slots(id_slot)
);
ALTER TABLE schedule ADD CONSTRAINT uc_teacher_slot UNIQUE (id_assignment, id_slot, day_of_week);


-- ===========================================
-- INSERT DE DOCENTES
-- ===========================================
INSERT INTO teachers (full_name) VALUES
('JORGE ABELARDO BURGASI ZAPATA'),
('ROLANDO GELIO TOAPANTA VALVERDE'),
('ALBA JEANNETH CHICAIZA TIGASI'),
('FERNANDA MARICELA CHICAIZA BALSECA'),
('VINICIO PAUL CHARIGUAMAN MOROCHO'),
('FABIAN JEOVANNY MOSQUERA JACOME'),
('IRENE AMPARITO TAPIA VITERI'),
('MARIA FERNANDA ANCHUNDIA MARCILLO'),
('SORAYA LORENA CAPILLA FABARA'),
('MARCO RAMIRO ESCOBAR TAPIA'),
('ARACELY SILVANA COLLAGUAZO MARCILLO'),
('ANGEL OSWALDO ALMACHE CHANGO'),
('SENEIDA MARLENE CAMPOS MASABANDA'),
('DEISY ALEXANDRA BURGASI OÑA'),
('BLANCA MARINA CHACON MOLINA'),
('ALEXANDRA PAULINA MONTALUISA ESCOBAR'),
('SONIA VERONICA PATATE BUSTILLOS'),
('ANGEL FERNANDO REMACHE CEVALLOS'),
('SEGUNDO EDUARDO SEMBLANTES CLAUDIO'),
('CLARA SILVANA ALBAN QUINTANA'),
('FRANKLIN JAVIER GUAMANGALLO MORENO');

-- ===========================================
-- INSERT DE MATERIAS
-- ===========================================
INSERT INTO subjects (name) VALUES
('Control de Caracteristicas'),
('Dibujo Tecnico Aplicado'),
('Soldadura'),
('Seguridad Industrial'),
('Fundamentos de Metrologia y Control de Calidad'),
('Proceso Industriales Sostenibles'),
('Modulo Práctico Experimental'),
('Dibujo Técnico'),
('Mecanizado por Arranque de Viruta'),
('EE.FF'),
('Emprendimiento y Gestión'),
('Animación a La Lectura'),
('Educacion Fisica'),
('Calculo Mecanico y Estructural'),
('ECA'),
('Optativas Informatica, Computacion, Afines'),
('Educación para Ciudadania'),
('OVP'),
('FOL'),
('Acompañamiento'),
('Matematica'),
('Filosofia'),
('Optativa Problemas del Mundo Contemporaneo'),
('Física'),
('Lengua y Literatura'),
('Inglés Técnico'),
('Inglés'),
('Optativa Diseño Proyectos'),
('Optativa Investigación'),
('Química'),
('Biologia'),
('CCNN'),
('EE SS'),
('CC. NN'),
('Historia'),
('Ciencias Sociales');

-- ===========================================
-- RELACIÓN DOCENTES ↔ MATERIAS
-- ===========================================

INSERT INTO teacher_subjects (id_teacher, id_subject) SELECT t.id_teacher, s.id_subject FROM teachers t, subjects s
WHERE t.full_name = 'JORGE ABELARDO BURGASI ZAPATA'
  AND s.name IN (
    'Control de Caracteristicas',
    'Dibujo Tecnico Aplicado',
    'Soldadura',
    'Seguridad Industrial',
    'Fundamentos de Metrologia y Control de Calidad'
);

INSERT INTO teacher_subjects (id_teacher, id_subject) SELECT t.id_teacher, s.id_subject FROM teachers t, subjects s
WHERE t.full_name = 'ROLANDO GELIO TOAPANTA VALVERDE'
  AND s.name IN (
    'Proceso Industriales Sostenibles',
    'Modulo Práctico Experimental',
    'Dibujo Técnico',
    'Mecanizado por Arranque de Viruta'
);

INSERT INTO teacher_subjects (id_teacher, id_subject) SELECT t.id_teacher, s.id_subject FROM teachers t, subjects s
WHERE t.full_name = 'ALBA JEANNETH CHICAIZA TIGASI'
  AND s.name IN ('EE.FF');

INSERT INTO teacher_subjects (id_teacher, id_subject) SELECT t.id_teacher, s.id_subject FROM teachers t, subjects s
WHERE t.full_name = 'FERNANDA MARICELA CHICAIZA BALSECA'
  AND s.name IN ('Emprendimiento y Gestión', 'Animación a La Lectura');

INSERT INTO teacher_subjects (id_teacher, id_subject) SELECT t.id_teacher, s.id_subject FROM teachers t, subjects s
WHERE t.full_name = 'VINICIO PAUL CHARIGUAMAN MOROCHO'
  AND s.name IN ('Educacion Fisica');

INSERT INTO teacher_subjects (id_teacher, id_subject) SELECT t.id_teacher, s.id_subject FROM teachers t, subjects s
WHERE t.full_name = 'FABIAN JEOVANNY MOSQUERA JACOME'
  AND s.name IN (
    'Calculo Mecanico y Estructural',
    'ECA',
    'Optativas Informatica, Computacion, Afines',
    'Educación para Ciudadania',
    'OVP',
    'FOL',
    'Acompañamiento'
);

INSERT INTO teacher_subjects (id_teacher, id_subject) SELECT t.id_teacher, s.id_subject FROM teachers t, subjects s
WHERE t.full_name = 'IRENE AMPARITO TAPIA VITERI'
  AND s.name IN (
    'Matematica',
    'Acompañamiento',
    'Emprendimiento y Gestión',
    'Filosofia',
    'Optativa Problemas del Mundo Contemporaneo'
);

INSERT INTO teacher_subjects (id_teacher, id_subject) SELECT t.id_teacher, s.id_subject FROM teachers t, subjects s
WHERE t.full_name = 'MARIA FERNANDA ANCHUNDIA MARCILLO'
  AND s.name IN ('Matematica', 'Física', 'EE.FF');

INSERT INTO teacher_subjects (id_teacher, id_subject) SELECT t.id_teacher, s.id_subject FROM teachers t, subjects s
WHERE t.full_name = 'SORAYA LORENA CAPILLA FABARA'
  AND s.name IN ('Lengua y Literatura', 'Acompañamiento');

INSERT INTO teacher_subjects (id_teacher, id_subject) SELECT t.id_teacher, s.id_subject FROM teachers t, subjects s
WHERE t.full_name = 'MARCO RAMIRO ESCOBAR TAPIA'
  AND s.name IN ('Inglés Técnico', 'Inglés', 'Acompañamiento', 'Animación a La Lectura');

INSERT INTO teacher_subjects (id_teacher, id_subject) SELECT t.id_teacher, s.id_subject FROM teachers t, subjects s
WHERE t.full_name = 'ARACELY SILVANA COLLAGUAZO MARCILLO'
  AND s.name IN (
    'Animación a La Lectura',
    'Filosofia',
    'Lengua y Literatura',
    'ECA',
    'Acompañamiento',
    'Optativa Diseño Proyectos',
    'Optativa Investigación'
);

INSERT INTO teacher_subjects (id_teacher, id_subject)   SELECT t.id_teacher, s.id_subject FROM teachers t, subjects s
WHERE t.full_name = 'ANGEL OSWALDO ALMACHE CHANGO'
  AND s.name IN ('Química', 'Biologia', 'Animación a La Lectura', 'Acompañamiento');

INSERT INTO teacher_subjects (id_teacher, id_subject)  SELECT t.id_teacher, s.id_subject FROM teachers t, subjects s
WHERE t.full_name = 'SENEIDA MARLENE CAMPOS MASABANDA'
  AND s.name IN ('Inglés', 'Acompañamiento');

INSERT INTO teacher_subjects (id_teacher, id_subject)  SELECT t.id_teacher, s.id_subject FROM teachers t, subjects s
WHERE t.full_name = 'DEISY ALEXANDRA BURGASI OÑA'
  AND s.name IN ('CCNN', 'Biologia', 'Acompañamiento');

INSERT INTO teacher_subjects (id_teacher, id_subject)  SELECT t.id_teacher, s.id_subject FROM teachers t, subjects s
WHERE t.full_name = 'BLANCA MARINA CHACON MOLINA'
  AND s.name IN ('Matematica', 'Acompañamiento');

INSERT INTO teacher_subjects (id_teacher, id_subject)  SELECT t.id_teacher, s.id_subject FROM teachers t, subjects s
WHERE t.full_name = 'ALEXANDRA PAULINA MONTALUISA ESCOBAR'
  AND s.name IN ('Matematica', 'Física', 'Acompañamiento');

INSERT INTO teacher_subjects (id_teacher, id_subject)  SELECT t.id_teacher, s.id_subject FROM teachers t, subjects s
WHERE t.full_name = 'SONIA VERONICA PATATE BUSTILLOS'
  AND s.name IN ('EE SS', 'CC. NN', 'ECA', 'OVP');

INSERT INTO teacher_subjects (id_teacher, id_subject)  SELECT t.id_teacher, s.id_subject FROM teachers t, subjects s
WHERE t.full_name = 'ANGEL FERNANDO REMACHE CEVALLOS'
  AND s.name IN ('Lengua y Literatura', 'Acompañamiento');

INSERT INTO teacher_subjects (id_teacher, id_subject)  SELECT t.id_teacher, s.id_subject FROM teachers t, subjects s
WHERE t.full_name = 'SEGUNDO EDUARDO SEMBLANTES CLAUDIO'
  AND s.name IN ('EE SS', 'Historia', 'Ciencias Sociales', 'Educación para Ciudadania', 'OVP', 'Acompañamiento');

INSERT INTO teacher_subjects (id_teacher, id_subject)  SELECT t.id_teacher, s.id_subject FROM teachers t, subjects s
WHERE t.full_name = 'CLARA SILVANA ALBAN QUINTANA'
  AND s.name IN ('Animación a La Lectura');
  
INSERT INTO teacher_subjects (id_teacher, id_subject)  SELECT t.id_teacher, s.id_subject FROM teachers t, subjects s
WHERE t.full_name = 'FRANKLIN JAVIER GUAMANGALLO MORENO'
  AND s.name IN ('EE.FF');

  -- Insertar grados
INSERT INTO grades (level, type, description) VALUES
(7, 'BASICA', '7mo de Básica'),
(8, 'BASICA', '8vo de Básica'),
(9, 'BASICA', '9no de Básica'),
(10, 'BASICA', '10mo de Básica'),
(1, 'BGU', '1ro de Bachillerato'),
(1, 'MEC', '1ro de Bachillerato Técnico'),
(2, 'BGU', '2do de Bachillerato'),
(2, 'MEC', '2do de Bachillerato Técnico'),
(3, 'BGU', '3ro de Bachillerato'),
(3, 'MEC', '3ro de Bachillerato Técnico');

-- Paralelos para BASICA
INSERT INTO parallels (id_grade, name)
SELECT id_grade, 'A' FROM grades WHERE level = 7 AND type = 'BASICA';
INSERT INTO parallels (id_grade, name)
SELECT id_grade, 'B' FROM grades WHERE level = 7 AND type = 'BASICA';

INSERT INTO parallels (id_grade, name)
SELECT id_grade, 'A' FROM grades WHERE level = 8 AND type = 'BASICA';
INSERT INTO parallels (id_grade, name)
SELECT id_grade, 'B' FROM grades WHERE level = 8 AND type = 'BASICA';

INSERT INTO parallels (id_grade, name)
SELECT id_grade, 'A' FROM grades WHERE level = 9 AND type = 'BASICA';
INSERT INTO parallels (id_grade, name)
SELECT id_grade, 'B' FROM grades WHERE level = 9 AND type = 'BASICA';

INSERT INTO parallels (id_grade, name)
SELECT id_grade, 'A' FROM grades WHERE level = 10 AND type = 'BASICA';
INSERT INTO parallels (id_grade, name)
SELECT id_grade, 'B' FROM grades WHERE level = 10 AND type = 'BASICA';

-- Paralelos para BGU/MEC (solo un paralelo por tipo)
INSERT INTO parallels (id_grade, name)
SELECT id_grade, 'BGU' FROM grades WHERE type = 'BGU';
INSERT INTO parallels (id_grade, name)
SELECT id_grade, 'MEC' FROM grades WHERE type = 'MEC';

INSERT INTO schedules_types (name, description) VALUES
('GENERAL','Horario de estudiantes de Básica y Bachillerato General Unificado'),
('MECA','Bachillerato Técnico');

--basica & BGU
INSERT INTO time_slots (slot_number, start_time, end_time, id_schedules_types, is_break, description) VALUES
(1, '07:00', '07:45', 1, FALSE, 'Hora 1'),
(2, '07:45', '08:30', 1, FALSE, 'Hora 2'),
(3, '08:30', '09:15', 1, FALSE, 'Hora 3'),
(4, '09:15', '10:00', 1, FALSE, 'Hora 4'),
(5, '10:00', '10:30', 1, TRUE, 'Recreo'),
(6, '10:30', '11:15', 1, FALSE, 'Hora 5'),
(7, '11:15', '12:00', 1, FALSE, 'Hora 6'),
(8, '12:00', '12:45', 1, FALSE, 'Hora 7');

--MECA
INSERT INTO time_slots (slot_number, start_time, end_time, id_schedules_types, is_break, description) VALUES
(1, '07:00', '07:40', 2, FALSE, 'Hora 1'),
(2, '07:45', '08:25', 2, FALSE, 'Hora 2'),
(3, '08:30', '09:10', 2, FALSE, 'Hora 3'),
(4, '09:15', '09:55', 2, FALSE, 'Hora 4'),
(5, '09:55', '10:30', 2, TRUE, 'Recreo'),
(6, '10:30', '11:10', 2, FALSE, 'Hora 5'),
(7, '11:15', '11:55', 2, FALSE, 'Hora 6'),
(8, '12:00', '12:40', 2, FALSE, 'Hora 7'),
(9, '12:45', '13:20', 2, FALSE, 'Hora 8');

-- BÁSICA
-- 7mo (id:1)
INSERT INTO grade_time_slots (id_grade, id_slot) VALUES
(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8);

-- 8vo (id:2)
INSERT INTO grade_time_slots (id_grade, id_slot) VALUES
(2,1),(2,2),(2,3),(2,4),(2,5),(2,6),(2,7),(2,8);

-- 9no (id:3)
INSERT INTO grade_time_slots (id_grade, id_slot) VALUES
(3,1),(3,2),(3,3),(3,4),(3,5),(3,6),(3,7),(3,8);

-- 10mo (id:4)
INSERT INTO grade_time_slots (id_grade, id_slot) VALUES
(4,1),(4,2),(4,3),(4,4),(4,5),(4,6),(4,7),(4,8);

-- BGU
-- 1ro (id:5)
INSERT INTO grade_time_slots (id_grade, id_slot) VALUES
(5,1),(5,2),(5,3),(5,4),(5,5),(5,6),(5,7),(5,8);

-- 2do (id:7)
INSERT INTO grade_time_slots (id_grade, id_slot) VALUES
(7,1),(7,2),(7,3),(7,4),(7,5),(7,6),(7,7),(7,8);

-- 3ro (id:9)
INSERT INTO grade_time_slots (id_grade, id_slot) VALUES
(9,1),(9,2),(9,3),(9,4),(9,5),(9,6),(9,7),(9,8);

-- 1ro MEC (id:6)
INSERT INTO grade_time_slots (id_grade, id_slot) VALUES
(6,9),(6,10),(6,11),(6,12),(6,13),(6,14),(6,15),(6,16),(6,17);

-- 2do MEC (id:8)
INSERT INTO grade_time_slots (id_grade, id_slot) VALUES
(8,9),(8,10),(8,11),(8,12),(8,13),(8,14),(8,15),(8,16),(8,17);

-- 3ro MEC (id:10)
INSERT INTO grade_time_slots (id_grade, id_slot) VALUES
(10,9),(10,10),(10,11),(10,12),(10,13),(10,14),(10,15),(10,16),(10,17);











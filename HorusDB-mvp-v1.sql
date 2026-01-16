CREATE TABLE teachers (
    id_teacher SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    color VARCHAR(7);
    full_name VARCHAR(150) NOT NULL,
    identification VARCHAR(20) UNIQUE, -- opcional: cédula/pasaporte
    email VARCHAR(100),
    phone VARCHAR(20)
);


CREATE TABLE teacher_roles (
    id_role SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE, -- Ejemplo: Rector, Vicerrector, Inspector General
    description VARCHAR(200)
);

CREATE TABLE teacher_role_assignments (
    id_teacher INT NOT NULL REFERENCES teachers(id_teacher),
    id_role INT NOT NULL REFERENCES teacher_roles(id_role),
    start_date DATE,
    end_date DATE,
    PRIMARY KEY (id_teacher, id_role)
);

CREATE TABLE subjects (
    id_subject SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description VARCHAR(255) NULL,
    color VARCHAR(150) NOT NULL,
    is_practical BOOLEAN DEFAULT FALSE -- ejemplo: soldadura, arranque de viruta
);

CREATE TABLE grades (
    id_grade SERIAL PRIMARY KEY,
    level INT NOT NULL, -- Ejemplo: 6, 7, 8, 9, 10, 1 (para 1ro BGU/MEC)
    type VARCHAR(20) NOT NULL, -- BASICA, BACJILLERATO,
    description VARCHAR(50) -- Ejemplo: "1ro de Bachillerato Técnico"
);

CREATE TABLE parallels (
    id_parallel SERIAL PRIMARY KEY,
    id_grade INT NOT NULL REFERENCES grades(id_grade),
    id_tutor_teacher INT REFERENCES teachers(id_teacher) ON DELETE SET NULL,
    name VARCHAR(5) NOT NULL, -- Ejemplo: "A", "B"
    track VARCHAR(10) NOT NULL DEFAULT 'BGU'
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
    name VARCHAR(50) NOT NULL UNIQUE, -- 'BASICA', 'BGU', 'MEC', etc.
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

CREATE TABLE parallel_time_slots (
    id_parallel INT NOT NULL REFERENCES parallels(id_parallel),
    id_slot INT NOT NULL REFERENCES time_slots(id_slot),
    PRIMARY KEY (id_parallel, id_slot)
);


CREATE TABLE schedule (
    id_schedule SERIAL PRIMARY KEY,
    id_assignment INT NOT NULL REFERENCES course_assignments(id_assignment),
    day_of_week INT NOT NULL CHECK (day_of_week BETWEEN 1 AND 6), -- 1=Lunes ... 6=Sábado
    id_slot INT NOT NULL REFERENCES time_slots(id_slot)
);
ALTER TABLE schedule ADD CONSTRAINT uc_teacher_slot UNIQUE (id_assignment, id_slot, day_of_week);

CREATE TABLE institutions (
    id_institution SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    logo_url VARCHAR(300),
    logo_ministry_url VARCHAR(300),
    amie_code VARCHAR(300),
    address VARCHAR(200),
    slogan VARCHAR(1000),
    phone VARCHAR(20),
    email VARCHAR(100),
    website VARCHAR(100),
    rector_name VARCHAR(150),
    description TEXT
);


-- =====================================
-- INSERTS INICIALES PARA teacher_roles
-- =====================================

INSERT INTO teacher_roles (name, description) VALUES
('Rector', 'Máxima autoridad institucional, responsable de la dirección general de la institución.'),
('Vicerrector', 'Asiste al Rector en la gestión académica y administrativa.'),
('Inspector General', 'Encargado del control disciplinario y orden institucional.'),
('Coordinador Académico', 'Supervisa y coordina las actividades pedagógicas y curriculares.'),
('Coordinador de Área', 'Responsable de un área específica del conocimiento, como Matemática o Lengua.'),
('Tutor de Curso', 'Docente responsable de la tutoría y acompañamiento de un paralelo o grupo de estudiantes.'),
('Secretario Académico', 'Encargado de los procesos académicos y administrativos de los estudiantes.'),
('Docente', 'Profesor encargado de impartir clases en una o más materias.'),
('Orientador', 'Profesional de apoyo psicológico y vocacional de los estudiantes.'),
('Bibliotecario', 'Encargado de la biblioteca y recursos educativos.'),
('Administrador', 'Responsable de la gestión financiera y operativa de la institución.'),
('Coordinador de Convivencia', 'Encargado de la disciplina y convivencia escolar.'),
('Inspector de Nivel', 'Supervisa y controla un nivel educativo específico (Ej. BGU o Básica).');

-- ===========================================
-- INSERT DE DOCENTES
-- ===========================================
INSERT INTO teachers (first_name, last_name, full_name, color) VALUES
('JORGE ABELARDO', 'BURGASI ZAPATA', 'JORGE ABELARDO BURGASI ZAPATA', '#f8d7da'),
('ROLANDO GELIO', 'TOAPANTA VALVERDE', 'ROLANDO GELIO TOAPANTA VALVERDE', '#fff3cd'),
('ALBA JEANNETH', 'CHICAIZA TIGASI', 'ALBA JEANNETH CHICAIZA TIGASI', '#d1ecf1'),
('FERNANDA MARICELA', 'CHICAIZA BALSECA', 'FERNANDA MARICELA CHICAIZA BALSECA', '#d4edda'),
('VINICIO PAUL', 'CHARIGUAMAN MOROCHO', 'VINICIO PAUL CHARIGUAMAN MOROCHO', '#f0d9ff'),
('FABIAN JEOVANNY', 'MOSQUERA JACOME', 'FABIAN JEOVANNY MOSQUERA JACOME', '#ffe5b4'),
('IRENE AMPARITO', 'TAPIA VITERI', 'IRENE AMPARITO TAPIA VITERI', '#e8daef'),
('MARIA FERNANDA', 'ANCHUNDIA MARCILLO', 'MARIA FERNANDA ANCHUNDIA MARCILLO', '#d6e0f0'),
('SORAYA LORENA', 'CAPILLA FABARA', 'SORAYA LORENA CAPILLA FABARA', '#f9e79f'),
('MARCO RAMIRO', 'ESCOBAR TAPIA', 'MARCO RAMIRO ESCOBAR TAPIA', '#fde2e4'),
('ARACELY SILVANA', 'COLLAGUAZO MARCILLO', 'ARACELY SILVANA COLLAGUAZO MARCILLO', '#d7e3fc'),
('ANGEL OSWALDO', 'ALMACHE CHANGO', 'ANGEL OSWALDO ALMACHE CHANGO', '#e2f0cb'),
('SENEIDA MARLENE', 'CAMPOS MASABANDA', 'SENEIDA MARLENE CAMPOS MASABANDA', '#ffdfd3'),
('DEISY ALEXANDRA', 'BURGASI OÑA', 'DEISY ALEXANDRA BURGASI OÑA', '#cce2cb'),
('BLANCA MARINA', 'CHACON MOLINA', 'BLANCA MARINA CHACON MOLINA', '#faf3dd'),
('ALEXANDRA PAULINA', 'MONTALUISA ESCOBAR', 'ALEXANDRA PAULINA MONTALUISA ESCOBAR', '#dbe7e4'),
('SONIA VERONICA', 'PATATE BUSTILLOS', 'SONIA VERONICA PATATE BUSTILLOS', '#ede7b1'),
('ANGEL FERNANDO', 'REMACHE CEVALLOS', 'ANGEL FERNANDO REMACHE CEVALLOS', '#f5c6aa'),
('SEGUNDO EDUARDO', 'SEMBLANTES CLAUDIO', 'SEGUNDO EDUARDO SEMBLANTES CLAUDIO', '#c3bef0'),
('CLARA SILVANA', 'ALBAN QUINTANA', 'CLARA SILVANA ALBAN QUINTANA', '#e2ece9'),
('FRANKLIN JAVIER', 'GUAMANGALLO MORENO', 'FRANKLIN JAVIER GUAMANGALLO MORENO', '#f7d9c4');


-- ===========================================
-- INSERT DE MATERIAS
-- ===========================================
INSERT INTO subjects (name, description, color, is_practical) VALUES
('Control de Caracteristicas', 'Análisis y control de parámetros de calidad en procesos industriales.', '#A8D5BA', false),
('Dibujo Tecnico Aplicado', 'Representación gráfica de piezas y estructuras con normas técnicas.', '#F8C8DC', false),
('Soldadura', 'Fundamentos teóricos y prácticos del proceso de unión de metales.', '#F7D9A8', false),
('Seguridad Industrial', 'Prevención de riesgos laborales y aplicación de normas de seguridad.', '#B5EAD7', false),
('Fundamentos de Metrologia y Control de Calidad', 'Principios de medición y aseguramiento de la calidad en la producción.', '#C7CEEA', false),
('Proceso Industriales Sostenibles', 'Prácticas sostenibles en los procesos productivos modernos.', '#FFDAC1', false),
('Modulo Práctico Experimental', 'Aplicación práctica de conocimientos técnicos en laboratorio o taller.', '#E2F0CB', false),
('Dibujo Técnico', 'Principios del dibujo técnico para el diseño y fabricación mecánica.', '#FFB7B2', false),
('Mecanizado por Arranque de Viruta', 'Técnicas de corte y mecanizado de materiales metálicos.', '#BDE0FE', false),
('EE.FF', 'Educación espiritual y formación en valores institucionales.', '#FFB6B9', false),
('Emprendimiento y Gestión', 'Desarrollo de proyectos empresariales y administración básica.', '#FFD6A5', false),
('Animación a La Lectura', 'Fomento del hábito lector y comprensión lectora crítica.', '#D5AAFF', false),
('Educacion Fisica', 'Desarrollo físico, coordinación y trabajo en equipo mediante el deporte.', '#F9E79F', false),
('Calculo Mecanico y Estructural', 'Análisis de fuerzas y estructuras aplicadas a la ingeniería mecánica.', '#CDEAC0', false),
('ECA', 'Espacio curricular autónomo destinado al desarrollo integral del estudiante.', '#A0CED9', false),
('Optativas Informatica, Computacion, Afines', 'Asignaturas orientadas a la tecnología y el manejo de herramientas digitales.', '#FFC9DE', false),
('Educación para Ciudadania', 'Formación ética, social y cívica para la convivencia democrática.', '#FFCBF2', false),
('OVP', 'Orientación vocacional y profesional para la proyección futura del estudiante.', '#C1E1DC', false),
('FOL', 'Formación y orientación laboral para la inserción en el ámbito profesional.', '#FAD6A5', false),
('Acompañamiento', 'Seguimiento académico y emocional del estudiante.', '#E4C1F9', false),
('Matematica', 'Estudio de conceptos numéricos, algebraicos y geométricos aplicados.', '#A7BED3', false),
('Filosofia', 'Reflexión crítica sobre el pensamiento humano y su contexto.', '#FF9AA2', false),
('Optativa Problemas del Mundo Contemporaneo', 'Análisis de los principales desafíos actuales de la sociedad global.', '#F6EAC2', false),
('Física', 'Estudio de los fenómenos naturales y sus leyes fundamentales.', '#BEE5BF', false),
('Lengua y Literatura', 'Desarrollo de la comunicación oral y escrita y apreciación literaria.', '#F1C0E8', false),
('Inglés Técnico', 'Aprendizaje del inglés orientado al ámbito técnico y profesional.', '#FDFD96', false),
('Inglés', 'Desarrollo de habilidades comunicativas en el idioma inglés.', '#C5E1A5', false),
('Optativa Diseño Proyectos', 'Diseño y gestión de proyectos técnicos o sociales aplicados.', '#B5D8EB', false),
('Optativa Investigación', 'Metodologías de investigación científica y elaboración de proyectos.', '#E2C6F9', false),
('Química', 'Estudio de la composición y transformación de la materia.', '#FFDACF', false),
('Biologia', 'Análisis de los seres vivos y los procesos biológicos fundamentales.', '#BDE8CA', false),
('CCNN', 'Ciencias Naturales: fundamentos biológicos, físicos y químicos.', '#E0BBE4', false),
('EE SS', 'Educación Social y Solidaria enfocada en la comunidad.', '#FEC8D8', false),
('CC. NN', 'Ciencias Naturales: exploración del entorno físico y biológico.', '#C7D3EA', false),
('Historia', 'Estudio de los procesos históricos y su impacto en la actualidad.', '#FFDFD3', false),
('Ciencias Sociales', 'Análisis de la organización y evolución de las sociedades humanas.', '#A0E7E5', false);


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

-- Tabla grades
INSERT INTO grades (level, type, description) VALUES
(1, 'BASICA', '1ro de Básica'),
(6, 'BASICA', '6to de Básica'),
(7, 'BASICA', '7mo de Básica'),
(8, 'BASICA', '8vo de Básica'),
(9, 'BASICA', '9no de Básica'),
(10, 'BASICA', '10mo de Básica'),
(101, 'BACHILLERATO', '1ro de Bachillerato'),
(102, 'BACHILLERATO', '2do de Bachillerato'),
(103, 'BACHILLERATO', '3ro de Bachillerato');

-- BÁSICA (A/B)
INSERT INTO parallels (id_grade, name, track)
SELECT id_grade, 'A', 'BASICA' FROM grades WHERE type = 'BASICA';
INSERT INTO parallels (id_grade, name, track)
SELECT id_grade, 'B', 'BASICA' FROM grades WHERE type = 'BASICA';

-- BGU (A)
INSERT INTO parallels (id_grade, name, track)
SELECT id_grade, 'A', 'BGU' FROM grades WHERE type = 'BACHILLERATO';

-- MEC (A)
INSERT INTO parallels (id_grade, name, track)
SELECT id_grade, 'A', 'MEC' FROM grades WHERE type = 'BACHILLERATO';




INSERT INTO schedules_types (name, description) VALUES
('GENERAL','Horario de estudiantes de Básica y Bachillerato General Unificado'),
('MEC','Bachillerato Técnico');

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

--MEC
INSERT INTO time_slots (slot_number, start_time, end_time, id_schedules_types, is_break, description) VALUES
(1, '07:00', '07:40', 2, FALSE, 'Hora 1'),
(2, '07:40', '08:20', 2, FALSE, 'Hora 2'),
(3, '08:20', '09:00', 2, FALSE, 'Hora 3'),
(4, '09:00', '09:40', 2, FALSE, 'Hora 4'),
(5, '09:40', '10:10', 2, TRUE, 'Recreo'),
(6, '10:10', '10:50', 2, FALSE, 'Hora 5'),
(7, '10:50', '11:30', 2, FALSE, 'Hora 6'),
(8, '11:30', '12:10', 2, FALSE, 'Hora 7'),
(9, '12:10', '12:50', 2, FALSE, 'Hora 8');


INSERT INTO parallel_time_slots (id_parallel, id_slot)
SELECT p.id_parallel, s.id_slot
FROM parallels p
JOIN time_slots s ON s.id_schedules_types = 1
WHERE p.track IN ('BASICA','BGU');

INSERT INTO parallel_time_slots (id_parallel, id_slot)
SELECT p.id_parallel, s.id_slot
FROM parallels p
JOIN time_slots s ON s.id_schedules_types = 2
WHERE p.track = 'MEC';
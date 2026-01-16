CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE teacher (
  id_teacher UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  full_name VARCHAR(150) GENERATED ALWAYS AS (first_name || ' ' || last_name) STORED,
  professional_title VARCHAR(20),
  identification VARCHAR(20) UNIQUE NULL,
  email VARCHAR(100),
  phone VARCHAR(20),
  color CHAR(7),
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ NULL
);

CREATE TABLE role_type (
  id_role_type UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL UNIQUE,
  description VARCHAR(200),
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ NULL
);

CREATE TABLE teacher_role (
  id_teacher_role UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_teacher UUID NOT NULL REFERENCES teacher(id_teacher),
  id_role_type UUID NOT NULL REFERENCES role_type(id_role_type),
  start_date DATE,
  end_date DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ NULL,
  CONSTRAINT uc_teacher_role UNIQUE (id_teacher, id_role_type)
);

CREATE TABLE subject (
  id_subject UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(150) NOT NULL,
  description VARCHAR(255),
  color CHAR(7),
  is_practical BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ NULL
);

CREATE TABLE grade (
  id_grade UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  level INT NOT NULL,
  type VARCHAR(20) NOT NULL,
  description VARCHAR(50),
  color CHAR(7),
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ NULL
);

CREATE TABLE parallel (
  id_parallel UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_grade UUID NOT NULL REFERENCES grade(id_grade),
  id_tutor_teacher UUID REFERENCES teacher(id_teacher) ON DELETE SET NULL,
  name VARCHAR(5) NOT NULL,
  track VARCHAR(10) NOT NULL DEFAULT 'BGU',
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ NULL
);

CREATE TABLE teacher_subject (
  id_teacher_subject UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_teacher UUID NOT NULL REFERENCES teacher(id_teacher),
  id_subject UUID NOT NULL REFERENCES subject(id_subject),
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uc_teacher_subject UNIQUE (id_teacher, id_subject)
);

CREATE TABLE parallel_subject (
  id_parallel_subject UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_teacher_subject UUID NOT NULL REFERENCES teacher_subject(id_teacher_subject),
  id_parallel UUID NOT NULL REFERENCES parallel(id_parallel),
  weekly_hours INT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ NULL,
  CONSTRAINT uc_parallel_subject UNIQUE (id_teacher_subject, id_parallel)
);

CREATE TABLE schedule_type (
  id_schedule_type UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(50) NOT NULL UNIQUE,
  description VARCHAR(100),
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ NULL
);

CREATE TABLE time_slot (
  id_time_slot UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_schedule_type UUID NOT NULL REFERENCES schedule_type(id_schedule_type),
  slot_number INT NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  is_break BOOLEAN NOT NULL DEFAULT FALSE,
  description VARCHAR(50),
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ NULL
);

CREATE TABLE parallel_time_slot (
  id_parallel_time_slot UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_parallel UUID NOT NULL REFERENCES parallel(id_parallel),
  id_time_slot UUID NOT NULL REFERENCES time_slot(id_time_slot),
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uc_parallel_time_slot UNIQUE (id_parallel, id_time_slot)
);

CREATE TABLE class_schedule (
  id_class_schedule UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_parallel_subject UUID NOT NULL REFERENCES parallel_subject(id_parallel_subject),
  id_time_slot UUID NOT NULL REFERENCES time_slot(id_time_slot),
  day_of_week INT NOT NULL CHECK (
    day_of_week BETWEEN 1
    AND 6
  ),
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  CONSTRAINT uc_class_schedule UNIQUE (id_parallel_subject, day_of_week, id_time_slot)
);

CREATE TABLE institution (
  id_institution UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(200) NOT NULL,
  logo_left VARCHAR(300),
  logo_right VARCHAR(300),
  amie_code VARCHAR(50),
  address VARCHAR(200),
  slogan VARCHAR(1000),
  phone VARCHAR(20),
  email VARCHAR(100),
  website VARCHAR(100),
  rector_name VARCHAR(150),
  description TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ NULL
);



-- =====================================
-- INSERTS INICIALES PARA role_type
-- =====================================

INSERT INTO role_type (name, description) VALUES
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
INSERT INTO teacher (first_name, last_name, professional_title, color) VALUES
('JORGE ABELARDO', 'BURGASI ZAPATA', 'LIC.', '#f8d7da'),
('ROLANDO GELIO', 'TOAPANTA VALVERDE', 'LIC.', '#fff3cd'),
('ALBA JEANNETH', 'CHICAIZA TIGASI', 'LICDA.', '#d1ecf1'),
('FERNANDA MARICELA', 'CHICAIZA BALSECA', 'LICDA.', '#d4edda'),
('VINICIO PAUL', 'CHARIGUAMAN MOROCHO', 'LIC.', '#f0d9ff'),
('FABIAN JEOVANNY', 'MOSQUERA JACOME', 'LIC.', '#ffe5b4'),
('IRENE AMPARITO', 'TAPIA VITERI', 'LICDA.', '#e8daef'),
('MARIA FERNANDA', 'ANCHUNDIA MARCILLO', 'LICDA.', '#d6e0f0'),
('SORAYA LORENA', 'CAPILLA FABARA', 'LICDA.', '#f9e79f'),
('MARCO RAMIRO', 'ESCOBAR TAPIA', 'LIC.', '#fde2e4'),
('ARACELY SILVANA', 'COLLAGUAZO MARCILLO', 'LICDA.', '#d7e3fc'),
('ANGEL OSWALDO', 'ALMACHE CHANGO', 'LIC.', '#e2f0cb'),
('SENEIDA MARLENE', 'CAMPOS MASABANDA', 'LICDA.', '#ffdfd3'),
('DEISY ALEXANDRA', 'BURGASI OÑA', 'LICDA.', '#cce2cb'),
('BLANCA MARINA', 'CHACON MOLINA', 'LICDA.', '#faf3dd'),
('ALEXANDRA PAULINA', 'MONTALUISA ESCOBAR', 'LICDA.', '#dbe7e4'),
('SONIA VERONICA', 'PATATE BUSTILLOS', 'LICDA.', '#ede7b1'),
('ANGEL FERNANDO', 'REMACHE CEVALLOS', 'LIC.', '#f5c6aa'),
('SEGUNDO EDUARDO', 'SEMBLANTES CLAUDIO', 'LIC.', '#c3bef0'),
('CLARA SILVANA', 'ALBAN QUINTANA', 'LICDA.', '#e2ece9'),
('FRANKLIN JAVIER', 'GUAMANGALLO MORENO', 'LIC.', '#f7d9c4');



-- ===========================================
-- INSERT DE MATERIAS
-- ===========================================
INSERT INTO subject (name, description, color, is_practical) VALUES
('Control de Caracteristicas', 'Análisis y control de parámetros de calidad en procesos industriales.', '#A8D5BA', false),
('Dibujo Tecnico Aplicado', 'Representación gráfica de piezas y estructuras con normas técnicas.', '#F8C8DC', false),
('Soldadura', 'Fundamentos teóricos y prácticos del proceso de unión de metales.', '#F7D9A8', false),
('Seguridad Industrial', 'Prevención de riesgos laborales y aplicación de normas de seguridad.', '#B5EAD7', false),
('Fundamentos de Metrologia y Control de Calidad', 'Principios de medición y aseguramiento de la calidad en la producción.', '#C7CEEA', false),
('Proceso Industriales Sostenibles', 'Prácticas sostenibles en los procesos productivos modernos.', '#FFDAC1', false),
('Modulo Práctico Experimental', 'Aplicación práctica de conocimientos técnicos en laboratorio o taller.', '#E2F0CB', false),
('Dibujo Técnico', 'Principios del dibujo técnico para el diseño y fabricación mecánica.', '#FFB7B2', false),
('Mecanizado por Arranque de Viruta', 'Técnicas de corte y mecanizado de materiales metálicos.', '#BDE0FE', false),
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
('Ciencias Naturales', 'Ciencias Naturales: fundamentos biológicos, físicos y químicos.', '#E0BBE4', false),
('Estudios Sociales', 'Educación Social y Solidaria enfocada en la comunidad.', '#FEC8D8', false),
('Historia', 'Estudio de los procesos históricos y su impacto en la actualidad.', '#FFDFD3', false),
('Ciencias Sociales', 'Análisis de la organización y evolución de las sociedades humanas.', '#A0E7E5', false);


-- ===========================================
-- RELACIÓN DOCENTES ↔ MATERIAS
-- ===========================================

INSERT INTO teacher_subject (id_teacher, id_subject) SELECT t.id_teacher, s.id_subject FROM teacher t, subject s
WHERE t.full_name = 'JORGE ABELARDO BURGASI ZAPATA'
  AND s.name IN (
    'Control de Caracteristicas',
    'Dibujo Tecnico Aplicado',
    'Soldadura',
    'Seguridad Industrial',
    'Fundamentos de Metrologia y Control de Calidad'
);

INSERT INTO teacher_subject (id_teacher, id_subject) SELECT t.id_teacher, s.id_subject FROM teacher t, subject s
WHERE t.full_name = 'ROLANDO GELIO TOAPANTA VALVERDE'
  AND s.name IN (
    'Proceso Industriales Sostenibles',
    'Modulo Práctico Experimental',
    'Dibujo Técnico',
    'Mecanizado por Arranque de Viruta'
);

INSERT INTO teacher_subject (id_teacher, id_subject) SELECT t.id_teacher, s.id_subject FROM teacher t, subject s
WHERE t.full_name = 'ALBA JEANNETH CHICAIZA TIGASI'
  AND s.name IN ('Educacion Fisica');

INSERT INTO teacher_subject (id_teacher, id_subject) SELECT t.id_teacher, s.id_subject FROM teacher t, subject s
WHERE t.full_name = 'FERNANDA MARICELA CHICAIZA BALSECA'
  AND s.name IN ('Emprendimiento y Gestión', 'Animación a La Lectura');

INSERT INTO teacher_subject (id_teacher, id_subject) SELECT t.id_teacher, s.id_subject FROM teacher t, subject s
WHERE t.full_name = 'VINICIO PAUL CHARIGUAMAN MOROCHO'
  AND s.name IN ('Educacion Fisica');

INSERT INTO teacher_subject (id_teacher, id_subject) SELECT t.id_teacher, s.id_subject FROM teacher t, subject s
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

INSERT INTO teacher_subject (id_teacher, id_subject) SELECT t.id_teacher, s.id_subject FROM teacher t, subject s
WHERE t.full_name = 'IRENE AMPARITO TAPIA VITERI'
  AND s.name IN (
    'Matematica',
    'Acompañamiento',
    'Emprendimiento y Gestión',
    'Filosofia',
    'Optativa Problemas del Mundo Contemporaneo'
);

INSERT INTO teacher_subject (id_teacher, id_subject) SELECT t.id_teacher, s.id_subject FROM teacher t, subject s
WHERE t.full_name = 'MARIA FERNANDA ANCHUNDIA MARCILLO'
  AND s.name IN ('Matematica', 'Física', 'Educacion Fisica');

INSERT INTO teacher_subject (id_teacher, id_subject) SELECT t.id_teacher, s.id_subject FROM teacher t, subject s
WHERE t.full_name = 'SORAYA LORENA CAPILLA FABARA'
  AND s.name IN ('Lengua y Literatura', 'Acompañamiento');

INSERT INTO teacher_subject (id_teacher, id_subject) SELECT t.id_teacher, s.id_subject FROM teacher t, subject s
WHERE t.full_name = 'MARCO RAMIRO ESCOBAR TAPIA'
  AND s.name IN ('Inglés Técnico', 'Inglés', 'Acompañamiento', 'Animación a La Lectura');

INSERT INTO teacher_subject (id_teacher, id_subject) SELECT t.id_teacher, s.id_subject FROM teacher t, subject s
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

INSERT INTO teacher_subject (id_teacher, id_subject)   SELECT t.id_teacher, s.id_subject FROM teacher t, subject s
WHERE t.full_name = 'ANGEL OSWALDO ALMACHE CHANGO'
  AND s.name IN ('Química', 'Biologia', 'Animación a La Lectura', 'Acompañamiento');

INSERT INTO teacher_subject (id_teacher, id_subject)  SELECT t.id_teacher, s.id_subject FROM teacher t, subject s
WHERE t.full_name = 'SENEIDA MARLENE CAMPOS MASABANDA'
  AND s.name IN ('Inglés', 'Acompañamiento');

INSERT INTO teacher_subject (id_teacher, id_subject)  SELECT t.id_teacher, s.id_subject FROM teacher t, subject s
WHERE t.full_name = 'DEISY ALEXANDRA BURGASI OÑA'
  AND s.name IN ('Ciencias Naturales', 'Biologia', 'Acompañamiento');

INSERT INTO teacher_subject (id_teacher, id_subject)  SELECT t.id_teacher, s.id_subject FROM teacher t, subject s
WHERE t.full_name = 'BLANCA MARINA CHACON MOLINA'
  AND s.name IN ('Matematica', 'Acompañamiento');

INSERT INTO teacher_subject (id_teacher, id_subject)  SELECT t.id_teacher, s.id_subject FROM teacher t, subject s
WHERE t.full_name = 'ALEXANDRA PAULINA MONTALUISA ESCOBAR'
  AND s.name IN ('Matematica', 'Física', 'Acompañamiento');

INSERT INTO teacher_subject (id_teacher, id_subject)  SELECT t.id_teacher, s.id_subject FROM teacher t, subject s
WHERE t.full_name = 'SONIA VERONICA PATATE BUSTILLOS'
  AND s.name IN ('Estudios Sociales', 'Ciencias Naturales', 'ECA', 'OVP');

INSERT INTO teacher_subject (id_teacher, id_subject)  SELECT t.id_teacher, s.id_subject FROM teacher t, subject s
WHERE t.full_name = 'ANGEL FERNANDO REMACHE CEVALLOS'
  AND s.name IN ('Lengua y Literatura', 'Acompañamiento');

INSERT INTO teacher_subject (id_teacher, id_subject)  SELECT t.id_teacher, s.id_subject FROM teacher t, subject s
WHERE t.full_name = 'SEGUNDO EDUARDO SEMBLANTES CLAUDIO'
  AND s.name IN ('Estudios Sociales', 'Historia', 'Ciencias Sociales', 'Educación para Ciudadania', 'OVP', 'Acompañamiento');

INSERT INTO teacher_subject (id_teacher, id_subject)  SELECT t.id_teacher, s.id_subject FROM teacher t, subject s
WHERE t.full_name = 'CLARA SILVANA ALBAN QUINTANA'
  AND s.name IN ('Animación a La Lectura');
  
INSERT INTO teacher_subject (id_teacher, id_subject)  SELECT t.id_teacher, s.id_subject FROM teacher t, subject s
WHERE t.full_name = 'FRANKLIN JAVIER GUAMANGALLO MORENO'
  AND s.name IN ('Educacion Fisica');

-- Tabla grades
INSERT INTO grade (level, type, description, color) VALUES
(1,   'BASICA',        '1ro de Básica',            '#E3F2FD'),  
(6,   'BASICA',        '6to de Básica',            '#E8F5E9'),  
(7,   'BASICA',        '7mo de Básica',            '#FFFDE7'),  
(8,   'BASICA',        '8vo de Básica',            '#FCE4EC'),  
(9,   'BASICA',        '9no de Básica',            '#F3E5F5'),  
(10,  'BASICA',        '10mo de Básica',           '#E0F2F1'),  
(101, 'BACHILLERATO',  '1ro de Bachillerato',      '#E1F5FE'), 
(102, 'BACHILLERATO',  '2do de Bachillerato',      '#FFF3E0'),  
(103, 'BACHILLERATO',  '3ro de Bachillerato',      '#EDE7F6'); 


-- BÁSICA (A/B)
INSERT INTO parallel (id_grade, name, track)
SELECT id_grade, 'A', 'BASICA' FROM grade WHERE type = 'BASICA';
INSERT INTO parallel (id_grade, name, track)
SELECT id_grade, 'B', 'BASICA' FROM grade WHERE type = 'BASICA';

-- BGU (A)
INSERT INTO parallel (id_grade, name, track)
SELECT id_grade, 'A', 'BGU' FROM grade WHERE type = 'BACHILLERATO';

-- MEC (A)
INSERT INTO parallel (id_grade, name, track)
SELECT id_grade, 'A', 'MEC' FROM grade WHERE type = 'BACHILLERATO';




INSERT INTO schedule_type (name, description) VALUES
('GENERAL','Horario de estudiantes de Básica y Bachillerato General Unificado'),
('MEC','Bachillerato Técnico');

--basica & BGU
INSERT INTO time_slot (
  slot_number,
  start_time,
  end_time,
  id_schedule_type,
  is_break,
  description
) VALUES
(1, '07:00', '07:45',
  (SELECT id_schedule_type FROM schedule_type WHERE name = 'GENERAL'),
  FALSE, 'Hora 1'),

(2, '07:45', '08:30',
  (SELECT id_schedule_type FROM schedule_type WHERE name = 'GENERAL'),
  FALSE, 'Hora 2'),

(3, '08:30', '09:15',
  (SELECT id_schedule_type FROM schedule_type WHERE name = 'GENERAL'),
  FALSE, 'Hora 3'),

(4, '09:15', '10:00',
  (SELECT id_schedule_type FROM schedule_type WHERE name = 'GENERAL'),
  FALSE, 'Hora 4'),

(5, '10:00', '10:30',
  (SELECT id_schedule_type FROM schedule_type WHERE name = 'GENERAL'),
  TRUE, 'Recreo'),

(6, '10:30', '11:15',
  (SELECT id_schedule_type FROM schedule_type WHERE name = 'GENERAL'),
  FALSE, 'Hora 5'),

(7, '11:15', '12:00',
  (SELECT id_schedule_type FROM schedule_type WHERE name = 'GENERAL'),
  FALSE, 'Hora 6'),

(8, '12:00', '12:45',
  (SELECT id_schedule_type FROM schedule_type WHERE name = 'GENERAL'),
  FALSE, 'Hora 7');


--MEC
INSERT INTO time_slot (
  slot_number,
  start_time,
  end_time,
  id_schedule_type,
  is_break,
  description
) VALUES
(1, '07:00', '07:40',
  (SELECT id_schedule_type FROM schedule_type WHERE name = 'MEC'),
  FALSE, 'Hora 1'),

(2, '07:40', '08:20',
  (SELECT id_schedule_type FROM schedule_type WHERE name = 'MEC'),
  FALSE, 'Hora 2'),

(3, '08:20', '09:00',
  (SELECT id_schedule_type FROM schedule_type WHERE name = 'MEC'),
  FALSE, 'Hora 3'),

(4, '09:00', '09:40',
  (SELECT id_schedule_type FROM schedule_type WHERE name = 'MEC'),
  FALSE, 'Hora 4'),

(5, '09:40', '10:10',
  (SELECT id_schedule_type FROM schedule_type WHERE name = 'MEC'),
  TRUE, 'Recreo'),

(6, '10:10', '10:50',
  (SELECT id_schedule_type FROM schedule_type WHERE name = 'MEC'),
  FALSE, 'Hora 5'),

(7, '10:50', '11:30',
  (SELECT id_schedule_type FROM schedule_type WHERE name = 'MEC'),
  FALSE, 'Hora 6'),

(8, '11:30', '12:10',
  (SELECT id_schedule_type FROM schedule_type WHERE name = 'MEC'),
  FALSE, 'Hora 7'),

(9, '12:10', '12:50',
  (SELECT id_schedule_type FROM schedule_type WHERE name = 'MEC'),
  FALSE, 'Hora 8');



INSERT INTO parallel_time_slot (id_parallel, id_time_slot)
SELECT
  p.id_parallel,
  ts.id_time_slot
FROM parallel p
JOIN time_slot ts
  ON ts.id_schedule_type = (
    SELECT id_schedule_type
    FROM schedule_type
    WHERE name = 'GENERAL'
  )
WHERE p.track IN ('BASICA', 'BGU');


INSERT INTO parallel_time_slot (id_parallel, id_time_slot)
SELECT
  p.id_parallel,
  ts.id_time_slot
FROM parallel p
JOIN time_slot ts
  ON ts.id_schedule_type = (
    SELECT id_schedule_type
    FROM schedule_type
    WHERE name = 'MEC'
  )
WHERE p.track = 'MEC';

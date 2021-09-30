


DROP TABLE IF EXISTS cursos CASCADE;
CREATE TABLE cursos (
  id INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL UNIQUE,
  descripcion VARCHAR(512) NOT NULL
);

INSERT INTO cursos VALUES (1, 'Programación', 'cosas');
INSERT INTO cursos VALUES (2, 'Bases de Datos', 'cosas');
INSERT INTO cursos VALUES (3, 'Lenguajes de Marcas', 'cosas');
INSERT INTO cursos VALUES (4, 'Programación Multiplataforma', 'cosas');
INSERT INTO cursos VALUES (5, 'Acceso a Datos', 'cosas');


DROP TABLE IF EXISTS empleados CASCADE;
CREATE TABLE empleados (
  id INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellidos VARCHAR(100) NOT NULL,
  nif CHAR(9) NOT NULL UNIQUE,
  telefono CHAR(9) NOT NULL UNIQUE,
  formacion_pedagogica boolean NOT NULL DEFAULT FALSE
);

INSERT INTO empleados VALUES (1, 'Pepe', 'Profe1', '01000111A', '666999111', false);
INSERT INTO empleados VALUES (2, 'Maria', 'Profa2', '01000222A', '666999222', true);
INSERT INTO empleados VALUES (3, 'Antonia', 'Profa3', '01000333A', '666999333', false);
INSERT INTO empleados VALUES (4, 'Mengano', 'Profe4', '01000444A', '666999444', true);

INSERT INTO empleados VALUES (11, 'Antonio', 'Alumno1', '02000111A', '666992111', false);
INSERT INTO empleados VALUES (12, 'Andrés', 'Alumno2', '02000222A', '666992222', true);
INSERT INTO empleados VALUES (13, 'Josefina', 'Alumno3', '02000333A', '666929333', false);
INSERT INTO empleados VALUES (14, 'Maribel', 'Alumno4', '02000444A', '666929444', true);



DROP TABLE IF EXISTS empleado_titulado CASCADE;
CREATE TABLE empleado_titulado (
  id_empleado INTEGER NOT NULL,
  id_curso INTEGER  NOT NULL,
  PRIMARY KEY (id_empleado, id_curso),
  FOREIGN KEY (id_empleado) REFERENCES empleados(id),
  FOREIGN KEY (id_curso) REFERENCES cursos(id)
);

INSERT INTO empleado_titulado VALUES (1, 1), (1, 2), (1, 3);
INSERT INTO empleado_titulado VALUES (2, 1), (2, 2), (2, 3);
INSERT INTO empleado_titulado VALUES (3, 4), (3, 5);
INSERT INTO empleado_titulado VALUES (4, 4), (4, 5);


DROP TABLE IF EXISTS prerrequisitos CASCADE;
CREATE TABLE prerrequisitos (
  id_curso INTEGER NOT NULL,
  id_curso_prerrequisito INTEGER NOT NULL,
  es_obligatorio BOOLEAN NOT NULL,
  PRIMARY KEY (id_curso, id_curso_prerrequisito),
  FOREIGN KEY (id_curso) REFERENCES cursos(id),
  FOREIGN KEY (id_curso_prerrequisito) REFERENCES cursos(id)
);

INSERT INTO prerrequisitos VALUES (4, 1, true);
INSERT INTO prerrequisitos VALUES (5, 1, true);
INSERT INTO prerrequisitos VALUES (5, 2, true);
INSERT INTO prerrequisitos VALUES (4, 3, false);

DROP TABLE IF EXISTS ediciones CASCADE;
CREATE TABLE ediciones (
  id_edicion INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  id_curso INTEGER NOT NULL,
  fecha DATE NOT NULL,
  lugar VARCHAR(100) NOT NULL,
  profesor INTEGER,
  FOREIGN KEY (id_curso) REFERENCES cursos(id),
  FOREIGN KEY (profesor) REFERENCES empleados(id)
);

INSERT INTO ediciones VALUES (1, 1, '2021-05-15', 'Vigo', NULL);
INSERT INTO ediciones VALUES (2, 1, '2021-06-15', 'Vigo', NULL);
INSERT INTO ediciones VALUES (3, 2, '2021-05-15', 'Vigo', NULL);
INSERT INTO ediciones VALUES (4, 2, '2021-05-15', 'Vigo', NULL);
INSERT INTO ediciones VALUES (5, 5, '2021-05-15', 'Vigo', NULL);
INSERT INTO ediciones VALUES (6, 5, '2021-05-15', 'Vigo', NULL);


DROP TABLE IF EXISTS alumnos CASCADE;
CREATE TABLE alumnos (
  id_empleado INTEGER NOT NULL,
  id_edicion INTEGER  NOT NULL,
  apto BOOLEAN DEFAULT FALSE,
  PRIMARY KEY (id_empleado, id_edicion),
  FOREIGN KEY (id_empleado) REFERENCES empleados(id),
  FOREIGN KEY (id_edicion) REFERENCES ediciones(id_edicion)
);




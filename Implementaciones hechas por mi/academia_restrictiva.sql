DROP DATABASE IF EXISTS academia_restrictiva;
CREATE DATABASE academia_restrictiva;
USE academia_restrictiva;

CREATE TABLE profesores(
id_profesor INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(50) NOT NULL,
apellidos VARCHAR(100) NOT NULL,
correo VARCHAR(100)
);

INSERT INTO profesores (nombre, apellidos) VALUES ("Alejando", "Vidal Domínguez");
INSERT INTO profesores (nombre, apellidos) VALUES ("Esther", "Ferreiro Fernández");
INSERT INTO profesores (nombre, apellidos) VALUES ("Gonzalo", "González González");
INSERT INTO profesores (nombre, apellidos) VALUES ("María Isabel", "Posada González");

CREATE TABLE cursos(
id_curso INT AUTO_INCREMENT PRIMARY KEY,
id_profesor INT NOT NULL,
FOREIGN KEY (id_profesor) REFERENCES profesores(id_profesor),
nombre VARCHAR(255) NOT NULL,
numero_plazas INT NOT NULL
);
INSERT INTO cursos (id_profesor, nombre, numero_plazas) VALUES (1, "Bases de datos", 30);
INSERT INTO cursos (id_profesor, nombre, numero_plazas) VALUES (2, "Programación", 30);
INSERT INTO cursos (id_profesor, nombre, numero_plazas) VALUES (3, "Sistemas informáticos", 30);

CREATE TABLE alumnos(
id_alumno INT AUTO_INCREMENT PRIMARY KEY,
id_curso INT NOT NULL,
FOREIGN KEY (id_curso) REFERENCES cursos (id_curso),
nif VARCHAR(20) NOT NULL UNIQUE,
nombre VARCHAR(50) NOT NULL,
apellido1 VARCHAR(100) NOT NULL,
apellido2 VARCHAR(100),
correo VARCHAR(100) NOT NULL,
telefono VARCHAR(20),
direccion VARCHAR(255)
);
INSERT INTO alumnos (id_curso, nif, nombre, apellido1, apellido2, correo, telefono) VALUES (1,"78342424H", "Antonio", "García", "González", "antoniogarciagonzalez@gmail.com", "986435678");
INSERT INTO alumnos (id_curso, nif, nombre, apellido1, apellido2, correo) VALUES (1,"23342426H", "Juan", "López", "González", "juanlopezgonzalez@gmail.com");
INSERT INTO alumnos (id_curso, nif, nombre, apellido1, apellido2, correo, telefono) VALUES (2,"23233458J", "María", "González", "García", "mariagonzalezgarcia@gmail.com", "986435678");
INSERT INTO alumnos (id_curso, nif, nombre, apellido1, apellido2, correo) VALUES (1,"23454594L", "Francisco", "Pérez", "Davila", "franciscoperezdavila@gmail.com");
INSERT INTO alumnos (id_curso, nif, nombre, apellido1, apellido2, correo, telefono) VALUES (2, "34556566M", "Paula", "Salgado", "Díaz", "paulasalgadodiaz@gmail.com", "986435678");
INSERT INTO alumnos (id_curso, nif, nombre, apellido1, apellido2, correo, telefono) VALUES (3, "34565346P", "Julia", "Vázquez", "Rey", "juliavazquezrey@gmail.com", "986435678");
INSERT INTO alumnos (id_curso, nif, nombre, apellido1, correo, telefono) VALUES (1, "43253246T", "Laura", "Molina", "lauramolinagonzalez@gmail.com", "986435678");




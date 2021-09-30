DROP DATABASE IF EXISTS bibliotecas;
CREATE DATABASE bibliotecas;
USE bibliotecas;

CREATE TABLE bibliotecas (
	id_biblioteca INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE libros (
	id_libro INT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    id_biblioteca INT,
    FOREIGN KEY (id_biblioteca) REFERENCES bibliotecas(id_biblioteca)
);


INSERT INTO bibliotecas VALUES (1, "Biblioteca 1");
INSERT INTO bibliotecas VALUES (2, "Biblioteca 2");
INSERT INTO bibliotecas VALUES (3, "Biblioteca 3");
INSERT INTO bibliotecas VALUES (4, "Biblioteca 4");

INSERT INTO libros VALUES (1, "Libro1", 1);
INSERT INTO libros VALUES (2, "Libro2", 2);
INSERT INTO libros VALUES (3, "Libro3", NULL);
INSERT INTO libros VALUES (4, "Libro4", 4);
INSERT INTO libros VALUES (5, "Libro5", 1);


SELECT titulo, nombre AS biblioteca
FROM libros L, bibliotecas B
WHERE L.id_biblioteca = B.id_biblioteca;

SELECT titulo, nombre AS biblioteca
FROM libros L LEFT JOIN bibliotecas B ON L.id_biblioteca = B.id_biblioteca;

SELECT titulo, nombre AS biblioteca
FROM bibliotecas B RIGHT JOIN libros L ON L.id_biblioteca = B.id_biblioteca;

SELECT titulo, nombre AS biblioteca
FROM bibliotecas B LEFT JOIN libros L ON L.id_biblioteca = B.id_biblioteca;

SELECT titulo, nombre AS biblioteca
FROM bibliotecas B LEFT JOIN libros L USING (id_biblioteca);







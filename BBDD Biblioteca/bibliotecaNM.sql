DROP DATABASE IF EXISTS bibliotecas;
CREATE DATABASE bibliotecas;
USE bibliotecas;

CREATE TABLE bibliotecas (
	id_biblioteca INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE libros (
	id_libro INT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL
);

CREATE TABLE libros_biblioteca (
	id_biblioteca INT,
	id_libro INT,
	ejemplares INT NOT NULL, 
	PRIMARY KEY (id_biblioteca, id_libro),
    FOREIGN KEY (id_biblioteca) REFERENCES bibliotecas(id_biblioteca),
    FOREIGN KEY (id_libro) REFERENCES libros(id_libro)
);



INSERT INTO bibliotecas VALUES (1, "Biblioteca 1");
INSERT INTO bibliotecas VALUES (2, "Biblioteca 2");
INSERT INTO bibliotecas VALUES (3, "Biblioteca 3");
INSERT INTO bibliotecas VALUES (4, "Biblioteca 4");

INSERT INTO libros VALUES (1, "Libro1");
INSERT INTO libros VALUES (2, "Libro2");
INSERT INTO libros VALUES (3, "Libro3");
INSERT INTO libros VALUES (4, "Libro4");
INSERT INTO libros VALUES (5, "Libro5");

INSERT INTO libros_biblioteca VALUES (1, 1, 10);
INSERT INTO libros_biblioteca VALUES (1, 2, 4);
INSERT INTO libros_biblioteca VALUES (2, 1, 5);
INSERT INTO libros_biblioteca VALUES (2, 3, 5);
INSERT INTO libros_biblioteca VALUES (2, 4, 5);


SELECT titulo, LB.id_biblioteca, LB.ejemplares
FROM libros L, libros_biblioteca LB
WHERE L.id_libro = LB.id_libro;

SELECT titulo, LB.id_biblioteca, LB.ejemplares
FROM libros L JOIN libros_biblioteca LB ON L.id_libro = LB.id_libro;

SELECT titulo, LB.id_biblioteca, LB.ejemplares
FROM libros L LEFT JOIN libros_biblioteca LB ON L.id_libro = LB.id_libro;

SELECT titulo, LB.id_biblioteca, LB.ejemplares
FROM libros L RIGHT JOIN libros_biblioteca LB ON L.id_libro = LB.id_libro;



SELECT nombre, LB.id_libro, LB.ejemplares
FROM bibliotecas B LEFT JOIN libros_biblioteca LB USING (id_biblioteca);

(
SELECT titulo, B.nombre AS biblioteca, LB.ejemplares
FROM libros L LEFT JOIN libros_biblioteca LB ON L.id_libro = LB.id_libro
	LEFT JOIN bibliotecas B USING (id_biblioteca)
-- )
UNION
(
SELECT titulo, B.nombre AS biblioteca, LB.ejemplares
FROM libros L RIGHT JOIN libros_biblioteca LB ON L.id_libro = LB.id_libro
	RIGHT JOIN bibliotecas B USING (id_biblioteca)
)







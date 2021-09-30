DROP DATABASE IF EXISTS entradas_unipersonales_un_evento;
CREATE DATABASE entradas_unipersonales_un_evento;
USE entradas_unipersonales_un_evento;

CREATE TABLE entradas(
id_entrada INT AUTO_INCREMENT PRIMARY KEY,
zona VARCHAR(50) NOT NULL,
fila INT NOT NULL,
asiento INT NOT NULL
);
INSERT INTO entradas (zona, fila, asiento) VALUES ("A", 1, 1);
INSERT INTO entradas (zona, fila, asiento) VALUES ("A", 1, 2);
INSERT INTO entradas (zona, fila, asiento) VALUES ("A", 1, 3);
INSERT INTO entradas (zona, fila, asiento) VALUES ("A", 1, 4);
INSERT INTO entradas (zona, fila, asiento) VALUES ("A", 1, 5);
INSERT INTO entradas (zona, fila, asiento) VALUES ("A", 1, 6);
INSERT INTO entradas (zona, fila, asiento) VALUES ("A", 1, 7);
INSERT INTO entradas (zona, fila, asiento) VALUES ("A", 1, 8);
INSERT INTO entradas (zona, fila, asiento) VALUES ("A", 1, 9);
INSERT INTO entradas (zona, fila, asiento) VALUES ("A", 1, 10);
INSERT INTO entradas (zona, fila, asiento) VALUES ("A", 1, 11);
INSERT INTO entradas (zona, fila, asiento) VALUES ("A", 1, 12);
INSERT INTO entradas (zona, fila, asiento) VALUES ("A", 1, 13);
INSERT INTO entradas (zona, fila, asiento) VALUES ("A", 1, 14);
INSERT INTO entradas (zona, fila, asiento) VALUES ("A", 1, 15);
INSERT INTO entradas (zona, fila, asiento) VALUES ("A", 1, 16);
INSERT INTO entradas (zona, fila, asiento) VALUES ("A", 1, 17);
INSERT INTO entradas (zona, fila, asiento) VALUES ("A", 1, 18);
INSERT INTO entradas (zona, fila, asiento) VALUES ("A", 1, 19);
INSERT INTO entradas (zona, fila, asiento) VALUES ("A", 1, 20);
INSERT INTO entradas (zona, fila, asiento) VALUES ("A", 2, 1);
INSERT INTO entradas (zona, fila, asiento) VALUES ("A", 2, 2);
INSERT INTO entradas (zona, fila, asiento) VALUES ("A", 2, 3);

CREATE TABLE clientes(
nif VARCHAR(20) NOT NULL PRIMARY KEY,
id_entrada INT UNIQUE NOT NULL,
FOREIGN KEY (id_entrada) REFERENCES entradas(id_entrada),
nombre VARCHAR(50) NOT NULL,
apellido1 VARCHAR(100) NOT NULL,
apellido2 VARCHAR(100),
correo VARCHAR(100) NOT NULL,
telefono VARCHAR(20)
);
INSERT INTO clientes (id_entrada, nif, nombre, apellido1, apellido2, correo, telefono) VALUES (20, "78342424H", "Antonio", "García", "González", "antoniogarciagonzalez@gmail.com", "986435678");
INSERT INTO clientes (id_entrada, nif, nombre, apellido1, apellido2, correo) VALUES (21, "23342426H", "Juan", "López", "González", "juanlopezgonzalez@gmail.com");
INSERT INTO clientes (id_entrada, nif, nombre, apellido1, apellido2, correo, telefono) VALUES (22, "23233458J", "María", "González", "García", "mariagonzalezgarcia@gmail.com", "986435678");
INSERT INTO clientes (id_entrada, nif, nombre, apellido1, apellido2, correo) VALUES (23, "23454594L", "Francisco", "Pérez", "Davila", "franciscoperezdavila@gmail.com");
INSERT INTO clientes (id_entrada, nif, nombre, apellido1, apellido2, correo, telefono) VALUES (10, "34556566M", "Paula", "Salgado", "Díaz", "paulasalgadodiaz@gmail.com", "986435678");
INSERT INTO clientes (id_entrada, nif, nombre, apellido1, apellido2, correo, telefono) VALUES (11, "34565346P", "Julia", "Vázquez", "Rey", "juliavazquezrey@gmail.com", "986435678");
INSERT INTO clientes (id_entrada, nif, nombre, apellido1, correo, telefono) VALUES (2, "43253246T", "Laura", "Molina", "lauramolinagonzalez@gmail.com", "986435678");



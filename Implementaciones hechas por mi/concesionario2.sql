DROP DATABASE IF EXISTS concesionario2;
CREATE DATABASE concesionario2;
USE concesionario2;

CREATE TABLE clientes(
id_cliente INT AUTO_INCREMENT PRIMARY KEY,
nif VARCHAR(255) NOT NULL UNIQUE,
nombre VARCHAR(255) NOT NULL,
apellido1 VARCHAR(255) NOT NULL,
apellido2 VARCHAR(255)
);
INSERT INTO clientes (nif, nombre, apellido1, apellido2) VALUES ("23342426H", "Juan", "López", "González");
INSERT INTO clientes (nif, nombre, apellido1, apellido2) VALUES ("23233458J", "María", "González", "García");
INSERT INTO clientes (nif, nombre, apellido1, apellido2) VALUES ("23454594L", "Francisco", "Pérez", "Davila");
INSERT INTO clientes (nif, nombre, apellido1, apellido2) VALUES ("34556566M", "Paula", "Salgado", "Díaz");
INSERT INTO clientes (nif, nombre, apellido1, apellido2) VALUES ("34565346P", "Julia", "Vázquez", "Rey");
INSERT INTO clientes (nif, nombre, apellido1) VALUES ("43253246T", "Laura", "Molina");

CREATE TABLE productos(
fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
bastidor CHAR(17) NOT NULL PRIMARY KEY,
descripcion VARCHAR(255) NOT NULL,
id_cliente INT ,
FOREIGN KEY (id_cliente) REFERENCES clinetes (id_cliente)
);
INSERT INTO productos (bastidor, descripcion, id_cliente) VALUES ("12345678910111213", "C1", 1);
INSERT INTO productos (bastidor, descripcion, id_cliente) VALUES ("12345678910111214", "C1", 3);
INSERT INTO productos (bastidor, descripcion, id_cliente ) VALUES ("12345678910111215", "C1", 6);
INSERT INTO productos (bastidor, descripcion) VALUES ("12345678910111216", "C1");
INSERT INTO productos (bastidor, descripcion) VALUES ("12345678910111217", "C1");
INSERT INTO productos (bastidor, descripcion, id_cliente) VALUES ("12345678910111218", "C3", 2);
INSERT INTO productos (bastidor, descripcion) VALUES ("12345678910111219", "C3");
INSERT INTO productos (bastidor, descripcion) VALUES ("12345678910111220", "C3");
INSERT INTO productos (bastidor, descripcion, id_cliente) VALUES ("12345678910111221", "C4", 4);
INSERT INTO productos (bastidor, descripcion, id_cliente) VALUES ("12345678910111222", "C4", 5);
INSERT INTO productos (bastidor, descripcion, id_cliente) VALUES ("12345678910111223", "C4 CACTUS", 1);
INSERT INTO productos (bastidor, descripcion, id_cliente) VALUES ("12345678910111224", "C4 CACTUS", 3);
INSERT INTO productos (bastidor, descripcion) VALUES ("12345678910111225", "C4 CACTUS");
INSERT INTO productos (bastidor, descripcion) VALUES ("12345678910111226", "C4 CACTUS");




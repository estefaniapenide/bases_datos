DROP DATABASE IF EXISTS concesionario;
CREATE DATABASE concesionario;
USE concesionario;

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
bastidor CHAR(17) NOT NULL PRIMARY KEY,
descripcion VARCHAR(255) NOT NULL
);
INSERT INTO productos (bastidor, descripcion) VALUES ("12345678910111213", "C1");
INSERT INTO productos (bastidor, descripcion) VALUES ("12345678910111214", "C1");
INSERT INTO productos (bastidor, descripcion) VALUES ("12345678910111215", "C1");
INSERT INTO productos (bastidor, descripcion) VALUES ("12345678910111216", "C1");
INSERT INTO productos (bastidor, descripcion) VALUES ("12345678910111217", "C1");
INSERT INTO productos (bastidor, descripcion) VALUES ("12345678910111218", "C3");
INSERT INTO productos (bastidor, descripcion) VALUES ("12345678910111219", "C3");
INSERT INTO productos (bastidor, descripcion) VALUES ("12345678910111220", "C3");
INSERT INTO productos (bastidor, descripcion) VALUES ("12345678910111221", "C4");
INSERT INTO productos (bastidor, descripcion) VALUES ("12345678910111222", "C4");
INSERT INTO productos (bastidor, descripcion) VALUES ("12345678910111223", "C4 CACTUS");
INSERT INTO productos (bastidor, descripcion) VALUES ("12345678910111224", "C4 CACTUS");
INSERT INTO productos (bastidor, descripcion) VALUES ("12345678910111225", "C4 CACTUS");
INSERT INTO productos (bastidor, descripcion) VALUES ("12345678910111226", "C4 CACTUS");

CREATE TABLE pedidos(
id_pedido INT AUTO_INCREMENT PRIMARY KEY,
fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
id_cliente INT NOT NULL,
bastidor CHAR(17) NOT NULL,
FOREIGN KEY (id_cliente) REFERENCES clientes (id_cliente),
FOREIGN KEY (bastidor) REFERENCES productos (bastidor)
);
INSERT INTO pedidos (id_cliente, bastidor) VALUES (1, "12345678910111214");
INSERT INTO pedidos (id_cliente, bastidor) VALUES (2, "12345678910111218");
INSERT INTO pedidos (id_cliente, bastidor) VALUES (3, "12345678910111213");
INSERT INTO pedidos (id_cliente, bastidor) VALUES (4, "12345678910111222");
INSERT INTO pedidos (id_cliente, bastidor) VALUES (5, "12345678910111215");
INSERT INTO pedidos (id_cliente, bastidor) VALUES (6, "12345678910111217");
INSERT INTO pedidos (id_cliente, bastidor) VALUES (6, "12345678910111226");


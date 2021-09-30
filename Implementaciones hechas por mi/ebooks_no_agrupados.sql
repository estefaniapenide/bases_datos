DROP DATABASE IF EXISTS ebooks_no_agrupados;
CREATE DATABASE ebooks_no_agrupados;
USE ebooks_no_agrupados;

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
id_producto INT AUTO_INCREMENT PRIMARY KEY,
titulo VARCHAR(255) NOT NULL,
descripcion VARCHAR(255)
);
INSERT INTO productos (titulo, descripcion) VALUES ("El señor de los anillos. Las comunidad del anillo","Primra parte trilogía El Señor de los anillos.");
INSERT INTO productos (titulo, descripcion) VALUES ("El señor de los anillos. Las dos torres","Segunda parte trilogía El Señor de los anillos.");
INSERT INTO productos (titulo, descripcion) VALUES ("El señor de los anillos. El retorno del rey","Tercera parte trilogía El Señor de los anillos.");
INSERT INTO productos (titulo) VALUES ("Grandes esperanzas");
INSERT INTO productos (titulo) VALUES ("Ulises");
INSERT INTO productos (titulo, descripcion) VALUES ("Mrs Dalloway","Versión en inglés");
INSERT INTO productos (titulo) VALUES ("El retrato de Dorian Gray");
INSERT INTO productos (titulo) VALUES ("Cien años de soledad");
INSERT INTO productos (titulo) VALUES ("La campana de cristal");
INSERT INTO productos (titulo, descripcion) VALUES ("The spire","Versión en inglés");
INSERT INTO productos (titulo, descripcion) VALUES ("The man in the high castle","Versión en inglés");
INSERT INTO productos (titulo) VALUES ("Dune");
INSERT INTO productos (titulo) VALUES ("Los Simpson y las matemáticas");
INSERT INTO productos (titulo) VALUES ("La fundación");
INSERT INTO productos (titulo) VALUES ("1984");

CREATE TABLE pedidos(
id_pedido INT AUTO_INCREMENT PRIMARY KEY,
fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
id_cliente INT NOT NULL, 
id_producto INT NOT NULL,
FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);
INSERT INTO pedidos (id_cliente, id_producto) VALUES (1, 15);
INSERT INTO pedidos (id_cliente, id_producto) VALUES (2, 12);
INSERT INTO pedidos (id_cliente, id_producto) VALUES (3, 5);
INSERT INTO pedidos (id_cliente, id_producto) VALUES (4, 6);
INSERT INTO pedidos (id_cliente, id_producto) VALUES (5, 8);
INSERT INTO pedidos (id_cliente, id_producto) VALUES (2, 8);
INSERT INTO pedidos (id_cliente, id_producto) VALUES (4, 10);
INSERT INTO pedidos (id_cliente, id_producto) VALUES (3, 13);




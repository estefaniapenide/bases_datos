DROP DATABASE IF EXISTS libros_agrupados;
CREATE DATABASE libros_agrupados;
USE libros_agrupados;

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
descripcion VARCHAR(255),
stock INT
);
INSERT INTO productos (titulo, descripcion, stock) VALUES ("El señor de los anillos. Las comunidad del anillo","Primra parte trilogía El Señor de los anillos.", 7);
INSERT INTO productos (titulo, descripcion, stock) VALUES ("El señor de los anillos. Las dos torres","Segunda parte trilogía El Señor de los anillos.", 7);
INSERT INTO productos (titulo, descripcion, stock) VALUES ("El señor de los anillos. El retorno del rey","Tercera parte trilogía El Señor de los anillos.", 7);
INSERT INTO productos (titulo, stock) VALUES ("Grandes esperanzas", 7);
INSERT INTO productos (titulo, stock) VALUES ("Ulises", 7);
INSERT INTO productos (titulo, descripcion, stock) VALUES ("Mrs Dalloway","Versión en inglés", 7);
INSERT INTO productos (titulo, stock) VALUES ("El retrato de Dorian Gray", 7);
INSERT INTO productos (titulo, stock) VALUES ("Cien años de soledad", 7);
INSERT INTO productos (titulo, stock) VALUES ("La campana de cristal", 7);
INSERT INTO productos (titulo, descripcion, stock) VALUES ("The spire","Versión en inglés", 7);
INSERT INTO productos (titulo, descripcion, stock) VALUES ("The man in the high castle","Versión en inglés", 7);
INSERT INTO productos (titulo, stock) VALUES ("Dune", 7);
INSERT INTO productos (titulo, stock) VALUES ("Los Simpson y las matemáticas", 7);
INSERT INTO productos (titulo, stock) VALUES ("La fundación", 7);
INSERT INTO productos (titulo, stock) VALUES ("1984", 7);

CREATE TABLE pedidos(
id_pedido INT AUTO_INCREMENT PRIMARY KEY,
fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
id_cliente INT NOT NULL, 
FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);
INSERT INTO pedidos (id_cliente) VALUES (1);
INSERT INTO pedidos (id_cliente) VALUES (2);
INSERT INTO pedidos (id_cliente) VALUES (3);
INSERT INTO pedidos (id_cliente) VALUES (4);
INSERT INTO pedidos (id_cliente) VALUES (5);
INSERT INTO pedidos (id_cliente) VALUES (2);
INSERT INTO pedidos (id_cliente) VALUES (4);
INSERT INTO pedidos (id_cliente) VALUES (3);

CREATE TABLE productos_pedidos (
id_pedido INT NOT NULL,
id_producto INT NOT NULL,
cantidad INT,
FOREIGN KEY (id_pedido) REFERENCES pedidos (id_pedido),
FOREIGN KEY (id_producto) REFERENCES productos (id_producto),
PRIMARY KEY (id_pedido, id_producto)
);
INSERT INTO productos_pedidos (id_pedido, id_producto, cantidad) VALUES (1, 4, 2);
INSERT INTO productos_pedidos (id_pedido, id_producto, cantidad) VALUES (1, 12, 3);
INSERT INTO productos_pedidos (id_pedido, id_producto) VALUES (1, 5);
INSERT INTO productos_pedidos (id_pedido, id_producto) VALUES (2, 9);
INSERT INTO productos_pedidos (id_pedido, id_producto) VALUES (2, 10);
INSERT INTO productos_pedidos (id_pedido, id_producto, cantidad) VALUES (3, 13, 1);
INSERT INTO productos_pedidos (id_pedido, id_producto) VALUES (4, 4);
INSERT INTO productos_pedidos (id_pedido, id_producto) VALUES (5, 10);
INSERT INTO productos_pedidos (id_pedido, id_producto) VALUES (5, 7);
INSERT INTO productos_pedidos (id_pedido, id_producto) VALUES (5, 12);
INSERT INTO productos_pedidos (id_pedido, id_producto) VALUES (6, 1);
INSERT INTO productos_pedidos (id_pedido, id_producto) VALUES (6, 2);
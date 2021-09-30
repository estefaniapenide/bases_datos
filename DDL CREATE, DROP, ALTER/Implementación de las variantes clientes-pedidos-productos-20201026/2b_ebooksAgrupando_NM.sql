-- Tienda de ebooks que sí permite agrupar varios libros en un pedido (interrelación N:M)

DROP DATABASE IF EXISTS pedidos_2b_ebooksAgrupando_NM;
CREATE DATABASE pedidos_2b_ebooksAgrupando_NM;
USE pedidos_2b_ebooksAgrupando_NM;

CREATE TABLE clientes (
	id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    apellidos VARCHAR(255) NOT NULL,
    nif VARCHAR(20) NOT NULL UNIQUE -- identificador altenativo
);

INSERT INTO clientes (nombre, apellidos, nif) VALUES ("Alejandro", "Vidal Domínguez", "11222333-A");
INSERT INTO clientes (nombre, apellidos, nif) VALUES ("Pepe", "Pérez", "33222333A");
INSERT INTO clientes (nombre, apellidos, nif) VALUES ("María", "Rodríguez", "44222333A");
INSERT INTO clientes (nombre, apellidos, nif) VALUES ("Alejandro", "Vidal Domínguez", "11222333A");

CREATE TABLE productos (
	id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT -- Tipo para textos muy largos que no caben en un char o varchar
);

INSERT INTO productos (nombre, descripcion) VALUES ("La insoportable levedad del ser", "Cosas existenciales en la primavera de praga");
INSERT INTO productos (nombre) VALUES ("Cien años de soledad");
INSERT INTO productos (nombre) VALUES ("Rayuela");

CREATE TABLE pedidos (
	id INT AUTO_INCREMENT PRIMARY KEY,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Valor por defecto: el timestamp del momento del INSERT
    id_cliente INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id)
);

INSERT INTO pedidos (id_cliente, timestamp) VALUES (1,"2020-10-09"); -- El cliente 1 realiza el pedido 1
INSERT INTO pedidos (id_cliente, timestamp) VALUES (1,"2020-10-09 10:30"); -- El cliente 1 realiza el pedido 2
INSERT INTO pedidos (id_cliente) VALUES (2); -- El cliente 2 realiza el pedido 3

CREATE TABLE productos_pedido ( -- Tabla asociativa (débil) correspondiente a la relación N:M
	id_pedido INT NOT NULL,
    id_producto INT NOT NULL, -- Las dos FK son obligatorias
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id)
		ON DELETE CASCADE, -- Regla de integridad referencial: si eliminamos un pedido, eliminamos todos los registros de productos que van en ese pedido (debilidad)
    FOREIGN KEY (id_producto) REFERENCES productos(id),
    PRIMARY KEY (id_pedido, id_producto) -- PK compuesta por las 2 FK, de modo que no se puede repetir el mismo producto en el mismo pedido
);

INSERT INTO productos_pedido (id_pedido, id_producto) VALUES (1,1); -- El pedido 1 contiene el libro 1
INSERT INTO productos_pedido (id_pedido, id_producto) VALUES (1,2); -- El pedido 1 contiene el libro 2
INSERT INTO productos_pedido (id_pedido, id_producto) VALUES (2,2); -- El pedido 2 contiene el libro 2
    
    
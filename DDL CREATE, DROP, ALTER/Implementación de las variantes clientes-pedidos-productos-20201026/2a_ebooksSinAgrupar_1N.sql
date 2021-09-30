-- Tienda de ebooks que no permite agrupar varios libros en un pedido (interrelación 1:N)

DROP DATABASE IF EXISTS pedidos_2a_ebooksSinAgrupar_1N;
CREATE DATABASE pedidos_2a_ebooksSinAgrupar_1N;
USE pedidos_2a_ebooksSinAgrupar_1N;

CREATE TABLE clientes (
	id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    apellidos VARCHAR(255) NOT NULL,
    nif VARCHAR(20) NOT NULL UNIQUE -- identificador altenativo (indice UNIQUE)
);

INSERT INTO clientes (nombre, apellidos, nif) VALUES ("Alejandro", "Vidal Domínguez", "11222333-A");
INSERT INTO clientes (nombre, apellidos, nif) VALUES ("Pepe", "Pérez", "33222333A");
INSERT INTO clientes (nombre, apellidos, nif) VALUES ("María", "Rodríguez", "44222333A");
INSERT INTO clientes (nombre, apellidos, nif) VALUES ("Alejandro", "Vidal Domínguez", "11222333A"); -- Conflicto por robustez de formato de DNI

CREATE TABLE productos (
	id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion VARCHAR(16126) -- NULL -- Atributo opcional
);

INSERT INTO productos (nombre, descripcion) VALUES ("La insoportable levedad del ser", "Cosas existenciales en la primavera de praga");
INSERT INTO productos (nombre) VALUES ("Cien años de soledad"); -- No se añade descripción ya que al ser opcional será NULL por defecto
INSERT INTO productos (nombre) VALUES ("Rayuela");

CREATE TABLE pedidos (
	id INT AUTO_INCREMENT PRIMARY KEY,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Valor por defecto: el timestamp del momento del INSERT
    id_cliente INT NOT NULL,
    id_producto INT NOT NULL,  -- Ambas FK son NOT NULL porque las cardinalidades mínimas de cliente y producto son 1
    FOREIGN KEY (id_cliente) REFERENCES clientes(id),
    FOREIGN KEY (id_producto) REFERENCES productos(id)
);

INSERT INTO pedidos (id_cliente, id_producto, timestamp) VALUES (1,1,"2020-10-09"); -- El cliente 1 compra el libro 1
INSERT INTO pedidos (id_cliente, id_producto, timestamp) VALUES (1,2,"2020-10-09 10:30"); -- El cliente 1 compra el libro 2
INSERT INTO pedidos (id_cliente, id_producto) VALUES (2,1); -- El cliente 2 compra el libro 1 -- No se añade el timestamp ya que toma valor por defecto


/*******************************************************************************************************************************
* Variante (interrelación N:M)
* - No es necesario almacenar un identificador propio de pedido.
* - Un mismo cliente no puede comprar el mismo producto más de una vez (mantenemos registrado que ya lo compró y 
* por tanto mantiene su licencia de por vida), y especialmente si quisiésemos asegurarnos de restringir que no se pueda dar.
*/

DROP DATABASE IF EXISTS pedidos_2a_NM;
CREATE DATABASE pedidos_2a_NM;
USE pedidos_2a_NM;

CREATE TABLE clientes (
	id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    apellidos VARCHAR(255) NOT NULL,
    nif VARCHAR(20) NOT NULL UNIQUE -- identificador altenativo (indice UNIQUE)
);

INSERT INTO clientes (nombre, apellidos, nif) VALUES ("Alejandro", "Vidal Domínguez", "11222333-A");
INSERT INTO clientes (nombre, apellidos, nif) VALUES ("Pepe", "Pérez", "33222333A");
INSERT INTO clientes (nombre, apellidos, nif) VALUES ("María", "Rodríguez", "44222333A");
INSERT INTO clientes (nombre, apellidos, nif) VALUES ("Alejandro", "Vidal Domínguez", "11222333A"); -- Conflicto por robustez de formato de DNI

CREATE TABLE productos (
	id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion VARCHAR(16126) -- NULL -- Atributo opcional
);

INSERT INTO productos (nombre, descripcion) VALUES ("La insoportable levedad del ser", "Cosas existenciales en la primavera de praga");
INSERT INTO productos (nombre) VALUES ("Cien años de soledad"); -- No se añade descripción ya que al ser opcional será NULL por defecto
INSERT INTO productos (nombre) VALUES ("Rayuela");

CREATE TABLE pedidos ( -- Ahora pedidos es la tabla asociativa que mantiene la relación N:M entre clientes y productos, no tiene una PK por si sola
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Valor por defecto: el timestamp del momento del INSERT
    id_cliente INT NOT NULL,
    id_producto INT NOT NULL,  -- Ambas FK son NOT NULL porque las cardinalidades mínimas de cliente y producto son 1
    FOREIGN KEY (id_cliente) REFERENCES clientes(id),
    FOREIGN KEY (id_producto) REFERENCES productos(id),
    PRIMARY KEY (id_cliente, id_producto) /* Cada pedido queda identificado por el cliente y el producto, de modo que el mismo cliente 
			no puede comprar el mismo producto dos veces */
); -- Solo han cambiado 2 líneas de la tabla pedidos

INSERT INTO pedidos (id_cliente, id_producto, timestamp) VALUES (1,1,"2020-10-09"); -- El cliente 1 compra el libro 1
INSERT INTO pedidos (id_cliente, id_producto, timestamp) VALUES (1,2,"2020-10-09 10:30"); -- El cliente 1 compra el libro 2
INSERT INTO pedidos (id_cliente, id_producto) VALUES (2,1); -- El cliente 2 compra el libro 1 -- No se añade el timestamp ya que toma valor por defecto



	
    
    
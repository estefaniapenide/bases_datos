/**
* Concesionario local de coches clásicos (Relación 1:1)
* TODO: Ejercicio interesante para ampliar y trabajar procedimental, especialmente la versión alternativa
*/

DROP DATABASE IF EXISTS pedidos_2d_coches_11;
CREATE DATABASE pedidos_2d_coches_11;
USE pedidos_2d_coches_11;

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
	bastidor CHAR(17) PRIMARY KEY,
    descripcion VARCHAR(255) NOT NULL
);

INSERT INTO productos (bastidor, descripcion) VALUES ("VSSZZZ1MZ2R040807", "MERCEDES-BENZ - SL 500 - 1992");
INSERT INTO productos VALUES ("VSSZZZ6KZ1R149943", "DAIMLER - SOVEREIGN - 1968");
INSERT INTO productos  VALUES ("VSSZZZ6KZ1R149555", "VOLKSWAGEN - KOMBI T1 - 1975");

CREATE TABLE pedidos (
	id INT AUTO_INCREMENT PRIMARY KEY,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Valor por defecto: el timestamp del momento del INSERT
    id_cliente INT NOT NULL,
    bastidor CHAR(17) NOT NULL,  
    FOREIGN KEY (id_cliente) REFERENCES clientes(id),
    FOREIGN KEY (bastidor) REFERENCES productos(bastidor) /* Esta conversión es como una 1:N. Para garantizar que el mismo producto no
		pueda estar en varios pedidos serían necesarias modificaciones */
);
/* En relaciones 1:1 hay varias soluciones de conversión a modelo lógico. Cuando hay una cardinalidad mínima 0 de un lado y 1 del otro, 
es mejor pasar al lado donde está el mínimo 0 (referencia obligatoria o NOT NULL), ya que esa columna siempre tendrá valores (un pedido
solo se registra cuando se ha realizado y por tanto hay un coche asignado a dicho pedido), mientras que haciéndolo al revés tendríamos
una tabla de productos con una FK pedido que estaría a null para todos los productos aún no vendidos. */

INSERT INTO pedidos (id_cliente, bastidor) VALUES (1,"VSSZZZ1MZ2R040807"); -- Pedido 1: El cliente 1 compra el coche 1
INSERT INTO pedidos (id_cliente, bastidor) VALUES (1,"VSSZZZ6KZ1R149943"); -- Pedido 2: El cliente 1 compra el coche 2
INSERT INTO pedidos (id_cliente, bastidor) VALUES (2,"VSSZZZ6KZ1R149555"); -- Pedido 3: El cliente 2 compra el coche 3

-- Problema 1: Garantizar que el mismo coche no aparezca en varios pedidos (TODO: Soluciones - Histórico // Procedimentales)
-- Problema 2: Consultar de modo cómodo coches ya vendidos y coches en stock


/*********************************************************************************
******* ALTERNATIVA:
(Facilita las consultas pero mantiene una base de datos con muchos valores nulos)
**********************************************************************************/

DROP DATABASE IF EXISTS pedidos_2d_simplificado;
CREATE DATABASE pedidos_2d_simplificado;
USE pedidos_2d_simplificado;

CREATE TABLE clientes (
	id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    apellidos VARCHAR(255) NOT NULL,
    nif VARCHAR(20) NOT NULL UNIQUE -- identificador altenativo
);

CREATE TABLE productos (
	bastidor CHAR(17) PRIMARY KEY,
    descripcion VARCHAR(255) NOT NULL,
    comprador INT, -- Tiene que poder ser null (valor por defecto; mientras no se han vendido)
    fecha TIMESTAMP DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP, -- TODO: ¿Hacerlo con DATE?
    -- fecha DATE DEFAULT NULL ON UPDATE curdate(),
    FOREIGN KEY (comprador) REFERENCES clientes(id)
);

INSERT INTO productos (bastidor, descripcion) VALUES ("VSSZZZ1MZ2R040807", "MERCEDES-BENZ - SL 500 - 1992");
INSERT INTO productos (bastidor, descripcion) VALUES ("VSSZZZ6KZ1R149943", "DAIMLER - SOVEREIGN - 1968");
INSERT INTO productos (bastidor, descripcion) VALUES ("VSSZZZ6KZ1R149555", "VOLKSWAGEN - KOMBI T1 - 1975");
-- Cuando se introducen los coches, el comprador está a NULL. Se modificará la tabla cuando se vendan

INSERT INTO clientes (nombre, apellidos, nif) VALUES ("Alejandro", "Vidal Domínguez", "11222333-A");
UPDATE productos SET comprador=1 WHERE bastidor="VSSZZZ1MZ2R040807";  -- El cliente 1 compra el primer coche
UPDATE productos SET comprador=1 WHERE bastidor="VSSZZZ6KZ1R149943";  -- El cliente 1 compra el segundo coche

INSERT INTO clientes (nombre, apellidos, nif) VALUES ("Pepe", "Pérez", "33222333A");
UPDATE productos SET comprador=2 WHERE bastidor="VSSZZZ6KZ1R149555";  -- El cliente 2 compra el tercer coche




    
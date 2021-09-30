DROP DATABASE IF EXISTS elva;
CREATE DATABASE elva;
USE elva;

CREATE TABLE clientes (
	cod_cliente INT UNSIGNED PRIMARY KEY,
    nombre VARCHAR(255) UNIQUE NOT NULL,
    nombre_comercial VARCHAR(255) UNIQUE
);

INSERT INTO clientes VALUES
	("000001", "empresa1", "Empresa1"),
    ("000002", "empresa2", "Empresa2"),
    ("00003", "empresa3", "Empresa3"),
    (000004, "empresa4", "Empresa4"),
    (5, "empresa5", "Empresa5"),
    ("000006", "empresa6", "Empresa6"),
    ("000007", "empresa7", "Empresa7");


CREATE VIEW vista_clientes AS
SELECT LPAD(cod_cliente, 6, '0') AS cod_cliente, nombre, nombre_comercial 
FROM clientes;

    
CREATE TABLE facturas (
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    num SMALLINT UNSIGNED NOT NULL, -- UNIQUE ?
    fecha_factura DATE NOT NULL,
    tipo_factura ENUM('A','D') NOT NULL,
    importe DECIMAL(7,2) NOT NULL,
    cliente INT UNSIGNED NOT NULL,
    FOREIGN KEY (cliente) REFERENCES clientes(cod_cliente)
);
/* Restriccion: el mismo num de factura no se repite dentro del mismo año */
/* Cuanto tipo_factura='D', importe debe ser negativo (y viceversa) */



INSERT INTO facturas VALUES (1, 1, "2019-01-19", 'A', 1000.11, 1);
INSERT INTO facturas VALUES (2, 1, "2019-02-18", 'D', -2000.11, 2); 
INSERT INTO facturas VALUES (3, 3, "2019-03-19", 'A', 3000.11, 3);
INSERT INTO facturas VALUES (4, 4, "2019-04-19", 'D', -4000.11, 4);
INSERT INTO facturas VALUES (5, 5, "2019-05-19", 'A', 5000.11, 5);
INSERT INTO facturas VALUES (6, 1, "2020-01-19", 'A', 1000.11, 6);
INSERT INTO facturas VALUES (7, 2, "2020-02-19", 'D', -200.11, 7);
INSERT INTO facturas VALUES (8, 3, "2020-03-19", 'A', 3000.11, 1);


CREATE TABLE pagos (
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    fecha_pago DATE NOT NULL,
    importe DECIMAL(7,2) NOT NULL,
    cliente INT UNSIGNED NOT NULL,
    FOREIGN KEY (cliente) REFERENCES clientes(cod_cliente)
);

INSERT INTO pagos VALUES (1, "2019-01-25", 500, 1);
INSERT INTO pagos VALUES (2, "2019-02-25", 1500, 2);
INSERT INTO pagos VALUES (3, "2019-03-25", 2500, 3);
INSERT INTO pagos VALUES (4, "2019-04-25", 800, 4);
INSERT INTO pagos VALUES (5, "2019-05-25", 500, 5);
INSERT INTO pagos VALUES (6, "2020-01-25", 500, 6);
INSERT INTO pagos VALUES (7, "2020-01-26", 800, 7);
INSERT INTO pagos VALUES (8, "2020-01-28", 500, 1);
INSERT INTO pagos VALUES (9, "2020-02-25", 900, 1);
INSERT INTO pagos VALUES (10,"2020-03-25", 1200, 2);
INSERT INTO pagos VALUES (11,"2020-04-25", 500, 2);



/* Restricción: la fecha de una devolución de un 
pago ha de ser posterior a la fecha del pago */

CREATE TABLE devoluciones_pagos (
    id_pago INT UNSIGNED PRIMARY KEY, 
    fecha_devolucion DATE NOT NULL,
    gastos DECIMAL(7,2) NOT NULL,
    FOREIGN KEY (id_pago) REFERENCES pagos(id)
);

INSERT INTO devoluciones_pagos VALUES (1, "2019-01-27", 10);
INSERT INTO devoluciones_pagos VALUES (2, "2019-02-28", 30);
INSERT INTO devoluciones_pagos VALUES (3, "2019-03-28", 40);


    
    
	
    

    
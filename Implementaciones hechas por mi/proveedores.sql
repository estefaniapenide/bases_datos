DROP DATABASE IF EXISTS proveedores;
CREATE DATABASE proveedores;
USE proveedores;

CREATE TABLE proveedores(
cod_proveedor INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(50) NOT NULL,
direccion VARCHAR(100),
ciudad VARCHAR(50) NOT NULL,
provincia VARCHAR(50)
);
INSERT INTO proveedores (nombre, direccion, ciudad, provincia) VALUES ("wfefe", "asdwddcd", "Vigo", "Pontevedra");
INSERT INTO proveedores (nombre, direccion, ciudad, provincia) VALUES ("sadfds", "cxvz", "Vigo", "Pontevedra");
INSERT INTO proveedores (nombre, direccion, ciudad, provincia) VALUES ("dsvd", "xzc ", "Monforte de Lemos", "Lugo");
INSERT INTO proveedores (nombre, direccion, ciudad, provincia) VALUES ("dsvdc", "dsvcv", "Pontevedra", "Pontevedra");
INSERT INTO proveedores (nombre, direccion, ciudad, provincia) VALUES ("dsvd", "cxvxv", "Burela", "Lugo");
INSERT INTO proveedores (nombre, direccion, ciudad, provincia) VALUES ("vdvfdf", "cvdvd", "Santiago de Compostela", "A Coruña");
INSERT INTO proveedores (nombre, direccion, ciudad, provincia) VALUES ("vdbsfd", "cxvdv", "Ourense", "Ourense");

CREATE TABLE categorias(
cod_categoria INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL
);
INSERT INTO categorias (nombre) VALUES ("planas");
INSERT INTO categorias (nombre) VALUES ("esféricas");
INSERT INTO categorias (nombre) VALUES ("cónicas");

CREATE TABLE piezas(
cod_pieza INT AUTO_INCREMENT PRIMARY KEY,
cod_categoria INT NOT NULL,
FOREIGN KEY (cod_categoria) REFERENCES categorias (cod_categoria),
nombre VARCHAR(50) NOT NULL,
color VARCHAR(50) NOT NULL,
precio INT NOT NULL
);
INSERT INTO piezas (cod_categoria, nombre, color, precio) VALUES (1, "ASDASD", "plateado", 12);
INSERT INTO piezas (cod_categoria, nombre, color, precio) VALUES (2, "dsfdd", "negra", 13);
INSERT INTO piezas (cod_categoria, nombre, color, precio) VALUES (3, "SDFDFD", "azul", 11);
INSERT INTO piezas (cod_categoria, nombre, color, precio) VALUES (1, "saddfd", "marron", 15);
INSERT INTO piezas (cod_categoria, nombre, color, precio) VALUES (2, "DFVFV", "negra", 23);
INSERT INTO piezas (cod_categoria, nombre, color, precio) VALUES (3, "sfdgtrh", "negra", 16);
INSERT INTO piezas (cod_categoria, nombre, color, precio) VALUES (3, "SERGBF", "plateada", 14);

CREATE TABLE proveedores_piezas(
fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
cod_proveedor INT NOT NULL,
cod_pieza INT NOT NULL,
FOREIGN KEY (cod_proveedor) REFERENCES proveedores(cod_proveedor),
FOREIGN KEY (cod_pieza) REFERENCES piezas(cod_pieza),
PRIMARY KEY(fecha, cod_proveedor, cod_pieza),
cantidad INT NOT NULL
);
INSERT INTO proveedores_piezas (cod_proveedor, cod_pieza, cantidad) VALUES (2,6,12);
INSERT INTO proveedores_piezas (cod_proveedor, cod_pieza, cantidad) VALUES (7,7,34);
INSERT INTO proveedores_piezas (cod_proveedor, cod_pieza, cantidad) VALUES (6,2,25);
INSERT INTO proveedores_piezas (cod_proveedor, cod_pieza, cantidad) VALUES (3,5,11);
INSERT INTO proveedores_piezas (cod_proveedor, cod_pieza, cantidad) VALUES (4,3,23);
INSERT INTO proveedores_piezas (cod_proveedor, cod_pieza, cantidad) VALUES (1,5,45);



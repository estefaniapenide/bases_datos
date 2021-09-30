DROP DATABASE IF EXISTS ejercicio_examen_empresa;
CREATE SCHEMA ejercicio_examen_empresa;
USE ejercicio_examen_empresa;

CREATE TABLE sedes(
id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
superficie INT UNSIGNED NOT NULL,
direccion VARCHAR(200) NOT NULL,
localidad VARCHAR(200) NOT NULL,
provincia VARCHAR(40) NOT NULL,
telefono1 BIGINT NOT NULL,
telefono2 BIGINT
);

CREATE TABLE dep_sedes(
dep SMALLINT UNSIGNED,
sede SMALLINT UNSIGNED,
PRIMARY KEY (dep, sede)
);

CREATE TABLE  departamentos(
id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(200) NOT NULL,
fcreacion DATE NOT NULL,
prima DECIMAL(8,2) NOT NULL,
director CHAR(10) /*Dejamos que sea null para que no de problemas cuando colocamos las inserciones
 después de las alteraciones de las tablas donde hemos definido las claves foráneas y no inmediatamente despúes
 (es el mínimo cero de las cardinalidades que vimos en diseño que poníamos para no tener problemas en las inserciones en las tablas).
 Las referencias cruzadas dan problemas si no se pueden poner a cero*/
);

CREATE TABLE empleados(
nif CHAR(10) PRIMARY KEY,
nombre VARCHAR(200) NOT NULL,
nss BIGINT NOT NULL UNIQUE,
salario DECIMAL(8,2) NOT NULL,
sexo ENUM("HOMBRE","MUJER","OTRO") NOT NULL,
fnacimiento DATE NOT NULL,
departamento SMALLINT UNSIGNED, /*Dejo que se pueda poner a 0 por la cardinalidad del diseño*/
supervisor CHAR(10)
);

CREATE TABLE empleados_proyectos(
proyecto SMALLINT UNSIGNED,
empleado CHAR(10),
horas SMALLINT UNSIGNED NOT NULL,
fincorporacion DATE NOT NULL,
fbaja DATE,
PRIMARY KEY (proyecto, empleado)
);

CREATE TABLE proyectos(
id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(200) NOT NULL,
departamento SMALLINT UNSIGNED /*Dejo que se pueda poner a cero por la cardinalidad del diseño*/
);

CREATE TABLE familiares_empleados(
empleado CHAR(10),
familiar CHAR(10),
parentesco VARCHAR(20) NOT NULL,
PRIMARY KEY (empleado, familiar)
);

CREATE TABLE familiares(
nif CHAR(20) PRIMARY KEY,
nombre VARCHAR(200) NOT NULL,
fnac DATE NOT NULL,
sexo ENUM("HOMBRE", "MUJER", "OTRO") NOT NULL
);


ALTER TABLE dep_sedes ADD
	FOREIGN KEY (dep) REFERENCES departamentos(id);
ALTER TABLE dep_sedes ADD
	FOREIGN KEY (sede) REFERENCES sedes(id);
ALTER TABLE departamentos ADD
	FOREIGN KEY (director) REFERENCES empleados(nif);
ALTER TABLE empleados ADD
	FOREIGN KEY(departamento) REFERENCES departamentos(id);
ALTER TABLE empleados ADD
	FOREIGN KEY (supervisor) REFERENCES empleados(nif);
ALTER TABLE empleados_proyectos ADD
	FOREIGN KEY (proyecto) REFERENCES proyectos(id);
ALTER TABLE empleados_proyectos ADD
	FOREIGN KEY (empleado) REFERENCES empleados(nif);
ALTER TABLE proyectos ADD
	FOREIGN KEY (departamento) REFERENCES departamentos(id);
ALTER TABLE familiares_empleados ADD
	FOREIGN KEY (empleado) REFERENCES empleados(nif);
ALTER TABLE familiares_empleados ADD
	FOREIGN KEY (familiar) REFERENCES familiares(nif);
    
INSERT INTO sedes(superficie, direccion, localidad, provincia, telefono1, telefono2) VALUES
(100,"Rúa Tarragona 10","Vigo","Pontevedra", 986345678, NULL),
(200,"Avenida Gran Vía 10","Vigo","Pontevedra", 9863454567, NULL),
(300,"Rúa das Hortas 10","Monforte de Lemos","Lugo", 982345678, NULL),
(500,"Rúa Nova de Abaixo 10","Santiago de Compostela","A Coruña", 981345678, 981456789),
(100,"Rúa Oliveira 4","Allariz","Ourense", 988345678, NULL),
(300,"Rúa Luís Braille 2","Pontevedra","Pontevedra", 986343278, NULL);

INSERT INTO departamentos(nombre, fcreacion, prima) VALUES
("Dep1",24/09/2007,1500.50),
("Dep2",23/11/2008,1650.50),
("Dep3",23/11/2008,1200.50),
("Dep4",26/04/2015,1600.50),
("Dep5",24/01/2021,1700.50);

INSERT INTO dep_sedes VALUES
(1,1),(1,2),(1,3),(1,4),(1,6),(2,1),(2,2),(2,3),(2,4),(2,5),(3,1),(3,2),(3,3),(3,4),(3,5),(4,1),(4,2),(4,3),(4,4),(4,5),(5,4),(5,6);

INSERT INTO empleados VALUES
("11000012A","Ramón González","11111111112", 2800,"HOMBRE", 19/11/1958, NULL, NULL),
("21000013A","Antonia Hernández","21111111113", 2500,"MUJER", 25/09/1959, NULL, NULL),
("21000014A","María García","21111111114", 2800,"MUJER", 07/12/1962, NULL, NULL),
("21000015A","Pablo Álvarez","21111111115", 2300,"HOMBRE", 13/07/1961, NULL, NULL),
("11000011A","Pedro Rodriguez","11111111116", 1500,"HOMBRE", 24/04/1974, 1, "11000012A"),
("21000011A","Pula González","21111111111", 1500,"MUJER", 12/11/1969, 2, "21000013A"),
("31000011A","Marta López","31111111111", 1500,"MUJER", 23/07/1977, 3,"21000014A"),
("41000011A","Juan Perez","41111111111", 1500,"HOMBRE", 08/04/1988, 4, "21000015A"),
("51000011A","Laura García","51111111111", 1500,"MUJER", 01/05/1985, 3, "11000011A"),
("61000011A","Antonio Vázquez","61111111111", 1500,"HOMBRE", 23/12/1990, 1, "51000011A"),
("71000011A","Patricia González","71111111111", 1500,"MUJER", 30/06/1990, 4, "11000011A"),
("81000011A","Rocío Garrido","81111111111", 1500,"MUJER", 16/02/1990, 2, NULL),
("91000011A","Carmen Díaz","91111111111", 1500,"MUJER", 17/01/1990, NULL, NULL);

UPDATE departamentos SET director="11000011A" WHERE id=1;
UPDATE departamentos SET director="21000011A" WHERE id=2;
UPDATE departamentos SET director="31000011A" WHERE id=3;
UPDATE departamentos SET director="41000011A" WHERE id=4;

INSERT INTO proyectos(nombre, departamento) VALUES 
("aaaa",1),("bbbb",1),("cccc",2),("dddd",4),("eeee",3),("ffff",2),("gggg",4),("hhhh",3);

INSERT INTO empleados_proyectos VALUES
(1,"21000011A",67,23/07/2009,15/12/2008),
(2,"41000011A",23,07/02/2010,28/02/2010),
(3,"21000011A",45,22/03/2011,08/06/2011),
(3,"51000011A",89,12/04/2013,14/06/2013),
(3,"61000011A",110,01/03/2014,31/07/2014),
(4,"71000011A",69,02/05/2015,12/12/2015),
(5,"91000011A",34,20/12/2020,NULL),
(8,"81000011A",22,6/01/2021,NULL);

INSERT INTO familiares VALUES
("444444444A","CFBFGBNGFN",23/07/1998,"MUJER"),
("544444444A","FBGFBG",12/09/1967,"HOMBRE"),
("644444444A","FHNHTNGT",09/11/1978,"OTRO"),
("744444444A","R TYET",30/01/1991,"MUJER"),
("844444444A","VDFVFDG",17/04/1985,"MUJER");

INSERT INTO familiares_empleados VALUES
("11000011A","444444444A","Hija"),
("41000011A","544444444A","Tío"),
("71000011A","644444444A","Hermana"),
("81000011A","744444444A","Mujer"),
("21000014A","844444444A","Hija");

SELECT *
FROM sedes;

SELECT *
FROM dep_sedes;

SELECT *
FROM departamentos;

SELECT *
FROM empleados;

SELECT *
FROM empleados_proyectos;

SELECT *
FROM proyectos;

SELECT *
FROM familiares;

SELECT *
FROM familiares_empleados;



/*INSERT INTO departamentos(nombre, director) VALUES
("Dep1", "1100011A"),
("Dep2", "2100011A"),
("Dep3", "3100011A");

/*SELECT E.nombre, D.nombre
FROM empleados E LEFT JOIN departamentos D
ON E.departamento=D.id;

/*SELECT E.nombre,departamento, id, D.nombre
FROM empleados E, departamentos D
WHERE E.departamento=D.id;

/*SELECT E.nombre, D.nombre
FROM empleados E LEFT JOIN departamentos D
ON E.departamento=D.id;


    
/*INSERT INTO departamentos VALUES
(1, "Dep1", "1100011A"),
(2, "Dep2", "2100011A"),
(3, "Dep3", "3100011A");


INSERT INTO departamentos VALUES
("Dep1"),
("Dep2"),
("Dep3");
    
/*INSERT INTO empleados VALUES
("1100011A", "Emp1", 1, NULL),
("2100011A", "Emp2", 2, NULL),
("3100011A", "Emp3", 3, NULL),
("4100011A", "Emp4", 2, NULL),
("5100011A", "Emp5", 1, NULL);
INSERT INTO empleados(nif, nombre, departamento) VALUES
("6100011A", "Emp6", 1);


INSERT INTO empleados VALUES
("1100011A", "Emp1", 1, NULL),
("2100011A", "Emp2", 2, "1100011A"),
("3100011A", "Emp3", 3, NULL),
("4100011A", "Emp4", 2, NULL),
("5100011A", "Emp5", 1, NULL);
INSERT INTO empleados(nif, nombre, departamento) VALUES
("6100011A", "Emp6", 1);

UPDATE departamentos SET director="1100011A" WHERE id=1;
UPDATE departamentos SET director="2100011A" WHERE id=2;
UPDATE departamentos SET director="3100011A" WHERE id=3;

DELETE FROM empleados WHERE nif="2100011A";

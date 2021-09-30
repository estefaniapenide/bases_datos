DROP DATABASE IF EXISTS emp_examen;
CREATE DATABASE emp_examen;
USE emp_examen;

CREATE TABLE sedes (
	id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    superficie SMALLINT UNSIGNED NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    localidad VARCHAR(255) NOT NULL,
    telefono BIGINT NOT NULL,
    telefono2 BIGINT,
    provincia VARCHAR(30) NOT NULL
);

CREATE TABLE departamentos (
	num SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL UNIQUE,
    fcreacion DATE NOT NULL,
    prima DECIMAL(10,2) UNSIGNED NOT NULL,
    director SMALLINT UNSIGNED UNIQUE -- El indice UNIQUE permite garantizar una relación 1:1
);

/* Se elimina la tabla dep_sedes ya que tiene más sentido almacenar la sede en que trabaja cada empleado. 
CREATE TABLE dep_sedes (
    departamento SMALLINT UNSIGNED,
	sede SMALLINT UNSIGNED,
    FOREIGN KEY (departamento) REFERENCES departamentos(num),
    FOREIGN KEY (sede) REFERENCES sedes(id),
    PRIMARY KEY (sede, departamento)
);
*/

CREATE TABLE empleados (
	id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, /* Se añade un id como PK por rendimiento */
	nif CHAR(9) NOT NULL UNIQUE,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(100) NOT NULL, /* Se distinte entre nombre y apellidos */
	nss BIGINT NOT NULL UNIQUE,
    salario DECIMAL(7,2) UNSIGNED NOT NULL,
    sexo ENUM("HOMBRE", "MUJER"),
    fnacimiento DATE NOT NULL,
    departamento SMALLINT UNSIGNED NOT NULL,
    sede SMALLINT UNSIGNED NOT NULL, /* Se añade la sede en la que está cada empleado */
    supervisor SMALLINT UNSIGNED
);

CREATE TABLE proyectos (
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    dept_coord SMALLINT UNSIGNED NOT NULL
);

DROP TABLE IF EXISTS proyectos_empleados;
CREATE TABLE proyectos_empleados (
	proyecto INT UNSIGNED,
	empleado SMALLINT UNSIGNED,
	horas TIME NOT NULL DEFAULT "40:00", -- Sería más óptimo TINYINT pero no permitiría minutos
	fincorporacion DATE NOT NULL DEFAULT (CURDATE()),
	fbaja DATE,
	PRIMARY KEY (proyecto, empleado)
);

CREATE TABLE familiares (
	id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, /* Se añade un id como PK por rendimiento */
	nif CHAR(9) NOT NULL UNIQUE,
    nombre VARCHAR(255) NOT NULL,
    apellidos VARCHAR(255) NOT NULL,
    sexo ENUM("HOMBRE","MUJER"),
    fnacimiento DATE NOT NULL
);

CREATE TABLE familiares_emp (
	empleado SMALLINT UNSIGNED,
    familiar SMALLINT UNSIGNED,
    parentesco VARCHAR(20) NOT NULL,
    PRIMARY KEY (empleado, familiar)
);


/* -------------------------------------------------------------------------------------------
----- CLAVES FORANEAS -----
------------------------------------------------------------------------------------------- */

ALTER TABLE departamentos ADD FOREIGN KEY (director) REFERENCES empleados(id);
ALTER TABLE empleados ADD FOREIGN KEY (sede) REFERENCES sedes(id);
ALTER TABLE empleados ADD FOREIGN KEY (departamento) REFERENCES departamentos(num);
ALTER TABLE empleados ADD FOREIGN KEY (supervisor) REFERENCES empleados(id);

ALTER TABLE proyectos ADD FOREIGN KEY (dept_coord) REFERENCES departamentos(num);
ALTER TABLE proyectos_empleados ADD FOREIGN KEY (proyecto) REFERENCES proyectos(id);
ALTER TABLE proyectos_empleados ADD FOREIGN KEY (empleado) REFERENCES empleados(id);
ALTER TABLE familiares_emp ADD FOREIGN KEY (familiar) REFERENCES familiares(id);
ALTER TABLE familiares_emp ADD FOREIGN KEY (empleado) REFERENCES empleados(id);


/* -------------------------------------------------------------------------------------------
----- INSERCIONES -----
------------------------------------------------------------------------------------------- */

INSERT INTO sedes VALUES (1, 101, "direccion1", "Vigo", 986111221, 986111227, "Pontevedra");
INSERT INTO sedes VALUES (2, 102, "direccion1", "Pontevedra", 986111222, NULL, "Pontevedra");
INSERT INTO sedes VALUES (3, 103, "direccion2", "Coruña", 981111223, 986111228, "Coruña");
INSERT INTO sedes VALUES (4, 104, "direccion2", "Santiago de Compostela", 981111224, NULL, "Coruña");
INSERT INTO sedes VALUES (5, 105, "direccion3", "Lugo", 982111225, NULL, "Lugo");
INSERT INTO sedes VALUES (6, 106, "direccion4", "Ourense", 988111226, NULL, "Ourense");

INSERT INTO departamentos VALUES (1, "Dep1: Administración", "2000-01-01", 500.111, NULL);
INSERT INTO departamentos VALUES (2, "Dep2: Ventas", "2002-01-01", 500.22, NULL);
INSERT INTO departamentos VALUES (3, "Dep3: Marketing", "2003-01-01", 500.33, NULL);
INSERT INTO departamentos VALUES (4, "Dep4: RRHH", "2004-01-01", 500.44, NULL);
INSERT INTO departamentos VALUES (5, "Dep5: IT", "2005-01-01", 500.55, NULL);
INSERT INTO departamentos VALUES (6, "Dep6: Pandemias", "2019-03-14", 500.66, NULL);

/* Directores */
INSERT INTO empleados VALUES (1, "01999999A", "Empleado1", "Director1 Apellido2", 12345678901, 6000.11, "HOMBRE", "1988-01-01", 1, 1, NULL);
UPDATE departamentos SET director=1 WHERE num=1;
INSERT INTO empleados VALUES (2, "02999999A", "Empleado2", "Director2 Apellido2", 22345678902, 6000.22, "MUJER", "1988-01-02", 2, 2, NULL);
UPDATE departamentos SET director=2 WHERE num=2;
INSERT INTO empleados VALUES (3, "03999999A", "Empleado3", "Director3 Apellido2", 32345678903, 6000.33, NULL, "1988-01-03", 3, 3, NULL);
UPDATE departamentos SET director=3 WHERE num=3;
INSERT INTO empleados VALUES (4, "04999999A", "Empleado4", "Director4 Apellido2", 42345678904, 6000.44, "HOMBRE", "1988-01-04", 4, 4, NULL);
UPDATE departamentos SET director=4 WHERE num=4;
INSERT INTO empleados VALUES (5, "05999999A", "Empleado5", "Director5 Apellido2", 52345678905, 6000.55, "MUJER", "1988-01-05", 5, 5, NULL);
UPDATE departamentos SET director=5 WHERE num=5;
INSERT INTO empleados VALUES (6, "06999999A", "Empleado6", "Director6 Apellido2", 62345678906, 6000.66, "MUJER", "1988-01-06", 6, 6, NULL);
UPDATE departamentos SET director=6 WHERE num=6;

/* Dep1: Administración  */
INSERT INTO empleados VALUES (10, "10000111A", "Empleado10", "Dep1 Apellido2", 102345678901, 1000.10, "HOMBRE", "1988-01-10", 1, 1, 1);
INSERT INTO empleados VALUES (11, "11000111A", "Empleado11", "Dep1 Apellido2", 112345678902, 1000.11, "MUJER", "1988-01-11", 1, 2, 1);
INSERT INTO empleados VALUES (12, "12000111A", "Empleado12", "Dep1 Apellido2", 122345678903, 1000.12, NULL, "1988-01-12", 1, 3, 1);
INSERT INTO empleados VALUES (13, "13000111A", "Empleado13", "Dep1 Apellido2", 132345678904, 1000.13, "HOMBRE", "1988-01-13", 4, 3, 1);

INSERT INTO empleados VALUES (14, "14000111A", "Empleado14", "Dep1 Apellido2", 14345678905, 1000.14, "MUJER", "1988-01-14", 1, 5, 1);
INSERT INTO empleados VALUES (15, "15000111A", "Empleado15", "Dep1 Apellido2", 152345678905, 1000.15, "MUJER", "1988-01-15", 1, 1, 10);
INSERT INTO empleados VALUES (16, "16000111A", "Empleado16", "Dep1 Apellido2", 162345678905, 1000.16, "HOMBRE", "1988-01-16", 1, 2, 11);
INSERT INTO empleados VALUES (17, "17000111A", "Empleado17", "Dep1 Apellido2", 172345678905, 1000.17, "HOMBRE", "1988-01-17", 1, 3, 12);
INSERT INTO empleados VALUES (18, "18000111A", "Empleado18", "Dep1 Apellido2", 182345678905, 1000.18, "HOMBRE", "1988-01-18", 1, 4, 13);
INSERT INTO empleados VALUES (19, "19000111A", "Empleado19", "Dep1 Apellido2", 192345678905, 1000.19, "HOMBRE", "1988-01-19", 1, 5, 14);

/* Dep2: Ventas */
INSERT INTO empleados VALUES (20, "20000111A", "Empleado20", "Dep2 Apellido2", 202345678901, 1000.01, "HOMBRE", "1988-01-10", 2, 1, 2);
INSERT INTO empleados VALUES (21, "21000111A", "Empleado21", "Dep2 Apellido2", 212345678902, 1000.01, "MUJER", "1988-01-11", 2, 2, 2);
INSERT INTO empleados VALUES (22, "22000111A", "Empleado22", "Dep2 Apellido2", 222345678903, 1000.01, "MUJER", "1988-01-12", 2, 3, 2);
INSERT INTO empleados VALUES (23, "23000111A", "Empleado23", "Dep2 Apellido2", 232345678904, 1000.01, "HOMBRE", "1988-01-13", 2, 4, 2);
INSERT INTO empleados VALUES (24, "24000111A", "Empleado24", "Dep2 Apellido2", 242345678905, 1000.01, "MUJER", "1988-01-14", 2, 5, 2);
INSERT INTO empleados VALUES (25, "25000111A", "Empleado25", "Dep2 Apellido2", 252345678905, 1000.01, "MUJER", "1988-01-15", 2, 1, 20);
INSERT INTO empleados VALUES (26, "26000111A", "Empleado26", "Dep2 Apellido2", 262345678905, 1000.01, "MUJER", "1988-01-16", 2, 2, 21);
INSERT INTO empleados VALUES (27, "27000111A", "Empleado27", "Dep2 Apellido2", 272345678905, 1000.01, "HOMBRE", "1988-01-17", 2, 3, 22);
INSERT INTO empleados VALUES (28, "28000111A", "Empleado28", "Dep2 Apellido2", 282345678905, 1000.01, "MUJER", "1988-01-18", 2, 4, 23);
INSERT INTO empleados VALUES (29, "29000111A", "Empleado29", "Dep2 Apellido2", 292345678905, 1000.01, "MUJER", "1988-01-19", 2, 5, 24);

/* Dep3: Marketing */
INSERT INTO empleados VALUES (30, "30000111A", "Empleado30", "Dep3 Apellido2", 302345678901, 1000.01, "HOMBRE", "1988-01-10", 3, 3, 3);
INSERT INTO empleados VALUES (31, "31000111A", "Empleado31", "Dep3 Apellido2", 312345678902, 1000.01, "MUJER", "1988-01-11", 3, 3, 30);
INSERT INTO empleados VALUES (32, "32000111A", "Empleado32", "Dep3 Apellido2", 322345678903, 1000.01, "MUJER", "1988-01-12", 3, 3, 31);
INSERT INTO empleados VALUES (33, "33000111A", "Empleado33", "Dep3 Apellido2", 332345678904, 1000.01, "HOMBRE", "1988-01-13", 3, 3, 31);
INSERT INTO empleados VALUES (34, "34000111A", "Empleado34", "Dep3 Apellido2", 342345678905, 1000.01, "MUJER", "1988-01-14", 3, 3, 31);

/* Dep4: RRHH */
INSERT INTO empleados VALUES (40, "40000111A", "Empleado40", "Dep4 Apellido2", 402345678901, 1000.01, "HOMBRE", "1988-01-10", 4, 4, 3);
INSERT INTO empleados VALUES (41, "41000111A", "Empleado41", "Dep4 Apellido2", 412345678902, 1000.01, "MUJER", "1988-01-11", 4, 4, 30);
INSERT INTO empleados VALUES (42, "42000111A", "Empleado42", "Dep4 Apellido2", 422345678903, 1000.01, "MUJER", "1988-01-12", 4, 4, 31);
INSERT INTO empleados VALUES (43, "43000111A", "Empleado43", "Dep4 Apellido2", 432345678904, 1000.01, "HOMBRE", "1988-01-13", 4, 4, 31);
INSERT INTO empleados VALUES (44, "44000111A", "Empleado44", "Dep4 Apellido2", 442345678905, 1000.01, "MUJER", "1988-01-14", 4, 4, 31);

/* Departamento 5: IT */
INSERT INTO empleados VALUES (50, "50000111A", "Empleado50", "Dep5 Apellido2", 502345678901, 1000.01, "HOMBRE", "1988-01-10", 5, 1, 5);
INSERT INTO empleados VALUES (51, "51000111A", "Empleado51", "Dep5 Apellido2", 512345678902, 1000.01, "MUJER", "1988-01-11", 5, 2, 5);
INSERT INTO empleados VALUES (52, "52000111A", "Empleado52", "Dep5 Apellido2", 522345678903, 1000.01, "MUJER", "1988-01-12", 5, 3, 5);
INSERT INTO empleados VALUES (53, "53000111A", "Empleado53", "Dep5 Apellido2", 532345678904, 1000.01, "HOMBRE", "1988-01-13", 5, 4, 5);
INSERT INTO empleados VALUES (54, "54000111A", "Empleado54", "Dep5 Apellido2", 542345678905, 1000.01, "MUJER", "1988-01-14", 5, 5, 5);

/* El departamento 6 solo tiene asignado a su director como empleado */



INSERT INTO proyectos VALUES (10, 'Proyecto 10', "2019-01-01", "2020-01-01", 1);
INSERT INTO proyectos VALUES (11, 'Proyecto 11', "2019-01-01", "2019-09-01", 1);
INSERT INTO proyectos VALUES (12, 'Proyecto 12', "2019-10-01", NULL, 1);
INSERT INTO proyectos VALUES (13, 'Proyecto 13', "2020-01-01", NULL, 1);

/* El departamento de ventas (2) no coordina proyectos */

INSERT INTO proyectos VALUES (30, 'Proyecto 30', "2019-01-01", "2020-01-01", 3);
INSERT INTO proyectos VALUES (31, 'Proyecto 31', "2019-01-01", "2019-09-01", 3);
INSERT INTO proyectos VALUES (32, 'Proyecto 32', "2019-10-01", NULL, 3);
INSERT INTO proyectos VALUES (33, 'Proyecto 33', "2020-01-01", NULL, 3);

INSERT INTO proyectos VALUES (40, 'Proyecto 40', "2019-01-01", "2020-01-01", 4);
INSERT INTO proyectos VALUES (41, 'Proyecto 41', "2019-01-01", "2019-09-01", 4);
INSERT INTO proyectos VALUES (42, 'Proyecto 42', "2019-10-01", NULL, 4);
INSERT INTO proyectos VALUES (43, 'Proyecto 43', "2020-01-01", NULL, 4);

INSERT INTO proyectos VALUES (50, 'Proyecto 50', "2019-01-01", "2020-01-01", 5);
INSERT INTO proyectos VALUES (51, 'Proyecto 51', "2019-01-01", "2019-09-01", 5);
INSERT INTO proyectos VALUES (52, 'Proyecto 52', "2019-10-01", NULL, 5);
INSERT INTO proyectos VALUES (53, 'Proyecto 53', "2020-01-01", NULL, 5);

INSERT INTO proyectos VALUES (60, 'Proyecto 60', "2020-03-13", NULL, 6);



/* Proyectos del dep1 */
INSERT INTO proyectos_empleados VALUES (10, 1, "10:00", "2019-01-01", "2020-01-01");
INSERT INTO proyectos_empleados VALUES (11, 1, "10:00", "2019-01-01", "2019-09-01");
INSERT INTO proyectos_empleados VALUES (12, 1, "10:00", "2019-09-01", "2020-01-01");
INSERT INTO proyectos_empleados VALUES (13, 1, "10:00", "2019-10-01", NULL);
INSERT INTO proyectos_empleados (proyecto, empleado, horas) VALUES (13, 2, "10:00"); -- Poniendo la fecha DEFAULT

INSERT INTO proyectos_empleados VALUES (10, 10, "10:00", "2019-01-01", "2020-01-01");
INSERT INTO proyectos_empleados VALUES (11, 10, "10:00", "2019-01-01", "2019-09-01");
INSERT INTO proyectos_empleados VALUES (12, 10, "10:00", "2019-09-01", "2020-01-01");
INSERT INTO proyectos_empleados VALUES (13, 10, "10:00", "2019-10-01", NULL);

INSERT INTO proyectos_empleados VALUES (10, 11, "10:00", "2019-01-01", "2020-01-01");
INSERT INTO proyectos_empleados VALUES (11, 11, "10:00", "2019-01-01", "2019-09-01");
INSERT INTO proyectos_empleados VALUES (12, 12, "10:00", "2019-09-01", "2020-01-01");
INSERT INTO proyectos_empleados VALUES (13, 12, "10:00", "2019-10-01", NULL);

INSERT INTO proyectos_empleados VALUES (10, 13, "10:00", "2019-01-01", "2020-01-01");
INSERT INTO proyectos_empleados VALUES (11, 14, "10:00", "2019-01-01", "2019-09-01");
INSERT INTO proyectos_empleados VALUES (12, 11, "10:00", "2019-09-01", "2020-01-01");
INSERT INTO proyectos_empleados VALUES (13, 21, "10:00", "2019-10-01", NULL);

INSERT INTO proyectos_empleados VALUES (10, 24, "10:00", "2019-01-01", "2020-01-01");
INSERT INTO proyectos_empleados VALUES (11, 34, "10:00", "2019-01-01", "2019-09-01");
INSERT INTO proyectos_empleados VALUES (12, 33, "10:00", "2019-09-01", "2020-01-01");
INSERT INTO proyectos_empleados VALUES (13, 23, "10:00", "2019-10-01", NULL);

/*--- Pendiente otros departamentos ---*/



INSERT INTO familiares VALUES (101, "10100111A", "Familiar60", "Apellido2", "HOMBRE", "1988-01-10");
INSERT INTO familiares VALUES (102, "10200111A", "Familiar61", "Apellido2", "MUJER", "1988-01-11");
INSERT INTO familiares VALUES (111, "11100111A", "Familiar62", " Apellido2", "MUJER", "1988-01-12");
INSERT INTO familiares VALUES (11, "11000111A", "Familiar63", " Apellido2", "HOMBRE", "1988-01-13");
INSERT INTO familiares VALUES (31, "31000111A", "Familiar64", " Apellido2", "MUJER", "1988-01-14");
INSERT INTO familiares VALUES (121, "12100111A", "Familiar64", " Apellido2", "MUJER", "1988-01-14");
INSERT INTO familiares VALUES (131, "13100111A", "Familiar64", " Apellido2", "MUJER", "1988-01-14");
INSERT INTO familiares VALUES (132, "13200111A", "Familiar64", " Apellido2", "MUJER", "1988-01-14");
INSERT INTO familiares VALUES (221, "22100111A", "Familiar64", " Apellido2", "MUJER", "1988-01-14");
INSERT INTO familiares VALUES (231, "23100111A", "Familiar64", " Apellido2", "MUJER", "1988-01-14");
INSERT INTO familiares VALUES (232, "23200111A", "Familiar64", " Apellido2", "MUJER", "1988-01-14");
INSERT INTO familiares VALUES (331, "33100111A", "Familiar64", " Apellido2", "MUJER", "1988-01-14");
INSERT INTO familiares VALUES (341, "34100111A", "Familiar64", " Apellido2", "MUJER", "1988-01-14");


INSERT INTO familiares_emp VALUES (10, 101, "HIJA");
INSERT INTO familiares_emp VALUES (10, 102, "CONYUGE");
INSERT INTO familiares_emp VALUES (11, 111, "HIJA");
INSERT INTO familiares_emp VALUES (31, 111, "HIJA");
INSERT INTO familiares_emp VALUES (11, 31, "CONYUGE");
INSERT INTO familiares_emp VALUES (31, 11, "CONYUGE");

INSERT INTO familiares_emp VALUES (12, 121, "HIJA");
INSERT INTO familiares_emp VALUES (13, 131, "HIJO");
INSERT INTO familiares_emp VALUES (13, 132, "CONYUGE");
INSERT INTO familiares_emp VALUES (22, 221, "HIJO");
INSERT INTO familiares_emp VALUES (23, 231, "HIJA");
INSERT INTO familiares_emp VALUES (23, 232, "HIJO");
INSERT INTO familiares_emp VALUES (33, 331, "CONYUGE");
INSERT INTO familiares_emp VALUES (34, 341, "HIJO");

/*SELECT nombre, apellidos, salario
FROM empleados
ORDER BY salario;*/

/*SELECT nombre, apellidos, salario, departamento
FROM empleados
WHERE departamento=2 OR departamento=3 -- WHERE departamento IN (2,3)
ORDER BY departamento;*/

/*SELECT COUNT(id) as Empleados
FROM empleados;*/

/*SELECT COUNT(supervisor) as Empleados_con_supervisor
FROM empleados;*/

/*SELECT COUNT(id) as Empleados, COUNT(supervisor) as Empleados_con_supervisor
FROM empleados;

SELECT COUNT(id) as Empleados, COUNT(DISTINCT nombre) as Empleados_con_nombre_distinto
FROM empleados;*/

/*SELECT COUNT(DISTINCT supervisor) as Supervisores
FROM empleados;*/

/*SELECT DISTINCT departamento as Departamento_con_empleados
FROM empleados;*/

/*SELECT COUNT(DISTINCT departamento) as  Num_departamentos
FROM empleados;*/

/*SELECT nombre, departamento
FROM empleados
WHERE  supervisor IS NULL AND salario>1000
ORDER BY departamento;*/

/*SELECT COUNT(id) as Numeo_empleados_con_supervisor_departamento_3
FROM empleados
WHERE supervisor IS NOT NULL AND departamento=3;*/

/*SELECT SUM(salario)/COUNT(salario) as Media_salarios
FROM empleados;*/

/*SELECT AVG(salario)
FROM empleados;*/

/*SELECT AVG(salrio)
FROM empleados
WHERE departamento=3;*/

/*SELECT ROUND(AVG(salario),2), COUNT(id)
FROM empleados
WHERE departamento=3;*/

/*SELECT departamento, COUNT(id)
FROM empleados
GROUP BY departamento;*/

/*SELECT deparatmento, COUNT(id), ROUND(AVG(salario),2) as Media_salarios
FROM empleados
GROUP BY departamento;*/

/*SELECT deparatmento, COUNT(id) as Num_empleados, ROUND(AVG(salario),2) as Media_salarios, COUNT(supervisor)
FROM empleados
GROUP BY departamento;*/

/*SELECT departamento, COUNT(DISTINCT supervisor) as num_supervisores, COUNT(supervisor) as num_supervisados
FROM empleados
GROUP BY departamento
ORDER BY supervisores;*/











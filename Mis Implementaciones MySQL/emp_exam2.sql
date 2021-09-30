DROP DATABASE IF EXISTS emp_examen2;
CREATE SCHEMA emp_examen2;
USE emp_examen2;

CREATE TABLE empleados(
nif CHAR(10) PRIMARY KEY,
nombre VARCHAR(200) NOT NULL,
departamento SMALLINT UNSIGNED NOT NULL,
supervisor CHAR(10)
);



CREATE TABLE  departamentos(
id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(200) NOT NULL,
director CHAR(10) /*Dejamos que sea null para que no de problemas cuando colocamos las inserciones
 después de las alteraciones de las tablas donde hemos definido las claves foráneas y no inmediatamente despúes
 (es el mínimo cero de las cardinalidades que vimos en diseño que poníamos para no tener problemas en las inserciones en las tablas).
 Las referencias cruzadas dan problemas si no se pueden poner a cero*/
);



/*INSERT INTO departamentos(nombre, director) VALUES
("Dep1", "1100011A"),
("Dep2", "2100011A"),
("Dep3", "3100011A");*/

/*SELECT E.nombre, D.nombre
FROM empleados E LEFT JOIN departamentos D
ON E.departamento=D.id;*/

/*SELECT E.nombre,*/ /*departamento, id,*//* D.nombre
FROM empleados E, departamentos D
WHERE E.departamento=D.id;*/

/*SELECT E.nombre, D.nombre
FROM empleados E LEFT JOIN departamentos D
ON E.departamento=D.id;*/


ALTER TABLE empleados ADD
	FOREIGN KEY(departamento) REFERENCES departamentos(id);
ALTER TABLE empleados ADD
	FOREIGN KEY (supervisor) REFERENCES empleados(nif);
ALTER TABLE departamentos ADD
	FOREIGN KEY (director) REFERENCES empleados(nif);
    
/*INSERT INTO departamentos VALUES
(1, "Dep1", "1100011A"),
(2, "Dep2", "2100011A"),
(3, "Dep3", "3100011A");*/

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
("6100011A", "Emp6", 1);*/

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

   
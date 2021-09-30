

/* ------------------------------------------------
 * 301. Comprobar qué supervisores tienen proyectos asignados. */

WITH supervisores AS (
	SELECT DISTINCT SUP.*
	FROM empleados E JOIN empleados SUP ON E.supervisor=SUP.id
)
SELECT id, nombre, apellidos
FROM supervisores
WHERE id IN (SELECT DISTINCT empleado
			FROM proyectos_empleados);
		
WITH supervisores AS (
	SELECT DISTINCT SUP.*
	FROM empleados E JOIN empleados SUP ON E.supervisor=SUP.id
)
SELECT DISTINCT id, nombre, apellidos
FROM supervisores S JOIN proyectos_empleados PE ON  S.id=PE.empleado;

		

 /* 302. Supervisores tienen no tiene proyectos asignados. */

SELECT id, nombre, apellidos
FROM supervisores
WHERE id NOT IN (SELECT DISTINCT empleado
			FROM proyectos_empleados);


		
/* 303. Empleados cuyo salario es mayor que el de su supervisor */
		
SELECT E.id, E.nombre, E.apellidos
FROM empleados E INNER JOIN empleados SUP ON E.supervisor=SUP.id
WHERE E.salario > SUP.salario;

		
SELECT id, nombre, apellidos, salario, supervisor
FROM empleados E
WHERE E.salario > (SELECT id, salario
				FROM empleados SUP
				WHERE SUP.id=E.supervisor);


/* 304. Empleados cuyo salario es mayor que el de cualquier director */
			
SELECT *
FROM empleados
WHERE salario > ANY (SELECT salario
					FROM empleados E JOIN departamentos D ON D.director=E.id);

SELECT *
FROM empleados
WHERE salario > (SELECT min(salario)
					FROM empleados E JOIN departamentos D ON D.director=E.id);
			
			

/* 304b. Empleados cuyo salario es igual al de cualquier director */


SELECT *
FROM empleados
WHERE salario = ANY (SELECT salario
					FROM empleados E JOIN departamentos D ON D.director=E.id);	
				
SELECT *
FROM empleados E, (SELECT salario
					FROM empleados E JOIN departamentos D ON D.director=E.id) SD
WHERE E.salario = SD.salario
		
				
							
							
/* 305. Mostrar todos los empleados que tengan un salario superior al empleado 3 */
							
SELECT *
FROM empleados
WHERE salario > (SELECT salario
						FROM empleados
                        WHERE id_empleado=3);



/* 306. Empleados con algún familiar */

SELECT *
FROM empleados E
WHERE EXISTS (SELECT *
			FROM familiares_emp FE
			WHERE E.id=FE.empleado)

			
SELECT DISTINCT E.*
FROM empleados E JOIN familiares_emp FE ON E.id=FE.empleado;



/* 307. Empleados que trabajan en más de 2 proyectos */
			

SELECT empleado, nombre, apellidos
FROM proyectos_empleados pe JOIN empleados E ON E.id=PE.empleado 
GROUP BY empleado
HAVING count(DISTINCT proyecto)>2


SELECT E.id, E.nombre, E.apellidos
FROM empleados E
WHERE EXISTS (SELECT count(proyecto) 
			FROM proyectos_empleados PE 
			WHERE E.id=PE.empleado 
			GROUP BY empleado
			HAVING count(proyecto)>2);


/* Exists devuelve TRUE cuando la subconsulta devuelve alguna fila */
		

SELECT E.id, E.nombre, E.apellidos
FROM (SELECT empleado, count(proyecto) AS num_proy
	FROM proyectos_empleados
	GROUP BY empleado
	HAVING count(proyecto)>2 ) NPE
		JOIN empleados E ON NPE.empleado = E.id

			



		
		
		
		

		
/* -------------------------------------------------------------------------------------------
----- Mostrar aquellos empleados cuyo salario se repite -----
----------------------------------------------------------------------------------------------*/


SELECT nombre, E.salario
FROM empleados E, (SELECT count(*) AS num_empl, salario
	FROM empleados
	GROUP BY salario) AUX
WHERE E.salario=AUX.salario AND num_empl>1;



WITH num_emp_x_salario AS 
(
SELECT count(*) AS num_empl, salario
FROM empleados
GROUP BY salario
),

salarios_repetidos AS
(
SELECT salario
FROM num_emp_x_salario
WHERE num_empl>1
)

SELECT nombre, SR.salario
FROM empleados E, salarios_repetidos SR
WHERE E.salario=SR.salario;


WITH num_emp_x_salario AS 
(
SELECT count(*) AS num_empl, salario
FROM empleados
GROUP BY salario
),

salarios_repetidos AS
(
SELECT salario
FROM num_emp_x_salario
WHERE num_empl>1
)

SELECT nombre, salario
FROM empleados
WHERE salario IN (SELECT * FROM salarios_repetidos);
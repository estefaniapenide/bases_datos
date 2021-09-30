


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
		

SELECT DISTINCT id, nombre, apellidos
FROM supervisores S JOIN proyectos_empleados PE ON S.id=PE.empleado ;


 /* 301b. Si consideramos solo proyectos asignados en vigor */
 	
SELECT DISTINCT SUP.id, SUP.nombre, SUP.apellidos, SUP.salario 
FROM empleados E JOIN empleados SUP ON E.supervisor=SUP.id
WHERE SUP.id NOT IN (SELECT DISTINCT empleado
					FROM proyectos_empleados
					WHERE fbaja IS NULL OR fbaja>CURRENT_DATE); 
		

 /* 302. Supervisores tienen no tiene proyectos asignados. */

SELECT id, nombre, apellidos
FROM supervisores
WHERE id NOT IN (SELECT DISTINCT empleado
			FROM proyectos_empleados);


		
/* 303. Empleados cuyo salario es mayor que el de su supervisor */
		
SELECT E.id, E.nombre, E.apellidos
FROM empleados E INNER JOIN empleados SUP ON E.supervisor=SUP.id
WHERE E.salario > SUP.salario;

		
SELECT id, nombre, apellidos
FROM empleados E
WHERE E.salario > (SELECT salario
				FROM empleados SUP
				WHERE SUP.id=E.supervisor);
		
SELECT id, nombre, apellidos
FROM empleados E
WHERE E.salario > (SELECT salario
				FROM supervisores
				WHERE id=E.supervisor);		
			

/* 304. Empleados cuyo salario es mayor que el de cualquier director */

SELECT *
FROM empleados
WHERE salario > (SELECT min(salario) 
				FROM empleados E JOIN departamentos D ON D.director=E.id)

SELECT *
FROM empleados
WHERE salario > ANY (SELECT salario
				FROM empleados E JOIN departamentos D ON D.director=E.id)
				
SELECT *
FROM empleados
WHERE salario > SOME (SELECT salario
				FROM empleados E JOIN departamentos D ON D.director=E.id)
		
			

/* 304b. Empleados cuyo salario es igual al de cualquier director */


SELECT *
FROM empleados
WHERE salario = ANY (SELECT salario
					FROM empleados E JOIN departamentos D ON D.director=E.id);	

SELECT *
FROM empleados
WHERE salario IN (SELECT salario
					FROM empleados E JOIN departamentos D ON D.director=E.id);				
						
SELECT *
FROM empleados E, (SELECT salario
					FROM empleados E JOIN departamentos D ON D.director=E.id) SD
WHERE E.salario = SD.salario
		


/* 305. Empleados que tengan una fecha de nacimiento menor que la de alguno de sus familiares */


SELECT *
FROM empleados E
WHERE fnacimiento < ANY (SELECT fnacimiento 
					FROM familiares F JOIN familiares_emp FE ON FE.familiar=F.id
					WHERE FE.empleado=E.id);
				
SELECT *
FROM empleados E
WHERE fnacimiento < (SELECT max(fnacimiento) 
					FROM familiares F JOIN familiares_emp FE ON FE.familiar=F.id
					WHERE FE.empleado=E.id);
							

/* 305. Empleados que tengan una fecha de nacimiento menor que la de todos sus 
 * familiares */

SELECT E.id, E.nombre, E.apellidos
FROM empleados E JOIN familiares_emp FE ON E.id=FE.empleado
		JOIN familiares F ON FE.familiar=F.id
GROUP BY E.id, E.nombre, E.apellidos, E.fnacimiento
HAVING E.fnacimiento < min(F.fnacimiento);

SELECT *
FROM (
	SELECT DISTINCT E.* 
	FROM empleados E JOIN familiares_emp FE ON FE.empleado=E.id) E -- empleados con familiares
WHERE fnacimiento = ALL (SELECT fnacimiento 
					FROM familiares F JOIN familiares_emp FE ON FE.familiar=F.id
					WHERE FE.empleado=E.id);

EXPLAIN					
SELECT id, nombre, apellidos, fnacimiento 
FROM empleados E
WHERE fnacimiento < (SELECT min(fnacimiento)
						FROM familiares F JOIN familiares_emp FE ON F.id=FE.familiar
						WHERE FE.empleado=E.id
						GROUP BY FE.empleado);
				
				
					
/* 3143. Empleados que tengan en su DNI 1 o 5 */

SELECT id, nif, nombre, apellidos
FROM empleados
WHERE nif LIKE ANY (ARRAY['%1%','%5%']);

SELECT id, nif, nombre, apellidos
FROM empleados
WHERE nif LIKE'%5%';



/* 306. Empleados con algún familiar */

SELECT DISTINCT E.* 
	FROM empleados E JOIN familiares_emp FE ON FE.empleado=E.id
ORDER BY E.id;


SELECT *
FROM empleados E
WHERE EXISTS (SELECT *
			FROM familiares_emp FE
			WHERE E.id=FE.empleado)
ORDER BY E.id;




/* 307. Empleados que trabajan en más de 2 proyectos */
			

SELECT empleado, nombre, apellidos
FROM proyectos_empleados pe JOIN empleados E ON E.id=PE.empleado 
GROUP BY empleado, nombre, apellidos
HAVING count(proyecto)>2;


SELECT E.id, E.nombre, E.apellidos
FROM empleados E
WHERE EXISTS (SELECT count(proyecto) 
			FROM proyectos_empleados PE
			WHERE E.id=PE.empleado 
			GROUP BY empleado
			HAVING count(proyecto)>2);
/* Exists devuelve TRUE cuando la subconsulta devuelve alguna fila */
		

SELECT E.id, E.nombre, E.apellidos
FROM (SELECT empleado
	FROM proyectos_empleados
	GROUP BY empleado
	HAVING count(proyecto)>2 ) NPE
		JOIN empleados E ON NPE.empleado = E.id

			
SELECT E.id, E.nombre, E.apellidos
FROM empleados E 
WHERE E.id IN (SELECT empleado
	FROM proyectos_empleados
	GROUP BY empleado
	HAVING count(proyecto)>2 )


		
/* 308. Mostrar un listado con los nombres (y apellidos) de todos los familiares de empleados,
 * y de los empleados que tengan algún familiar registrado */

SELECT id, concat(nombre,' ', apellidos) AS nombre
FROM empleados E JOIN familiares_emp fe ON E.id=FE.empleado 
UNION
SELECT id, concat(nombre,' ', apellidos) AS nombre
FROM familiares
	
SELECT id, concat(nombre,' ', apellidos) AS nombre, 'empleado' AS vinculacion
FROM empleados
WHERE id IN (SELECT empleado FROM familiares_emp fe)
UNION ALL
SELECT id, concat(nombre,' ', apellidos) AS nombre, 'familiar'
FROM familiares;
	
	
/* 309. Mostrar el empleado que tenga el mayor salario */

SELECT id, nif, nombre, apellidos
FROM empleados
WHERE salario=(SELECT max(salario) FROM empleados);

	
	
	
	

/* -------------------------------------------------------------------------------------------
----- Mostrar aquellos empleados cuyo salario se repite -----
----------------------------------------------------------------------------------------------*/

SELECT *
FROM empleados
WHERE salario IN (SELECT salario
			FROM empleados
			GROUP BY salario
			HAVING count(salario)>1);
		
SELECT *
FROM empleados E, (SELECT salario
			FROM empleados
			GROUP BY salario
			HAVING count(salario)>1) SR
WHERE E.salario=SR.salario;
		
SELECT *
FROM empleados E JOIN (SELECT salario
			FROM empleados
			GROUP BY salario
			HAVING count(salario)>1) SR
	ON E.salario=SR.salario;
		
WITH sal_rep AS (
			SELECT salario
			FROM empleados
			GROUP BY salario
			HAVING count(salario)>1))		
SELECT *
FROM empleados E JOIN sal_rep SR
	ON E.salario=SR.salario;

		


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
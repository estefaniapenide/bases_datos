

/* ------------------------------------------------
 * 301. Comprobar qué supervisores tienen proyectos asignados. */
DROP VIEW IF EXISTS supervisores;
CREATE VIEW supervisores AS(
		SELECT DISTINCT SUP.id, SUP.nombre, SUP.apellidos, SUP.nif, SUP.nss, SUP.sexo, SUP.salario,SUP.fnacimiento, SUP.departamento, SUP.sede, SUP.supervisor
		FROM empleados E INNER JOIN empleados SUP ON E.supervisor=SUP.id 
		WHERE E.supervisor!=E.id);

SELECT DISTINCT concat(S.nombre," ",S.apellidos) AS supervisor_con_proyecto
FROM supervisores S INNER JOIN proyectos_empleados PE ON S.id=PE.empleado; 


		

 /* 302. Supervisores tienen no tiene proyectos asignados. */

SELECT DISTINCT concat(S.nombre," ",S.apellidos) AS supervisor_SIN_proyecto
FROM supervisores S LEFT JOIN proyectos_empleados PE ON S.id=PE.empleado 
WHERE PE.proyecto IS NULL;

		
/* 303. Empleados cuyo salario es mayor que el de su supervisor */
		
SELECT concat(E.nombre," ",E.apellidos) AS empleado
FROM empleados E INNER JOIN empleados SUP ON E.supervisor =SUP.id
WHERE E.salario >SUP.salario;


/* 304. Empleados cuyo salario es mayor que el de cualquier director */

SELECT concat(E.nombre," ",E.apellidos) AS empleado
FROM empleados E LEFT JOIN empleados SUP ON E.supervisor =SUP.id
WHERE E.salario >SUP.salario;			
			

/* 304b. Empleados cuyo salario es igual al de cualquier director */



		
				
							
							
/* 305. Mostrar todos los empleados que tengan un salario superior al empleado 3 */
							




/* 306. Empleados con algún familiar */







/* 307. Empleados que trabajan en más de 2 proyectos */
			





			



		
		
		
		

		
/* -------------------------------------------------------------------------------------------
----- Mostrar aquellos empleados cuyo salario se repite -----
----------------------------------------------------------------------------------------------*/
SELECT DISTINCT salario, concat(nombre," ",apellidos) AS empleado
FROM empleados


/* -----------------------------------------------------------------------
----- 2. CONSULTAS DE VARIAS TABLAS -----
----------------------------------------------------------------------- */

/* 201. DE CADA EMPLEADO, mostrar su NOMBRE, SALARIO, NOMBRE DEL DEPARTAMENTO 
AL QUE ESTÃ¡ ASIGNADO Y CLAVE DE SU DIRECTOR DE DEPARTAMENTO */

SELECT concat(E.nombre,' ',E.apellidos) AS empleado, E.salario, D.nombre AS departamento, D.director
FROM empleados E, departamentos D
WHERE departamento=D.num;

SELECT concat(E.nombre,' ',E.apellidos) AS empleado, E.salario, D.nombre AS departamento, D.director
FROM empleados E INNER JOIN departamentos D
	ON E.departamento=D.num;

/* Si considerÃ¡semnos que un empleado puede tener departamento a NULL (no es el caso), habrÃ­a
 * que usar un LEFT JOIN para poder incluir a todos los empleados:
 */
SELECT E.nombre AS empleado, E.salario, D.nombre AS departamento, D.director
FROM empleados E LEFT OUTER JOIN departamentos D
	ON E.departamento=D.num;



/* 202. Mostrar PARA CADA DEPARTAMENTO (por su NOMBRE) 
 * EL NOMBRE Y SALARIO DE SU DIRECTOR */

SELECT D.nombre AS departamento,
		concat(E.nombre,' ', E.apellidos) AS director,
		E.salario AS salario_director
FROM departamentos D LEFT JOIN empleados E ON D.director=E.id;

/* Tiene que ser un LEFT JOIN para contemplar aquellos departamentos que puedan no tener
 * asignado un director (ya que definimos esa columna como NULLable para evitar el problema
 * de las referencias cruzadas.
 */	
	
/* El LEFT JOIN no puede hacerse con WHERE directamente. Su equivalente serÃ­a: */
	
(	SELECT D.nombre AS departamento, 
		concat(E.nombre,' ', E.apellidos) AS director, E.salario
	FROM departamentos D, empleados E
	WHERE D.director=E.id
)
UNION ALL
(	SELECT nombre, NULL, NULL
	FROM departamentos
	WHERE director IS NULL
)

/* Para probarlo: */

UPDATE departamentos SET director=NULL WHERE director=6;

/* "UNION ALL" Junta filas aunque sean idÃ©nticas, "UNION" elimina duplicadas */


/* 202b. DE CADA EMPLEADO, mostrar su NOMBRE, SALARIO, NOMBRE DEL DEPARTAMENTO 
AL QUE ESTÃ¡ ASIGNADO Y nombre DE SU DIRECTOR DE DEPARTAMENTO */

SELECT concat(E.nombre," ",E.apellidos) AS empleado, E.salario, D.nombre AS departamento, 
		concat(DIR.nombre," ",DIR.apellidos) AS director
FROM empleados E LEFT JOIN departamentos D ON E.departamento=D.num
	LEFT JOIN empleados DIR ON D.director=DIR.id


/* 203. NÃºmero de sedes en que estÃ¡ presente cada departamento (identificado por su nombre)*/
	
/* Ignorando las sedes sin departamento */
SELECT D.nombre AS departamento, count(DISTINCT E.sede) AS numero_sedes
FROM empleados E RIGHT JOIN departamentos D ON E.departamento=D.num
GROUP BY departamento;


/* Mostrando tambiÃ©n sedes sin departamento */
(	SELECT D.nombre, 
		count(DISTINCT sede) AS sedes
	FROM empleados E RIGHT JOIN departamentos D ON E.departamento=D.num 
	GROUP BY departamento
)
UNION -- EmulaciÃ³n de Full JOIN en caso de querer contemplar empleados sin departamento
(     -- y tambiÃ©n departamentos sin empleados
	SELECT COALESCE(D.nombre, "Sin departamento"),
		count(DISTINCT sede) AS sedes
	FROM empleados E LEFT JOIN departamentos D ON E.departamento=D.num 
	GROUP BY departamento)
ORDER BY nombre;


/* 204. NÃºmero de sedes en que estÃ¡n presentes los departamentos 1 y 6, 
para cada uno de ellos mostrando su nombre */

SELECT D.nombre AS departamento, count(DISTINCT E.sede) AS numero_sedes
FROM empleados E RIGHT JOIN departamentos D ON E.departamento=D.num
WHERE num IN (1,6) -- D.num=1 OR D.num=6
GROUP BY departamento;


/* 205. NÃºmero de sedes en que estÃ¡n presentes los departamentos de AdministraciÃ³n 
 * y Ventas */


SELECT D.nombre AS departamento, count(DISTINCT E.sede) AS numero_sedes
FROM empleados E RIGHT JOIN departamentos D ON E.departamento=D.num
WHERE D.nombre LIKE "%Administraci%" OR D.nombre LIKE "%Ventas%"
GROUP BY D.num; -- TODO!!


/* 206. NÃºmero de sedes en que estÃ¡ presentes el departamento "Dep1: AdministraciÃ³n" */

SELECT D.nombre AS departamento, count(DISTINCT sede) AS num_sedes
FROM empleados E JOIN departamentos D ON E.departamento=D.num
WHERE D.nombre="Dep1: AdministraciÃ³n";



/* 209. PARA LOS EMPLEADOS QUE TIENEN ASIGNADO SUPERVISOR OBTENER:
NOMBRE, SALARIO, NOMBRE DE SU DEPARTAMENTO, Y NOMBRE Y 
SALARIO DE SU DIRECTOR */

SELECT concat(E.nombre,' ',E.apellidos) AS empleado,
	E.salario AS salario_empleado,
	D.nombre AS departamento,
	concat(DIR.nombre,' ',DIR.apellidos) AS director,
	DIR.salario AS salario_director
FROM empleados E LEFT JOIN departamentos D ON E.departamento=D.num
	LEFT JOIN empleados DIR ON D.director=DIR.id
WHERE E.supervisor IS NOT NULL AND E.supervisor!=E.id;


/* 210. PARA LOS EMPLEADOS QUE TIENEN ASIGNADO SUPERVISOR OBTENER:
NOMBRE, SALARIO, NOMBRE DE SU DEPARTAMENTO, NOMBRE Y 
SALARIO DE SU DIRECTOR, y nombre y salario de su supervisor */


SELECT concat(E.nombre,' ',E.apellidos) AS empleado,
	E.salario AS salario_empleado,
	D.nombre AS departamento,
	concat(DIR.nombre,' ',DIR.apellidos) AS director,
	DIR.salario AS salario_director,
	concat(SUP.nombre,' ',SUP.apellidos) AS supervisor,
	SUP.salario AS salario_supervisor
FROM empleados E LEFT JOIN departamentos D ON E.departamento=D.num
	LEFT JOIN empleados DIR ON D.director=DIR.id
	LEFT JOIN empleados SUP ON E.supervisor=SUP.id 
WHERE E.supervisor IS NOT NULL AND E.supervisor!=E.id;


SELECT concat(E.nombre,' ',E.apellidos) AS empleado,
	E.salario AS salario_empleado,
	D.nombre AS departamento,
	concat(DIR.nombre,' ',DIR.apellidos) AS director,
	DIR.salario AS salario_director,
	concat(SUP.nombre,' ',SUP.apellidos) AS supervisor,
	SUP.salario AS salario_supervisor
FROM empleados E JOIN empleados SUP ON E.supervisor=SUP.id 
	LEFT JOIN departamentos D ON E.departamento=D.num
	LEFT JOIN empleados DIR ON D.director=DIR.id
WHERE E.supervisor!=E.id;


	
/* 210b. Como la anterior, pero para todos los empleados */

SELECT concat(E.nombre,' ',E.apellidos) AS empleado,
	E.salario AS salario_empleado,
	D.nombre AS departamento,
	concat(DIR.nombre,' ',DIR.apellidos) AS director,
	DIR.salario AS salario_director,
	concat(SUP.nombre,' ',SUP.apellidos) AS supervisor,
	SUP.salario AS salario_supervisor
FROM empleados E LEFT JOIN empleados SUP ON E.supervisor=SUP.id 
	LEFT JOIN departamentos D ON E.departamento=D.num
	LEFT JOIN empleados DIR ON D.director=DIR.id;

	
	
/* 211. Listar todos los nombres de familiares, junto con el nombre del empleado 
 del que son familiares */

SELECT concat(f.nombre, " ", f.apellidos) AS familiar,
	 concat(e.nombre, " ", e.apellidos) AS empleado
FROM familiares f LEFT JOIN familiares_emp fe ON f.id=fe.familiar
	LEFT JOIN empleados e ON e.id=fe.empleado;

	
/* 212- POR CADA PROYECTO QUE TENGA AL MENOS UN EMPLEADO TRABAJANDO EN Ã‰L
    OBTENER SU CLAVE Y NOMBRE, NOMBRE DEL DEPARTAMENTO QUE LO CREA, 
   CANTIDAD DE EMPLEADOS TRABAJANDO EN EL PROYECTO */

SELECT P.id, P.nombre, D.nombre AS departamento, count(PE.empleado) AS num_empleados 
FROM proyectos P JOIN proyectos_empleados PE ON P.id=PE.proyecto
	JOIN departamentos D ON P.dept_coord=D.num
GROUP BY P.id ;

	
SELECT proyecto AS clave, P.nombre, D.nombre AS departamento, count(*) AS num_empleados
FROM proyectos_empleados PE JOIN proyectos P ON P.id=PE.proyecto
	JOIN departamentos D ON d.num=P.dept_coord 
GROUP BY proyecto;

/* Al excluir el enunciado los proyectos sin empleados, no es necesario hacer un OUTER JOIN */	




/* 212b- POR CADA PROYECTO OBTENER SU CLAVE Y NOMBRE, NOMBRE DEL DEPARTAMENTO QUE LO CREA (si lo hay), 
   y CANTIDAD DE EMPLEADOS TRABAJANDO EN EL PROYECTO */


SELECT P.id, P.nombre, D.nombre AS departamento, count(PE.empleado) AS num_empleados 
FROM proyectos P LEFT JOIN proyectos_empleados PE ON P.id=PE.proyecto
	JOIN departamentos D ON P.dept_coord=D.num
GROUP BY P.id ;






/*****************/


/* Empleados ------- Departamentos ----- Directores */

SELECT E.nombre, D.nombre, DIR.nombre 
FROM empleados E LEFT JOIN departamentos D ON E.departamento=D.num
	LEFT JOIN empleados DIR ON D.director=DIR.id;


/* Proyecto ----- proyectos_empleados
 	   |
       |--- departamentos */

SELECT P.nombre, PE.empleado 
FROM proyectos P LEFT JOIN proyectos_empleados PE ON P.id=PE.proyecto
 JOIN departamentos D ON P.dept_coord=D.num



	
SELECT proyecto AS clave, P.nombre, D.nombre AS departamento, count(*) AS num_empleados
FROM proyectos_empleados PE RIGHT JOIN proyectos P ON P.id=PE.proyecto
	LEFT JOIN departamentos D ON d.num=P.dept_coord 
GROUP BY proyecto;



/* 213. PARA CADA EMPLEADO OBTENER SU NOMBRE, EL NOMBRE DE SU DIRECTOR 
 * Y LA CANTIDAD DE PROYECTOS EN LOS QUE TRABAJA. */

SELECT concat(E.nombre, " ", E.apellidos) AS empleado,
	 COALESCE(concat(DIR.nombre, " ", DIR.apellidos), "No tiene") AS director,
	 count(PE.proyecto) AS num_proyectos
FROM empleados E JOIN departamentos D ON E.departamento=D.num -- 1:N dept de cada empl.
	LEFT JOIN empleados DIR ON D.director=DIR.id   -- 1:1 director de dept.
	LEFT JOIN proyectos_empleados PE ON E.id=PE.empleado
GROUP BY E.id;



/* 214. Como la anterior pero solo para proyectos que aÃºn no han terminado.*/

SELECT concat(E.nombre, " ", E.apellidos) AS empleado,
	 COALESCE(concat(DIR.nombre, " ", DIR.apellidos), "No tiene") AS director,
	 count(PE.proyecto) AS "NÃºmero de proyectos"
FROM empleados E JOIN departamentos D ON E.departamento=D.num -- 1:N dept de cada empl.
	LEFT JOIN empleados DIR ON D.director=DIR.id   -- 1:1 director de dept.
	LEFT JOIN proyectos_empleados PE ON E.id=PE.empleado
	LEFT JOIN proyectos P ON PE.proyecto=P.id 
WHERE P.fecha_fin IS NULL OR P.fecha_fin>curdate()   -- Comprobamos proyectos activos
GROUP BY E.id;



/* 215. PARA CADA supervisor OBTENER SU NOMBRE, EL NOMBRE DE SU DIRECTOR 
 * Y LA CANTIDAD DE PROYECTOS EN LOS QUE TRABAJA. */

WITH claves_supervisor AS (
	SELECT DISTINCT supervisor
	FROM empleados
	WHERE supervisor IS NOT NULL)
SELECT SUP.id, concat(SUP.nombre, " ", SUP.apellidos) AS supervisor,
	COALESCE(concat(DIR.nombre, " ", DIR.apellidos), "No tiene") AS director,
	count(PE.proyecto) AS "NÃºmero de proyectos"
FROM empleados SUP JOIN departamentos D ON SUP.departamento=D.num -- 1:N dept de cada empl.
	LEFT JOIN empleados DIR ON D.director=DIR.id   -- 1:1 director de dept.
	LEFT JOIN proyectos_empleados PE ON SUP.id=PE.empleado
WHERE SUP.id IN (SELECT * FROM claves_supervisor)
GROUP BY SUP.id;


WITH supervisores AS (
	SELECT DISTINCT SUP.id, SUP.nombre, SUP.apellidos, SUP.departamento 
	FROM empleados E JOIN empleados SUP ON E.supervisor=SUP.id
	WHERE E.supervisor IS NOT NULL
)
SELECT concat(SUP.nombre, " ", SUP.apellidos) AS supervisor,
	COALESCE(concat(DIR.nombre, " ", DIR.apellidos), "No tiene") AS director,
	count(PE.proyecto) AS "NÃºmero de proyectos"
FROM supervisores SUP JOIN departamentos D ON SUP.departamento=D.num -- 1:N dept de cada empl.
	LEFT JOIN empleados DIR ON D.director=DIR.id   -- 1:1 director de dept.
	LEFT JOIN proyectos_empleados PE ON SUP.id=PE.empleado
GROUP BY SUP.id;



DROP VIEW IF EXISTS supervisores;
CREATE VIEW supervisores AS (
	SELECT DISTINCT SUP.id, SUP.nombre, SUP.apellidos, SUP.departamento 
	FROM empleados E JOIN empleados SUP ON E.supervisor=SUP.id
	WHERE E.supervisor IS NOT NULL
);
SELECT concat(SUP.nombre, " ", SUP.apellidos) AS supervisor,
	COALESCE(concat(DIR.nombre, " ", DIR.apellidos), "No tiene") AS director,
	count(PE.proyecto) AS "NÃºmero de proyectos"
FROM supervisores SUP JOIN departamentos D ON SUP.departamento=D.num -- 1:N dept de cada empl.
	LEFT JOIN empleados DIR ON D.director=DIR.id   -- 1:1 director de dept.
	LEFT JOIN proyectos_empleados PE ON SUP.id=PE.empleado
GROUP BY SUP.id;





SELECT SUP.nombre, SUP.apellidos,
	CONCAT(DIR.nombre," ",DIR.apellidos) AS director,
	count(proyecto) AS proyectos 
FROM (SELECT SUP.id, SUP.nombre, SUP.apellidos, SUP.departamento
		FROM empleados E INNER JOIN empleados SUP ON E.supervisor=SUP.id
			-- Supervisores son solo los presentes en la FK, asÃ­ que tiene que ser INNER
		GROUP BY SUP.id) SUP
	LEFT JOIN departamentos DEP ON SUP.departamento=DEP.num
	LEFT JOIN empleados DIR ON DEP.director=DIR.id
	LEFT JOIN proyectos_empleados PE ON PE.empleado = SUP.id
GROUP BY SUP.id


SELECT SUP.nombre, SUP.apellidos, DIR.nombre AS director, count(DISTINCT proyecto)
FROM empleados E INNER JOIN empleados SUP ON SUP.id=E.supervisor 
	-- INNER JOIN ya garantiza que solo sean los empleados que son supervisores
	join departamentos DEP ON SUP.departamento=DEP.num -- 1:N dept de cada empl.
	join empleados DIR ON DIR.id=DEP.director  -- 1:1 director de dept.
	LEFT join proyectos_empleados PE ON PE.empleado=SUP.id
GROUP BY SUP.id;
	



/* --------------------------------------------------------------
 *  216. Supervisores con su salario y con el salario mÃ¡ximo de sus supervisados */
					
	/* Empleados que tienen supervisor */
	SELECT id, nombre, apellidos, supervisor 
	FROM empleados
	WHERE supervisor IS NOT NULL AND supervisor<>id
	-- Si se supervisa a sÃ­ mismo no lo consideramos ni supervisor ni supervisado

	/* Listado de claves de supervisores: */
	SELECT DISTINCT supervisor
	FROM empleados
	WHERE supervisor IS NOT NULL AND supervisor<>id

	/* Salario mÃ¡ximo de los supervisados de cada supervisor */
	SELECT supervisor, max(salario)
	FROM empleados
	WHERE supervisor IS NOT NULL AND supervisor!=id
	GROUP BY supervisor;


SELECT concat(SUP.nombre,' ',SUP.apellidos) AS supervisor, 
	SUP.salario,
	max(E.salario) AS max_salario_supervisados
FROM empleados E INNER JOIN empleados SUP ON E.supervisor=SUP.id
WHERE E.supervisor<>E.id
GROUP BY E.supervisor;


WITH list_PKs_supervisores AS (
	SELECT DISTINCT supervisor
	FROM empleados
	WHERE supervisor IS NOT NULL AND supervisor!=id
)
,datos_supervisores AS (
	SELECT id, concat(nombre,' ',apellidos) AS supervisor, salario
	FROM empleados
	WHERE id IN (SELECT *  FROM list_PKs_supervisores)
),
sal_max_supervisados AS (
	SELECT supervisor, max(salario) AS max_salar_supervisados
	FROM empleados
	WHERE supervisor IS NOT NULL AND supervisor!=id
	GROUP BY supervisor
)
SELECT SUP.supervisor, SUP.salario, max_salar_supervisados
FROM datos_supervisores SUP JOIN sal_max_supervisados SM ON SUP.id = SM.supervisor;
		



/* 217. Supervisores sin proyectos, asignados con su salario */




/* Creo una vista de supervisores */
CREATE VIEW supervisores AS
	WITH list_PKs_supervisores AS (
		SELECT DISTINCT supervisor
		FROM empleados
		WHERE supervisor IS NOT NULL AND supervisor!=id
	)
	SELECT id, concat(nombre,' ',apellidos) AS supervisor, salario
	FROM empleados
	WHERE id IN (SELECT *  FROM list_PKs_supervisores)
;

SELECT *
FROM supervisores
WHERE id NOT IN ( SELECT DISTINCT empleado
				FROM proyectos_empleados PE)

				
SELECT DISTINCT SUP.nombre, SUP.apellidos, SUP.salario
FROM empleados E INNER JOIN empleados SUP ON SUP.id=E.supervisor
	LEFT JOIN proyectos_empleados PE ON SUP.id = PE.empleado
WHERE PE.proyecto IS NULL;
					
SELECT DISTINCT SUP.nombre, SUP.apellidos, SUP.salario
FROM empleados E INNER JOIN empleados SUP ON SUP.id=E.supervisor
WHERE SUP.id NOT IN (SELECT DISTINCT empleado
						FROM proyectos_empleados);
					
					
					
					
					*********


/* 217b. Supervisores con proyectos asignados con su salario */

SELECT DISTINCT SUP.nombre, SUP.apellidos, SUP.salario
FROM empleados E INNER JOIN empleados SUP ON SUP.id=E.supervisor
	JOIN proyectos_empleados PE ON SUP.id = PE.empleado

	
	
			
/* 218. Cada departamento con el salario medio de todos sus empleados
 * y con el de solo los supervisados */

SELECT E.departamento,
	FORMAT(max(E.salario),2) AS salario_medio_general,
	FORMAT(max(supervisados.salario),2) AS salario_medio_supervisados
FROM empleados E
	LEFT JOIN (SELECT *
			FROM empleados
			WHERE supervisor IS NOT NULL) supervisados
	ON supervisados.id=E.id
GROUP BY departamento;


/* 219. Todos los empleados (su nombre) con el nombre de su director, 
 * la cantidad de proyecto en que trabaja Y LA CANTIDAD TOTAL DE HORAS TRABAJADAS, 
 * tengan o no proyectos asignados, o sea, tambiÃ©n con aquellos que tengan 0 proyectos */

SELECT E.nombre, E.apellidos,
	concat(DIR.nombre, ' ', DIR.apellidos) AS director,
	count(PE.proyecto) AS num_proyectos,
	COALESCE( sum(time_to_sec(PE.horas))/3600, 0) AS horas_trabajadas
FROM empleados E LEFT JOIN departamentos D ON E.departamento=D.num
	LEFT JOIN empleados DIR ON D.director=DIR.id
	LEFT JOIN proyectos_empleados PE ON PE.empleado=E.id
GROUP BY E.id
/* COALESCE() devuelve el primer valor que no sea null de una lista de parÃ¡metros
https://www.w3schools.com/sql/func_mysql_coalesce.asp */



/* 220. PARA CADA EMPLEADO QUE ES SUPERVISOR, SU CLAVE, SU NOMBRE 
 * Y LA CANTIDAD DE EMPLEADOS A LOS QUE SUPERVISA */

SELECT E.supervisor AS clave, CONCAT(SUP.nombre," ",SUP.apellidos) AS nombre, 
	count(E.id) AS supervisados
FROM empleados E INNER JOIN empleados SUP ON E.supervisor=SUP.id
GROUP BY E.supervisor 


/* 221- OBTENER PARA CADA EMPLEADO EN LA EMPRESA:
     SU NOMBRE Y SALARIO,
     EL NOMBRE Y SALARIO DEL DIRECTOR DE SU DEPARTAMENTO,
     LA CANTIDAD DE PROYECTOS ASIGNADOS */


SELECT CONCAT(E.nombre," ",E.apellidos) AS Nombre,
	E.salario,
	CONCAT(DIR.nombre," ",DIR.apellidos) AS "Nombre Director",
	DIR.salario AS "Salario Director",
	count(PE.proyecto) AS "Proyectos"	
FROM empleados E LEFT JOIN departamentos D ON E.departamento=D.num
	LEFT JOIN empleados DIR ON D.director=DIR.id
	LEFT JOIN proyectos_empleados PE ON E.id=PE.empleado
GROUP BY E.id










/* 221- OBTENER PARA CADA EMPLEADO EN LA EMPRESA:
     SU NOMBRE Y SALARIO,
     EL NOMBRE Y SALARIO DEL DIRECTOR DE SU DEPARTAMENTO,
     LA CANTIDAD DE PROYECTOS ASIGNADOS EN LA ACTUALIDAD */


WITH proyectos_actuales AS 
(	SELECT empleado, count(proyecto) AS proyectos	
	FROM proyectos_empleados 
	WHERE fbaja IS NULL OR fbaja>CURDATE()
	GROUP BY empleado
)
SELECT CONCAT(E.nombre," ",E.apellidos) AS Nombre,
	E.salario,
	CONCAT(DIR.nombre," ",DIR.apellidos) AS "Nombre Director",
	DIR.salario AS "Salario Director",
	COALESCE(PA.proyectos, 0) AS "Proyectos actuales" 	
FROM empleados E LEFT JOIN departamentos D ON E.departamento=D.num
	LEFT JOIN empleados DIR ON D.director=DIR.id
	LEFT JOIN proyectos_actuales PA ON E.id=PA.empleado


WITH proyectos_actuales AS 
(	SELECT empleado, proyecto
	FROM proyectos_empleados pe 
	WHERE PE.fbaja IS NULL OR PE.fbaja>CURDATE()
)
SELECT CONCAT(E.nombre," ",E.apellidos) AS Nombre,
	E.salario,
	CONCAT(DIR.nombre," ",DIR.apellidos) AS "Nombre Director",
	DIR.salario AS "Salario Director",
	count(PE.proyecto) AS "Proyectos actuales" 	
FROM empleados E LEFT JOIN departamentos D ON E.departamento=D.num
	LEFT JOIN empleados DIR ON D.director=DIR.id
	LEFT JOIN proyectos_actuales PE ON E.id=PE.empleado
GROUP BY E.id


SELECT CONCAT(E.nombre," ",E.apellidos) AS Nombre,
	E.salario,
	CONCAT(DIR.nombre," ",DIR.apellidos) AS "Nombre Director",
	DIR.salario AS "Salario Director",
	( SELECT count(*) 
	FROM proyectos_empleados PE
	WHERE E.id=PE.empleado AND
		(PE.fbaja IS NULL OR PE.fbaja>CURDATE())
		) AS "Proyectos actuales"
FROM empleados E LEFT JOIN departamentos D ON E.departamento=D.num
	LEFT JOIN empleados DIR ON D.director=DIR.id
	LEFT JOIN proyectos_empleados PE ON E.id=PE.empleado
GROUP BY E.id


SELECT CONCAT(E.nombre," ",E.apellidos) AS Nombre,
	E.salario,
	CONCAT(DIR.nombre," ",DIR.apellidos) AS "Nombre Director",
	DIR.salario AS "Salario Director",
	SUM( PE.fbaja>CURDATE() OR 
			(PE.fbaja IS NULL AND PE.empleado IS NOT NULL)
		) AS "Proyectos actuales"
FROM empleados E LEFT JOIN departamentos D ON E.departamento=D.num
	LEFT JOIN empleados DIR ON D.director=DIR.id
GROUP BY E.id



	
/* 222. MISMO INFORME, AÃ‘ADiendo
     NOMBRE DE SU SUPERVISOR 
     Y CANTIDAD DE FAMILIARES REGISTRADOS */


WITH proyectos_actuales AS 
(	SELECT empleado, proyecto	
	FROM proyectos_empleados 
	WHERE fbaja IS NULL OR fbaja>CURDATE()
)
SELECT CONCAT(E.nombre," ",E.apellidos) AS Nombre,
	E.salario,
	CONCAT(DIR.nombre," ",DIR.apellidos) AS "Nombre Director",
	DIR.salario AS "Salario Director",
	count(DISTINCT PA.proyecto) AS "Proyectos actuales",
	CONCAT(SUP.nombre," ",SUP.apellidos) AS "Nombre Supervisor",
	count(familiar)
FROM empleados E LEFT JOIN departamentos D ON E.departamento=D.num
	LEFT JOIN empleados DIR ON D.director=DIR.id
	LEFT JOIN proyectos_actuales PA ON E.id=PA.empleado
	LEFT JOIN empleados SUP ON E.supervisor=SUP.id
	LEFT JOIN familiares_emp F ON E.id=F.empleado
GROUP BY E.id


WITH proyectos_actuales AS 
(	SELECT empleado, count(proyecto) AS proyectos	
	FROM proyectos_empleados 
	WHERE fbaja IS NULL OR fbaja>CURDATE()
	GROUP BY empleado
)
SELECT CONCAT(E.nombre," ",E.apellidos) AS Nombre,
	E.salario,
	CONCAT(DIR.nombre," ",DIR.apellidos) AS "Nombre Director",
	DIR.salario AS "Salario Director",
	COALESCE(PA.proyectos, 0) AS "Proyectos actuales",
	CONCAT(SUP.nombre," ",SUP.apellidos) AS "Nombre Supervisor",
	count(familiar)
FROM empleados E LEFT JOIN departamentos D ON E.departamento=D.num
	LEFT JOIN empleados DIR ON D.director=DIR.id
	LEFT JOIN proyectos_actuales PA ON E.id=PA.empleado
	LEFT JOIN empleados SUP ON E.supervisor=SUP.id
	LEFT JOIN familiares_emp F ON E.id=F.empleado
GROUP BY E.id
	


/* 223 - MISMO INFORME, SÓLO PARA LOS EMPLEADOS 
    DE MÁS DE 9 HORAS EN TOTAL DE TRABAJO EN PROYECTOS
    CONDICIÓN DE GRUPO**/


WITH proyectos_actuales AS 
(	SELECT empleado, count(proyecto) AS proyectos, sec_to_time(sum(time_to_sec(horas))) AS segundos_total 
	FROM proyectos_empleados 
	WHERE fbaja IS NULL OR fbaja>CURDATE()
	GROUP BY empleado 
)
SELECT CONCAT(E.nombre," ",E.apellidos) AS Nombre,
	E.salario,
	CONCAT(DIR.nombre," ",DIR.apellidos) AS "Nombre Director",
	DIR.salario AS "Salario Director",
	COALESCE(PA.proyectos, 0) AS "Proyectos actuales",
	CONCAT(SUP.nombre," ",SUP.apellidos) AS "Nombre Supervisor",
	count(familiar)
FROM empleados E LEFT JOIN departamentos D ON E.departamento=D.num
	LEFT JOIN empleados DIR ON D.director=DIR.id
	LEFT JOIN proyectos_actuales PA ON E.id=PA.empleado
	LEFT JOIN empleados SUP ON E.supervisor=SUP.id
	LEFT JOIN familiares_emp F ON E.id=F.empleado
WHERE PA.segundos_total > 9*3600
GROUP BY E.id;

/* 
SELECT empleado, time_format(sec_to_time(sum(time_to_sec(horas))), "%H:%i")
FROM proyectos_empleados pe 
GROUP BY empleado
*/



/* 224. Mostrar el Ãºltimo empleado en incorporarse a cada proyecto */

SELECT ultimo, e.nombre AS empleado, p.nombre AS proyecto
FROM (SELECT max(fincorporacion) AS ultimo, proyecto
		FROM proyectos_empleados
		GROUP BY proyecto) AS aux
	JOIN proyectos_empleados pe ON aux.ultimo = pe.fincorporacion 
								AND aux.proyecto = pe.proyecto
JOIN proyectos p ON aux.proyecto = p.id
JOIN empleados e ON pe.empleado = e.id



WITH aux AS (
	SELECT proyecto, max(fincorporacion) AS fecha_ultima
	FROM proyectos_empleados PE
	GROUP BY proyecto
)
, aux2 AS (
	SELECT PE.proyecto, PE.empleado, PE.fincorporacion
	FROM proyectos_empleados PE, aux
	WHERE PE.proyecto=aux.proyecto AND PE.fincorporacion=aux.fecha_ultima
)
SELECT P.nombre,
	COALESCE( CONCAT(E.nombre,' ',E.apellidos), "Sin empleados") AS empleado
FROM proyectos P LEFT JOIN aux2 ON P.id=aux2.proyecto
	LEFT JOIN empleados E ON aux2.empleado=E.id;




/* 225. Todos los departamentos con su nÃºmero de empleados, mostrando tambiÃ©n el nÃºmero
 * de empleados sin departamento asignado y considerando empleados sin departamento y
 * departamentos sin empleados
 */


(
SELECT D.nombre, count(E.id) AS num_empl
FROM empleados E RIGHT JOIN departamentos D ON E.departamento=D.num
GROUP BY E.departamento
)
UNION
(
SELECT COALESCE(D.nombre, "Sin departamento"), count(*)
FROM departamentos D RIGHT JOIN empleados E ON D.num=E.departamento
GROUP BY E.departamento
);


WITH empl_dept AS (
	SELECT departamento, count(*) AS num_empl
	FROM empleados
	GROUP BY departamento
)
(
SELECT D.nombre, COALESCE(num_empl, 0)
FROM departamentos D LEFT JOIN empl_dept ED ON D.num=ED.departamento
)
UNION -- EmulaciÃ³n de un FULL JOIN
(
SELECT COALESCE(D.nombre, "Sin departamento"), num_empl
FROM departamentos D RIGHT JOIN empl_dept ED ON D.num=ED.departamento
);









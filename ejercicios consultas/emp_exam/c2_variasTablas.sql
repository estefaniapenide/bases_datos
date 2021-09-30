/* -----------------------------------------------------------------------
----- 2. CONSULTAS DE VARIAS TABLAS -----
----------------------------------------------------------------------- */

/* 201. DE CADA EMPLEADO, mostrar su NOMBRE, SALARIO, NOMBRE DEL DEPARTAMENTO 
AL QUE ESTÃ¡ ASIGNADO Y CLAVE DE SU DIRECTOR DE DEPARTAMENTO */

SELECT concat(E.nombre,' ',E.apellidos) AS empleado, E.salario, D.nombre, D.director
FROM empleados E JOIN departamentos D ON E.departamento = D.num;

/* Si considerÃ¡semnos que un empleado puede tener departamento a NULL (no es el caso), habrÃ­a
 * que usar un LEFT JOIN para poder incluir a todos los empleados:
 */


/* 202. Mostrar PARA CADA DEPARTAMENTO (por su NOMBRE) 
 * EL NOMBRE Y SALARIO DE SU DIRECTOR */

SELECT D.nombre AS departamento, concat(E.nombre,' ',E.apellidos) AS director, E.salario
FROM empleados E LEFT JOIN departamentos D ON D.director=E.id 
GROUP BY D.nombre;

/* 202b. DE CADA EMPLEADO, mostrar su NOMBRE, SALARIO, NOMBRE DEL DEPARTAMENTO 
AL QUE ESTÃ¡ ASIGNADO Y nombre DE SU DIRECTOR DE DEPARTAMENTO */


SELECT concat(E.nombre,' ',E.apellidos) AS empleado,
	E.salario,
	D.nombre AS deparatamento,
	concat(DIR.nombre,' ',DIR.apellidos) AS director
FROM empleados E LEFT JOIN departamentos D ON E.departamento=D.num
	LEFT JOIN empleados DIR ON D.director=DIR.id;



/* 203. NÃºmero de sedes en que estÃ¡ presente cada departamento (identificado por su nombre)*/
	
SELECT D.nombre AS departamento,
	count(DISTINCT E.sede) AS "Número de sedes"		
FROM empleados E RIGHT JOIN departamentos D ON E.departamento = D.num
GROUP BY departamento;


/* 204. NÃºmero de sedes en que estÃ¡n presentes los departamentos 1 y 6, 
para cada uno de ellos mostrando su nombre */

SELECT D.nombre AS departamento,
	count(DISTINCT E.sede) AS "Número de sedes"		
FROM empleados E RIGHT JOIN departamentos D ON E.departamento = D.num
WHERE D.num=1 OR D.num=6
GROUP BY departamento;


/* 205. NÃºmero de sedes en que estÃ¡n presentes los departamentos de AdministraciÃ³n 
 * y Ventas */

SELECT D.nombre AS departamento,
	count(DISTINCT E.sede) AS "Número de sedes"		
FROM empleados E RIGHT JOIN departamentos D ON E.departamento = D.num
WHERE D.nombre LIKE '%administrac%' OR D.nombre LIKE '%ventas%'
GROUP BY departamento;


/* 206. NÃºmero de sedes en que estÃ¡ presentes el departamento "Dep1: AdministraciÃ³n" */

SELECT D.nombre AS departamento,
	count(DISTINCT E.sede) AS "Número de sedes"		
FROM empleados E RIGHT JOIN departamentos D ON E.departamento = D.num
WHERE D.nombre LIKE 'Dep1: administraci%'
GROUP BY departamento;

/* 209. PARA LOS EMPLEADOS QUE TIENEN ASIGNADO SUPERVISOR OBTENER:
NOMBRE, SALARIO, NOMBRE DE SU DEPARTAMENTO, Y NOMBRE Y 
SALARIO DE SU DIRECTOR */

SELECT concat(E.nombre,' ',E.apellidos) AS empleado,
	E.salario AS salario_empleado,
	D.nombre AS departamento,
 	concat(DIR.nombre,' ',DIR.apellidos) AS director,
 	DIR.salario AS salario_director
FROM empleados E LEFT JOIN departamentos D ON D.num=E.departamento 
	LEFT JOIN empleados DIR ON D.director=DIR.id
WHERE E.supervisor IS NOT NULL AND E.supervisor!=E.id;

/* 210. PARA LOS EMPLEADOS QUE TIENEN ASIGNADO SUPERVISOR OBTENER:
NOMBRE, SALARIO, NOMBRE DE SU DEPARTAMENTO, NOMBRE Y 
SALARIO DE SU DIRECTOR, y nombre y salario de su supervisor */

SELECT concat(E.nombre,' ',E.apellidos) AS empleado,
	E.salario AS salario_empleado,
	D.nombre AS departamento,
 	concat(DIR.nombre,' ',DIR.apellidos) AS director,
 	DIR.salario AS salrio_director,
 	concat(SUP.nombre,' ',SUP.apellidos) AS supervisor,
 	sup.salario AS salario_supervisor
FROM empleados E LEFT JOIN departamentos D ON D.num=E.departamento 
	LEFT JOIN empleados DIR ON D.director=DIR.id 
	LEFT JOIN empleados SUP ON SUP.id=E.supervisor
WHERE E.supervisor IS NOT NULL AND E.supervisor!=E.id;
	
/* 210b. Como la anterior, pero para todos los empleados */

SELECT concat(E.nombre,' ',E.apellidos) AS empleado,
	E.salario AS salario_empleado,
	D.nombre AS departamento,
 	concat(DIR.nombre,' ',DIR.apellidos) AS director,
 	DIR.salario AS salrio_director,
 	concat(SUP.nombre,' ',SUP.apellidos) AS supervisor,
 	sup.salario AS salario_supervisor
FROM empleados E LEFT JOIN departamentos D ON D.num=E.departamento 
	LEFT JOIN empleados DIR ON D.director=DIR.id 
	LEFT JOIN empleados SUP ON SUP.id=E.supervisor;
	
/* 211. Listar todos los nombres de familiares, junto con el nombre del empleado 
 del que son familiares */

SELECT concat(F.nombre," ",F.apellidos) AS familiar,
	concat(E.nombre," ",E.apellidos) AS empleado
FROM familiares F LEFT JOIN familiares_emp FE ON F.id=FE.familiar 
	LEFT JOIN empleados E ON E.id=FE.empleado;

	
/* 212- POR CADA PROYECTO QUE TENGA AL MENOS UN EMPLEADO TRABAJANDO EN Ã‰L
    OBTENER SU CLAVE Y NOMBRE, NOMBRE DEL DEPARTAMENTO QUE LO CREA, 
   CANTIDAD DE EMPLEADOS TRABAJANDO EN EL PROYECTO */

SELECT P.id AS clave, P.nombre AS proyecto, D.nombre AS departamento, count(PE.empleado) AS "N�mero de empleados"
FROM proyectos P JOIN proyectos_empleados PE ON P.id=PE.proyecto
	JOIN departamentos D ON D.num=P.dept_coord 
GROUP BY P.id;

/* 212b- POR CADA PROYECTO OBTENER SU CLAVE Y NOMBRE, NOMBRE DEL DEPARTAMENTO QUE LO CREA (si lo hay), 
   y CANTIDAD DE EMPLEADOS TRABAJANDO EN EL PROYECTO */

SELECT P.id AS clave, P.nombre AS proyecto, D.nombre AS departamento, count(PE.empleado) AS "N�mero de empleados"
FROM proyectos P LEFT JOIN proyectos_empleados PE ON P.id=PE.proyecto
	JOIN departamentos D ON D.num=P.dept_coord 
GROUP BY P.id;



/* 213. PARA CADA EMPLEADO OBTENER SU NOMBRE, EL NOMBRE DE SU DIRECTOR 
 * Y LA CANTIDAD DE PROYECTOS EN LOS QUE TRABAJA. */

SELECT concat(E.nombre," ",E.apellidos) AS empleado,
		COALESCE (concat(DIR.nombre," ",DIR.apellidos),"No tiene") AS director,
		count(PE.proyecto) AS "N�mero de proyectos"
FROM empleados E LEFT JOIN departamentos D ON E.departamento=D.num 
	LEFT JOIN empleados DIR ON DIR.id=D.director
	LEFT JOIN proyectos_empleados PE ON PE.empleado=E.id 
GROUP BY E.id;



/* 214. Como la anterior pero solo para proyectos que aÃºn no han terminado.*/

SELECT concat(E.nombre," ",E.apellidos) AS empleado,
		COALESCE (concat(DIR.nombre," ",DIR.apellidos),"No tiene") AS director,
		count(PE.proyecto) AS "N�mero de proyectos"
FROM empleados E LEFT JOIN departamentos D ON E.departamento=D.num 
	LEFT JOIN empleados DIR ON DIR.id=D.director
	LEFT JOIN proyectos_empleados PE ON PE.empleado=E.id 
	LEFT JOIN proyectos P ON PE.proyecto=P.id
WHERE P.fecha_fin > curdate() OR P.fecha_fin IS NULL
GROUP BY E.id;



/* 215. PARA CADA supervisor OBTENER SU NOMBRE, EL NOMBRE DE SU DIRECTOR 
 * Y LA CANTIDAD DE PROYECTOS EN LOS QUE TRABAJA. */

SELECT DISTINCT concat(SUP.nombre," ",SUP.apellidos)	AS supervisor,
	COALESCE(concat(DIR.nombre," ",DIR.apellidos),"No tiene") AS director,
	count(PE.proyecto) AS "N�mero de proyectos"
FROM empleados E JOIN empleados SUP ON E.supervisor=SUP.id 
	LEFT JOIN departamentos D ON SUP.departamento =D.num 
	LEFT JOIN empleados DIR ON DIR.id=D.director
	LEFT JOIN proyectos_empleados PE ON PE.empleado =SUP.id
WHERE E.supervisor!=E.id
GROUP BY SUP.id;




/* --------------------------------------------------------------
 *  216. Supervisores con su salario y con el salario mÃ¡ximo de sus supervisados */

SELECT concat(SUP.nombre," ",SUP.apellidos) AS supervisor,
	SUP.salario,
	max(E.salario) AS "Salario max de sus supervisados"
FROM empleados E JOIN empleados SUP ON E.supervisor=SUP.id	
WHERE E.supervisor!=E.id
GROUP BY supervisor;


/* 217. Supervisores sin proyectos, asignados con su salario */

SELECT concat(SUP.nombre," ",SUP.apellidos) as supervisores_sin_proyectos,
	SUP.salario
FROM empleados E JOIN empleados SUP ON E.supervisor=SUP.id
	LEFT JOIN proyectos_empleados PE ON PE.empleado=SUP.id 
WHERE E.supervisor!=E.id AND PE.empleado IS NULL
GROUP BY supervisores_sin_proyectos;


/* 217b. Supervisores con proyectos asignados con su salario */

SELECT concat(SUP.nombre," ",SUP.apellidos) as supervisores_sin_proyectos,
	SUP.salario
FROM empleados E JOIN empleados SUP ON E.supervisor=SUP.id
	JOIN proyectos_empleados PE ON PE.empleado=SUP.id 
WHERE E.supervisor!=E.id
GROUP BY supervisores_sin_proyectos;
	
	
			
/* 218. Cada departamento con el salario medio de todos sus empleados
 * y con el de solo los supervisados */

SELECT D.nombre AS departamento,
	format(avg(E.salario),2) AS "Salario medio",
	format(avg(supervisados.salario),2) AS "Salario medio de los supervisados"
FROM empleados E 
	LEFT JOIN 
		(SELECT * 
		FROM empleados 
		WHERE supervisor IS NOT NULL ) AS supervisados 
	ON E.id=supervisados.id
	LEFT JOIN departamentos D ON D.num=E.departamento
GROUP BY departamento;



/* 219. Todos los empleados (su nombre) con el nombre de su director, 
 * la cantidad de proyecto en que trabaja Y LA CANTIDAD TOTAL DE HORAS TRABAJADAS, 
 * tengan o no proyectos asignados, o sea, tambiÃ©n con aquellos que tengan 0 proyectos */

SELECT concat(E.nombre," ",E.apellidos) AS empleado,
	concat(DIR.nombre," ",DIR.apellidos) AS director,
	count(PE.proyecto) AS "Cantidad de proyectos",
	COALESCE(sec_to_time(sum(time_to_sec(PE.horas))),"00:00:00") AS "Horas trabajadas"
FROM empleados E LEFT JOIN departamentos D ON D.num=E.departamento 
	LEFT JOIN empleados DIR ON DIR.id=D.director 
	LEFT JOIN proyectos_empleados PE ON PE.empleado=E.id
GROUP BY E.id;


/* 220. PARA CADA EMPLEADO QUE ES SUPERVISOR, SU CLAVE, SU NOMBRE 
 * Y LA CANTIDAD DE EMPLEADOS A LOS QUE SUPERVISA */

SELECT SUP.id AS clave,
	concat(SUP.nombre," ",SUP.apellidos) AS supervisor,
	count(supervisados.id) AS "N�mero de empleados que supervisa"
FROM empleados E JOIN empleados SUP ON E.supervisor=SUP.id
     LEFT JOIN 
     	(SELECT *
     	FROM empleados E
     	WHERE supervisor IS NOT NULL AND E.supervisor!=E.id) supervisados
     ON E.id=supervisados.id
WHERE E.supervisor!=E.id
GROUP BY SUP.id;
	

/* 221- OBTENER PARA CADA EMPLEADO EN LA EMPRESA:
     SU NOMBRE Y SALARIO,
     EL NOMBRE Y SALARIO DEL DIRECTOR DE SU DEPARTAMENTO,
     LA CANTIDAD DE PROYECTOS ASIGNADOS */
WITH proyectos_actuales AS
	(SELECT *
	FROM proyectos_empleados
	WHERE fbaja >curdate() AND fincorporacion <curdate()
	)
SELECT concat(E.nombre," ",E.apellidos) AS empleado,
	E.salario AS salario_empleado,
	COALESCE(concat(DIR.nombre," ",DIR.apellidos),"No tiene") AS director,
	COALESCE(DIR.salario,0) AS salario_director,
	count(PA.proyecto) AS num_proyectos
FROM empleados E LEFT JOIN departamentos D ON D.num=E.departamento 
	LEFT JOIN empleados DIR ON DIR.id=D.director 
	LEFT JOIN proyectos_actuales PA ON PA.empleado=E.id
GROUP BY E.id;
	
	

	
/* 222. MISMO INFORME, AÃ‘ADiendo
     NOMBRE DE SU SUPERVISOR 
     Y CANTIDAD DE FAMILIARES REGISTRADOS */

WITH proyectos_actuales AS
	(SELECT *
	FROM proyectos_empleados
	WHERE fbaja >curdate() AND fincorporacion <curdate()
	)
SELECT concat(E.nombre," ",E.apellidos) AS empleado,
	E.salario AS salario_empleado,
	COALESCE(concat(DIR.nombre," ",DIR.apellidos),"No tiene") AS director,
	COALESCE(DIR.salario,0) AS salario_director,
	count(PA.proyecto) AS num_proyectos,
	COALESCE(concat(SUP.nombre," ",SUP.apellidos),"No tiene") AS supervisor,
	count(FE.familiar) AS "N�mero de familiares registrados"
FROM empleados E LEFT JOIN departamentos D ON D.num=E.departamento 
	LEFT JOIN empleados DIR ON DIR.id=D.director 
	LEFT JOIN proyectos_actuales PA ON PA.empleado=E.id
	LEFT JOIN empleados SUP ON SUP.id=E.supervisor 
	LEFT JOIN familiares_emp FE ON FE.empleado=E.id
GROUP BY E.id;




/* 223 - MISMO INFORME, S�LO PARA LOS EMPLEADOS 
    DE M�S DE 9 HORAS EN TOTAL DE TRABAJO EN PROYECTOS
    CONDICI�N DE GRUPO**/

WITH proyectos_actuales AS
	(SELECT empleado, proyecto, (sum(time_to_sec(horas)))/3600 AS horas_totales
	FROM proyectos_empleados
	WHERE fbaja>curdate() OR fbaja IS NOT NULL
	GROUP BY empleado
	)
SELECT concat(E.nombre," ",E.apellidos) AS empleado,
	E.salario AS salario_empleado,
	COALESCE(concat(DIR.nombre," ",DIR.apellidos),"No tiene") AS director,
	COALESCE(DIR.salario,0) AS salario_director,
	count(PA.proyecto) AS num_proyectos,
	COALESCE(concat(SUP.nombre," ",SUP.apellidos),"No tiene") AS supervisor,
	count(FE.familiar) AS "N�mero de familiares registrados"
FROM empleados E LEFT JOIN departamentos D ON D.num=E.departamento 
	LEFT JOIN empleados DIR ON DIR.id=D.director 
	LEFT JOIN proyectos_actuales PA ON PA.empleado=E.id
	LEFT JOIN empleados SUP ON SUP.id=E.supervisor 
	LEFT JOIN familiares_emp FE ON FE.empleado=E.id
WHERE PA.horas_totales > 9
GROUP BY E.id;



/* 224. Mostrar el Ãºltimo empleado en incorporarse a cada proyecto */

SELECT concat(E.nombre," ",E.apellidos) AS empleado,
	PE.proyecto,
	max(PE.fincorporacion) AS fecha
FROM empleados E INNER JOIN proyectos_empleados PE ON PE.empleado = E.id
GROUP BY PE.proyecto;
-- MAL. REVISAR. HAY EMPLEADOS QUE EMPEZARON EL MISMO D�A. VARIOS EMPLEADOS SON LOS �LTIMOS EN INCORPORARSE EN CADA PROYECTO



/* 225. Todos los departamentos con su nÃºmero de empleados, mostrando tambiÃ©n el nÃºmero
 * de empleados sin departamento asignado y considerando empleados sin departamento y
 * departamentos sin empleados
 */

SELECT D.nombre AS departamento,
	count()











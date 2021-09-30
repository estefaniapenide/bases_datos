/* -----------------------------------------------------------------------
----- 1. CONSULTAS DE UNA TABLA -----
----------------------------------------------------------------------- */



/* 101. INFORME DE NOMBRE Y SALARIO DE TODOS LOS EMPLEADOS, ORDENADOS POR SALARIO */

SELECT nombre, apellidos, salario
FROM empleados
ORDER BY salario ASC; -- La ordenación puede ser ASC(endente) o DESC(endente)



/* 101b. INFORME DE departamento, NOMBRE Y SALARIO DE TODOS LOS EMPLEADOS, ORDENADOS POR departamento del menos al mayor,
 *  y dentro de cada departamento, por salario de mayor a menor */

SELECT departamento, nombre, apellidos, salario
FROM empleados
ORDER BY departamento, salario DESC; -- ASC es la opción por defecto, así que se puede omitir


/* 102. Departamento, NOMBRE Y SALARIO DE todos LOS EMPLEADOS DE los DEPARTAMENTOs 2 Y 3 */

SELECT departamento, nombre, salario
FROM empleados
WHERE departamento=2 OR departamento=3; 

/* Error:
SELECT departamento, nombre, salario
FROM empleados
WHERE departamento=2 OR 3; */


SELECT departamento, nombre, salario
FROM empleados
WHERE departamento IN (2,3);


/* 103. CUÁNTOS EMPLEADOS HAY EN MI EMPRESA */

SELECT COUNT(id) -- o también COUNT(*)
FROM empleados;


/* 103.b Empleados y empleados con distinto nombre */

SELECT count(nombre) AS "Empleados", -- Cuenta las filas que no son NULL en la columna "nombre"
	count(DISTINCT nombre) AS "Emp. con nombre distinto" -- Cuenta solo una vez aquellos valores idénticos
FROM empleados;

UPDATE empleados SET nombre='Pepe' WHERE id IN (1,2,3,4); -- Para probarla, podemos modificar algunos nombres en la tabla


/* 104. CUÁNTOS EMPLEADOS TIENEN ASIGNADO SUPERVISOR */

SELECT COUNT(supervisor) -- Contamos cuántas filas tienen a algún empleado referenciado como supervisor
FROM empleados; -- o sea, aquellas en que supervisor es distinto de NULL

SELECT COUNT(*) -- Es equivalente a contar contar en el conjunto de todas las columnas
FROM empleados
WHERE supervisor IS NOT NULL; -- pero solo las filas que no tienen NULL en la columna supervisor


/* 105. Departamentos en los que hay empleados (o departamentos presentes en la tabla de empleados) */

SELECT DISTINCT departamento
FROM empleados
WHERE departamento IS NOT NULL; -- Para que NULL no sea uno de los resultados (en este caso, por diseño no se permite que departamento=NULL)

SELECT departamento
FROM empleados
GROUP BY departamento; /* GROUP BY agrupa todas las filas que tienen el mismo valor en una determinada columna, normalmente para 
	utilizar funciones de agregación sobre las otras */


/* 106. Número de departamentos en los que hay empleados (o departamentos presentes en la tabla de empleados) */

SELECT COUNT(DISTINCT departamento) AS num_departamentos 
FROM empleados;

/* Sería equivalente a hacer primero la agrupación y luego contar las filas en la tabla resultante. Estos dos pasos podrían
realizarse con una consulta subordinada. (En esta consulta no es necesario, pero sirve para introducir el concepto) */

SELECT count(*) -- o COUNT(departamento), que sería lo mismo ya que la subordinada solo devuelve una columna.
FROM (SELECT DISTINCT departamento 	-- aux es la tabla "virtual" resultante de la consulta subordinada, 
	FROM empleados) AUX;			-- sobre la que se pueden hacer nuevas consultas como si fuese cualquier otra
	 
/* A su vez, para facilitar las consultas que requieren subordinadas. Se puede usar la instrucción WITH.
 * La siguiente es equivalente a la anterior */
WITH AUX AS (
	SELECT DISTINCT departamento
	FROM empleados
)
SELECT count(departamento) FROM aux;



/* 107. NOMBRE Y departamento DE LOS EMPLEADOS SIN SUPERVISOR CUYO SALARIO SEA
 *  MAYOR QUE 5000, 
 * ordenados por departamento */

/* Se puede utilizar la función concat() que concatena cadenas de texto, permitiendo mostrar en una columna los valores de dos, p.ej. */

SELECT concat(nombre,' ',apellidos) AS nombre, departamento 
FROM empleados
WHERE (supervisor IS NULL  -- Empleados sin supervisor: aquellos que tienen supervisor a NULL
			OR id=supervisor) -- O (por robustez) aquellos que tienen como supervisor a sí mismo, si los hubiese (no es el diseño contemplado)
	AND salario>5000  -- Y también tienen que cumplir la condición salario>5000
ORDER BY departamento;

/* Para testear, podríamos ver la diferencia tras: */
UPDATE empleados SET salario=4000 WHERE id IN (4,5,6); -- Cambiamos el salario de los empleados 4, 5 y 6



/* 107b. Nombre y departamento de los empleados cuyo salario 
 * esté entre 1000.19 y 6000.44 */

SELECT concat(nombre,' ',apellidos) AS nombre, departamento 
FROM empleados
WHERE salario>=1000.19 AND salario<=6000.44;

SELECT nombre || ' ' || apellidos AS nombre, departamento 
FROM empleados
WHERE salario BETWEEN 1000.19 AND 6000.44;



/* 108. CUÁNTOS EMPLEADOS DEL DEPARTAMENTO 3 TIENEN SUPERVISOR. 
 * IMPORTANTE recordar que la columna supervisor tiene la clave del empleado que es el supervisor, a través de una referencia reflexiva */

SELECT COUNT(supervisor) AS emp_supervisados -- Al contar aquellas filas que no tienen NULL en supervisor estamos
FROM EMPLEADOS								 -- contando empleados (cada fila, cada PK) que tiene supervisor (FK)	
WHERE DEPARTAMENTO=3;

/* Equivalente filtrando explicitamente las filas donde supervisor está a NULL (empleados sin supervisor) */
SELECT COUNT(*) AS CANTIDAD_EMPLEADOS
FROM EMPLEADOS
WHERE DEPARTAMENTO=3 AND SUPERVISOR IS NOT NULL;


/* De nuevo, en ambos casos podríamos considerar que un empleado supervisado es aquel que tiene un valor distinto de NULL en la
 * columna supervisor, pero también aquellos que tengan en dicha columna una referencia a si mismos
 * (que sean supervisores de si mismos): */

SELECT COUNT(*) AS CANTIDAD_EMPLEADOS
FROM EMPLEADOS
WHERE DEPARTAMENTO=3 AND SUPERVISOR IS NOT NULL AND supervisor!=id;


/* 109. CUÁL ES EL SALARIO MEDIO DE LA EMPRESA */
/* Además de count(), exiten otras funciones de agregación de varias filas: 
 * SUM para sumar valores, AVG para calcular valores medios, MAX/MIN para elegir el valor máximo/mínimo */

SELECT SUM(SALARIO)/COUNT(*) AS SALARIO_MEDIO_EMPRESA 
FROM EMPLEADOS;

SELECT AVG(SALARIO) 
FROM EMPLEADOS;


/* 110. SALARIO MEDIO DEL DEPARTAMENTO 3 */

SELECT AVG(SALARIO) FROM EMPLEADOS WHERE DEPARTAMENTO=3;


/* 110b . Salario medio de los departamentos 3 y 4 (media de ambos) */

SELECT avg(salario)
FROM empleados
WHERE DEPARTAMENTO=3 OR DEPARTAMENTO=4;


/* -----------------------------------------------------------------------------
 * --- 110c . Salario medio de los departamentos 3 y 4 (media de cada uno) */

/* Algunas operaciones matemáticas dan resultados con muchos decimales.  */
SELECT departamento,
	avg(salario)::money AS salario_medio
FROM empleados
WHERE DEPARTAMENTO=3 OR DEPARTAMENTO=4
GROUP BY departamento; 

	
(	SELECT departamento, round(avg(salario),2) AS salario_medio
	FROM empleados
	WHERE DEPARTAMENTO=3
	GROUP BY departamento 
)
UNION
(	SELECT departamento, round(avg(salario),2) AS salario_medio
	FROM empleados
	WHERE DEPARTAMENTO=4
	GROUP BY departamento
);	



/* 113. Por cada departamento obtener, su clave, cantidad de empleados, 
 * salario medio del departamento */

SELECT departamento,
	COUNT(*) AS num_empleados,
	to_char(AVG(salario),'FM99999D99') AS salario_medio -- TODO
FROM empleados
GROUP BY departamento;




/* 115. Número de supervisores y de supervisados por departamento,
 *  ordenado por numero de supervisores */


SELECT departamento, 
	COUNT(DISTINCT supervisor) AS supervisores, 
    COUNT(supervisor) AS supervisados,
    count(*)-count(supervisor) AS no_supervisados,
    sum((supervisor IS NULL)::int) AS no_supervisados2, -- otro modo de hacerlo
	sum((supervisor IS NOT NULL)::int) AS supervisados2
FROM empleados
GROUP BY departamento
ORDER BY supervisores;



/* 116. En cuántos proyectos y cuántas horas trabaja 
 * el empleado de clave 1 */


/* Si la columna hora fuese simplemente algún tipo INT, bastaría con la función de
 * agregación SUM(): */

SELECT count(proyecto) AS proyectos,
	sum(horas) AS tiempo_totales
FROM proyectos_empleados pe
WHERE empleado=1

/* Pero como hemos optado por el tipo TIME, será necesario 1. Convertir a segundos con
 * TIME_TO_SEC(); 2. agregar con SUM(); 3. Dividir entre 3600 (segundos en una hora). 
 * Esto nos devolvería un número (DOUBLE) de horas con decimales, que podríamos redondear.
 */

SELECT count(proyecto) AS proyectos,
	round( sum(time_to_sec(horas))/3600 ,1) AS tiempo_totales
FROM proyectos_empleados pe
WHERE empleado=1


/* Pero también podríamos volver a convertir a TIME la agregación de segundos con SEC_TO_TIME() */

SELECT count(proyecto) AS proyectos,
	sec_to_time(sum(time_to_sec(horas))) AS tiempo_totales
FROM proyectos_empleados pe
WHERE empleado=1


/* Si queremos mantener el tipo TIME, pero mostrar solo horas y minutos, podemos extraer 
 * esas dos partes con las funciones HOUR y MINUTE.
 */


SELECT proyectos, CONCAT(HOUR(tiempo_totales),':',MINUTE(tiempo_totales)) AS horas
FROM (
	SELECT count(proyecto) AS proyectos,
		sec_to_time(sum(time_to_sec(horas))) AS tiempo_totales
	FROM proyectos_empleados pe
	WHERE empleado=1
) aux;

SELECT proyectos, TIME_FORMAT(tiempo_totales,"%H:%i") AS horas
FROM (
	SELECT count(proyecto) AS proyectos,
		sec_to_time(sum(time_to_sec(horas))) AS tiempo_totales
	FROM proyectos_empleados pe
	WHERE empleado=1
) aux;



/* 117. Empleados con cantidad de proyectos y total de horas de trabajo asignadas */

SELECT empleado,
	count(proyecto) AS proyectos,
	TIME_FORMAT(sec_to_time(sum(time_to_sec(horas))),"%H:%i") AS tiempo_totales
FROM proyectos_empleados pe
GROUP BY empleado


/* 118. Empleados, con las horas asignadas a cada proyecto que tienen asignado */

SELECT empleado, proyecto, horas 
FROM proyectos_empleados
/* No es necesario hacer nada más, ya que si la tabla está bien diseñada (con 
 * PK compuesta sobre las dos FK (empleado, proyecto) (o en su defecto, con un 
 * indice UNIQUE sobre esas dos columnas), no se podrá repetir el mismo proyecto
 * para el mismo empleado.
 */


/* Si la tabla no está bien diseñada, esta consulta sería más robusta: */
SELECT empleado, proyecto, SEC_TO_TIME(sum(TIME_TO_SEC(horas)))
FROM proyectos_empleados
GROUP BY empleado, proyecto; /* Se agrupan las filas que tengan mismo empleado
		y mismo proyecto (el conjunto de ambas igual */


/* 119. (Clave de) proyectos con el total de horas asignadas a él 
(sumando las de todos los empleados que trabajen en él) */

SELECT proyecto, sum(TIME_TO_SEC(horas))/3600 AS horas
FROM proyectos_empleados
GROUP BY proyecto;



/* --------------------------------------------------------------------------------------------------
 * ----- 120. (Claves de) proyectos con carga de trabajo asignado */

/* En principio, todos los proyectos que estén listados en la tabla deberían estarlo por 
 * tener trabajo asignado, así que sería suficiente con: */

SELECT DISTINCT proyecto AS "Proyectos con carga"
FROM proyectos_empleados;

/* En caso de que se consideren asignaciones con 0 horas: */

SELECT DISTINCT proyecto AS "Proyectos con carga"
FROM proyectos_empleados
WHERE horas>0;

/* En caso de que se consideren tambien horas a NULL: */

SELECT DISTINCT proyecto AS "Proyectos con carga"
FROM proyectos_empleados
WHERE horas>0 AND horas IS NOT NULL;

/* Si, como antes, contemplamos que (empleado,proyecto) no sea UNIQUE: */

SELECT proyecto
FROM proyectos_empleados
GROUP BY proyecto
HAVING sum(TIME_TO_SEC(horas))>0;

/* que, para recordar el funcionamiento de HAVING, recordaremos que es equivalente a: */

SELECT proyecto
FROM (
	SELECT proyecto,
		sum(TIME_TO_SEC(horas)) AS sum_segundos -- como no se muestra en el resultado final, no es necesario convertir
	FROM proyectos_empleados
	GROUP BY proyecto
) aux
WHERE sum_segundos>0;

/* o, con CTE (WITH): */

WITH aux AS (
	SELECT proyecto, sum(TIME_TO_SEC(horas)) AS sum_segundos
	FROM proyectos_empleados
	GROUP BY proyecto
)
SELECT proyecto
FROM aux
WHERE sum_segundos>0;



/* -- Para testear el funcionamiento de horas!=0 cuando está a NULL:

describe proyectos_empleados;
ALTER TABLE proyectos_empleados MODIFY
	horas TIME; -- Se redefine la columna horas como NULL (opción por defecto)
    
INSERT INTO proyectos_empleados VALUES (10,6,NULL,now(),NULL);
INSERT INTO proyectos_empleados VALUES (12,6,  0 ,now(),NULL);

SELECT * 
FROM proyectos_empleados
WHERE horas>0 AND horas IS NOT NULL;
*/





/* -------------------------------------------------------------------------------------------------------
--- 121. Obtener, por cada (clave de) proyecto, cuántos empleados están trabajando en él, 
y el total de horas de trabajo asignadas al proyecto */

SELECT proyecto, COUNT(empleado) AS empleados, SEC_TO_TIME(sum(TIME_TO_SEC(horas))) AS horas
FROM proyectos_empleados
GROUP BY proyecto;


/* 122. Cuántos proyectos tienen asignada carga de trabajo */

SELECT COUNT(DISTINCT proyecto)
FROM proyectos_empleados
WHERE horas>0;


/* --------------------------------------------------------------------------
 * 123. Para cada departamento, en cuántas sedes está presente */

SELECT departamento, count(id) AS empleados, count(DISTINCT sede) AS sedes
FROM empleados
GROUP BY departamento;

/* 123b. Total de sedes en que está presente el departamento 1 o el 2 */

SELECT count(DISTINCT sede)
FROM empleados
WHERE DEPARTAMENTO IN (1,2);

/* 123c. En cuántas sedes están presentes LOS DEPARTAMENTOS DE CLAVE 1 Y 2 */

SELECT departamento, count(DISTINCT sede)
FROM empleados
WHERE DEPARTAMENTO IN (1,2)
GROUP BY departamento;


/* -------------------------------------------------------------------------
 * 124. Mostrar la fecha en la que se incorporó el último empleado a cada proyecto */

SELECT proyecto, max(fincorporacion) AS "Fecha incorporación"
FROM proyectos_empleados
GROUP BY proyecto;


/* 125. CUÁNTOS SALARIOS distintos TENEMOS EN LA EMPRESA */

SELECT COUNT(DISTINCT SALARIO) FROM EMPLEADOS;



/* 126. CUÁNTOS EMPLEADOS DE los DEPARTAMENTOs 2 Y 3 NO TIENEN SUPERVISOR 
 * Y CÚAL ES SU MEDIA DE SALARIO */


SELECT count(*) AS num_emp, format(avg(salario),2) AS salario_medio
FROM empleados
WHERE departamento IN (2,3) 
	AND supervisor IS NULL; -- Podemos primero filtrar las filas que no tienen supervisor, para luego agregar

	
SELECT count(*)-count(supervisor) AS num_emp, -- o contar todas las filas y restar las que sí tienen
	round(avg(salario),2) AS salario_medio
FROM empleados
WHERE departamento IN (2,3);


/* 127. Por cada departamento, cuántos empleados no tienen supervisor */

SELECT departamento, count(*)-count(supervisor) AS num_no_supervisados
FROM empleados
GROUP BY departamento; 

SELECT departamento, count(*) AS num_emp_sin_sup
FROM empleados
WHERE supervisor IS NULL
GROUP BY departamento;

SELECT departamento, sum(supervisor IS NULL) AS num_emp_sin_sup
FROM empleados
WHERE supervisor IS NULL
GROUP BY departamento;


/* 128. LISTA DE CLAVES PRIMARIAS DE LOS EMPLEADOS QUE SON SUPERVISORES */

SELECT DISTINCT supervisor
FROM empleados
WHERE supervisor IS NOT NULL;


/* 129. CUÁNTOS EMPLEADOS SON SUPERVISORES */

SELECT COUNT(DISTINCT SUPERVISOR) FROM EMPLEADOS WHERE SUPERVISOR IS NOT NULL;


/* 130. PARA CADA DEPARTAMENTO EN LA EMPRESA, CANTIDAD DE EMPLEADOS ASIGNADOS, 
MAYOR Y MENOR SALARIO DEL DEPARTAMENTO y media de ellos */

SELECT departamento, count(id) AS empleados,
	max(SALARIO) AS salario_max, 
    min(salario) AS salario_min,
    format(avg(salario),2) AS salario_medio
FROM empleados
GROUP BY departamento;


/* 131. PARA CADA DEPARTAMENTO EN LA EMPRESA, CANTIDAD DE EMPLEADOS ASIGNADOS, 
MAYOR Y MENOR SALARIO DEL DEPARTAMENTO, CANTIDAD DE EMPLEADOS CON SUPERVISOR, 
Y LA CANTIDAD DE EMPLEADOS SIN SUPERVISOR */

SELECT departamento, count(*) AS empleados,
	max(SALARIO) AS salario_max, 
    min(salario) AS salario_min,
    count(supervisor) AS supervisados,
    count(*)-count(supervisor) AS no_supervisados
FROM empleados
GROUP BY departamento;

SELECT departamento, count(*) AS empleados,
	max(SALARIO) AS salario_max,
	min(salario) AS salario_min,
    sum(supervisor IS NOT NULL) AS supervisados,
    sum(supervisor IS NULL) AS no_supervisados
FROM empleados
GROUP BY departamento;


/* 132. Mismos datos que la anterior, pero solo para aquellos departamentos que
tengan más de 4 empleados */

SELECT departamento, count(*) AS empleados,
	max(SALARIO) AS salario_max, 
    min(salario) AS salario_min,
    count(supervisor) AS supervisados,
    count(*)-count(supervisor) AS no_supervisados
FROM empleados
GROUP BY departamento
HAVING empleados>4;

/* que (recordando), equivale a: */

SELECT * FROM 
(
	SELECT departamento, count(*) AS empleados,
		max(SALARIO) AS salario_max, 
    	min(salario) AS salario_min,
    	count(supervisor) AS supervisados,
    	sum(supervisor IS NULL) AS no_supervisados
	FROM empleados
	GROUP BY departamento
) aux
WHERE empleados>4;


/* 133. PARA CADA PROYECTO, CANTIDAD DE EMPLEADOS TRABAJANDO EN ÉL, 
TOTAL DE HORAS DE TRABAJO ASIGNADAS Y FECHA MÁS ANTIGUA DE ASIGNACIÓN */

SELECT proyecto, count(empleado) AS empleados,
	SEC_TO_TIME(sum(TIME_TO_SEC(horas))) AS total_horas,
	min(fincorporacion) AS primera_fecha
FROM proyectos_empleados
GROUP BY proyecto;


/* 134. PARA CADA PROYECTO, CANTIDAD DE EMPLEADOS TRABAJANDO EN ÉL, 
TOTAL HORAS ASIGNADAS, año DE ASIGNACIÓN MÁS ANTIGUO */

SELECT proyecto, count(empleado) AS empleados,
	SEC_TO_TIME(sum(TIME_TO_SEC(horas))) AS total_horas,
	min(year(fincorporacion)) AS año_inicio
FROM proyectos_empleados
GROUP BY proyecto;


/* 135. PARA CADA PROYECTO, CANTIDAD DE EMPLEADOS TRABAJANDO EN ÉL Y 
MEDIA DE HORAS ASIGNADAS, SÓLO PARA LOS PROYECTOS QUE TENGAN MÁS DE 
51 HORAS TOTALES ASIGNADAS */

SELECT proyecto, empleados, media_horas
FROM (
	SELECT proyecto, count(*) AS empleados, 
		time_format(sec_to_time(avg(time_to_sec(horas))),"%H:%i") AS media_horas,
		sum(time_to_sec(horas)) AS total_segundos
	FROM proyectos_empleados
	GROUP BY proyecto
) aux
WHERE total_segundos>50*3600


SELECT proyecto, count(empleado) AS empleados,
	time_format(sec_to_time(avg(time_to_sec(horas))),"%H:%i") AS media_horas
FROM proyectos_empleados
GROUP BY proyecto
HAVING sum(time_to_sec(horas))>50*3600



/* 136. POR CADA EMPLEADO QUE TENGA FAMILIARES REGISTRADOS,
MOSTRAR SU CLAVE Y LA CANTIDAD DE FAMILIARES QUE HA REGISTRADO */

SELECT empleado, count(*) AS familiares
FROM familiares_emp
GROUP BY empleado;


/* 137. POR CADA EMPLEADO, número de PROYECTOS asignados con posterioridad
a mayo del 2017 Y número de HORAS asignadas en estos proyectos */

SELECT empleado, count(proyecto), SEC_TO_TIME(sum(TIME_TO_SEC(horas))) AS horas
FROM proyectos_empleados
WHERE fincorporacion>="2017-06-01"
GROUP BY empleado;

SELECT empleado, count(proyecto), SEC_TO_TIME(sum(TIME_TO_SEC(horas))) AS horas
FROM proyectos_empleados
WHERE year(fincorporacion)>=2017 AND month(fincorporacion)>5
GROUP BY empleado;

















/* Para entender qué pasa con la relación reflexiva 1:N, podemos ver la consulta de cómo 
 * vincular datos de un empleado con datos de su supervisor: */
SELECT E.id AS id_empleado,
	concat(E.nombre,' ', E.apellidos) AS Empleado, 
	E.supervisor AS FK_supervisor,
	SUP.id AS PK_empleado_supervisor,
	concat(SUP.nombre,' ', SUP.apellidos) AS Supervisor
FROM empleados E, empleados SUP
WHERE E.supervisor=SUP.id;


/* 138. OBTENER POR CADA SUPERVISOR: SU CLAVE y LA CANTIDAD DE EMPLEADOS A LOS QUE 
 * SUPERVISA */


SELECT supervisor, count(id) AS empleados_supervisados
FROM empleados
WHERE supervisor IS NOT NULL
GROUP BY supervisor;


/* 139. POR CADA DEPARTAMENTO, LA CANTIDAD DE PROYECTOS QUE HA LANZADO O CREADO */

SELECT dept_coord, count(*) AS num_proyectos
FROM proyectos
GROUP BY dept_coord 




/* -------------------------------------------------------
 * ---- USO DE LIKE */


/* 140. Empleados cuyo primer apellido empieza por "D" */

UPDATE empleados SET apellidos="pérez Fernández" WHERE id>32;

-- https://www.w3schools.com/sql/sql_like.asp
SELECT id, nombre, apellidos
FROM empleados
WHERE apellidos LIKE 'd%';

/* En el examen no se pedirá nada que no pueda ser resuelto con LIKE.
 * Las soluciones con REGEX no serán requeridas pero se aceptarán. */
-- https://dev.mysql.com/doc/refman/8.0/en/regexp.html
SELECT id, nombre, apellidos
FROM empleados
WHERE apellidos REGEXP '^d[A-Z]*';


/* 141. Empleados con algún apellido que empiece por "A" */

UPDATE empleados SET apellidos="alba Fernández" WHERE id>42;

SELECT id, nombre, apellidos
FROM empleados
WHERE apellidos LIKE '% a%'
	OR apellidos LIKE 'a%';

SELECT id, nombre, apellidos
FROM empleados
WHERE apellidos REGEXP '[a-z]*\\sa[a-z]*'
	OR apellidos REGEXP '^a[a-z]*';


/* 142. Empleados con algún apellido que empiece por "A" mayúscula */

SELECT id, nombre, apellidos
FROM empleados
WHERE apellidos LIKE BINARY '% A%'
	OR apellidos LIKE BINARY 'A%';
-- Usamos "BINARY" para que sea Case Sensitive

SELECT id, nombre, apellidos
FROM empleados
WHERE BINARY apellidos REGEXP BINARY '[a-z]*\\sA[a-z]*'
	OR BINARY apellidos REGEXP BINARY '^A[a-z]*';


/* 143. Empleados que tengan en su DNI el caracter "5" */

SELECT id, nif, nombre, apellidos
FROM empleados
WHERE nif LIKE '%5%';


/* 144. Empleados que tengan un DNI cuya segunda cifra sea 5 */

SELECT id, nif, nombre, apellidos
FROM empleados
WHERE nif LIKE '_5%';


/* 144. Empleados mostrando su nombre completamente en mayúsculas 
 * y sus apellidos completamente en minúsculas */

SELECT upper(nombre), lower(apellidos)
FROM empleados




/* 205. Número de sedes en que están presentes los departamentos de Administración 
 * y Ventas */


SELECT D.nombre AS departamento, count(DISTINCT E.sede) AS numero_sedes
FROM empleados E RIGHT JOIN departamentos D ON E.departamento=D.num
WHERE D.nombre LIKE '%Administraci%' OR D.nombre LIKE '%Ventas%'
GROUP BY D.num, D.nombre;


SELECT D.nombre, count(DISTINCT sede) as numero_sedes
FROM empleados E JOIN departamentos D ON E.departamento=D.num
WHERE D.nombre LIKE '%ventas%' OR D.nombre LIKE '%dministraci%'
GROUP BY departamento;



/***********************************************************/


/* 217. Supervisores sin proyectos asignados, con su salario */



SELECT DISTINCT SUP.id, SUP.nombre, SUP.apellidos, SUP.salario 
FROM empleados E JOIN empleados SUP ON E.supervisor=SUP.id
WHERE SUP.id NOT IN (SELECT DISTINCT empleado
					FROM proyectos_empleados); 


SELECT DISTINCT SUP.id, SUP.nombre, SUP.apellidos, SUP.salario 
FROM empleados E JOIN empleados SUP ON E.supervisor=SUP.id
 			LEFT JOIN proyectos_empleados PE ON SUP.id=PE.empleado
 		WHERE PE.proyecto IS NULL;

 
 /* Si consideramos solo proyectos asignados en vigor */
 	
SELECT DISTINCT SUP.id, SUP.nombre, SUP.apellidos, SUP.salario 
FROM empleados E JOIN empleados SUP ON E.supervisor=SUP.id
WHERE SUP.id NOT IN (SELECT DISTINCT empleado
					FROM proyectos_empleados
					WHERE fbaja IS NULL OR fbaja>CURRENT_DATE); 
	

							
WITH 
id_supervisores AS (
	SELECT DISTINCT supervisor AS id 
	FROM empleados
	WHERE supervisor IS NOT NULL
),
supervisores AS (
	SELECT *
	FROM empleados
	WHERE id IN (SELECT id FROM id_supervisores)
),
empl_con_proy AS (
	SELECT DISTINCT empleado AS id
	FROM proyectos_empleados
	WHERE fbaja IS NULL OR fbaja>CURRENT_DATE -- Bastaría quitar esta línea para considerar todos los proyectos
)
SELECT nombre, apellidos, salario
FROM supervisores
WHERE id not in (SELECT id FROM empl_con_proy);


/* Podríamos crear una vista de supervisores */
CREATE VIEW supervisores AS (
	SELECT DISTINCT SUP.id, SUP.nombre, SUP.apellidos, SUP.salario 
	FROM empleados E JOIN empleados SUP ON E.supervisor=SUP.id
);

WITH empl_con_proy AS (
	SELECT DISTINCT empleado AS id
	FROM proyectos_empleados
	WHERE fbaja IS NULL OR fbaja>CURRENT_DATE
)
SELECT nombre, apellidos, salario
FROM supervisores
WHERE id not in (SELECT id FROM empl_con_proy)



/* 217b. Supervisores con proyectos asignados con su salario */


WITH empl_con_proy AS (
	SELECT DISTINCT empleado AS id
	FROM proyectos_empleados
	WHERE fbaja IS NULL OR fbaja>CURRENT_DATE
)
SELECT nombre, apellidos, salario
FROM supervisores
WHERE id in (SELECT id FROM empl_con_proy)


SELECT DISTINCT SUP.nombre, SUP.apellidos, SUP.salario
FROM empleados E INNER JOIN empleados SUP ON SUP.id=E.supervisor
	JOIN proyectos_empleados PE ON SUP.id = PE.empleado






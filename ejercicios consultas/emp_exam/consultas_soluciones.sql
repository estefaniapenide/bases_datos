/* -----------------------------------------------------------------------
----- 1. CONSULTAS DE VARIAS TABLAS -----
----------------------------------------------------------------------- */


/* 101. INFORME DE NOMBRE Y SALARIO DE TODOS LOS EMPLEADOS, ORDENADOS POR SALARIO */

SELECT nombre, salario
FROM empleados
ORDER BY salario DESC, nombre ASC;


/* 102. Departamento, NOMBRE Y SALARIO DE LOS EMPLEADOS DEL DEPARTAMENTO 2 Y 3 */

SELECT departamento, nombre, salario
FROM empleados
WHERE departamento=2 OR departamento=3;

/* Posible error: */
SELECT departamento, nombre, salario
FROM empleados
WHERE departamento=2 OR 3; -- 3 es evaluado como TRUE

SELECT departamento, nombre, salario
FROM empleados
WHERE departamento IN (2,3);


/* 103. CUÁNTOS EMPLEADOS HAY EN MI EMPRESA */

SELECT COUNT(*)
FROM empleados;


/* 104. CUÁNTOS EMPLEADOS TIENEN ASIGNADO SUPERVISOR */

SELECT COUNT(supervisor)
FROM empleados;

SELECT COUNT(*)
FROM empleados
WHERE supervisor IS NOT NULL;


/* 105. Departamentos en los que hay empleados (o departamentos presentes en la tabla de empleados) */

SELECT DISTINCT departamento
FROM empleados;


/* 106. Número de epartamentos en los que hay empleados (o departamentos presentes en la tabla de empleados) */

SELECT COUNT(DISTINCT departamento) AS num_departamentos
FROM empleados;


/* 107. NOMBRE Y departamento DE LOS EMPLEADOS SIN SUPERVISOR CUYO SALARIO SEA MAYOR QUE 1000, ordenados por departamento */

SELECT nombre, departamento
FROM empleados
WHERE supervisor IS NULL
	AND salario>1000
ORDER BY departamento;


/* 108. CUÁNTOS EMPLEADOS DEL DEPARTAMENTO 3 TIENEN SUPERVISOR */

SELECT COUNT(supervisor) AS "CANTIDAD EMPLEADOS"
FROM EMPLEADOS
WHERE DEPARTAMENTO=3;

SELECT COUNT(*) AS CANTIDAD_EMPLEADOS
FROM EMPLEADOS
WHERE DEPARTAMENTO=3 AND SUPERVISOR IS NOT NULL;


/* 109. CUÁL ES EL SALARIO MEDIO DE LA EMPRESA */

SELECT SUM(SALARIO)/COUNT(*) AS SALARIO_MEDIO_EMPRESA 
FROM EMPLEADOS;

SELECT AVG(SALARIO) 
FROM EMPLEADOS;


/* 110. SALARIO MEDIO DEL DEPARTAMENTO 3 */

SELECT AVG(SALARIO) FROM EMPLEADOS WHERE DEPARTAMENTO=3;


/* 111. Salario medio y cantidad de EMPLEADOS DEL DEPARTAMENTO 3 */

select avg(salario) as "Salario medio", count(*) as "Cantidad Empleados"
from empleados where departamento=3;

-- Para mostrar el salario medio con solo 2 decimales
select round(avg(salario), 2) as "Salario medio", count(*) as "Cantidad Empleados"
from empleados where departamento=3;


/* 112. Número de empleados por cada departamento */

SELECT departamento, COUNT(*) AS num_empleados
FROM empleados
GROUP BY departamento;


/* 113. Por cada departamento obtener, su clave, cantidad de empleados, salario medio del departamento */

SELECT departamento, COUNT(*) AS num_empleados, ROUND(AVG(salario),2) AS salario_medio
FROM empleados
GROUP BY departamento;


/* 114. Por cada departamento obtener, su clave, cantidad de empleados, salario medio del departamento 
y cantidad de empleados que tengan asignado supervisor */

SELECT departamento, COUNT(*) AS num_empleados, ROUND(AVG(salario),2) AS salario_medio,
	COUNT(supervisor) AS cantidad_supervisados
FROM empleados
GROUP BY departamento;


/* 115. Número de supervisores y de supervisados por departamento, ordenado por numero de supervisores */

SELECT departamento, 
	COUNT(DISTINCT supervisor) AS supervisores, 
    COUNT(supervisor) AS supervisados
FROM empleados
GROUP BY departamento
ORDER BY supervisores;


/* 116. En cuantos proyectos y cuantas horas trabaja el empleado de clave 3 */

select count(*) as cantidad_proyectos, sum(num_horas) as total_horas
from empleados_proyectos 
where empleado=3;


/* 117. Empleados con cantidad de proyectos y total de horas de trabajo asignadas */

SELECT empleado, 
	count(proyecto) AS total_proyectos,
	sum(num_horas) AS horas_totales
FROM empleados_proyectos
GROUP BY empleado;


/* 118. Empleados, con las horas asignadas a cada proyecto que tienen asignado */

SELECT empleado, proyecto, num_horas 
FROM empleados_proyectos
ORDER BY empleado;

/* Si la tabla no está bien diseñada, esta consulta sería más robusta: */
SELECT empleado, proyecto, SUM(num_horas)
FROM empleados_proyectos
GROUP BY empleado, proyecto
ORDER BY empleado;


/* 119. (Claves de) proyectos con carga de trabajo asignado */

SELECT DISTINCT proyecto 
FROM empleados_proyectos
WHERE NUM_HORAS>0;


/* 120. (Clave de) proyectos con el total de horas asignadas a él (sumando las de todos los empleados que trabajen en él) */

SELECT proyecto, SUM(num_horas)
FROM empleados_proyectos
GROUP BY proyecto;


/* 121. Obtener, por cada (clave de) proyecto, cuántos empleados están trabajando en él, 
y el total de horas de trabajo asignadas al proyecto */

SELECT proyecto, COUNT(empleado), SUM(num_horas)
FROM empleados_proyectos
GROUP BY proyecto;


/* 122. Cuántos proyectos tienen asignada carga de trabajo */

SELECT COUNT(DISTINCT proyecto) AS "Proyectos con carga"
FROM empleados_proyectos
WHERE NUM_HORAS>0;


/* 123. Para cada departamento, en cuántas sedes está presente */

SELECT departamento, count(sede)
FROM departamentos_sedes
GROUP BY departamento;


/* 124. Mostrar la fecha en la que se incorporó el último empleado a cada proyecto */

SELECT proyecto, max(fecha_inicio)
FROM empleados_proyectos
GROUP BY proyecto;


/* 125. CUÁNTOS SALARIOS distintos TENEMOS EN LA EMPRESA */

SELECT COUNT(DISTINCT SALARIO) FROM EMPLEADOS;


/* 126. CUÁNTOS EMPLEADOS DE los DEPARTAMENTOs 2 Y 3 NO TIENEN SUPERVISOR Y CÚAL ES SU MEDIA DE SALARIO */

SELECT count(*) AS num_emp, round(avg(salario),2) AS salario_medio
FROM empleados
WHERE departamento IN (2,3) AND supervisor IS NULL;

SELECT count(*)-count(supervisor) AS num_emp, round(avg(salario),2) AS salario_medio
FROM empleados
WHERE departamento IN (2,3);

SELECT COUNT(*) AS CANTIDAD_DE_EMPLEADOS,
	AVG(SALARIO) AS SALARIO_MEDIO,
	MAX(SALARIO) AS MAYOR_SALARIO
FROM EMPLEADOS
WHERE SUPERVISOR IS NULL AND (DEPARTAMENTO=2 OR DEPARTAMENTO=3);


/* 127. Por cada departamento, cuántos empleados no tienen supervisor */

SELECT departamento, count(*)-count(supervisor) AS num_emp_sin_sup
FROM empleados
GROUP BY departamento; 

SELECT departamento, count(*) AS num_emp_sin_sup
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
MAYOR Y MENOR SALARIO DEL DEPARTAMENTO */

SELECT departamento, count(*) AS empleados,
	max(SALARIO) AS salario_max, 
    min(salario) AS salario_min
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
    count(supervisor) AS supervisados,
    sum(supervisor IS NULL) AS no_supervisados -- Nerd alert!
FROM empleados
GROUP BY departamento;


/* 132. Mismos datos que la anterior, pero solo para aquellos departamentos que
tengan más de 4 empleados */

SELECT * FROM (
SELECT departamento, count(*) AS empleados,
	max(SALARIO) AS salario_max, 
    min(salario) AS salario_min,
    count(supervisor) AS supervisados,
    count(*)-count(supervisor) AS no_supervisados
FROM empleados
GROUP BY departamento
) aux
WHERE empleados>4;

SELECT departamento, count(*) AS empleados,
	max(SALARIO) AS salario_max, 
    min(salario) AS salario_min,
    count(supervisor) AS supervisados,
    count(*)-count(supervisor) AS no_supervisados
FROM empleados
GROUP BY departamento
HAVING empleados>4;


/* 133. PARA CADA PROYECTO, CANTIDAD DE EMPLEADOS TRABAJANDO EN ÉL, 
TOTAL DE HORAS DE TRABAJO ASIGNADAS Y FECHA MÁS ANTIGUA DE ASIGNACIÓN */

SELECT proyecto, count(empleado) AS empleados,
	sum(num_horas) AS total_horas,
	min(fecha_inicio) AS primera_fecha
FROM empleados_proyectos
GROUP BY proyecto;


/* 134. PARA CADA PROYECTO, CANTIDAD DE EMPLEADOS TRABAJANDO EN ÉL, 
TOTAL HORAS ASIGNADAS, año DE ASIGNACIÓN MÁS ANTIGUO */

SELECT proyecto, count(empleado) AS empleados,
	sum(num_horas) AS total_horas,
	min(year(fecha_inicio)) AS año_inicio
FROM empleados_proyectos
GROUP BY proyecto;


/* 135. PARA CADA PROYECTO CANTIDAD DE EMPLEADOS TRABAJANDO EN ÉL Y 
MEDIA DE HORAS ASIGNADAS, SÓLO PARA LOS PROYECTOS QUE TENGAN MÁS DE 
50 HORAS TOTALES ASIGNADAS */

SELECT proyecto, empleados, media_horas FROM (
	SELECT proyecto, count(empleado) AS empleados,
		round(avg(num_horas),2) AS media_horas,
		sum(num_horas) AS total_horas
	FROM empleados_proyectos
	GROUP BY proyecto
) aux
WHERE total_horas>200;

SELECT proyecto, count(empleado) AS empleados,
	avg(num_horas) AS media_horas
FROM empleados_proyectos
GROUP BY proyecto
HAVING sum(num_horas)>200;


/* 136. POR CADA EMPLEADO QUE TENGA FAMILIARES REGISTRADOS,
MOSTRAR SU CLAVE Y LA CANTIDAD DE FAMILIARES QUE HA REGISTRADO */

SELECT empleado, count(*) AS familiares
FROM familiares
GROUP BY empleado;


/* 137. POR CADA EMPLEADO, número de PROYECTOS asignados con posterioridad
a mayo del 2017 Y número de HORAS asignadas en estos proyectos */

SELECT empleado, count(proyecto), sum(num_horas)
FROM empleados_proyectos
WHERE fecha_inicio>="2017-06-01"
GROUP BY empleado;

SELECT empleado, count(proyecto), sum(num_horas)
FROM empleados_proyectos
WHERE year(fecha_inicio)>=2017 AND month(fecha_inicio)>5
GROUP BY empleado;



/* -----------------------------------------------------------------------
----- 2. CONSULTAS DE VARIAS TABLAS -----
----------------------------------------------------------------------- */

/* 201. DE CADA EMPLEADO, mostrar su NOMBRE, SALARIO, NOMBRE DEL DEPARTAMENTO 
AL QUE ESTÁ ASIGNADO Y CLAVE DE SU DIRECTOR DE DEPARTAMENTO */

SELECT E.nombre AS empleado, E.salario, E.departamento, D.director
FROM empleados E, departamentos D
WHERE E.departamento=D.numero;

SELECT E.nombre AS empleado, E.salario, D.nombre AS departamento, D.director
FROM empleados E INNER JOIN departamentos D
	ON E.departamento=D.numero;


/* 202. Mostrar PARA CADA DEPARTAMENTO (por su NOMBRE) EL NOMBRE Y SALARIO DE SU DIRECTOR */

SELECT D.nombre AS departamento, E.nombre AS director, E.salario
FROM departamentos D INNER JOIN empleados E
	ON D.director=E.id_empleado;


/* 203. Número de sedes en que está presente cada departamento */

SELECT D.nombre AS departamento, count(*) AS numero_sedes
FROM departamentos D, departamentos_sedes DS
WHERE D.numero=DS.departamento
GROUP BY DS.departamento;

SELECT D.nombre AS departamento, count(*) AS numero_sedes
FROM departamentos D JOIN departamentos_sedes DS
	ON D.numero=DS.departamento
GROUP BY D.numero









/* -----------------------------------------------------------------------
----- 1. CONSULTAS DE UNA TABLA -----
----------------------------------------------------------------------- */


/* 101. INFORME DE NOMBRE Y SALARIO DE TODOS LOS EMPLEADOS, ORDENADOS POR SALARIO */

SELECT concat(nombre,' ',apellidos) AS empleado , salario
FROM empleados
ORDER BY salario DESC;


/* 101b. INFORME DE departamento, NOMBRE Y SALARIO DE TODOS LOS EMPLEADOS, ORDENADOS POR departamento del menos al mayor,
 *  y dentro de cada departamento, por salario de mayor a menor */

SELECT departamento, concat(nombre,' ',apellidos) AS empleado, salario
FROM empleados
ORDER BY departamento ASC, salario DESC;


/* 102. Departamento, NOMBRE Y SALARIO DE todos LOS EMPLEADOS DE los DEPARTAMENTOs 2 Y 3 */

SELECT departamento, concat(nombre,' ',apellidos) AS empleado, salario
FROM empleados
WHERE departamento=2 OR departamento=3;


/* 103. CUÃ�NTOS EMPLEADOS HAY EN MI EMPRESA */

SELECT count(id) AS "Número de empleados"
FROM empleados;



/* 103.b Empleados y empleados con distinto nombre */

SELECT count(DISTINCT nombre) AS "Empleados con distinto nombre"
FROM empleados;


/* 104. CUÃ�NTOS EMPLEADOS TIENEN ASIGNADO SUPERVISOR */
 SELECT count(id) AS "Número de empleados con supervisor"
 FROM empleados
 WHERE supervisor IS NOT NULL;

SELECT count(supervisor) AS "Número de empleados con supervisor"
FROM empleados;


/* 105. Departamentos en los que hay empleados (o departamentos presentes en la tabla de empleados) */

SELECT DISTINCT departamento AS "Departamentos con empleados"
FROM empleados
WHERE departamento IS NOT NULL;


/* 106. NÃºmero de departamentos en los que hay empleados (o departamentos presentes en la tabla de empleados) */

SELECT count(DISTINCT departamento) AS "Número de departamentos con empleados"
FROM empleados
WHERE departamento IS NOT NULL;



/* 107. NOMBRE Y departamento DE LOS EMPLEADOS SIN SUPERVISOR CUYO SALARIO SEA
 *  MAYOR QUE 5000, 
 * ordenados por departamento */

SELECT concat(nombre,' ',apellidos) AS empleado, departamento
FROM empleados
WHERE salario > 5000 AND supervisor IS NULL
ORDER BY departamento;


/* 107b. Nombre y departamento de los empleados cuyo salario 
 * estÃ© entre 1000.19 y 6000.44 */

SELECT concat(nombre,' ',apellidos) AS empleado, departamento
FROM empleados
WHERE salario>=1000.19 AND salario<=6000.44;


/* 108. CUÃ�NTOS EMPLEADOS DEL DEPARTAMENTO 3 TIENEN SUPERVISOR. 
 * IMPORTANTE recordar que la columna supervisor tiene la clave del empleado que es el supervisor, a travÃ©s de una referencia reflexiva */

SELECT count(id) "Empleados del departamento 3 con supervisor"
FROM empleados
WHERE departamento=3 AND supervisor IS NOT NULL;

SELECT count(supervisor) "Empleados del departamento 3 con supervisor"
FROM empleados
WHERE departamento=3;


/* 109. CUÃ�L ES EL SALARIO MEDIO DE LA EMPRESA */
/* AdemÃ¡s de count(), exiten otras funciones de agregaciÃ³n de varias filas: 
 * SUM para sumar valores, AVG para calcular valores medios, MAX/MIN para elegir el valor mÃ¡ximo/mÃ­nimo */

SELECT format(avg(salario),2) AS "Salario medio"
FROM empleados;

SELECT round(avg(salario),2) AS "Salario medio"
FROM empleados;


/* 110. SALARIO MEDIO DEL DEPARTAMENTO 3 */

SELECT round(avg(salario),2) AS "Salario medio del departamento 3"
FROM empleados
WHERE departamento=3;


/* 110b . Salario medio de los departamentos 3 y 4 (media de ambos) */

SELECT round(avg(salario),2) AS "Salario medio departamentos 3 y 4"
FROM empleados
WHERE departamento=3 OR departamento=4;


/* -----------------------------------------------------------------------------
 * --- 110c . Salario medio de los departamentos 3 y 4 (media de cada uno) */

SELECT departamento, format(avg(salario),2) AS "Salario medio"
FROM empleados
WHERE departamento=3 OR departamento=4
GROUP BY departamento;


/* -----------------------------------------------------------------------------
  ----- 111. Salario medio y cantidad de EMPLEADOS DEL DEPARTAMENTO 3 */

SELECT format(avg(salario),2) AS "Salario medio", count(id) AS "Cantidad de empleados"
FROM empleados
WHERE departamento=3;


/* 112. NÃºmero de empleados por cada departamento */

SELECT departamento, count(id) AS "Número de empleados"
FROM empleados
GROUP BY departamento;


/* 113. Por cada departamento obtener, su clave, cantidad de empleados, 
 * salario medio del departamento */

SELECT departamento, count(id) AS "Número de empleados", format(avg(salario),2) AS "Salario medio"
FROM empleados
GROUP BY departamento;


/* 114. Por cada departamento obtener, su clave, cantidad de empleados, 
 * salario medio del departamento y cantidad de empleados que tengan asignado supervisor */

SELECT departamento, 
	count(id) AS "Número de empleados", 
	format(avg(salario),2) AS "Salario medio", 
	count(supervisor) AS "Empleados con supervisor"
FROM empleados
GROUP BY departamento; 


/* 115. NÃºmero de supervisores y de supervisados por departamento,
 *  ordenado por numero de supervisores */

SELECT departamento, 
	count(DISTINCT supervisor) AS "Supervisores", 
	count(supervisor) AS "Supervisados"
FROM empleados
GROUP BY departamento
ORDER BY supervisores;


/* 116. En cuÃ¡ntos proyectos y cuÃ¡ntas horas trabaja 
 * el empleado de clave 1 */

SELECT count(proyecto) AS "Cantidad de proyectos", sum(time_to_sec((horas))/3600) AS "Cantidad de horas"
FROM  proyectos_empleados
WHERE empleado=1;

/* 117. Empleados con cantidad de proyectos y total de horas de trabajo asignadas */

SELECT empleado, 
	count(proyecto) AS "Número de proyectos",
	format(sum(time_to_sec((horas))/3600),2) AS "Horas de trabajo"
FROM proyectos_empleados
GROUP BY empleado;



SELECT concat(E.nombre,' ',E.apellidos) AS empleados, 
	count(PE.proyecto) AS "Número de proyectos",
	format(sum(time_to_sec((PE.horas))/3600),2) AS "Horas de trabajo"
FROM proyectos_empleados PE, empleados E
WHERE E.id=PE.empleado
GROUP BY empleados;

/* 118. Empleados, con las horas asignadas a cada proyecto que tienen asignado */

SELECT empleado, (time_to_sec(horas))/3600 AS horas, proyecto
FROM proyectos_empleados
GROUP BY empleado, proyecto;


/* 119. (Clave de) proyectos con el total de horas asignadas a Ã©l 
(sumando las de todos los empleados que trabajen en Ã©l) */

SELECT proyecto, format(sum(time_to_sec(horas)/3600),2)
FROM proyectos_empleados
GROUP BY proyecto;


/* --------------------------------------------------------------------------------------------------
 * ----- 120. (Claves de) proyectos con carga de trabajo asignado */

SELECT DISTINCT proyecto AS "Proyectos con carga"
FROM proyectos_empleados
WHERE time_to_sec(horas)>0 OR horas IS NOT NULL;

/* -------------------------------------------------------------------------------------------------------
--- 121. Obtener, por cada (clave de) proyecto, cuÃ¡ntos empleados estÃ¡n trabajando en Ã©l, 
y el total de horas de trabajo asignadas al proyecto */

 SELECT proyecto, count(DISTINCT empleado) AS "N�mero de empleados", format(sum(time_to_sec(horas)/3600),2) AS "Horas totales"
 FROM proyectos_empleados
 GROUP BY proyecto;

/* 122. CuÃ¡ntos proyectos tienen asignada carga de trabajo */

SELECT count(DISTINCT proyecto) AS "N�mero de proyectos con caraga de trabajo"
FROM proyectos_empleados
WHERE horas>0 OR horas IS NOT NULL;

/* --------------------------------------------------------------------------
 * 123. Para cada departamento, en cuÃ¡ntas sedes estÃ¡ presente */

SELECT departamento, count(DISTINCT sede) AS "N�mero de sedes en las que est� presente"
FROM empleados
GROUP BY departamento;

/* 123b. Total de sedes en que estÃ¡ presente el departamento 1 o el 2 */

SELECT count(DISTINCT sede) AS "Total sedes"
FROM empleados
WHERE departamento=1 OR departamento =2;

/* 123c. En cuÃ¡ntas sedes estÃ¡n presentes LOS DEPARTAMENTOS DE CLAVE 1 Y 2 */

SELECT departamento, count(DISTINCT sede) AS "N�mero de sedes en las que est� presente"
FROM empleados
WHERE departamento =1 OR departamento =2
GROUP BY departamento;

/* -------------------------------------------------------------------------
 * 124. Mostrar la fecha en la que se incorporÃ³ el Ãºltimo empleado a cada proyecto */

SELECT max(fincorporacion) AS "Fecha de incorporaci�n", proyecto
FROM proyectos_empleados
GROUP BY proyecto;


/* 125. CUÃ�NTOS SALARIOS distintos TENEMOS EN LA EMPRESA */

SELECT count(DISTINCT salario) AS "N�mero de distintos salarios"
FROM empleados;

/* 126. CUÃ�NTOS EMPLEADOS DE los DEPARTAMENTOs 2 Y 3 NO TIENEN SUPERVISOR 
 * Y CÃšAL ES SU MEDIA DE SALARIO */

SELECT count(id) AS "N�mero de empleados", format(avg(salario),2) AS "Salario medio"
FROM empleados
WHERE (supervisor IS NULL OR supervisor = id) AND (departamento =2 OR departamento =3);

/* 127. Por cada departamento, cuÃ¡ntos empleados no tienen supervisor */

SELECT departamento, count(id) AS "Empleados sin supervisor"
FROM empleados
WHERE supervisor IS NULL OR supervisor = id
GROUP BY departamento;

/* 128. LISTA DE CLAVES PRIMARIAS DE LOS EMPLEADOS QUE SON SUPERVISORES */

SELECT DISTINCT supervisor
FROM empleados
WHERE supervisor IS NOT NULL;

/* 129. CUÃ�NTOS EMPLEADOS SON SUPERVISORES */

SELECT count( DISTINCT supervisor) AS "N�mero de supervisores"
FROM empleados
WHERE supervisor IS NOT NULL;

/* 130. PARA CADA DEPARTAMENTO EN LA EMPRESA, CANTIDAD DE EMPLEADOS ASIGNADOS, 
MAYOR Y MENOR SALARIO DEL DEPARTAMENTO y media de ellos */

SELECT departamento, 
	count(id) AS "N�mero de epleados", 
	min(salario) AS "Salario m�nimo", 
	max(salario) AS "Salario m�ximo", 
	format(avg(salario),2) AS "Media de salarios"
FROM empleados
GROUP by departamento;

/* 131. PARA CADA DEPARTAMENTO EN LA EMPRESA, CANTIDAD DE EMPLEADOS ASIGNADOS, 
MAYOR Y MENOR SALARIO DEL DEPARTAMENTO, CANTIDAD DE EMPLEADOS CON SUPERVISOR, 
Y LA CANTIDAD DE EMPLEADOS SIN SUPERVISOR */

SELECT departamento, 
	count(id) AS "N�mero de empleados",
	min(salario) AS "Salario m�nimo",
	max(salario) AS "Salario m�ximo",
	count(supervisor) AS "Supervisados",
	count(id)-count(supervisor) AS "No supervisados"
FROM empleados
GROUP BY departamento;

/* 132. Mismos datos que la anterior, pero solo para aquellos departamentos que
tengan mÃ¡s de 4 empleados */

SELECT departamento, 
	count(id) AS "N�mero de empleados",
	min(salario) AS "Salario m�nimo",
	max(salario) AS "Salario m�ximo",
	count(supervisor) AS "Supervisados",
	count(id)-count(supervisor) AS "No supervisados"
FROM empleados
GROUP BY departamento
HAVING count(id)>4;

/* 133. PARA CADA PROYECTO, CANTIDAD DE EMPLEADOS TRABAJANDO EN Ã‰L, 
TOTAL DE HORAS DE TRABAJO ASIGNADAS Y FECHA MÃ�S ANTIGUA DE ASIGNACIÃ“N */

SELECT proyecto, 
	count(empleado) AS "N�mero de empleados", 
	format(sum(time_to_sec(horas)/3600),2) AS horas, 
	min(fincorporacion) AS "Fecha m�s antigua de incoporaci�n"
FROM proyectos_empleados
GROUP BY proyecto;

/* 134. PARA CADA PROYECTO, CANTIDAD DE EMPLEADOS TRABAJANDO EN Ã‰L, 
TOTAL HORAS ASIGNADAS, aÃ±o DE ASIGNACIÃ“N MÃ�S ANTIGUO */

SELECT proyecto, 
	count(empleado) AS "N�mero de empleados", 
	format(sum(time_to_sec(horas)/3600),2) AS horas, 
	min(year(fincorporacion)) AS "A�o m�s antiguo de incoporaci�n"
FROM proyectos_empleados
GROUP BY proyecto;

/* 135. PARA CADA PROYECTO, CANTIDAD DE EMPLEADOS TRABAJANDO EN Ã‰L Y 
MEDIA DE HORAS ASIGNADAS, SÃ“LO PARA LOS PROYECTOS QUE TENGAN MÃ�S DE 
51 HORAS TOTALES ASIGNADAS */

SELECT proyecto, 
	count(empleado) AS "N�mero de empleados", 
	format(avg(time_to_sec(horas)/3600),2) AS media_horas 
FROM proyectos_empleados
GROUP BY proyecto
HAVING sum(time_to_sec(horas))/3600>51;

/* 136. POR CADA EMPLEADO QUE TENGA FAMILIARES REGISTRADOS,
MOSTRAR SU CLAVE Y LA CANTIDAD DE FAMILIARES QUE HA REGISTRADO */

SELECT empleado, count(familiar) AS "N�mero de familiares registrados"
FROM familiares_emp
GROUP BY empleado;

/* 137. POR CADA EMPLEADO, nÃºmero de PROYECTOS asignados con posterioridad
a mayo del 2017 Y nÃºmero de HORAS asignadas en estos proyectos */

SELECT empleado, count(proyecto) AS "N�mero de proyectos", sec_to_time(sum(time_to_sec(horas))) AS horas
FROM proyectos_empleados
WHERE fincorporacion >"2017-05-31"
GROUP BY empleado;

/* 138. OBTENER POR CADA SUPERVISOR: SU CLAVE y LA CANTIDAD DE EMPLEADOS A LOS QUE 
 * SUPERVISA */

SELECT supervisor, count(id) AS "Supervisados"
FROM empleados
WHERE supervisor IS NOT NULL
GROUP BY supervisor;

/* 139. POR CADA DEPARTAMENTO, LA CANTIDAD DE PROYECTOS QUE HA LANZADO O CREADO */

SELECT dept_coord, count(id) AS "N�mero de proyectos"
FROM proyectos
WHERE fecha_inicio < curdate()
GROUP BY dept_coord;


/* -------------------------------------------------------
 * ---- USO DE LIKE */


/* 140. Empleados cuyo primer apellido empieza por "D" */

SELECT concat(nombre,' ',apellidos) AS empleados
FROM empleados
WHERE apellidos LIKE 'D%';

/* 141. Empleados con algÃºn apellido que empiece por "A" */

SELECT concat(nombre,' ',apellidos) AS empleados
FROM empleados
WHERE apellidos LIKE 'A%' OR apellidos LIKE '% A%';

/* 142. Empleados con algÃºn apellido que empiece por "A" mayÃºscula */

SELECT concat(nombre,' ',apellidos) AS empleados
FROM empleados
WHERE apellidos LIKE BINARY 'A%' OR apellidos LIKE BINARY '% A%';

/* 143. Empleados que tengan en su DNI el caracter "5" */

SELECT concat(nombre,' ',apellidos) AS empleados, nif
FROM empleados
WHERE nif LIKE '%5%';

/* 144. Empleados que tengan un DNI cuya segunda cifra sea 5 */

SELECT concat(nombre,' ',apellidos) AS empleados, nif
FROM empleados
WHERE nif LIKE '_5%';

/* 144. Empleados mostrando su nombre completamente en mayÃºsculas 
 * y sus apellidos completamente en minÃºsculas */

SELECT concat(upper(nombre),' ',lower(apellidos)) AS empleados
FROM empleados;








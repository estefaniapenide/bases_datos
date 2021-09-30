USE prof_mod_ciclos_3;

/* Para cada consulta, solo se pueden utilizar como valores literales aquellos indicados en 
 * el enunciado:
 * Si el enunciado cita "DAM", se puede utilizar ese literal, pero si el enunciado dice
 * "Desarrollo de Aplicaciones Multiplataforma", ha de utilizarse este nombre.
 * 
 * En el resultado mostrado, pueden añadirse campos no pedidos explícitamente si son necesarios para
 * clarificar el resultado (por ejemplo para diferenciar el mismo módulo en distintos ciclos/regímenes).
 * 
 * Cada respuesta debe ir debajo del comentario con su número.
 * Debe ser posible ejecutar este script completo sin que dé error.
 * 
 * Normas de entrega:
 * El fichero debe nombrarse con el nombre del alumno/a siguiendo el formato "Apellido1_Nombre.sql".
 * 
 * Completar también los siguientes datos:
 * 
 * Nombre:
 * Grupo: [DUAL, Adultos A o Adultos B]
 * 
 * */



/* ---------------------------------------------------------------------------------------------------
 * 1. Listado de profesores (nombre y primer apellido) junto con el número de módulo que tiene 
 * asignados ordenados de mayor a menor. Un mismo módulo impartido en grupos distintos 
 * (ciclo y/o régimen) se cuenta como distinto. */

SELECT nombre, apellido1, count(modulo) AS modulos
FROM profesores P LEFT JOIN modulos_ciclo MC ON MC.profesor=P.id
GROUP BY P.id
ORDER BY modulos DESC;

SELECT P.nif, P.nombre, P.apellido1, count(modulo) AS num_modulos
FROM modulos_ciclo MC RIGHT JOIN profesores P ON MC.profesor=P.id
GROUP BY P.id
ORDER BY num_modulos DESC;

/* 1b. Si contabilizamos cada módulo igual (misma clave de módulo 
 * aunque sea en distintos regímenes/ciclos) */

select concat_ws(" ", p.nombre, p.apellido1) as NombreProfesor,
	count(DISTINCT mc.modulo) as NumeroModulosAsiganados
from profesores p left join modulos_ciclo mc on p.id=mc.profesor
group by p.id
order by NumeroModulosAsiganados desc;



/* ---------------------------------------------------------------------------------------------------
 * 2. Nombre de aquellos módulos que tienen como prerrequisito "Programación" o
 * "Bases de datos" */

SELECT m.nombre AS modulo
FROM modulos m JOIN prerrequisitos mp ON m.cod=mp.modulo
	JOIN modulos p ON p.cod=mp.prerrequisito 
WHERE P.nombre IN ('Programación', 'Bases de datos');

SELECT nombre AS modulo
FROM modulos M JOIN prerrequisitos P ON m.cod=p.modulo
WHERE p.prerrequisito IN 
	(SELECT cod FROM modulos WHERE nombre IN ('Programación', 'Bases de datos'));



/* ---------------------------------------------------------------------------------------------------
 * 3. Profesores (nombre y apellidos) que imparten módulos que no tengan ningún 
 * prerrequisito */

SELECT DISTINCT id, nombre, apellido1, apellido2
FROM profesores p JOIN modulos_ciclo mc ON mc.profesor=p.id
WHERE mc.modulo NOT IN (SELECT DISTINCT modulo FROM prerrequisitos);

select DISTINCT id, concat_ws(" ", p.nombre, p.apellido1, p.apellido2) as profesor
from profesores p join modulos_ciclo mc on p.id = mc.profesor 
		 join modulos m on m.cod = mc.modulo 
		 	left join prerrequisitos p2 on p2.modulo = m.cod 
where prerrequisito is null;


/* ---------------------------------------------------------------------------------------------------
 * 4. Cantidad de profesores de la especialidad de "Informática" que se 
 * incorporaron cada año, junto con su salario medio (el de los profesores por 
 * año de incorporación). Debe aparecer también una última fila con el total de 
 * profesores de esa especialidad y el salario medio general. */


(
SELECT year(fecha_incorporación) as "Año Incorporación",
	count(id) as "Profesores incorporados",
	format(avg(salario),2) AS "Salario medio"
FROM profesores p 
WHERE especialidad = (SELECT cod FROM especialidades WHERE nombre='Informática')
GROUP BY year(fecha_incorporación)
ORDER BY year(fecha_incorporación)
)
union
(
SELECT 'Total', count(id), format(avg(salario),2)
FROM profesores p
WHERE especialidad = (SELECT cod FROM especialidades WHERE nombre='Informática')
);


WITH prof_informatica AS (
	SELECT year(fecha_incorporación) as anho, id, salario
	FROM profesores p 
	WHERE especialidad = (SELECT cod FROM especialidades WHERE nombre='Informática')
)
(
SELECT anho as "Año Incorporación",
	count(id) as "Profesores incorporados",
	format(avg(salario),2) AS "Salario medio"
FROM prof_informatica p
GROUP BY anho
ORDER BY anho
)
union
(
SELECT 'Total', count(id), format(avg(salario),2)
FROM prof_informatica p
)



SELECT YEAR(P.fecha_incorporación) AS anho, COUNT(P.id) AS nprofes, AVG(P.salario)
FROM profesores P INNER JOIN especialidades E
	 ON P.especialidad = E.cod 
WHERE E.nombre="Informática"
GROUP BY YEAR(P.fecha_incorporación) 
-- union...
;

/* ---------------------------------------------------------------------------------------------------
 * 5. Especialidades presentes (su nombre) junto con el número de profesores y el 
 * número de módulos de cada especialidad */

SELECT E.nombre, count(DISTINCT P.id) AS profesores, count(DISTINCT M.cod) AS modulos
FROM especialidades E LEFT JOIN profesores P ON E.cod=P.especialidad
	LEFT JOIN modulos M ON E.cod=M.especialidad
GROUP BY E.cod;



/* ---------------------------------------------------------------------------------------------------
 * 6. Mostrar todos los módulos (sus siglas) del ciclo "Desenvolvemento de 
 * aplicacións multiplataforma" junto con el nombre de la especialidad a 
 * la que pertenecen */

SELECT DISTINCT M.siglas, E.nombre
FROM modulos M JOIN modulos_ciclo MC ON MC.modulo=M.cod
	LEFT JOIN especialidades E ON M.especialidad=E.cod -- Hay módulos con especialidad a NULL
WHERE ciclo = (SELECT cod FROM ciclos WHERE nombre='Desenvolvemento de aplicacións multiplataforma');

SELECT DISTINCT M.siglas, E.nombre
FROM modulos M INNER JOIN modulos_ciclo MC ON M.cod = MC.modulo
	INNER JOIN ciclos C ON MC.ciclo = C.cod
	LEFT JOIN especialidades E ON M.especialidad = E.cod
WHERE C.nombre='Desenvolvemento de aplicacións multiplataforma';



/* ---------------------------------------------------------------------------------------------------
 * 7. Módulos (sus siglas) impartidos por "Alejandro Vidal" con el número de módulos 
 * del que son prerrequisito */


SELECT mc.profesor, siglas, count(DISTINCT p.modulo)
FROM modulos m JOIN modulos_ciclo mc ON mc.modulo=m.cod
	LEFT JOIN prerrequisitos p ON p.prerrequisito=m.cod 
WHERE profesor IN (SELECT id FROM profesores WHERE nombre='Alejandro' AND apellido1='Vidal')
GROUP BY m.cod;


SELECT p.nif, siglas, count(DISTINCT pm.modulo)
FROM modulos m JOIN modulos_ciclo mc ON mc.modulo=m.cod
	JOIN profesores p ON mc.profesor=p.id 
	LEFT JOIN prerrequisitos pm ON pm.prerrequisito=m.cod 
WHERE p.nombre='Alejandro' AND p.apellido1='Vidal'
GROUP BY m.cod;


WITH MAV AS (
	SELECT DISTINCT p.nif, modulo
	FROM modulos_ciclo mc JOIN profesores p ON mc.profesor=p.id
	WHERE nombre='Alejandro' AND apellido1='Vidal'
),
SAV AS (
	SELECT MAV.nif, siglas, MAV.modulo
	FROM modulos m JOIN MAV ON m.cod=MAV.modulo
),
PNM AS (
	SELECT prerrequisito, count(modulo) AS num_mod
	FROM prerrequisitos
	GROUP BY prerrequisito
)
SELECT SAV.nif, SAV.siglas, COALESCE(PNM.num_mod,0)
FROM SAV LEFT JOIN PNM ON SAV.modulo=PNM.prerrequisito



/* ---------------------------------------------------------------------------------------------------
 * 8. Módulos (sus siglas) que son prerrequisito de otro de otra especialidad */

SELECT DISTINCT P.siglas
FROM modulos M JOIN prerrequisitos PM ON M.cod=PM.modulo
	JOIN modulos P ON PM.prerrequisito=P.cod
WHERE M.especialidad<>P.especialidad;



/* ---------------------------------------------------------------------------------------------------
 * 9. Sesiones semanales medias de los módulos de cada ciclo en cada régimen */

select ciclo, regimen, round(avg(sesiones),1) AS "Sesiones semanales"
from modulos_ciclo mc 
group by ciclo, regimen;



/* ---------------------------------------------------------------------------------------------------
 * 10. Listado de posibles combinaciones de tres módulos que sumen entre 18 y 21 
 * sesiones (inclusive) solo contemplando módulos de régimen de adultos o de régimen
 * dual y de la especialidad de Informática.
 * Por ejemplo:
+---------------------+---------------------+------------------+------------+
| modulo1             | modulo2             | modulo3          | sesiones_t |
+---------------------+---------------------+------------------+------------+
| DAM Adultos - LMSXI | DAM Dual - LMSXI    | DAM Adultos - PR |         20 |
| DAM Dual - LMSXI 	  | DAM Adultos - LMSXI | DAM Adultos - PR |         20 |
| DAM Adultos - LMSXI | DAM Dual - LMSXI    | DAM Adultos - BD |         18 |
|                    ...												    |

No es necesario eliminar bloques duplicados por el orden de columnas 
(como los dos primeros del ejemplo, que son realmente el mismo bloque)
 * */
	
WITH MI AS (
	SELECT CONCAT(mc.ciclo, ' ', mc.regimen, ' - ', m.siglas) AS modulo, sesiones
	FROM modulos m JOIN modulos_ciclo mc ON m.cod=mc.modulo
		JOIN especialidades e on m.especialidad=e.cod
	WHERE regimen IN ('Adultos', 'Dual') AND e.nombre="Informática"
)
SELECT m1.modulo AS modulo1,
		m2.modulo AS modulo2,
		m3.modulo AS modulo3,
		m1.sesiones+m2.sesiones+m3.sesiones as sesiones_t
	FROM MI m1 JOIN MI m2, MI m3
	HAVING sesiones_t>=18 AND sesiones_t<=21 
		AND modulo1<>modulo2 AND modulo1<>modulo3 AND modulo3<>modulo2 -- Eliminamos bloques con módulos duplicados
UNION -- Añadiendo bloques de dos módulos
SELECT m1.modulo AS modulo1,
		m2.modulo AS modulo2,
		NULL,
		m1.sesiones+m2.sesiones as sesiones_t
FROM MI m1, MI m2
HAVING sesiones_t>=18 AND sesiones_t<=21 AND modulo1<>modulo2; 

	
	
	

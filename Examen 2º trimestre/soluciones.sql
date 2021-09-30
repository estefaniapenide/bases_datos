USE prof_mod_ciclos_3;

/* 
 * Para cada consulta, solo se pueden utilizar como valores aquellos indicados en el enunciado:
 * Si el enunciado cita "DAM", se puede utilizar ese literal, pero si el enunciado dice
 * "Desarrollo de Aplicaciones Multiplataforma", ha de utilizarse este nombre.
 * 
 * Cada respuesta debe ir debajo del comentario con su número.
 * 
 * Normas de entrega:
 * El fichero debe nombrarse con vuestro nombre siguiendo el formato "Apellido1_Nombre.sql".
 * 
 * Nombre:
 * Grupo: [DUAL, Adultos A o Adultos B]
 * 
 * */



/* 1. Listado de módulos (su nombre y el código del ciclo o ciclos en que se imparte)
 * de la especialidad "Informática" */

SELECT distinct M.nombre, MC.ciclo
FROM modulos M JOIN especialidades E ON M.especialidad=E.cod
	JOIN modulos_ciclo MC ON M.cod=MC.modulo
WHERE E.nombre="Informática";

SELECT M.nombre, MC.ciclo, MC.regimen -- Especificando el régimen, que es lo que da los duplicados
FROM modulos M JOIN especialidades E ON M.especialidad=E.cod
	JOIN modulos_ciclo MC ON M.cod=MC.modulo
WHERE E.nombre="Informática";

select distinct m.nombre as modulo, mc.ciclo 
from modulos m join modulos_ciclo mc on m.cod = mc.modulo
where m.especialidad = (select cod from especialidades where nombre = "Informática");



/* 2. Módulos con sus prerrequisitos (aquellos que los tienen), mostrando de ambos su curso y siglas */

SELECT M.curso, M.siglas, P.curso, P.siglas 
FROM modulos M JOIN prerrequisitos MP ON M.cod=MP.modulo
	JOIN modulos P ON P.cod=MP.prerrequisito;



/* 3. Profesores que imparten módulos que no son de su especialidad. Se mostrará el 
 * nombre (y apellidos) del profesor con las siglas de los módulos que imparten
 * que no sean de su especialidad */

SELECT P.id, P.nombre, P.apellido1, M.siglas 
FROM profesores P JOIN modulos_ciclo MC ON MC.profesor=P.id
	JOIN modulos M ON M.cod=MC.modulo
WHERE P.especialidad != M.especialidad;



/* 4. Dado que, por error de diseño, la columna nif no cuenta con un índice UNIQUE, 
 * se pide mostrar aquellos profesores que tienen el mismo nif, para comprobar posibles errores.
 * Debe mostrarse su id, nombre completo y nif. De ser más de uno, deben mostrarse agrupando 
 * (mostrando seguidos) aquellos que tengan el mismo nif */

SELECT id, nombre, apellido1, nif
FROM profesores
WHERE nif IN (SELECT nif
				FROM profesores
				GROUP BY nif
				HAVING COUNT(*)>1)
ORDER BY nif;

SELECT trim(CONCAT(P.NOMBRE ," ",p.APELLIDO1," ", COALESCE(p.APELLIDO2 ,""))) AS nombreCompleto, p.NIF
FROM profesores p, profesores P2
WHERE p2.nif=p.nif AND p2.id!=p.id
ORDER BY nif;
			


/* 5. Informe de profesores (nombre completo) y módulos que imparten (sus siglas). 
 * Deben mostrarse juntos (seguidos) los módulos de cada profesor, ordenados de mayor a menor número de sesiones. */

SELECT concat_ws(" ", p.nombre, p.apellido1, p.apellido2) AS profesor, ciclo, regimen, M.cod, M.nombre, sesiones
FROM profesores P JOIN modulos_ciclo MC ON P.id=MC.profesor
	JOIN modulos M ON MC.modulo=M.cod
ORDER BY id, sesiones DESC;



/* 6. Mostrar todos los módulos de DAM Adultos (sus siglas) con el nombre del profesor 
 * que los imparte, si lo hay (el nombre) */

SELECT M.siglas, concat_ws(" ", p.nombre, p.apellido1, p.apellido2) AS profesor
FROM modulos M JOIN modulos_ciclo MC ON M.cod=MC.modulo
	LEFT JOIN profesores P ON P.id=MC.profesor
WHERE ciclo="DAM" AND regimen="Adultos";



/* 7. Módulos (sus siglas) con su número de prerrequisitos y con el número de módulos del que son prerrequisito */

/* Módulos con número de prerrequisitos */
SELECT M.siglas, count(prerrequisito) AS prerreq_de 
FROM modulos M LEFT JOIN prerrequisitos P ON M.cod=P.modulo
GROUP BY M.cod;

/* Módulos con número de módulos de los que son prerrequisitos */
SELECT M.siglas, count(modulo) AS prerrequisitos 
FROM modulos M LEFT JOIN prerrequisitos P ON M.cod=P.prerrequisito
GROUP BY M.cod;

SELECT M.siglas, count(P1.modulo) AS prerre_de, count(P2.prerrequisito) AS prerrequisitos
FROM modulos M LEFT JOIN prerrequisitos P1 ON M.cod=P1.prerrequisito /* Interrelación de prerrequisito */
	LEFT JOIN prerrequisitos P2 ON M.cod=P2.modulo  /* Interrelación de tener prerrequisito */
GROUP BY M.cod;


/* 8. Mostrar el listado de módulos, por sus siglas, junto con el número de modulos del que son prerrequisito
 * y el número de ciclos en que está presente. */

SELECT PRE.siglas, prerreq_de, ciclos
FROM ( 
		SELECT M.siglas, count(P.modulo) AS prerreq_de 
		FROM modulos M LEFT JOIN prerrequisitos P ON M.cod=P.prerrequisito
		GROUP BY M.cod
	) PRE /* Módulos con número de módulos de los que son prerrequisitos */
JOIN
	(
		SELECT M.siglas, count(DISTINCT ciclo) AS ciclos
		FROM modulos M LEFT JOIN modulos_ciclo MC ON MC.modulo=M.cod
		GROUP BY M.siglas
	) C /* Módulos con número de ciclos en que están */
ON PRE.siglas=C.siglas;

SELECT m.siglas,
	count(DISTINCT P.modulo) AS "Es prerrequisito de",
	count(DISTINCT mc.ciclo) AS "Número de ciclos"
FROM modulos m LEFT JOIN prerrequisitos P ON m.cod = P.prerrequisito
	JOIN modulos_ciclo mc ON mc.modulo = m.cod
GROUP BY m.cod;


			
/* 9. Profesores (su nombre completo en la primera columna) que tengan menos de 18 sesiones lectivas semanales
 * asignadas con su número total de sesiones lectivas semanales y el número de módulos que imparten */
			
SELECT /* trim(CONCAT(P.NOMBRE ," ",p.APELLIDO1," ", COALESCE(p.APELLIDO2 ,""))) AS profesor, */
	concat_ws(" ", p.nombre, p.apellido1, p.apellido2) AS profesor,
	COALESCE(sum(sesiones),0) AS sesiones,
	count(MC.modulo) AS modulos /* Valdría con DISTINCT si se cuenta una vez el mismo módulo en varios ciclos/regímenes */
FROM profesores P LEFT JOIN modulos_ciclo MC ON P.id=MC.profesor
GROUP BY P.id /* Nunca se debe agrupar por campos que puedan ser iguales para diferentes tuplas (como nombre de persona) */
HAVING sesiones<18; /* HAVING sum(sesiones)<18 OR sum(sesiones) IS NULL; */



/* 10. Ciclo, régimen, siglas y sesiones semanales de aquellos módulos que, no estando asignados a 
 * ningún profesor, puedan asignarse a Dennis Ritchie sin superar las 21 horas. */

SELECT ciclo, regimen, siglas, sesiones
FROM modulos M JOIN modulos_ciclo MC ON M.cod=MC.modulo
WHERE sesiones <= 
(
	SELECT 21-sum(sesiones)
	FROM profesores P JOIN modulos_ciclo MC ON P.id=MC.profesor
	WHERE P.Nombre = "Dennis" AND P.Apellido1 ="Ritchie"
)
AND MC.profesor IS NULL;

SELECT c.nombre AS "Ciclo", mc.regimen, m.siglas, mc.sesiones
FROM modulos m JOIN modulos_ciclo mc ON mc.modulo = m.cod 
	JOIN ciclos c ON c.cod = mc.ciclo 
WHERE mc.profesor IS NULL 
	AND (SELECT sum(mc2.sesiones) 
			FROM modulos_ciclo mc2 JOIN profesores p2 ON mc2.profesor = p2.id 
			WHERE p2.nombre = "Dennis" AND p2.apellido1 = "Ritchie") 
		+ mc.sesiones <= 21;




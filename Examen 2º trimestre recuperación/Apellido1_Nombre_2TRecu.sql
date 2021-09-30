USE prof_mod_ciclos_3;

/* Para cada consulta, solo se pueden utilizar como valores literales aquellos indicados en el enunciado:
 * Si el enunciado cita "DAM", se puede utilizar ese literal, pero si el enunciado dice
 * "Desarrollo de Aplicaciones Multiplataforma", ha de utilizarse este nombre.
 * 
 * En el resultado mostrado, pueden a帽adirse campos no pedidos expl铆citamente si son necesarios para
 * clarificar el resultado (por ejemplo para diferenciar el mismo m贸dulo en distintos ciclos/reg铆menes).
 * 
 * Cada respuesta debe ir debajo del comentario con su n煤mero.
 * Debe ser posible ejecutar este script completo sin que d茅 error.
 * 
 * Normas de entrega:
 * El fichero debe nombrarse con el nombre del alumno/a siguiendo el formato "Apellido1_Nombre.sql".
 * 
 * Completar tambi茅n los siguientes datos:
 * 
 * Nombre: Estefan韆 Penide Casanova
 * Grupo: Adultos A
 * 
 * */


/* ---------------------------------------------------------------------------------------------------
 * 1. Listado de profesores (nombre y primer apellido) junto con el n煤mero de m贸dulo que tiene asignados ordenados
 * de mayor a menor. Un mismo m贸dulo impartido en grupos distintos (ciclo y/o r茅gimen) se cuenta como distinto. */
SELECT concat(P.nombre," ",P.apellido1) AS Profesor, count(MC.modulo) AS numero_modulos
FROM profesores P LEFT JOIN modulos_ciclo MC ON MC.profesor = P.id
GROUP BY P.id 
ORDER BY numero_modulos desc;


/* ---------------------------------------------------------------------------------------------------
 * 2. Nombre de aquellos m贸dulos que tienen como prerrequisito "Programaci贸n" o el "Bases de datos" */
SELECT M.nombre
FROM modulos M JOIN prerrequisitos PR ON PR.modulo = M.cod
JOIN modulos M2 ON M2.cod = PR.prerrequisito 
WHERE M2.nombre ='Programaci贸n' OR M2.nombre='Bases de datos';


/* ---------------------------------------------------------------------------------------------------
 * 3. Profesores (nombre y apellidos) que imparten m贸dulos que no tengan ning煤n prerrequisito */
SELECT DISTINCT concat(P.nombre, P.apellido1,COALESCE (P.apellido2,"")) AS "Profesores con m骴ulos sin prerrequisto"
FROM profesores P LEFT JOIN modulos_ciclo MC ON MC.profesor =P.id 
LEFT JOIN modulos M ON M.cod = MC.modulo 
LEFT JOIN prerrequisitos PR ON PR.modulo = M.cod
WHERE PR.prerrequisito IS NULL;


/* ---------------------------------------------------------------------------------------------------
 * 4. Cantidad de profesores de la especialidad de "Inform谩tica" que se incorporaron cada a帽o,
 * junto con su salario medio (el de los profesores por a帽o de incorporaci贸n).
 * Debe aparecer tambi茅n una 煤ltima fila con el total de profesores y el salario medio general. */
(SELECT YEAR(P.`fecha_incorporaci贸n`) AS "A駉_incorporaci髇", count(P.id) AS "Profe_infor_incorporados",format(avg(salario),2) AS salario_medio, E.nombre AS especialidad
FROM profesores P LEFT JOIN especialidades E ON E.cod =P.especialidad 
GROUP BY YEAR(P.`fecha_incorporaci贸n`)
HAVING E.nombre ='Inform谩tica')
UNION
(SELECT 'Total',count(id), format(avg(salario),2),'---'
FROM profesores p
);


/* ---------------------------------------------------------------------------------------------------
 * 5. Especialidades presentes (su nombre) junto con el n煤mero de profesores y el n煤mero de m贸dulos de 
 * cada especialidad */

SELECT E.nombre AS "Especialidad", count(DISTINCT P.id) AS "Profesores", count(DISTINCT M.cod) AS "M骴ulos"
FROM especialidades E  JOIN modulos M ON M.especialidad = E.cod 
	JOIN profesores P ON P.especialidad = E.cod 
GROUP BY E.cod;


/* ---------------------------------------------------------------------------------------------------
 * 6. Mostrar todos los m贸dulos (sus siglas) del ciclo "Desenvolvemento de aplicaci贸ns multiplataforma" 
 * junto con el nombre de la especialidad a la que pertenecen */
SELECT DISTINCT M.siglas AS "M骴ulos_DAM", COALESCE(E.nombre,"-") AS Especialidad
FROM modulos M LEFT JOIN modulos_ciclo MC ON MC.modulo = M.cod 
LEFT JOIN ciclos C ON C.cod = MC.ciclo 
LEFT JOIN especialidades E ON E.cod = M.especialidad 
WHERE C.nombre ='Desenvolvemento de aplicaci贸ns multiplataforma';


/* ---------------------------------------------------------------------------------------------------
 * 7. M贸dulos (sus siglas) impartidos por "Alejandro Vidal" con el n煤mero de m贸dulos 
 * del que son prerrequisito */
SELECT M.siglas AS "M骴ulos"
FROM modulos M LEFT JOIN modulos_ciclo MC ON MC.modulo = M.cod 
LEFT JOIN profesores P ON MC.profesor = P.id 
WHERE P.nombre ='Alejandro' AND P.apellido1 = 'Vidal';

SELECT M.cod, COUNT(PR.prerrequisito) AS "Prerrequisito de x m骴ulos"
FROM modulos M LEFT JOIN prerrequisitos PR ON PR.prerrequisito = M.cod 
GROUP BY M.cod;

SELECT M.siglas AS "M骴ulos impartidos por Alejandro Vidal" , COUNT(PR.prerrequisito) AS "Prerrequisito de x m骴ulos"
FROM modulos M LEFT JOIN prerrequisitos PR ON PR.prerrequisito = M.cod 
JOIN modulos_ciclo MC ON MC.modulo = M.cod 
LEFT JOIN profesores P ON MC.profesor = P.id 
WHERE P.nombre ='Alejandro' AND P.apellido1 = 'Vidal'
GROUP BY MC.regimen, M.cod;
/*Agrupo por r間imen y luego por m骴ulo para evitar que junte las dos BD (una de r間imen adultos y otra de dual) en una sola fila y sume las dos filas de columna "prerrequisito de x m骴ulos" de BD  */


SELECT *
FROM prerrequisitos p;

SELECT siglas, cod
FROM modulos m;

SELECT nombre, apellido1, id
FROM profesores p
WHERE nombre ='Alejandro';

SELECT *
FROM modulos_ciclo mc
WHERE profesor=209 OR profesor = 307;


			
/* ---------------------------------------------------------------------------------------------------
 * 8. M贸dulos (sus siglas) que son prerrequisito de otro de otra especialidad */
SELECT DISTINCT M.siglas
FROM modulos M JOIN prerrequisitos PR ON PR.prerrequisito = M.cod 
JOIN modulos M2 ON PR.modulo = M2.cod 
WHERE M2.especialidad != M.especialidad;

/* ---------------------------------------------------------------------------------------------------
 * 9. Sesiones semanales medias de los m贸dulos de cada ciclo en cada r茅gimen */

SELECT regimen, ciclo, format(avg(sesiones),2) AS "Media sesiones semanales"
FROM modulos_ciclo mc
GROUP BY ciclo, regimen;

(SELECT regimen, ciclo, format(avg(sesiones),2) AS "Media sesiones semanales"
FROM modulos_ciclo
WHERE regimen='Adultos'
GROUP BY ciclo)
UNION
(SELECT regimen, ciclo, format(avg(sesiones),2) AS "Media sesiones semanales"
FROM modulos_ciclo
WHERE regimen='Dual'
GROUP BY ciclo)
UNION
(SELECT regimen, ciclo, format(avg(sesiones),2) AS "Media sesiones semanales"
FROM modulos_ciclo
WHERE regimen='Ordinario'
GROUP BY ciclo)
UNION
(SELECT regimen, ciclo, format(avg(sesiones),2) AS "Media sesiones semanales"
FROM modulos_ciclo
WHERE regimen='Distancia'
GROUP BY ciclo);



/* ---------------------------------------------------------------------------------------------------
 * 10. Listado de posibles combinaciones de tres m贸dulos que sumen entre 18 y 21 sesiones (inclusive)
 * solo contemplando m贸dulos de r茅gimen de adultos o de r茅gimen dual y de la especialidad de Inform谩tica.
 * Por ejemplo:
+---------------------+---------------------+------------------+------------+
| modulo1             | modulo2             | modulo3          | sesiones_t |
+---------------------+---------------------+------------------+------------+
| DAM Adultos - LMSXI | DAM Dual - LMSXI    | DAM Adultos - PR |         20 |
| DAM Dual - LMSXI 	  | DAM Adultos - LMSXI | DAM Adultos - PR |         20 |
| DAM Adultos - LMSXI | DAM Dual - LMSXI    | DAM Adultos - BD |         18 |
|                    ...												    |
No es necesario eliminar bloques duplicados por el orden (como los dos primeros del ejemplo, que son iguales)
 * */ 


SELECT  MC.ciclo, MC.regimen,M.nombre, MC.sesiones 
FROM modulos_ciclo MC LEFT JOIN modulos M ON M.cod = MC.modulo 
LEFT JOIN especialidades E ON E.cod = M.especialidad 
WHERE (MC.regimen ='Adultos' OR MC.regimen ='Dual') AND E.nombre ='Inform谩tica';


WITH modulo1 AS 
(SELECT concat(MC.ciclo," ",MC.regimen," - ",M.siglas) AS modulo, MC.sesiones 
FROM modulos_ciclo MC LEFT JOIN modulos M ON M.cod = MC.modulo 
LEFT JOIN especialidades E ON E.cod = M.especialidad 
WHERE (MC.regimen ='Adultos' OR MC.regimen ='Dual') AND E.nombre ='Inform谩tica'),
modulo2 AS 
(SELECT concat(MC.ciclo," ",MC.regimen," - ",M.siglas) AS modulo, MC.sesiones 
FROM modulos_ciclo MC LEFT JOIN modulos M ON M.cod = MC.modulo 
LEFT JOIN especialidades E ON E.cod = M.especialidad 
WHERE (MC.regimen ='Adultos' OR MC.regimen ='Dual') AND E.nombre ='Inform谩tica'),
modulo3 AS 
(SELECT concat(MC.ciclo," ",MC.regimen," - ",M.siglas) AS modulo, MC.sesiones 
FROM modulos_ciclo MC LEFT JOIN modulos M ON M.cod = MC.modulo 
LEFT JOIN especialidades E ON E.cod = M.especialidad 
WHERE (MC.regimen ='Adultos' OR MC.regimen ='Dual') AND E.nombre ='Inform谩tica')
SELECT modulo1.modulo AS "m骴ulo 1", modulo2.modulo AS "m骴ulo 2", modulo3.modulo AS "m骴ulo 3", (modulo1.sesiones + modulo2.sesiones + modulo3.sesiones) AS sesiones_totales
FROM modulo1 LEFT JOIN modulo2 ON modulo1.modulo!=modulo2.modulo
LEFT JOIN modulo3 ON modulo2.modulo!=modulo3.modulo
WHERE (modulo1.sesiones + modulo2.sesiones + modulo3.sesiones) BETWEEN 18 AND 21 AND modulo3.modulo!=modulo1.modulo;

	
	
	

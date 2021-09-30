USE prof_mod_ciclos_3;

/* Para cada consulta, solo se pueden utilizar como valores literales aquellos indicados en el enunciado:
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
 * Nombre: Estefan�a Penide Casanova
 * Grupo: Adultos A
 * 
 * */


/* ---------------------------------------------------------------------------------------------------
 * 1. Listado de profesores (nombre y primer apellido) junto con el número de módulo que tiene asignados ordenados
 * de mayor a menor. Un mismo módulo impartido en grupos distintos (ciclo y/o régimen) se cuenta como distinto. */
SELECT concat(P.nombre," ",P.apellido1) AS Profesor, count(MC.modulo) AS numero_modulos
FROM profesores P LEFT JOIN modulos_ciclo MC ON MC.profesor = P.id
GROUP BY P.id 
ORDER BY numero_modulos desc;


/* ---------------------------------------------------------------------------------------------------
 * 2. Nombre de aquellos módulos que tienen como prerrequisito "Programación" o el "Bases de datos" */
SELECT M.nombre
FROM modulos M JOIN prerrequisitos PR ON PR.modulo = M.cod
JOIN modulos M2 ON M2.cod = PR.prerrequisito 
WHERE M2.nombre ='Programación' OR M2.nombre='Bases de datos';


/* ---------------------------------------------------------------------------------------------------
 * 3. Profesores (nombre y apellidos) que imparten módulos que no tengan ningún prerrequisito */
SELECT DISTINCT concat(P.nombre, P.apellido1,COALESCE (P.apellido2,"")) AS "Profesores con m�dulos sin prerrequisto"
FROM profesores P LEFT JOIN modulos_ciclo MC ON MC.profesor =P.id 
LEFT JOIN modulos M ON M.cod = MC.modulo 
LEFT JOIN prerrequisitos PR ON PR.modulo = M.cod
WHERE PR.prerrequisito IS NULL;


/* ---------------------------------------------------------------------------------------------------
 * 4. Cantidad de profesores de la especialidad de "Informática" que se incorporaron cada año,
 * junto con su salario medio (el de los profesores por año de incorporación).
 * Debe aparecer también una última fila con el total de profesores y el salario medio general. */
(SELECT YEAR(P.`fecha_incorporación`) AS "A�o_incorporaci�n", count(P.id) AS "Profe_infor_incorporados",format(avg(salario),2) AS salario_medio, E.nombre AS especialidad
FROM profesores P LEFT JOIN especialidades E ON E.cod =P.especialidad 
GROUP BY YEAR(P.`fecha_incorporación`)
HAVING E.nombre ='Informática')
UNION
(SELECT 'Total',count(id), format(avg(salario),2),'---'
FROM profesores p
);


/* ---------------------------------------------------------------------------------------------------
 * 5. Especialidades presentes (su nombre) junto con el número de profesores y el número de módulos de 
 * cada especialidad */

SELECT E.nombre AS "Especialidad", count(DISTINCT P.id) AS "Profesores", count(DISTINCT M.cod) AS "M�dulos"
FROM especialidades E  JOIN modulos M ON M.especialidad = E.cod 
	JOIN profesores P ON P.especialidad = E.cod 
GROUP BY E.cod;


/* ---------------------------------------------------------------------------------------------------
 * 6. Mostrar todos los módulos (sus siglas) del ciclo "Desenvolvemento de aplicacións multiplataforma" 
 * junto con el nombre de la especialidad a la que pertenecen */
SELECT DISTINCT M.siglas AS "M�dulos_DAM", COALESCE(E.nombre,"-") AS Especialidad
FROM modulos M LEFT JOIN modulos_ciclo MC ON MC.modulo = M.cod 
LEFT JOIN ciclos C ON C.cod = MC.ciclo 
LEFT JOIN especialidades E ON E.cod = M.especialidad 
WHERE C.nombre ='Desenvolvemento de aplicacións multiplataforma';


/* ---------------------------------------------------------------------------------------------------
 * 7. Módulos (sus siglas) impartidos por "Alejandro Vidal" con el número de módulos 
 * del que son prerrequisito */
SELECT M.siglas AS "M�dulos"
FROM modulos M LEFT JOIN modulos_ciclo MC ON MC.modulo = M.cod 
LEFT JOIN profesores P ON MC.profesor = P.id 
WHERE P.nombre ='Alejandro' AND P.apellido1 = 'Vidal';

SELECT M.cod, COUNT(PR.prerrequisito) AS "Prerrequisito de x m�dulos"
FROM modulos M LEFT JOIN prerrequisitos PR ON PR.prerrequisito = M.cod 
GROUP BY M.cod;

SELECT M.siglas AS "M�dulos impartidos por Alejandro Vidal" , COUNT(PR.prerrequisito) AS "Prerrequisito de x m�dulos"
FROM modulos M LEFT JOIN prerrequisitos PR ON PR.prerrequisito = M.cod 
JOIN modulos_ciclo MC ON MC.modulo = M.cod 
LEFT JOIN profesores P ON MC.profesor = P.id 
WHERE P.nombre ='Alejandro' AND P.apellido1 = 'Vidal'
GROUP BY MC.regimen, M.cod;
/*Agrupo por r�gimen y luego por m�dulo para evitar que junte las dos BD (una de r�gimen adultos y otra de dual) en una sola fila y sume las dos filas de columna "prerrequisito de x m�dulos" de BD  */


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
 * 8. Módulos (sus siglas) que son prerrequisito de otro de otra especialidad */
SELECT DISTINCT M.siglas
FROM modulos M JOIN prerrequisitos PR ON PR.prerrequisito = M.cod 
JOIN modulos M2 ON PR.modulo = M2.cod 
WHERE M2.especialidad != M.especialidad;

/* ---------------------------------------------------------------------------------------------------
 * 9. Sesiones semanales medias de los módulos de cada ciclo en cada régimen */

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
 * 10. Listado de posibles combinaciones de tres módulos que sumen entre 18 y 21 sesiones (inclusive)
 * solo contemplando módulos de régimen de adultos o de régimen dual y de la especialidad de Informática.
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
WHERE (MC.regimen ='Adultos' OR MC.regimen ='Dual') AND E.nombre ='Informática';


WITH modulo1 AS 
(SELECT concat(MC.ciclo," ",MC.regimen," - ",M.siglas) AS modulo, MC.sesiones 
FROM modulos_ciclo MC LEFT JOIN modulos M ON M.cod = MC.modulo 
LEFT JOIN especialidades E ON E.cod = M.especialidad 
WHERE (MC.regimen ='Adultos' OR MC.regimen ='Dual') AND E.nombre ='Informática'),
modulo2 AS 
(SELECT concat(MC.ciclo," ",MC.regimen," - ",M.siglas) AS modulo, MC.sesiones 
FROM modulos_ciclo MC LEFT JOIN modulos M ON M.cod = MC.modulo 
LEFT JOIN especialidades E ON E.cod = M.especialidad 
WHERE (MC.regimen ='Adultos' OR MC.regimen ='Dual') AND E.nombre ='Informática'),
modulo3 AS 
(SELECT concat(MC.ciclo," ",MC.regimen," - ",M.siglas) AS modulo, MC.sesiones 
FROM modulos_ciclo MC LEFT JOIN modulos M ON M.cod = MC.modulo 
LEFT JOIN especialidades E ON E.cod = M.especialidad 
WHERE (MC.regimen ='Adultos' OR MC.regimen ='Dual') AND E.nombre ='Informática')
SELECT modulo1.modulo AS "m�dulo 1", modulo2.modulo AS "m�dulo 2", modulo3.modulo AS "m�dulo 3", (modulo1.sesiones + modulo2.sesiones + modulo3.sesiones) AS sesiones_totales
FROM modulo1 LEFT JOIN modulo2 ON modulo1.modulo!=modulo2.modulo
LEFT JOIN modulo3 ON modulo2.modulo!=modulo3.modulo
WHERE (modulo1.sesiones + modulo2.sesiones + modulo3.sesiones) BETWEEN 18 AND 21 AND modulo3.modulo!=modulo1.modulo;

	
	
	

USE prof_mod_ciclos_3;

/* 
 * Para cada consulta, solo se pueden utilizar como valores aquellos indicados en el enunciado:
 * Si el enunciado cita "DAM", se puede utilizar ese literal, pero si el enunciado dice
 * "Desarrollo de Aplicaciones Multiplataforma", ha de utilizarse este nombre.
 * 
 * Cada respuesta debe ir debajo del comentario con su número.
 * 
 * Normas de entrega:
 * El fichero debe nombrarse con siguiendo el formato "Apellido1_Nombre_2T.sql".
 * Tras entregar, se dejará una copia del examen en el escritorio de la cuenta del usuario,
 * que no deberá tocarse hasta que la nota esté confirmada.
 * 
 * Además, debe escribirse aquí:
 *
 * Nombre: Estefanía Penide Casanova
 * Grupo: Adultos A 
 * 
 * */



/* 1. Listado de módulos (su nombre y el código del ciclo o ciclos en que se imparte)
 * de la especialidad "Informática" */
select distinct M.nombre, C.cod
from modulos M left join modulos_ciclo MC on M.cod = MC.modulo
	 left join ciclos C on MC.ciclo =C.cod
	 left join especialidades E on E.cod = M.especialidad
where E.nombre like 'Inform%';


/* 2. Modulos con sus prerrequisitos, mostrando de ambos su curso y siglas */
select distinct M.cod as "Código módulo", M.siglas as "Módulo", M.curso as "Curos del módulo", 
coalesce (P.cod,"NO tiene") as "Código prerrequisito",
coalesce(P.siglas,"NO tiene") as "Módulo que es prerrequisito",
coalesce(P.curso,"NO tiene") as "Curso del módulo que es prerrequisito"
from modulos M left join prerrequisitos PR on PR.modulo =M.cod
		left join modulos P on PR.prerrequisito = P.cod;

-- Si sólo se quieren listar los módulos que tienen prerrequisitos e ignorar el resto:
select distinct M.cod as "Código módulo", M.siglas as "Módulo", M.curso as "Curos del módulo", 
P.cod as "Código prerrequisito",
P.siglas as "Módulo que es prerrequisito",
P.curso as "Curso del módulo que es prerrequisito"
from modulos M join prerrequisitos PR on PR.modulo =M.cod
		left join modulos P on PR.prerrequisito = P.cod;


/* 3. Profesores que imparten modulos que no son de su especialidad. Se mostrará el 
 * nombre (y apellidos) del profesor con las siglas de los módulos que imparten
 * que no sean de su especialidad */
select P.nombre, P.apellido1, P.apellido2, M.cod as "Módulo"
from profesores p join modulos_ciclo mc on MC.profesor = P.id
	left join modulos M on M.cod =MC.modulo
where P.especialidad <> M.especialidad and M.especialidad is not null;


/* 4. Dado que por error de diseño la columna nif no cuenta con un índice UNIQUE, 
 * se pide mostrar aquellos profesores que tienen el mismo nif, para comprobar posibles errores.
 * Debe mostrarse su id, nombre completo y nif. De ser más de uno, deben mostrarse agrupando 
 * (mostrando seguidos) aquellos que tengan el mismo nif */

 with aux as (select distinct nif
from profesores)
select *
from profesores P left join aux on aux.nif=p.nif;
;

select nif, id
from profesores;
			

/* 5. Informe de profesores (nombre completo) y módulos que imparten. 
 * Deben mostrarse juntos los módulos de cada profesor, ordenados de mayor a menor número de sesiones. */
select P.id, P.nombre, P.apellido1, P.apellido2, MC.modulo, MC.regimen, MC.ciclo,MC.sesiones 
from profesores P left join modulos_ciclo MC on MC.profesor = P.id 
left join modulos M on M.cod =MC.modulo 
order by MC.sesiones desc;


/* 6. Mostrar todos los modulos de DAM Adultos con el nombre del profesor que los imparte, si lo hay */
select MC.modulo as "Código del módulo", M.nombre as "Módulo", coalesce(concat(P.nombre,' ',p.apellido1),"No tiene") as "Profesor"
from modulos_ciclo MC left join profesores P on p.id =MC.profesor 
join modulos M on M.cod = MC.modulo 
where MC.ciclo='DAM' and MC.regimen ='Adultos';


/* 7. Modulos con su número de prerrequisitos y con el número de módulos del que son prerrequisito */
select M.cod, M.nombre, COUNT(PR.prerrequisito) as "Número de prerrequisitos"
from modulos M left join prerrequisitos PR on M.cod = PR.modulo 
group by M.cod;

/
select distinct prerrequisito 
from prerrequisitos;

select *
from prerrequisitos;

select M.cod, M.nombre, COUNT(PR.prerrequisito) as "Número de prerrequisitos", count(PR2.prerrequisito)  as "Número del que son prerrequisito"
from modulos M left join prerrequisitos PR on M.cod = PR.modulo 
left join prerrequisitos PR2 on PR2.modulo  = PR.prerrequisito
group by M.cod;


/* 8. Mostrar el listado de módulos, por sus siglas, junto con el número de modulos del que son prerrequisito Y
 * el número de ciclos en que está presente. */
select M.siglas as "Módulo", count(MC.ciclo) as "Número de ciclos en los que está presente"
from modulos M left join modulos_ciclo MC on MC.modulo=M.cod
group by M.cod;

			
/* 9. Profesores (su nombre completo en la primera columna) que tengan menos de 18 sesiones lectivas semanales
 *  asignadas con su número total de horas lectivas semanales y el número de módulos que imparten */
select concat(P.nombre," ",P.apellido1," ",coalesce(P.apellido2,"")) as "Profesor", sum(MC.sesiones) as "Horas lectivas semanales", count(distinct MC.modulo) as "Número de módulos que imparte"
from profesores P left join modulos_ciclo MC on MC.profesor = P.id
group by P.id 
having sum(MC.sesiones) < 18;


/* 10. Ciclo, régimen, siglas y sesiones semanales de aquellos módulos que, no estando asignados a ningún profesor, 
 * puedan permitir a Dennis Ritchie completar su horario pero sin superar las 21 horas lectivas. */
select M.cod, MC.profesor, MC.ciclo 
from modulos M left join modulos_ciclo MC on M.cod=MC.modulo
where MC.profesor is null;

select P. NOMBRE,P.apellido1, SUM(MC.sesiones) as "Numero de horas que trabaja actualmente" 
from modulos M left join modulos_ciclo MC on M.cod=MC.modulo
left join profesores P on P.id = MC.profesor 
group by P.ID
having P.NOMBRE='Dennis' and P.apellido1 ='Ritchie';

select M.nombre, M.cod, MC.ciclo, SUM(MC.sesiones) as "Horas semanales por módulo en cada ciclo"
from modulos M left join modulos_ciclo MC on M.cod=MC.modulo
group by M.cod, MC.ciclo 
having SUM(MC.sesiones)<=5;









-- Nombre de los empleados que trabajan en el departamento 121

select nomem, numhi from temple;

-- 2. Extraer todos los datos del departamento 121

select nomem from temple where numde=121;

-- 3. Obtener los nombres y sueldos de los empleados con m�s de 3 hijos por orden alfab�tico

select * from tdepto where numde=121;

-- 4. Obtener         la comisi�n, departamentos y nombre de los empleados cuyo salario es inferior a 1900 euros, clasific�ndolos por depart
amento en orden creciente y por comisi�n en orden decreciente dentro de cada departamento.

select nomem, salar from temple where numhi>3 
order by nomem asc;

-- 5. Igual que la anterior, pero las columnas resultantes han de llamarse comisi�n, departamento y empleado.

select comis, numde, nomem from temple
where salar<1900
order by numde asc, comis desc;

select comis as 'Comision', numde as 'Departamento', 
nomem as 'Nombre de empleado' from temple
where salar<1900
order by 2 asc, 1 desc;

-- 6. N�meros de los departamentos donde trabajan empleados con salario inferior a 2500.

select numem, nomem from temple where salar<2500;

-- 7. Obtener los valores diferentes de comisiones que hay en el departamento 110.

select distinct comis from temple where numde=110;

-- 8. Hallar las combinaciones diferentes de valores de salario y comisi�n en el departamento 111, por orden de salario y comisi�n crecientes.

select distinct salar, comis from temple
where numde=111 order by salar , comis ;

-- 9. Obtener los nombres de los empleados cuya comisi�n es superior o igual al 50% de su salario, por orden alfab�tico.

select nomem as 'Nombre' from temple where comis>=(salar*0.5)
order by 1;

-- 10. Obtener por orden alfab�tico los nombres de los empleados cuyo salario supera al m�ximo salario de los empleados del departamento 122.

select nomem from temple where salar>
(select max(salar) from temple where numde=122);

-- 11. Obtener por orden alfab�tico los nombres de los empleados cuyo sueldo supera en tres veces y media o m�s al m�nimo salario de los empleados del departamento 122.

select nomem from temple where salar>3.5*
(select min(salar) from temple where numde=122)
order by 1;
SELECT NOMEM
FROM TEMPLE
WHERE SALAR>=3.5*( SELECT min(SALAR)
                FROM TEMPLE
               WHERE NUMDE=122)


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
------ Predicados
--------------------------------------------------------------------------------

-- 12. Para todos los empleados que tienen comisi�n, hallar sus salarios mensuales totales incluyendo �sta. Ordenarlos por orden alfab�tico. Hallar tambi�n el porcentaje de su salario total que supone la comisi�n.

SELECT NOMEM, SALAR+COMIS AS SALAR_TOT,
        round(COMIS*100/(SALAR+COMIS),2) AS PORC_COMIS
FROM TEMPLE
WHERE COMIS>0
ORDER BY NOMEM, SALAR_TOT DESC




-- 13. Mostrar nombres y presupuestos de los departamentos 111 y 112, de tal manera que aparezcan en la misma fila

select d1.nomde , d1.presu, d2.nomde , d2.presu
from tdepto d1 , tdepto d2 
where d1.numde=111 and d2.numde=112;

select d1.NOMDE , d1.PRESU, d2.NOMDE , d2.PRESU
from
        (SELECT NOMDE, PRESU
        FROM TDEPTO
        WHERE NUMDE=111) AS d1,
   
           (SELECT NOMDE, PRESU
        FROM TDEPTO 
        WHERE NUMDE=112) AS d2


SELECT
        (SELECT NOMDE FROM TDEPTO WHERE NUMDE=111) AS NOMDE_111,
        (SELECT PRESU FROM TDEPTO WHERE NUMDE=111) AS PRESU_111,
    (SELECT concat(NOMDE, " ", PRESU)
      FROM TDEPTO 
        WHERE NUMDE=112) AS DEP_112;




-- 14. Obtener los nombres de los departamentos que no dependen funcionalmente de otros.

select nomde from tdepto where depde is null or depde=0;

-- 15. Para los empleados que no tienen comisi�n obtener por orden alfab�tico el nombre y el cociente entre su salario y el n�mero de hijos.

select nomem, COALESCE(salar/numhi, "Sin hijos") AS "Salario/hijos"
from temple
where (comis=0 or comis is null)
order by nomem;


select nomem, COALESCE(salar/numhi, Salar) AS "Salario/hijos"
from temple
where (comis=0 or comis is null)
order by nomem;




select nomem, salar/numhi from temple
where (comis=0 or comis is null) and numhi>0;

-- 16. Obtener los nombres y salarios de los empleados cuyo salario coincide con la comisi�n de alg�n otro o la suya propia. Ordenarlos alfab�ticamente.

select distinct e1.nomem as Nombre, e1.salar as Salario
from temple e1 , temple e2
where e1.salar=e2.comis
order by e1.nomem;

select nomem, salar from temple 
where salar in (select comis from temple)
order by nomem;


SELECT NOMEM, SALAR
FROM TEMPLE, (SELECT DISTINCT COMIS
                                FROM TEMPLE
                                WHERE COMIS<>0) AS COMISS
WHERE SALAR=COMISS.COMIS
ORDER BY NOMEM




SELECT NOMEM, SALAR
FROM TEMPLE INNER JOIN (SELECT DISTINCT COMIS
                                FROM TEMPLE
                                WHERE COMIS<>0) AS COMISS
WHERE SALAR=COMISS.COMIS
ORDER BY NOMEM




-- 17. Obtener por orden alfab�tico los nombres y salarios de los empleados cuyo salario es inferior a la comisi�n m�s alta existente.

select nomem, salar from temple
where salar<(select max(comis) from temple)
order by nomem;

-- 18. Obtener por orden alfab�tico los nombres y salarios de los empleados cuyo salario es inferior al cu�druplo de la comisi�n m�s baja existente.

select nomem, salar from temple
where salar< (select min(comis)*4 from temple where comis>0)
order by nomem;

-- 19. Obtener por orden alfab�tico los nombres de los empleados cuyo salario est� entre 2500 y 3000 euros.

select nomem, salar from temple
where salar between 2500 and 3000
order by nomem;

-- 20. Obtener por orden alfab�tico los nombres y los salarios de los empleados cuyo salario dividido por su n�mero de hijos cumpla una, o ambas, de las dos condiciones siguientes: Que sea inferior a 1200 euros. Que sea superior al doble de su comisi�n.

select nomem, salar from temple
where (salar/numhi)<1200 or (salar/numhi) > (comis*2) 
order by 1; 

-- 21. En la fiesta de Reyes se desea organizar un espect�culo para los hijos de los empleados, que se representar� en dos d�as diferentes. El primer d�a asistir�n los empleados cuyo apellido empiece por las letras desde A hasta L, ambas inclusive. El segundo d�a se cursar�n invitaciones para el resto. A cada empleado se le asignar�n tantas invitaciones gratuitas como hijos tenga y dos m�s. Adem�s, en la fiesta se entregar� a cada empleado un obsequio por hijo. Obtener una lista por orden alfab�tico de los nombres a quienes hay que invitar el primer d�a de la representaci�n, incluyendo tambi�n cu�ntas invitaciones corresponden a cada nombre y cu�ntos regalos hay que preparar para �l.

select nomem, numhi+2 as 'Invitaciones por nombre', numhi as Regalos
from temple
where nomem between 'A' and 'M'
order by 1;

-- 22. Obtener por orden alfab�tico los nombres de los empleados cuyo primer apellido es Mora o empieza por Mora.

select nomem
from temple
where nomem like 'Mora%'
order by nomem;

-- 23. Obtener por orden alfab�tico los nombres de los empleados cuyo nombre de pila empieza por Valeriana.

select nomem from temple
where nomem like '%,Valeriana%'
order by 1;

-- 24. Obtener por orden alfab�tico los nombres de los empleados cuyo apellido tenga siete letras.

select nomem from temple
where nomem like '_______,%'
order by 1;

-- 25. Obtener por orden alfab�tico los nombres de los empleados cuyo apellido tenga seis o m�s letras.

select nomem from temple
where nomem like '______%,%'
order by 1;

-- 26. Obtener los nombres de los empleados cuyo apellido tenga tres letras o menos.


select nomem from TEMPLE
nomem like '___,%'
        or nomem like '__,%'
        or nomem like '_,%'
        or nomem like ',%'
order by nomem;


-- 27. Obtener por orden alfab�tico los nombres de los empleados cuyo apellido termina en EZ y su nombre de pila termina en O y tiene al menos tres letras.

select nomem from temple
where nomem like '%EZ,%__O'
order by 1;




select nomem from TEMPLE
where nomem like '%EZ,__%O'
order by nomem;



-- 28. Se desea hacer un regalo de un 1% del salario a los empleados en el d�a de su onom�stica. Hallar por orden alfab�tico los nombres y cuant�a de los regalos en euros para los que celebren su santo el d�a de San Honorio.

select nomem, salar*0.01 as Regalo
from temple
where nomem like '%,%Honori_%'
order by 1;

-- 29. Obtener por orden alfab�tico los nombres de los empleados que trabajan en el mismo departamento que Pilar G�lvez o Dorotea Flor.

select nomem, numde
from TEMPLE
where numde in (
        select numde
        from TEMPLE
        where nomem='Galvez,Pilar' or nomem='Flor,Dorotea'
        )
order by nomem;


select nomem, numde
from TEMPLE
where numde =(
        select numde
        from TEMPLE
        where nomem='Galvez,Pilar'
        )
    or
    numde =(
        select numde
        from TEMPLE
        where nomem='Flor,Dorotea'
        )
order by nomem;




select nomem, T.numde
from TEMPLE T, (select numde
                                from TEMPLE
                                where nomem='Galvez,Pilar' 
                                        or nomem='Flor,Dorotea'
) AUX  -- (NUMDE) 100,130
where T.numde = AUX.numde
order by nomem;









-- 30. Obtener una lista por orden alfab�tico de los empleados cuyo salario coincida con el de alguno de los empleados del departamento 100. Resolver de dos maneras diferentes.

select nomem, salar
from temple
where salar in (select salar from temple where numde=100)
order by 1;

select a1.nomem as nombre , a1.salar
from temple a1 , temple a2
where a1.salar = a2.salar and a2.numde=100
order by 1;


-- 31. Obtener los nombres de los centros de trabajo si hay alguno que est� en la calle Atocha.

select nomce
from tcentr
where exists 
( select nomce from tcentr where senas like '%atocha%' );

-- 32. Obtener por orden alfab�tico los nombres y salarios de los empleados del departamento 111 que tienen comisi�n si hay alguno de ellos cuya comisi�n supere al 15 % de su salario.

select nomem, salar
from temple
where numde=111 and (comis > 0 AND comis is not null)
and
exists (select comis from temple where
comis > salar*0.15 and numde=111 and 
(comis > 0 or comis is not null))
order by 1;


-- 33. Obtener por orden alfab�tico los nombres y comisiones de los empleados del departamento 110 si hay en �l alg�n empleado que tenga comisi�n.

select nomem, comis
from temple
where numde = 110 and exists 
(select comis from temple where (comis>0 AND comis
is not null) and numde=110);


-- 34. Obtener los nombres, salarios y fechas de ingreso de los empleados que, o bien ingresaron despu�s de 1.1.88, bien tienen un salario inferior a 2000 euros. Clasificarlos por fecha y nombre.

select nomem, salar, fecin
from temple
where fecin >'1988-01-01' or salar<2000
order by 3,1;


-- 35. Obtener por orden alfab�tico los nombres de los departamentos que no sean de Direcci�n ni de Sectores.

select nomde 
from tdepto
where nomde not like '%Direccion%' 
and nomde not like '%sector%'
order by nomde;


-- 36. Obtener por orden alfab�tico los nombres y salarios de los empleados que o bien no tienen hijos y ganan m�s de 2000 euros, o bien tienen hijos y ganan menos de 3000 euros.

select nomem, salar
from temple
where (numhi = 0 and salar > 2000)
or (numhi >0 and salar<3000)
order by 1;


-- 37. Hallar por orden alfab�tico los nombres y salarios de empleados de los departamentos 110 y 111 que o bien no tengan hijos o bien su salario por hijo supere a 1000 euros, si hay alguno sin comisi�n en los departamentos 111 � 112.

SELECT NOMEM, SALAR
FROM TEMPLE
WHERE (NUMDE=110 OR NUMDE=111) 
        AND (NUMHI=0 OR SALAR/NUMHI>1000)
    AND EXISTS (
                SELECT COMIS
               FROM TEMPLE
               WHERE NUMDE IN (111,112) AND COMIS=0)
ORDER BY NOMEM;


select nomem, salar
from temple
where exists (select numde from temple where
(numde =111 or numde=112) and 
(comis=0 or comis is null))
and (numde=110 or numde=111) 
and ( (numhi=0 or numhi is null)
or (numhi/salar)>1000)
order by 1;

select nomem, salar
from temple
where exists (select numde from temple where
numde in(111,112) and 
(comis=0 or comis is null))
and numde in(110,111) 
and ( (numhi=0 or numhi is null)
or (numhi/salar)>1000)
order by 1;


-- 38. Hallar por orden alfab�tico los nombres de departamentos que o bien tienen directores en funciones o bien en propiedad y su presupuesto anual excede a 50.000 euros o bien no dependen de ning�n otro.

select nomde
from tdepto
where (tidir like 'P' or tidir like 'F')
and (presu > 50000 or depde is null)
order by nomde;


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
------ Consultas varias tablas
--------------------------------------------------------------------------------

-- 39. Averiguar los nombres de los departamentos que tienen un presupuesto inferior a 100.000 euros, as� como el nombre del centro de trabajo donde se encuentran ubicados.

select d.nomde , c.nomce, d.presu
from tdepto d , tcentr c
where d.presu < 100000 and c.numce=d.numce;


-- 40. Hallar el salario m�ximo para el conjunto de empleados del departamento FINANZAS.

select max(e.salar)
from temple e, tdepto d
where d.nomde like '%Finanzas%' and e.numde=d.numde;


-- 41. Obtener por orden alfab�tico los salarios, n�mero de empleado y nombre de departamento de los empleados cuyo salario sea mayor que el 60% del salario m�ximo.

select e.salar , e.numem, d.nomde
from temple e, tdepto d
where e.salar > 0.6*( select max(salar) from temple)
and e.numde = d.numde
order by d.nomde;


-- 42. Hallar el n�mero de empleados y de extensiones telef�nicas del departamento PERSONAL.

select count(e.numem), count(distinct e.extel)
from temple e, tdepto d
where d.nomde like 'Personal' and e.numde=d.numde;


-- 43. Hallar el n�mero de empleados del departamento PERSONAL, as� como cu�ntas comisiones hay y la suma y media de sus comisiones.

select count(e.numem) , 
sum(e.comis) , count(e.comis) , avg(e.comis)
from temple e , tdepto d
where d.nomde like 'Personal' and e.numde=d.numde;


-- 44. Hallar la media del n�mero de hijos de los empleados del departamento PROCESO DE DATOS.

select avg(a1.numhi) , sum(a1.numhi) , count(a1.numhi)
from temple a1 , tdepto a2
where a1.numde=a2.numde and
a2.nomde like 'Proceso de datos';


-- 45. Hallar para cada departamento que depende del depto DIRECC. COMERCIAL su n�mero y su presupuesto, junto con la media del presupuesto de todos los departamentos.

select numde, presu, nomde,
(select avg(presu) from tdepto)
from tdepto
where  
depde in (select numde from tdepto 
where nomde ='Direccion comercial');

SELECT T1.NUMDE,T1.PRESU,
(SELECT AVG(PRESU) FROM TDEPTO)
FROM TDEPTO T1, TDEPTO T2
WHERE T2.NOMDE = 'DIRECCION COMERCIAL' 
AND T1.DEPDE = T2.NUMDE;


-- 46. Hallar por orden de n�mero de empleado el nombre del departamento, nombre del empleado y salario total (salario m�s comisi�n) de los empleados cuyo salario total supera al salario m�nimo en 1000 euros mensuales.


select a1.nomde, a2.nomem,
a2.salar+a2.comis as Salario_total
from tdepto a1, temple a2
where (a2.salar+a2.comis) > 
(1000+(select min(salar) from temple))
and a1.numde=a2.numde
order by a2.numem;


-- 47. Si el departamento 122 est� ubicado en la calle Alcal�, obtener por orden alfab�tico los nombres de aquellos empleados cuyo salario supere al salario medio de su departamento.





-- 48. Para cada departamento con presupuesto inferior a 60.000 euros, hallar el nombre del centro donde est� ubicado y el m�ximo salario de sus empleados, si �ste excede a 2000 euros. Clasificar alfab�ticamente por nombre de departamento.



-- 49. Hallar por orden alfab�tico los nombres de los departamentos que dependen de los que tienen un presupuesto inferior a 50.000 euros.

select nomde
from tdepto
where depde in 
(select numde from tdepto where presu<50000)
order by 1;

select a1.nomde
from tdepto a1 , tdepto a2
where a1.depde = a2.numde and a2.presu<50000 
order by a1.nomde;

-- 50. Para los departamentos cuyo presupuesto anual supera a 60.000 euros, hallar cu�ntos empleados hay en promedio por cada extensi�n telef�nica.


select count(distinct e.extel) / count(e.nomem) 
as 'Promedio extensiones' , d.nomde
from tdepto d, temple e
where d.presu>60000 and d.numde=e.numde
group by d.nomde;



-- 51. Obtener por orden alfab�tico los nombres de empleados cuyo apellido empieza por G y trabajan en un departamento ubicado en alg�n centro de trabajo de la calle Alcal�.


select e.nomem
from temple e, tdepto d, tcentr c
where e.nomem like 'G%' and c.senas like '%Alcala%'
and e.numde=d.numde and d.numce=c.numce
order by 1;



-- 52. Hallar por orden alfab�tico los distintos nombres de los empleados que son directores en funciones.


select e.nomem
from temple e , tdepto d
where e.numem=d.direc and d.tidir='F'
order by 1;

-- 53. Para todos los departamentos que no sean de direcci�n ni de sectores, hallar n�mero de departamento y sus extensiones telef�nicas, por orden creciente de departamento y, dentro de �ste, por n�mero de extensi�n creciente.

select distinct e.extel , d.numde
from temple e, tdepto d
where d.nomde not like '%direccion%' 
and d.nomde not like '%sector%'
and d.numde=e.numde
order by 2,1;

-- 54. A los distintos empleados que son directores en funciones se les asignar� una gratificaci�n del 5% de su salario. Hallar por orden alfab�tico los nombres de estos empleados y la gratificaci�n correspondiente a cada uno.


select distinct e.nomem , (e.salar)*0.05 as 'Gratificacion'
from temple e, tdepto d
where d.tidir like 'F' and e.numem=d.direc 
order by 1;


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
------ Consultas de agregaci�n y agrupamiento
--------------------------------------------------------------------------------


-- 55. Hallar por orden alfab�tico los nombres de los empleados cuyo director de departamento es Marcos P�rez, bien en propiedad o bien en funciones, indicando cu�l es el caso para cada uno de ellos.


select distinct e.nomem, d.tidir 
from temple e, tdepto d
where d.direc in (select numem from temple where nomem like
'%Perez,marcos%') and e.numde=d.numde 
AND (D.TIDIR LIKE 'P' OR D.TIDIR LIKE 'F')
order by e.nomem asc;


-- 56. Hallar por orden alfab�tico los nombres de los empleados que dirigen departamentos de los que dependen otros departamentos, indicando cu�ntos empleados hay en total en �stos.


select distinct e.nomem
from temple e , tdepto d
where e.numem=d.direc and d.numde in 
(select distinct depde from tdepto where depde is not null);


-- 57. Hallar el salario m�ximo para el conjunto de empleados del departamento 100.

select max(salar)
from temple
where numde=100;


-- 58. Obtener por orden alfab�tico los salarios y nombres de los empleados cuyo salario se diferencia con el m�ximo en menos de un 40% de �ste.


select nomem, salar
from temple
where salar > (select max(salar)*0.6 from temple)
order by 1;

-- 59. Hallar el n�mero de empleados de la empresa.


select count(*) from temple;

-- 60. Hallar el n�mero de empleados y de extensiones telef�nicas del departamento 112.


select count(numem) , count(distinct extel)
from temple
where numde=112;

-- 61. Hallar cu�ntos empleados hay cuya fecha de nacimiento sea anterior al a�o 1929.


select count(numem) from temple where fecna < '1929-01-01';



-- 62. Hallar el n�mero de empleados del departamento 112, as� como cu�ntas comisiones hay y la suma y media de sus comisiones.


select count(numem), count(comis), sum(comis), avg(comis)
from temple
where numde=112;

select ( select count(numem) from temple where numde=112), 
( select avg(comis) from temple where numde=112),
count(comis), sum(comis) 
from temple
where numde=112 and comis>0;


-- 63. Hallar cu�ntas comisiones diferentes hay y su valor medio.

use empresa;
select count(distinct comis), avg(distinct comis)
from temple
where comis>0 or comis is not null;


-- 64. Hallar la media del n�mero de hijos de los empleados del departamento 123.


select avg(numhi) from temple where numde=123;

-- 65. Hallar para cada departamento que depende del 100 su n�mero y su presupuesto, junto con la media del presupuesto de todos los departamentos.

select numde, presu, 
(select avg(presu) from tdepto) as 'media total'
from tdepto
where depde=100;


-- 66. Hallar cu�ntos departamentos hay y el presupuesto anual medio de ellos.


select count(numde), avg(presu) from tdepto;


-- 67. Como la pregunta anterior, pero para los departamentos que no tienen director en propiedad.

select count(numde), avg(presu) 
from tdepto
where tidir not like 'P';

-- 68. Hallar por orden de n�mero de empleado el nombre y salario total (salario m�s comisi�n) de los empleados cuyo salario total supera al salario m�nimo en 3000 euros mensuales.


select nomem, (salar+comis) as 'Salario total' 
from temple
where (salar+comis) > (select min(salar)+3000 from temple)
order by numem;


-- 69. Hallar la masa salarial anual (salario m�s comisi�n) de la empresa (se suponen 14 pagas anuales).


select sum(salar+comis)*14 as 'Masa salarial' from temple;

-- 70. Hallar el salario medio de los empleados cuyo salario no supera en m�s de 20 % al salario m�nimo de los empleados que tienen alg�n hijo y su salario medio por hijo es mayor que 1000 euros.

select avg(salar)
from temple
where salar < (select min(salar)*1.2 from temple 
where numhi> 0 or numhi is not null and (salar/numhi)>1000);


-- 71. Hallar la diferencia entre el salario m�s alto y el m�s bajo.


select max(salar)- min(salar) as Diferencia from temple;


-- 72. Hallar el presupuesto medio de los departamentos cuyo presupuesto supera al presupuesto medio de los departamentos.

select avg(presu)
from tdepto
where presu> (select avg(presu) from tdepto);


-- 73. Hallar el n�mero medio de hijos por empleado para todos los empleados que no tienen m�s de dos hijos.
select sum(numhi)/count(numem)
from temple
where numhi <=2;


-- 74. Hallar el n�mero de empleados de los departamentos 100 y 110.

select count(numem) from temple
where numde=100 or numde=110
group by numde;

select count(numem) from temple
where numde in (100,110)
group by numde;


-- 75. Agrupando por departamento y n�mero de hijos, hallar cu�ntos empleados hay en cada grupo para los departamentos 100 y 110.


select numde, numhi, count(numem)
from temple
where numde in (100,110)
group by numde, numhi
order by numde,numhi;


-- 76. Para los departamentos en los que hay alg�n empleado cuyo salario sea mayor que 4000 euros al mes hallar el n�mero de empleados y la suma de sus salarios, comisiones y n�mero de hijos.

select count(numem), sum(salar) , sum(comis), sum(numhi) , numde
from temple
group by numde
having numde in (select numde from temple where salar>4000);

-- 77. Agrupando por n�mero de hijos, hallar la media por hijo del salario total (salario y comisi�n).

select avg((salar+comis)/numhi) , numhi from temple
where numhi >0
group by numhi
order by numhi;


-- 78. Para cada departamento, hallar la media de la comisi�n con respecto a los empleados que la reciben y con respecto al total de empleados.


select numde, avg(comis), (select avg(comis) from temple)
from temple
where comis>0
group by numde;


-- 79. Para cada extensi�n telef�nica hallar cu�ntos empleados la usan y el salario medio de �stos.

select extel, count(numem) , avg(salar)
from temple
group by extel;


-- 80. Para cada extensi�n telef�nica y cada departamento hallar cu�ntos empleados la usan y el salario medio de �stos.


select extel, numde, count(numem) , avg(salar)
from temple
group by extel, numde
order by 2 ,1;



-- 81. Hallar los n�meros de extensi�n telef�nica mayores de los diversos departamentos, sin incluir los n�meros de �stos.


select max(extel)
from temple
group by numde 
order by 1;


-- 82. Para cada extensi�n telef�nica hallar el n�mero de departamentos a los que sirve.


select extel, count(distinct numde)
from temple
group by extel
order by 1;


-- 83. Para los departamentos en los que alg�n empleado tiene comisi�n, hallar cu�ntos empleados hay en promedio por cada extensi�n telef�nica.

select count(nomem)/count(distinct extel), numde
from temple
group by numde
HAVING NUMDE IN 
(SELECT DISTINCT NUMDE FROM TEMPLE WHERE COMIS > 0);


-- 84. Para los empleados que tienen comisi�n, hallar para los departamentos cu�ntos empleados hay en promedio por cada extensi�n telef�nica.

select count(nomem)/count(distinct extel), numde
from temple
where comis >0
group by numde;


-- 85. Obtener por orden creciente los n�meros de extensiones telef�nicas de los departamentos que tienen m�s de dos y que son compartidas por menos de 4 empleados, excluyendo las que no son compartidas.


select distinct extel, numde
from temple
where numde in 
(select numde from temple 
group by numde having count(distinct extel)>2) 
and extel in 
(select extel from temple 
group by extel having count(numem)<4 and count(numem)>1) 
order by 1;


-- 86. Para los departamentos cuyo salario medio supera al de la empresa, hallar cu�ntas extensiones telef�nicas tienen.

select count(distinct extel), numde
from temple
group by numde
having avg(salar) > (select avg(salar) from temple);


-- 87. Para cada centro hallar los presupuestos medios de los departamentos dirigidos en propiedad y en funciones, excluyendo del resultado el n�mero del centro.

select avg(presu), tidir
from tdepto
group by numce, tidir;

-- 88. Hallar el m�ximo valor de la suma de los salarios de los departamentos.        

select sum(salar), numde
from temple
group by NUMDE
order by 1 desc
limit 1;

SELECT SUM(SALAR) AS 'MAXIMO VALOR SUMA SALARIOS' ,NUMDE
FROM TEMPLE
GROUP BY NUMDE
HAVING SUM(SALAR) >= ALL 
(SELECT SUM(SALAR) FROM TEMPLE GROUP BY NUMDE);


-- 89. Para los departamentos cuyos todos sus empleados tengan hijos, calcular su salario medio, salario m�ximo y salario m�nimo.


SELECT NUMDE,AVG(SALAR),MAX(SALAR),MIN(SALAR)
        FROM TEMPLE
   GROUP BY NUMDE
   HAVING NUMDE not IN 
   (SELECT NUMDE FROM TEMPLE WHERE NUMHI = 0);
   
SELECT NUMDE,AVG(SALAR),MAX(SALAR),MIN(SALAR)
        FROM TEMPLE
   GROUP BY NUMDE    
   having min(numhi) >0;



-- 90. Para los departamentos que tengan menos de 5 empleados, calcular el gasto en salarios anuales (salar + comis) *14


select numde, sum(salar+comis)*14
from temple
group by numde
having count(numem)<5;

-- 91. Calcular el desfase de salarios entre el m�ximo y el m�nimo para cada departamento de los empleados que tienen hijos.


select numde, max(salar)-min(salar) as "Desfase salarial"
from temple
where numhi>0
group by numde;


-- 92. Para los departamentos que tienen un presupuesto menor de 50000 euros hallar el n�mero de empleados que lo forman.

select numde, count(numem)
from temple
group by numde
having numde in (select numde from tdepto where presu<50000);

select numde, count(numem)
from temple
where numde in (select numde from tdepto where presu<50000)
group by numde;



-- 93. Hallar la suma de los presupuestos, el presupuesto m�ximo, el m�nimo de cada tipo de departamento.

select tidir, max(presu), min(presu), sum(presu)
from tdepto
group by tidir;

-- 94. Hallar la suma de los presupuestos de cada centro, indicando el nombre de cada uno.

select sum(d.presu), c.nomce
from tdepto d, tcentr c
where d.numce=c.numce
group by c.nomce; 


-- 95. Hallar los nombres de los empleados y nombre de centro al que pertenece, ordenando por n�mero de este.

select e.nomem, c.nomce
from temple e, tdepto d, tcentr c
where e.numde=d.numde and d.numce=c.numce
order by c.numce;




-- 96. Hallar el n�mero del departamento que tiene m�s hijos.

select numde, sum(numhi)
from temple
group by numde
having sum(numhi) >= 
all (select sum(numhi) from temple group by numde);

select numde, sum(numhi)
from temple
group by numde
order by 2 desc
limit 1;



-- 97. Hallar el n�mero del departamento que tiene un gasto en salarios mayor.


SELECT NUMDE, SUM(SALAR+COMIS) AS SALARIO_DEP
        FROM TEMPLE
    GROUP BY NUMDE
    HAVING SUM(SALAR+COMIS)>= ALL (SELECT SUM(SALAR+COMIS)FROM TEMPLE GROUP BY
NUMDE);








SELECT NUMDE, SUM(SALAR+COMIS) AS SALARs
FROM TEMPLE
GROUP BY NUMDE
having SALARS = (SELECT MAX(SALAR) FROM   
                                (
                                SELECT SUM(SALAR+COMIS) AS SALAR
                                FROM TEMPLE
                                GROUP BY NUMDE
                                ) AUX);


-- 98. Averiguar si hay alg�n departamento que tenga un presupuesto menor que la suma de salarios que tiene que pagar (salarios y comisiones) anualmente.


select a1.numde, a2.presu, sum(a1.salar+a1.comis)*14
from temple a1 , tdepto a2
where a1.numde = a2.numde 
group by a1.numde, a2.presu
having a2.presu < sum(a1.salar+a1.comis)*14 ;

SELECT D.NOMDE,D.PRESU
FROM TDEPTO D
WHERE D.PRESU < 
(SELECT SUM(E.SALAR+E.COMIS)*14 FROM TEMPLE E 
WHERE D.NUMDE = E.NUMDE)
GROUP BY d.NUMDE;



-- 99. Actualizar los datos del empleado 110, poniendo su fecha de nacimiento a 1974-05-08


-- 100. Quitar las comisiones de los empleados del departamento 100.


-- 101. Actualizar los salarios de los empleados siguiendo la siguiente tabla:

-- 101a. Salario menor o igual a 1000 euros > 1000 �


-- 101b. Salario mayor a 1000 y menor o igual a 1500 > 1500 �


-- 101c. Salario mayor a 1500 y menor o igual a 2300 > 2300 �


-- 101d. Salario mayor a 2300 y menor o igual a 3000 > 3000 �


-- 102e. Salarios mayores a 3000 euros > 3300 �


-- 102. Crear una tabla auxiliar llamada empleados que contenga todos los datos de los empleados.


-- 103. Borrar de la tabla empleados los empleados que no tengan hijos.







-- 104. Empleados que trabajan en un departamento dependiente del departamento 100


SELECT NOMEM, TEMPLE.NUMDE
FROM TEMPLE, (SELECT NUMDE
                        FROM TDEPTO
                        WHERE DEPDE =100) AUX
WHERE TEMPLE.NUMDE = AUX.NUMDE
/*Consultas sobre la BBDD "Empresa"*/
                          
/*1. Nombre de los empleados que trabajan en el departamento 121*/
/*2. Extraer todos los datos del departamento 121
3. Obtener         los nombres y sueldos de los empleados con m�s de 3 hijos por orden alfab�tico
4. Obtener         la comisi�n, departamentos y nombre de los empleados cuyo salario es inferior a 1900 euros, clasific�ndolos por departamento en orden creciente y por comisi�n en orden decreciente dentro de cada departamento.
5. Igual que la anterior, pero las columnas resultantes han de llamarse comisi�n, departamento y empleado.
6. N�meros de los departamentos donde trabajan empleados con salario inferior a 2500.
7. Obtener        los valores diferentes de comisiones que hay en el departamento 110.
8. Hallar las combinaciones diferentes de valores de salario y comisi�n en el departamento 111, por orden de salario y comisi�n crecientes.
9. Obtener        los nombres de los empleados cuya comisi�n es superior o igual al 50% de su salario, por orden alfab�tico.
10. Obtener por orden alfab�tico los nombres de los empleados cuyo salario supera al m�ximo salario de los empleados del departamento 122.
11. Obtener         por orden alfab�tico los nombres de los empleados cuyo sueldo supera en tres veces y media o m�s al m�nimo salario de los empleados del departamento 122.


PREDICADOS


12. Para todos los empleados que tienen comisi�n, hallar sus salarios mensuales totales incluyendo �sta. Ordenarlos por orden alfab�tico. Hallar tambi�n el porcentaje de su salario total que supone la comisi�n.
13. Mostrar nombres y presupuestos de los departamentos 111 y 112, de tal manera que aparezcan en la misma fila.
14. Obtener         los nombres de los departamentos que no dependen funcionalmente de otros.
15. Para los empleados que no tienen comisi�n obtener por orden alfab�tico el nombre y el cociente entre su salario y el n�mero de hijos.
16. Obtener        los nombres y salarios de los empleados cuyo salario coincide con la comisi�n de alg�n otro o la suya propia. Ordenarlos alfab�ticamente.
17. Obtener por orden alfab�tico los nombres y salarios de los empleados cuyo salario es inferior a la comisi�n m�s alta existente.
18. Obtener por orden alfab�tico los nombres y salarios de los empleados cuyo salario es inferior al cu�druplo de la comisi�n m�s baja existente.
19. Obtener         por orden alfab�tico los nombres de los empleados cuyo salario est� entre 2500 y 3000 euros.

20. Obtener por orden alfab�tico los nombres y los salarios de los empleados cuyo salario dividido por su n�mero de hijos cumpla una, o ambas, de las dos condiciones siguientes:
   1. Que sea inferior a 1200 euros
   2. Que sea superior al doble de su comisi�n
   21. En la fiesta de Reyes se desea organizar un espect�culo para los hijos         de los empleados, que se representar� en dos d�as diferentes. El primer d�a asistir�n los empleados cuyo apellido empiece por las letras desde A hasta L, ambas inclusive. El segundo d�a se cursar�n invitaciones para el resto. A cada empleado se le asignar�n tantas invitaciones gratuitas como hijos tenga y dos m�s. Adem�s, en la fiesta se entregar� a cada empleado un obsequio por hijo. Obtener una lista por orden alfab�tico de los nombres a quienes hay que invitar el primer d�a de la representaci�n, incluyendo tambi�n cu�ntas invitaciones corresponden a cada nombre y cu�ntos regalos hay que preparar para �l.
   22. Obtener por orden alfab�tico los nombres de los empleados cuyo primer apellido es Mora o empieza por Mora
   23. Obtener por orden alfab�tico los nombres de los empleados cuyo nombre de pila empieza por Valeriana.
   24. Obtener por orden alfab�tico los nombres de los empleados cuyo apellido tenga siete letras.
   25. Obtener por orden alfab�tico los nombres de los empleados cuyo apellido tenga seis o m�s letras.
   26. Obtener los nombres de los empleados cuyo apellido tenga tres letras o menos.
   27. Obtener por orden alfab�tico los nombres de los empleados cuyo apellido termina en EZ y su nombre de pila termina en O y tiene al menos tres letras.
   28. Se desea hacer un regalo de un 1 % del salario a los empleados en el d�a de su onom�stica. Hallar por orden alfab�tico los nombres y cuant�a de los regalos en euros para los que celebren su santo el d�a de San Honorio.
   29. Obtener por orden alfab�tico los nombres de los empleados que trabajan en el mismo departamento que Pilar G�lvez o Dorotea Flor.
   30. Obtener una lista por orden alfab�tico de los empleados cuyo salario coincida con el de alguno de los empleados del departamento 100. Resolver de dos maneras diferentes.
   31. Obtener los nombres de los centros de trabajo si hay alguno que est� en la calle Atocha.
   32. Obtener por orden alfab�tico los nombres y salarios de los empleados del departamento 111 que tienen comisi�n si hay alguno de ellos cuya comisi�n supere al 15 % de su salario.
   33. Obtener        por orden alfab�tico los nombres y comisiones de los empleados del departamento 110 si hay en �l alg�n empleado que tenga comisi�n.
   34. Obtener los nombres, salarios y fechas de ingreso de los empleados que, o bien ingresaron despu�s de 1.1.88, bien tienen un salario inferior a 2000 euros. Clasificarlos por fecha y nombre.
   35. Obtener por orden alfab�tico los nombres de los departamentos que no sean de Direcci�n ni de Sectores.
   36. Obtener por orden alfab�tico los nombres y salarios de los empleados que o bien no tienen hijos y ganan m�s de 2000 euros, o bien tienen hijos y ganan menos de 3000 euros.
   37. Hallar por orden alfab�tico los nombres y salarios de empleados de los departamentos 110 y 111 que o bien no tengan hijos o bien su salario por hijo supere a 1000 euros, si hay alguno sin comisi�n en los departamentos 111 � 112.
   38. Hallar por orden alfab�tico los nombres de departamentos que o bien tienen directores en funciones o bien en propiedad y su presupuesto anual excede a 50.000 euros o bien no dependen de ning�n otro.


CONSULTAS DE VARIAS TABLAS


   39. Averiguar los nombres de los departamentos que tienen un presupuesto inferior a 100.000 euros, as� como el nombre del centro de trabajo donde se encuentran ubicados.
   40. Hallar el salario m�ximo para el conjunto de empleados del departamento FINANZAS.
   41. Obtener por orden alfab�tico los salarios, n�mero de empleado y nombre de departamento de los empleados cuyo salario sea mayor que el 60% del salario m�ximo.
   42. Hallar el n�mero de empleados y de extensiones telef�nicas del departamento PERSONAL.
   43. Hallar el n�mero de empleados del departamento PERSONAL, as� como cu�ntas comisiones hay y la suma y media de sus comisiones.
   44. Hallar la media del n�mero de hijos de los empleados del departamento PROCESO DE DATOS.
   45. Hallar para cada departamento que depende del depto DIRECC. COMERCIAL su n�mero y su presupuesto, junto con la media del presupuesto de todos los departamentos.
   46. Hallar por orden de n�mero de empleado el nombre del departamento, nombre del empleado y salario total (salario m�s comisi�n) de los empleados cuyo salario total supera al salario m�nimo en 1000 euros mensuales.
   47. Si el departamento 122 est� ubicado en la calle Alcal�, obtener por orden alfab�tico los nombres de aquellos empleados cuyo salario supere al salario medio de su departamento.
   48. Para cada departamento con presupuesto inferior a 60.000 euros, hallar el nombre del centro donde est� ubicado y el m�ximo salario de sus empleados, si �ste excede a 2000 euros. Clasificar alfab�ticamente por nombre de departamento.
   49. Hallar por orden alfab�tico los nombres de los departamentos que dependen de los que tienen un presupuesto inferior a 50.000 euros.
   50. Para los departamentos cuyo presupuesto anual supera a 60.000 euros, hallar cu�ntos empleados hay en promedio por cada extensi�n telef�nica.
   51. Obtener por orden alfab�tico los nombres de empleados cuyo apellido empieza por G y trabajan en un departamento ubicado en alg�n centro de trabajo de la calle Alcal�.
   52. Hallar por orden alfab�tico los distintos nombres de los empleados que son directores en funciones.
   53. Para todos los departamentos que no sean de direcci�n ni de sectores, hallar n�mero de departamento y sus extensiones telef�nicas, por orden creciente de departamento y, dentro de �ste, por n�mero de extensi�n creciente.
   54. A los distintos empleados que son directores en funciones se les asignar� una gratificaci�n del 5 % de su salario. Hallar por orden alfab�tico los nombres de estos empleados y la gratificaci�n correspondiente a cada uno.


CONSULTAS DE AGREGACI�N Y AGRUPAMIENTO


   55. Hallar por orden alfab�tico los nombres de los empleados cuyo director de departamento es Marcos P�rez, bien en propiedad o bien en funciones, indicando cu�l es el caso para cada uno de ellos.
   56. Hallar por orden alfab�tico los nombres de los empleados que dirigen departamentos de los que dependen otros departamentos, indicando cu�ntos empleados hay en total en �stos.
   57. Hallar el salario m�ximo para el conjunto de empleados del departamento 100.
   58. Obtener por orden alfab�tico los salarios y nombres de los empleados cuyo salario se diferencia con el m�ximo en menos de un 40% de �ste.
   59. Hallar el n�mero de empleados de la empresa.
   60. Hallar el n�mero de empleados y de extensiones telef�nicas del departamento 112.
   61. Hallar cu�ntos empleados hay cuya fecha de nacimiento sea anterior al a�o 1929.
   62. Hallar el n�mero de empleados del departamento 112, as� como cu�ntas comisiones hay y la suma y media de sus comisiones.
   63. Hallar cu�ntas comisiones diferentes hay y su valor medio.
   64. Hallar la media del n�mero de hijos de los empleados del departamento 123.
   65. Hallar para cada departamento que depende del 100 su n�mero y su presupuesto, junto con la media del presupuesto de todos los departamentos.
   66. Hallar cu�ntos departamentos hay y el presupuesto anual medio de ellos.
   67. Como la pregunta anterior, pero para los departamentos que no tienen director en propiedad.
   68. Hallar por orden de n�mero de empleado el nombre y salario total (salario m�s comisi�n) de los empleados cuyo salario total supera al salario m�nimo en 3000 euros mensuales.
   69. Hallar la masa salarial anual (salario m�s comisi�n) de la empresa (se suponen 14 pagas anuales).
   70. Hallar el salario medio de los empleados cuyo salario no supera en m�s de 20 % al salario m�nimo de los empleados que tienen alg�n hijo y su salario medio por hijo es mayor que 1000 euros.
   71. Hallar la diferencia entre el salario m�s alto y el m�s bajo.
   72. Hallar el presupuesto medio de los departamentos cuyo presupuesto supera al presupuesto medio de los departamentos.
   73. Hallar el n�mero medio de hijos por empleado para todos los empleados que no tienen m�s de dos hijos.
   74. Hallar el n�mero de empleados de los departamentos 100 y 110.
   75. Agrupando por departamento y n�mero de hijos, hallar cu�ntos empleados hay en cada grupo para los departamentos 100 y 110.
   76. Para los departamentos en los que hay alg�n empleado cuyo salario sea mayor que 4000 euros al mes hallar el n�mero de empleados y la suma de sus salarios, comisiones y n�mero de hijos.
   77. Agrupando por n�mero de hijos, hallar la media por hijo del salario total (salario y comisi�n).
   78. Para cada departamento, hallar la media de la comisi�n con respecto a los empleados que la reciben y con respecto al total de empleados.
   79. Para cada extensi�n telef�nica hallar cu�ntos empleados la usan y el salario medio de �stos.
   80. Para cada extensi�n telef�nica y cada departamento hallar cu�ntos empleados la usan y el salario medio de �stos.
   81. Hallar los n�meros de extensi�n telef�nica mayores de los diversos departamentos, sin incluir los n�meros de �stos.
   82. Para cada extensi�n telef�nica hallar el n�mero de departamentos a los que sirve.
   83. Para los departamentos en los que alg�n empleado tiene comisi�n, hallar cu�ntos empleados hay en promedio por cada extensi�n telef�nica.
   84. Para los empleados que tienen comisi�n, hallar para los departamentos cu�ntos empleados hay en promedio por cada extensi�n telef�nica.
   85. Obtener por orden creciente los n�meros de extensiones telef�nicas de los departamentos que tienen m�s de dos y que son compartidas por menos de 4 empleados, excluyendo las que no son compartidas.
   86. Para los departamentos cuyo salario medio supera al de la empresa, hallar cu�ntas extensiones telef�nicas tienen.
   87. Para cada centro hallar los presupuestos medios de los departamentos dirigidos en propiedad y en funciones, excluyendo del resultado el n�mero del centro.
   88. Hallar el m�ximo valor de la suma de los salarios de los departamentos.        
   89. Para los departamentos cuyos todos sus empleados tengan hijos, calcular su salario medio, salario m�ximo y salario m�nimo.
   90. Para los departamentos que tengan menos de 5 empleados, calcular el gasto en salarios anuales (salar + comis) *14
   91. Calcular el desfase de salarios entre el m�ximo y el m�nimo para cada departamento de los empleados que tienen hijos.
   92. Para los departamentos que tienen un presupuesto menor de 50000 euros hallar el n�mero de empleados que lo forman.
   93. Hallar la suma de los presupuestos, el presupuesto m�ximo, el m�nimo de cada tipo de departamento.
   94. Hallar la suma de los presupuestos de cada centro, indicando el nombre de cada uno.
   95. Hallar los nombres de los empleados y nombre de centro al que pertenece, ordenando por n�mero de este.
   96. Hallar el n�mero del departamento que tiene m�s hijos.
   97. Hallar el n�mero del departamento que tiene un gasto en salarios mayor.
   98. Averiguar si hay alg�n departamento que tenga un presupuesto menor que la suma de salarios que tiene que pagar (salarios y comisiones) anualmente.
   99. Actualizar los datos del empleado 110, poniendo su fecha de nacimiento a 1974-05-08
   100. Quitar las comisiones de los empleados del departamento 100.
   101. Actualizar los salarios de los empleados siguiendo la siguiente tabla:
   1. Salario menor o igual a 1000 euros > 1000 �
   2. Salario mayor a 1000 y menor o igual a 1500 > 1500 �
   3. Salario mayor a 1500 y menor o igual a 2300 > 2300 �
   4. Salario mayor a 2300 y menor o igual a 3000 > 3000 �
   5. Salarios mayores a 3000 euros > 3300 �
   102. Crear una tabla auxiliar llamada empleados que contenga todos los datos de los empleados.
   103. Borrar de la tabla empleados los empleados que no tengan hijos.*/
/*Consultas sobre la BBDD "Empresa"*/
                          
/*1. Nombre de los empleados que trabajan en el departamento 121*/
/*2. Extraer todos los datos del departamento 121
3. Obtener         los nombres y sueldos de los empleados con más de 3 hijos por orden alfabético
4. Obtener         la comisión, departamentos y nombre de los empleados cuyo salario es inferior a 1900 euros, clasificándolos por departamento en orden creciente y por comisión en orden decreciente dentro de cada departamento.
5. Igual que la anterior, pero las columnas resultantes han de llamarse comisión, departamento y empleado.
6. Números de los departamentos donde trabajan empleados con salario inferior a 2500.
7. Obtener        los valores diferentes de comisiones que hay en el departamento 110.
8. Hallar las combinaciones diferentes de valores de salario y comisión en el departamento 111, por orden de salario y comisión crecientes.
9. Obtener        los nombres de los empleados cuya comisión es superior o igual al 50% de su salario, por orden alfabético.
10. Obtener por orden alfabético los nombres de los empleados cuyo salario supera al máximo salario de los empleados del departamento 122.
11. Obtener         por orden alfabético los nombres de los empleados cuyo sueldo supera en tres veces y media o más al mínimo salario de los empleados del departamento 122.


PREDICADOS


12. Para todos los empleados que tienen comisión, hallar sus salarios mensuales totales incluyendo ésta. Ordenarlos por orden alfabético. Hallar también el porcentaje de su salario total que supone la comisión.
13. Mostrar nombres y presupuestos de los departamentos 111 y 112, de tal manera que aparezcan en la misma fila.
14. Obtener         los nombres de los departamentos que no dependen funcionalmente de otros.
15. Para los empleados que no tienen comisión obtener por orden alfabético el nombre y el cociente entre su salario y el número de hijos.
16. Obtener        los nombres y salarios de los empleados cuyo salario coincide con la comisión de algún otro o la suya propia. Ordenarlos alfabéticamente.
17. Obtener por orden alfabético los nombres y salarios de los empleados cuyo salario es inferior a la comisión más alta existente.
18. Obtener por orden alfabético los nombres y salarios de los empleados cuyo salario es inferior al cuádruplo de la comisión más baja existente.
19. Obtener         por orden alfabético los nombres de los empleados cuyo salario está entre 2500 y 3000 euros.

20. Obtener por orden alfabético los nombres y los salarios de los empleados cuyo salario dividido por su número de hijos cumpla una, o ambas, de las dos condiciones siguientes:
   1. Que sea inferior a 1200 euros
   2. Que sea superior al doble de su comisión
   21. En la fiesta de Reyes se desea organizar un espectáculo para los hijos         de los empleados, que se representará en dos días diferentes. El primer día asistirán los empleados cuyo apellido empiece por las letras desde A hasta L, ambas inclusive. El segundo día se cursarán invitaciones para el resto. A cada empleado se le asignarán tantas invitaciones gratuitas como hijos tenga y dos más. Además, en la fiesta se entregará a cada empleado un obsequio por hijo. Obtener una lista por orden alfabético de los nombres a quienes hay que invitar el primer día de la representación, incluyendo también cuántas invitaciones corresponden a cada nombre y cuántos regalos hay que preparar para él.
   22. Obtener por orden alfabético los nombres de los empleados cuyo primer apellido es Mora o empieza por Mora
   23. Obtener por orden alfabético los nombres de los empleados cuyo nombre de pila empieza por Valeriana.
   24. Obtener por orden alfabético los nombres de los empleados cuyo apellido tenga siete letras.
   25. Obtener por orden alfabético los nombres de los empleados cuyo apellido tenga seis o más letras.
   26. Obtener los nombres de los empleados cuyo apellido tenga tres letras o menos.
   27. Obtener por orden alfabético los nombres de los empleados cuyo apellido termina en EZ y su nombre de pila termina en O y tiene al menos tres letras.
   28. Se desea hacer un regalo de un 1 % del salario a los empleados en el día de su onomástica. Hallar por orden alfabético los nombres y cuantía de los regalos en euros para los que celebren su santo el día de San Honorio.
   29. Obtener por orden alfabético los nombres de los empleados que trabajan en el mismo departamento que Pilar Gálvez o Dorotea Flor.
   30. Obtener una lista por orden alfabético de los empleados cuyo salario coincida con el de alguno de los empleados del departamento 100. Resolver de dos maneras diferentes.
   31. Obtener los nombres de los centros de trabajo si hay alguno que esté en la calle Atocha.
   32. Obtener por orden alfabético los nombres y salarios de los empleados del departamento 111 que tienen comisión si hay alguno de ellos cuya comisión supere al 15 % de su salario.
   33. Obtener        por orden alfabético los nombres y comisiones de los empleados del departamento 110 si hay en él algún empleado que tenga comisión.
   34. Obtener los nombres, salarios y fechas de ingreso de los empleados que, o bien ingresaron después de 1.1.88, bien tienen un salario inferior a 2000 euros. Clasificarlos por fecha y nombre.
   35. Obtener por orden alfabético los nombres de los departamentos que no sean de Dirección ni de Sectores.
   36. Obtener por orden alfabético los nombres y salarios de los empleados que o bien no tienen hijos y ganan más de 2000 euros, o bien tienen hijos y ganan menos de 3000 euros.
   37. Hallar por orden alfabético los nombres y salarios de empleados de los departamentos 110 y 111 que o bien no tengan hijos o bien su salario por hijo supere a 1000 euros, si hay alguno sin comisión en los departamentos 111 ó 112.
   38. Hallar por orden alfabético los nombres de departamentos que o bien tienen directores en funciones o bien en propiedad y su presupuesto anual excede a 50.000 euros o bien no dependen de ningún otro.


CONSULTAS DE VARIAS TABLAS


   39. Averiguar los nombres de los departamentos que tienen un presupuesto inferior a 100.000 euros, así como el nombre del centro de trabajo donde se encuentran ubicados.
   40. Hallar el salario máximo para el conjunto de empleados del departamento FINANZAS.
   41. Obtener por orden alfabético los salarios, número de empleado y nombre de departamento de los empleados cuyo salario sea mayor que el 60% del salario máximo.
   42. Hallar el número de empleados y de extensiones telefónicas del departamento PERSONAL.
   43. Hallar el número de empleados del departamento PERSONAL, así como cuántas comisiones hay y la suma y media de sus comisiones.
   44. Hallar la media del número de hijos de los empleados del departamento PROCESO DE DATOS.
   45. Hallar para cada departamento que depende del depto DIRECC. COMERCIAL su número y su presupuesto, junto con la media del presupuesto de todos los departamentos.
   46. Hallar por orden de número de empleado el nombre del departamento, nombre del empleado y salario total (salario más comisión) de los empleados cuyo salario total supera al salario mínimo en 1000 euros mensuales.
   47. Si el departamento 122 está ubicado en la calle Alcalá, obtener por orden alfabético los nombres de aquellos empleados cuyo salario supere al salario medio de su departamento.
   48. Para cada departamento con presupuesto inferior a 60.000 euros, hallar el nombre del centro donde está ubicado y el máximo salario de sus empleados, si éste excede a 2000 euros. Clasificar alfabéticamente por nombre de departamento.
   49. Hallar por orden alfabético los nombres de los departamentos que dependen de los que tienen un presupuesto inferior a 50.000 euros.
   50. Para los departamentos cuyo presupuesto anual supera a 60.000 euros, hallar cuántos empleados hay en promedio por cada extensión telefónica.
   51. Obtener por orden alfabético los nombres de empleados cuyo apellido empieza por G y trabajan en un departamento ubicado en algún centro de trabajo de la calle Alcalá.
   52. Hallar por orden alfabético los distintos nombres de los empleados que son directores en funciones.
   53. Para todos los departamentos que no sean de dirección ni de sectores, hallar número de departamento y sus extensiones telefónicas, por orden creciente de departamento y, dentro de éste, por número de extensión creciente.
   54. A los distintos empleados que son directores en funciones se les asignará una gratificación del 5 % de su salario. Hallar por orden alfabético los nombres de estos empleados y la gratificación correspondiente a cada uno.


CONSULTAS DE AGREGACIÓN Y AGRUPAMIENTO


   55. Hallar por orden alfabético los nombres de los empleados cuyo director de departamento es Marcos Pérez, bien en propiedad o bien en funciones, indicando cuál es el caso para cada uno de ellos.
   56. Hallar por orden alfabético los nombres de los empleados que dirigen departamentos de los que dependen otros departamentos, indicando cuántos empleados hay en total en éstos.
   57. Hallar el salario máximo para el conjunto de empleados del departamento 100.
   58. Obtener por orden alfabético los salarios y nombres de los empleados cuyo salario se diferencia con el máximo en menos de un 40% de éste.
   59. Hallar el número de empleados de la empresa.
   60. Hallar el número de empleados y de extensiones telefónicas del departamento 112.
   61. Hallar cuántos empleados hay cuya fecha de nacimiento sea anterior al año 1929.
   62. Hallar el número de empleados del departamento 112, así como cuántas comisiones hay y la suma y media de sus comisiones.
   63. Hallar cuántas comisiones diferentes hay y su valor medio.
   64. Hallar la media del número de hijos de los empleados del departamento 123.
   65. Hallar para cada departamento que depende del 100 su número y su presupuesto, junto con la media del presupuesto de todos los departamentos.
   66. Hallar cuántos departamentos hay y el presupuesto anual medio de ellos.
   67. Como la pregunta anterior, pero para los departamentos que no tienen director en propiedad.
   68. Hallar por orden de número de empleado el nombre y salario total (salario más comisión) de los empleados cuyo salario total supera al salario mínimo en 3000 euros mensuales.
   69. Hallar la masa salarial anual (salario más comisión) de la empresa (se suponen 14 pagas anuales).
   70. Hallar el salario medio de los empleados cuyo salario no supera en más de 20 % al salario mínimo de los empleados que tienen algún hijo y su salario medio por hijo es mayor que 1000 euros.
   71. Hallar la diferencia entre el salario más alto y el más bajo.
   72. Hallar el presupuesto medio de los departamentos cuyo presupuesto supera al presupuesto medio de los departamentos.
   73. Hallar el número medio de hijos por empleado para todos los empleados que no tienen más de dos hijos.
   74. Hallar el número de empleados de los departamentos 100 y 110.
   75. Agrupando por departamento y número de hijos, hallar cuántos empleados hay en cada grupo para los departamentos 100 y 110.
   76. Para los departamentos en los que hay algún empleado cuyo salario sea mayor que 4000 euros al mes hallar el número de empleados y la suma de sus salarios, comisiones y número de hijos.
   77. Agrupando por número de hijos, hallar la media por hijo del salario total (salario y comisión).
   78. Para cada departamento, hallar la media de la comisión con respecto a los empleados que la reciben y con respecto al total de empleados.
   79. Para cada extensión telefónica hallar cuántos empleados la usan y el salario medio de éstos.
   80. Para cada extensión telefónica y cada departamento hallar cuántos empleados la usan y el salario medio de éstos.
   81. Hallar los números de extensión telefónica mayores de los diversos departamentos, sin incluir los números de éstos.
   82. Para cada extensión telefónica hallar el número de departamentos a los que sirve.
   83. Para los departamentos en los que algún empleado tiene comisión, hallar cuántos empleados hay en promedio por cada extensión telefónica.
   84. Para los empleados que tienen comisión, hallar para los departamentos cuántos empleados hay en promedio por cada extensión telefónica.
   85. Obtener por orden creciente los números de extensiones telefónicas de los departamentos que tienen más de dos y que son compartidas por menos de 4 empleados, excluyendo las que no son compartidas.
   86. Para los departamentos cuyo salario medio supera al de la empresa, hallar cuántas extensiones telefónicas tienen.
   87. Para cada centro hallar los presupuestos medios de los departamentos dirigidos en propiedad y en funciones, excluyendo del resultado el número del centro.
   88. Hallar el máximo valor de la suma de los salarios de los departamentos.        
   89. Para los departamentos cuyos todos sus empleados tengan hijos, calcular su salario medio, salario máximo y salario mínimo.
   90. Para los departamentos que tengan menos de 5 empleados, calcular el gasto en salarios anuales (salar + comis) *14
   91. Calcular el desfase de salarios entre el máximo y el mínimo para cada departamento de los empleados que tienen hijos.
   92. Para los departamentos que tienen un presupuesto menor de 50000 euros hallar el número de empleados que lo forman.
   93. Hallar la suma de los presupuestos, el presupuesto máximo, el mínimo de cada tipo de departamento.
   94. Hallar la suma de los presupuestos de cada centro, indicando el nombre de cada uno.
   95. Hallar los nombres de los empleados y nombre de centro al que pertenece, ordenando por número de este.
   96. Hallar el número del departamento que tiene más hijos.
   97. Hallar el número del departamento que tiene un gasto en salarios mayor.
   98. Averiguar si hay algún departamento que tenga un presupuesto menor que la suma de salarios que tiene que pagar (salarios y comisiones) anualmente.
   99. Actualizar los datos del empleado 110, poniendo su fecha de nacimiento a 1974-05-08
   100. Quitar las comisiones de los empleados del departamento 100.
   101. Actualizar los salarios de los empleados siguiendo la siguiente tabla:
   1. Salario menor o igual a 1000 euros > 1000 €
   2. Salario mayor a 1000 y menor o igual a 1500 > 1500 €
   3. Salario mayor a 1500 y menor o igual a 2300 > 2300 €
   4. Salario mayor a 2300 y menor o igual a 3000 > 3000 €
   5. Salarios mayores a 3000 euros > 3300 €
   102. Crear una tabla auxiliar llamada empleados que contenga todos los datos de los empleados.
   103. Borrar de la tabla empleados los empleados que no tengan hijos.*/
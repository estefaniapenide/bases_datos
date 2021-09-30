
/* 
Cambiar nombre del fichero a "apellido1_nombre_examen1t.sql"

Nombre: Estefan�a Penide Casanova

*/



/* 01. Devuelve el listado de clientes registrados con el total pagado por cada uno de ellos.
Ordénalo por cantidad pagada de mayor a menor */

SELECT C.CodigoCliente, C.NombreCliente, COALESCE(sum(P.cantidad),0) AS total_pagado
FROM clientes C LEFT JOIN pagos P ON P.CodigoCliente =C.CodigoCliente 
GROUP BY C.CodigoCliente 
ORDER BY total_pagado DESC;

/* 02. Devuelve el nombre de los clientes que hayan hecho pedidos en 2008 */

SELECT DISTINCT C.NombreCliente
FROM clientes C INNER JOIN pedidos P ON C.CodigoCliente =P.CodigoCliente 
WHERE P.FechaPedido LIKE "2008%";

/* 03. Mostrar los nombre completos (junto en la misma columna) de los empleados que 
trabajan en España y cuyo primer apellido empiece por M */

SELECT concat(E.nombre," ",E.apellido1," ",E.apellido2) AS empleado
FROM empleados E JOIN oficinas O ON O.CodigoOficina =E.CodigoOficina 
WHERE E.apellido1 LIKE "M%" AND O.Pais LIKE "España";

/* 04. Muestra todos los pedidos con su precio */

SELECT CodigoPedido, sum(Cantidad*PrecioUnidad) AS precio
FROM detallepedidos
GROUP BY CodigoPedido;

/* 05. Listar las ciudades donde hay oficinas con el número de empleados que trabajan en cada ciudad */

SELECT O.Ciudad, count(E.CodigoEmpleado) AS "N�mero de empleados"
FROM oficinas O LEFT JOIN empleados E ON E.CodigoOficina =O.CodigoOficina 
GROUP BY O.Ciudad;

/* 06. Muestra el código, nombre y gama de los productos que nunca se han pedido. */

SELECT COALESCE(DP.CodigoProducto,P.CodigoProducto) AS codigo , P.Nombre, P.Gama 
FROM productos P LEFT JOIN detallepedidos DP ON P.CodigoProducto = DP.CodigoProducto
WHERE DP.CodigoProducto IS NULL;


/* 07. Devuelve el listado de clientes con el nombre, primer apellido, teléfono y extensión 
de su representante de ventas, de aquellos clientes que no hayan realizado ningún pago. */

SELECT C.NombreCliente, COALESCE(concat(E.Nombre," ",E.Apellido1," ",O.Telefono," ",E.Extension),"No tiene") AS representante_ventas
FROM clientes C LEFT JOIN empleados E ON E.CodigoEmpleado = C.CodigoEmpleadoRepVentas 
	LEFT JOIN oficinas O ON O.CodigoOficina =E.CodigoOficina
	LEFT JOIN pagos P ON P.CodigoCliente =C.CodigoCliente 
WHERE P.CodigoCliente IS NULL;


/* 08. Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que no
sean representante de ventas de ningún cliente. */

SELECT DISTINCT E.Nombre, E.Apellido1, E.Puesto, O.Telefono 
FROM empleados E LEFT JOIN clientes C  ON E.CodigoEmpleado = C.CodigoEmpleadoRepVentas
	LEFT JOIN oficinas O ON O.CodigoOficina =E.CodigoOficina
WHERE C.CodigoCliente IS NULL;



/* 09. Mostrar código, nombre y gama de aquellos productos de los que se han pedido más de 100 unidades
Ordenados por cantidad de unidades de mayor a menor. Se contabilizarán como pedidos todos, aunque estén
pendientes o hayan sido rechazados */

SELECT P.CodigoProducto, P.Nombre, P.Gama
FROM productos P JOIN detallepedidos DP ON P.CodigoProducto =DP.CodigoProducto 
GROUP BY P.CodigoProducto
HAVING sum(DP.cantidad) > 100
ORDER BY sum(DP.cantidad) DESC;



/* 10. La tabla Pedidos tiene una columna "Estado" cuyos posibles valores son solo "Entregado", "Rechazado"
y "Pendiente". Escribe el código necesario para corregir los errores que haya en los valores. Solo se trata
de modificar aquellos valores no correctos". */



 
 
 
 

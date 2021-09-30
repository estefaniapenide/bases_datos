
/* 
Cambiar nombre del fichero a "apellido1_nombre_examen1t.sql"

Nombre: 

*/



/* 01. Devuelve el listado de clientes registrados con el total pagado por cada uno de ellos.
Ordénalo por cantidad pagada de mayor a menor */

SELECT C.CodigoCliente, C.NombreCliente, COALESCE(sum(P.Cantidad),0) AS TotalPagado
FROM clientes C LEFT JOIN pagos P USING (CodigoCliente)
								-- ON P.CodigoCliente=C.CodigoCliente 
GROUP BY CodigoCliente
ORDER BY TotalPagado DESC;


/* 02. Devuelve el nombre de los clientes que hayan hecho pedidos en 2008 */


SELECT DISTINCT NombreCliente
FROM Clientes C INNER JOIN Pedidos P USING (CodigoCliente)
WHERE year(FechaPedido)=2008;

SELECT DISTINCT NombreCliente
FROM Clientes C JOIN Pedidos P USING (CodigoCliente)
WHERE FechaPedido BETWEEN "2008-01-01" AND "2008-12-31";
	-- AND FechaPedido between '20080101' and '20081231';
	-- AND FechaPedido > '2007-12-31' AND FechaPedido < '2009-01-01';

SELECT DISTINCT NombreCliente
FROM Clientes C, Pedidos P 
WHERE C.CodigoCliente = P.CodigoCliente 
	AND year(FechaPedido)=2008;

/* Entendiendo que dos Jardinerías pueden tener el mismo nombre */

INSERT INTO Clientes VALUES (41,'Jardin de Flores','Pepe','Pérez','666777777','','Rue del Percebe',NULL,'Madrid','Madrid','España','28001',NULL,80000);
INSERT INTO Pedidos VALUES (130,'2008-11-15','2008-11-23','2008-11-23','Entregado',NULL,41);

SELECT NombreCliente
FROM Clientes C INNER JOIN Pedidos P USING (CodigoCliente)
WHERE year(FechaPedido)=2008
GROUP BY C.CodigoCliente;

SELECT NombreCliente FROM 
( -- Realmente bastaría con la subordinada
SELECT DISTINCT C.CodigoCliente, NombreCliente
FROM Clientes C INNER JOIN Pedidos P USING (CodigoCliente)
WHERE year(FechaPedido)=2008 
) AUX;


/* 03. Mostrar los nombre completos (junto en la misma columna) de los empleados que 
trabajan en España y cuyo primer apellido empiece por M */

/* Para ver los paises presentes y comprobar posibles errores de diseño */
SELECT DISTINCT Pais FROM Oficinas;
SELECT DISTINCT Pais FROM Oficinas WHERE Pais LIKE "%spa%";

SELECT CONCAT(E.Nombre," ",E.Apellido1," ",E.Apellido2)) AS nombre, O.Pais 
FROM empleados E JOIN Oficinas O USING (CodigoOficina)
WHERE (O.Pais="España" OR CodigoOficina LIKE "%-ES") AND E.Apellido1 LIKE "M%";


/* Si contemplamos que Apellido 2 pueda ser NULL */

INSERT INTO Empleados VALUES (32,'Juan','Magaña',NULL,'3897','marcos@jardineria.es','TAL-ES',NULL,'Director General');

SELECT TRIM(CONCAT(E.Nombre," ",E.Apellido1," ",COALESCE(E.Apellido2,''))) AS nombre, O.Pais 
FROM empleados E JOIN Oficinas O USING (CodigoOficina)
WHERE (O.Pais="España" OR CodigoOficina LIKE "%-ES") AND E.Apellido1 LIKE "M%";

SELECT CONCAT_WS(" ", E.Nombre, E.Apellido1, E.Apellido2) AS nombre, O.Pais 
FROM empleados E JOIN Oficinas O USING (CodigoOficina)
WHERE (O.Pais="España" OR CodigoOficina LIKE "%-ES") AND E.Apellido1 LIKE "M%";



/* 04. Muestra todos los pedidos con su precio. */

SELECT CodigoPedido, sum(Cantidad * PrecioUnidad) as total
FROM DetallePedidos
GROUP BY CodigoPedido;


/* Teniendo en cuenta que hay pedidos que no tienen asignados productos en DetallesPedidos */
SELECT P.CodigoPedido, SUM(D.Cantidad*D.PrecioUnidad) AS Precio_Pedido
FROM Pedidos AS P LEFT JOIN DetallePedidos AS D
						ON P.CodigoPedido=D.CodigoPedido
GROUP BY P.CodigoPedido;


/* 05. Listar las ciudades donde hay oficinas con el número de empleados que trabajan en cada ciudad */

SELECT Ciudad, count(E.CodigoEmpleado) AS NumeroEmpleados
FROM Oficinas O LEFT JOIN Empleados E USING (CodigoOficina)
GROUP BY Ciudad;


/* 06. Muestra el código, nombre y gama de los productos que nunca se han pedido. */

SELECT CodigoProducto, Nombre, Gama
FROM Productos
WHERE CodigoProducto NOT IN (SELECT DISTINCT CodigoProducto FROM DetallePedidos);

SELECT CodigoProducto, Nombre, Gama
FROM DetallePedidos RIGHT JOIN Productos USING (CodigoProducto)
WHERE CodigoPedido IS NULL;

SELECT P.CodigoProducto, Nombre, Gama
FROM DetallePedidos D RIGHT JOIN Productos P ON D.CodigoProducto=P.CodigoProducto 
WHERE CodigoPedido IS NULL;


/* 07. Devuelve el listado de clientes con el nombre, primer apellido, teléfono y extensión 
de su representante de ventas, de aquellos clientes que no hayan realizado ningún pago. */

SELECT C.CodigoCliente, C.NombreCliente, RV.Nombre, RV.Apellido1, O.Telefono, RV.Extension, RV.CodigoOficina 
FROM clientes C LEFT JOIN empleados RV ON C.CodigoEmpleadoRepVentas=RV.CodigoEmpleado
			LEFT JOIN oficinas O USING (CodigoOficina)
WHERE C.CodigoCliente NOT IN (SELECT DISTINCT CodigoCliente FROM Pagos);


/* 08. Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos 
 * empleados que no sean representante de ventas de ningún cliente. */

SELECT E.Nombre, E.Apellido1, E.Apellido2, E.Puesto, O.Telefono
FROM empleados E LEFT JOIN oficinas O USING (CodigoOficina)
WHERE E.CodigoEmpleado NOT IN (SELECT DISTINCT CodigoEmpleadoRepVentas FROM Clientes
								WHERE CodigoEmpleadoRepVentas IS NOT NULL);

								
SELECT E.Nombre, E.Apellido1, E.Apellido2, E.Puesto , O.Telefono
FROM empleados E LEFT JOIN Clientes C ON C.CodigoEmpleadoRepVentas=E.CodigoEmpleado
	LEFT JOIN oficinas O USING (CodigoOficina)
WHERE C.CodigoCliente IS NULL;


/* Poco eficiente pero da el resultado correcto: */
SELECT E.NOMBRE AS NOMBRE, CONCAT (E.APELLIDO1," ",E.APELLIDO2) AS APELLIDOS, E.PUESTO,O.TELEFONO
FROM Empleados E LEFT JOIN Oficinas O ON E.CODIGOOFICINA=O.CODIGOOFICINA 
	LEFT JOIN Clientes C ON E.CODIGOEMPLEADO=C.CODIGOEMPLEADOREPVENTAS 
GROUP BY E.CODIGOEMPLEADO 
HAVING COUNT(C.CODIGOCLIENTE)=0;


/* 09. Mostrar código, nombre y gama de aquellos productos de los que se han pedido más de 100 unidades
Ordenados por cantidad de unidades de mayor a menor. Se contabilizarán como pedidos todos, aunque estén
pendientes o hayan sido rechazados */

SELECT P.CodigoProducto, P.Nombre, P.Gama
FROM Productos P JOIN DetallePedidos DP USING (CodigoProducto)
GROUP BY CodigoProducto
HAVING sum(Cantidad)>100
ORDER BY sum(Cantidad) DESC;



/* 10. La tabla Pedidos tiene una columna "Estado" cuyos posibles valores son solo "Entregado", "Rechazado"
y "Pendiente". Escribe el código necesario para corregir los errores que haya en los valores. Solo se trata
de modificar aquellos valores no correctos". */


SELECT CODIGOPEDIDO,ESTADO FROM Pedidos WHERE ESTADO NOT IN ("ENTREGADO","RECHAZADO","PENDIENTE");

SELECT DISTINCT Estado
FROM Pedidos;

UPDATE Pedidos SET Estado='Pendiente' WHERE Estado='Pediente';
 
 

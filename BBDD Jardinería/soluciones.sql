

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




/* 03. Mostrar los nombre completos (junto en la misma columna) de los 
 * empleados que trabajan en España y cuyo primer apellido empiece por M */


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



/* 05. Listar las ciudades donde hay oficinas con el número de empleados que 
 * trabajan en cada ciudad */



SELECT Ciudad, count(E.CodigoEmpleado) AS NumeroEmpleados
FROM Oficinas O LEFT JOIN Empleados E USING (CodigoOficina)
GROUP BY Ciudad;


/* 06. Muestra el código, nombre y gama de los productos que nunca se han pedido. */

SELECT CodigoProducto, Nombre, Gama
FROM Productos
WHERE CodigoProducto NOT IN (SELECT DISTINCT CodigoProducto FROM DetallePedidos);

SELECT CodigoProducto, Nombre, Gama 
FROM Productos P LEFT JOIN DetallePedidos DP USING (codigoproducto)
WHERE DP.CodigoProducto IS NULL


/* Productos que, habiendose pedido, no se han entregado (¿cancelaciones?) */

SELECT CodigoProducto, Nombre, Gama 
FROM Productos PRO JOIN DetallePedidos DP USING (codigoproducto)
	JOIN Pedidos PED USING(CodigoPedido)
WHERE FechaEntrega=NULL AND FechaEntrega<curdate(); 


/* Muestra el código, nombre y gama de los productos que nunca se han entregado */

( -- Los que no se han pedido
SELECT CodigoProducto, Nombre, Gama
FROM Productos
WHERE CodigoProducto NOT IN (SELECT DISTINCT CodigoProducto FROM DetallePedidos)
)
UNION
( -- Los que habiéndose pedido, se han cancelado
SELECT CodigoProducto, Nombre, Gama 
FROM Productos PRO JOIN DetallePedidos DP USING (codigoproducto)
	JOIN Pedidos PED USING(CodigoPedido)
WHERE FechaEntrega=NULL AND FechaEntrega<curdate()
); 




/* 07. Devuelve el listado de clientes con el nombre, primer apellido, teléfono y extensión 
de su representante de ventas, de aquellos clientes que no hayan realizado ningún pago. */

SELECT C.CodigoCliente, C.NombreCliente, RV.Nombre, RV.Apellido1, O.Telefono, RV.Extension 
FROM clientes C LEFT JOIN empleados RV ON C.CodigoEmpleadoRepVentas=RV.CodigoEmpleado
			LEFT JOIN oficinas O USING (CodigoOficina)
WHERE C.CodigoCliente NOT IN (SELECT DISTINCT CodigoCliente FROM Pagos);


SELECT C.CodigoCliente, C.NombreCliente, RV.Nombre, RV.Apellido1, O.Telefono, RV.Extension 
FROM clientes C LEFT JOIN empleados RV ON C.CodigoEmpleadoRepVentas=RV.CodigoEmpleado
			LEFT JOIN oficinas O USING (CodigoOficina)
		LEFT JOIN Pagos P USING (CodigoCliente)
		WHERE P.CodigoCliente IS NULL;



/* 08. Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos 
 * empleados que no sean representante de ventas de ningún cliente. */
	

SELECT E.Nombre, E.Apellido1, E.Apellido2, E.Puesto, O.Telefono
FROM empleados E JOIN oficinas O USING (CodigoOficina)
WHERE E.CodigoEmpleado NOT IN (SELECT DISTINCT CodigoEmpleadoRepVentas FROM Clientes
								WHERE CodigoEmpleadoRepVentas IS NOT NULL);
/* https://stackoverflow.com/questions/129077/null-values-inside-not-in-clause*/
							
							
							
SELECT E.Nombre, E.Apellido1, E.Apellido2, E.Puesto, (SELECT telefono
													FROM oficinas O
													WHERE E.CodigoOficina = O.CodigoOficina)
FROM empleados E
WHERE E.CodigoEmpleado NOT IN (SELECT DISTINCT CodigoEmpleadoRepVentas FROM Clientes
								WHERE CodigoEmpleadoRepVentas IS NOT NULL);		
					
								
SELECT E.Nombre, E.Apellido1, E.Apellido2, E.Puesto, O.Telefono
FROM empleados E LEFT JOIN oficinas O USING (CodigoOficina)
		LEFT JOIN Clientes C ON C.CodigoEmpleadoRepVentas=E.CodigoEmpleado
WHERE CodigoEmpleadoRepVentas IS NULL;


SELECT E.Nombre, E.Apellido1, E.Apellido2, E.Puesto , O.Telefono
FROM empleados E LEFT JOIN Clientes C ON C.CodigoEmpleadoRepVentas=E.CodigoEmpleado
	JOIN oficinas O USING (CodigoOficina)
WHERE C.CodigoCliente IS NULL;


/* Poco eficiente pero da el resultado correcto: */
SELECT E.NOMBRE AS NOMBRE, CONCAT (E.APELLIDO1," ",E.APELLIDO2) AS APELLIDOS, E.PUESTO,O.TELEFONO
FROM Empleados E JOIN Oficinas O ON E.CODIGOOFICINA=O.CODIGOOFICINA 
	LEFT JOIN Clientes C ON E.CODIGOEMPLEADO=C.CODIGOEMPLEADOREPVENTAS 
GROUP BY E.CODIGOEMPLEADO 
HAVING COUNT(C.CODIGOEMPLEADOREPVENTAS)=0;



/* 10. La tabla Pedidos tiene una columna "Estado" cuyos posibles valores son solo "Entregado", "Rechazado"
y "Pendiente". Escribe el código necesario para corregir los errores que haya en los valores. Solo se trata
de modificar aquellos valores no correctos". */


SELECT CODIGOPEDIDO,ESTADO FROM Pedidos WHERE ESTADO NOT IN ("ENTREGADO","RECHAZADO","PENDIENTE");

SELECT DISTINCT Estado
FROM Pedidos;

UPDATE Pedidos SET Estado='Pendiente' WHERE Estado='Pediente';

ALTER TABLE pedidos MODIFY COLUMN Estado ENUM("ENTREGADO","RECHAZADO","PENDIENTE") NOT NULL;



/* 11. Mostrar código, nombre y gama de aquellos productos de los que se han pedido más de 100 unidades
 * en total ordenados por cantidad de unidades de mayor a menor. Se contabilizarán como pedidos todos, 
 * aunque estén pendientes o hayan sido rechazados  */

SELECT P.CodigoProducto, Nombre, Gama, sum(DP.Cantidad) AS ventas
FROM Productos P JOIN DetallePedidos DP USING (CodigoProducto)
GROUP BY P.CodigoProducto, Nombre, Gama
HAVING ventas>100
ORDER BY ventas DESC;

SELECT CodigoProducto, Nombre, Gama
FROM Productos P NATURAL JOIN DetallePedidos DP
GROUP BY CodigoProducto 
HAVING sum(cantidad)>100
ORDER BY sum(cantidad) DESC;


/* 11b. Para saber productos de los que se han pedido más de 100 únidades juntas */

SELECT DISTINCT P.CodigoProducto, Nombre, Gama
FROM Productos P JOIN DetallePedidos DP USING (CodigoProducto)
WHERE cantidad>100;


/* 12. Mostrar el código de los pedidos donde se hayan vendido más de 6 productos */

SELECT CodigoPedido
FROM DetallePedidos
GROUP BY CodigoPedido
HAVING count(*)>6;


/* 13. Cantidad de ventas por gama */

SELECT Gama, sum(Cantidad)
FROM Productos P JOIN DetallePedidos DP USING(CodigoProducto)
GROUP BY Gama


/* 14. Gama más vendida */

WITH VxG AS (
	SELECT Gama, sum(Cantidad) AS cantidad
	FROM Productos P JOIN DetallePedidos DP USING(CodigoProducto)
	GROUP BY Gama
)
SELECT Gama
FROM VxG
WHERE cantidad = (SELECT max(cantidad) FROM VxG)
     

SELECT Gama
FROM (
	SELECT GP.Gama, sum(Cantidad) as cantidad
	FROM DetallePedidos DP, Productos P
	WHERE DP.CodigoProducto=P.CodigoProducto
	GROUP BY Gama) GamaVentas
WHERE cantidad = (SELECT max(cantidad) FROM (
						SELECT GP.Gama, sum(Cantidad) as cantidad
						FROM DetallePedidos DP, Productos P, GamasProductos GP
						WHERE DP.CodigoProducto=P.CodigoProducto AND P.Gama=GP.Gama
						GROUP BY Gama) GamaVentas
                     );


/* Podría haber más de una Gama con el mismo número de ventas máximo. Si no, también se podría hacer
 * ordenando y limitando el número de resultados a uno: */

SELECT Gama
FROM Productos P JOIN DetallePedidos DP USING(CodigoProducto)
GROUP BY Gama
ORDER BY sum(Cantidad) DESC
LIMIT 1;



/* 16. Código de los pedidos donde se haya vendido el producto de la gama ‘Aromáticas’ mas caro. */
                    
             
SELECT CodigoPedido
FROM DetallePedidos DP JOIN Productos P USING (CodigoProducto)
WHERE Gama="Aromáticas"
                   

WITH PA AS (
	SELECT *
	FROM productos P
	WHERE Gama LIKE "Arom%"
)
SELECT CodigoPedido
FROM DetallePedidos DP
WHERE CodigoProducto IN -- Porque varios productos tienen el precio máximo
	(SELECT CodigoProducto
	FROM PA
	WHERE PrecioVenta=(SELECT max(PrecioVenta) FROM PA)
	);
                    

select codigopedido
from detallepedidos 
where codigoproducto in 
	(select codigoproducto
    from productos 
    where precioventa = (select max(precioventa)
                         from productos p JOIN gamasproductos g on p.gama = g.gama
                         where g.gama='aromáticas'));


/* 17. Muestra el pais donde menos pedidos se hacen */

SELECT Pais
FROM (SELECT Pais, count(CodigoPedido) as pedidos
		FROM Clientes C LEFT JOIN Pedidos P ON C.CodigoCliente=P.CodigoCliente
		GROUP BY Pais) PedidosPais
WHERE pedidos= (SELECT min(pedidos)
				FROM (SELECT Pais, count(CodigoPedido) as pedidos
 						FROM Clientes C LEFT JOIN Pedidos P ON C.CodigoCliente=P.CodigoCliente
 						GROUP BY Pais) PedidosPais);
 
 
 
 
 /* Para resolver a la vuelta de navidad: 
	Gama más vendida, sin condiderar los pedidos que no han sido entregados.
    Modificar la tabla pedidos para que el campo estado sea un enum sin perder la información ya almacenada*/


 
 

USE jardineria;

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
 * El fichero debe nombrarse con el nombre del alumno/a siguiendo el formato "Apellido1_Nombre_finalConsultas.sql".
 * 
 * Completar también los siguientes datos:
 * 
 * Nombre:
 * Grupo: [DUAL, Adultos A o Adultos B]
 * 
 * */



/* ---------------------------------------------------------------------------------------------------
 * 1. Listado de clientes (código, nombre y teléfono) cuyo cantidad total realizada entre todos sus pagos
 * supera los 10000€ ordenados de mayor a menor cantidad pagada */


select p.codigo_cliente, c.nombre_cliente, c.telefono
from pago p join cliente c USING (codigo_cliente)
group by p.codigo_cliente
having sum(p.total)>10000
order by sum(p.total) desc;


/* ---------------------------------------------------------------------------------------------------
 * 2. Listado de clientes (código y nombre) con el número de pedidos registrados por cada uno */

select c.codigo_cliente, c.nombre_cliente, count(p.codigo_pedido) as NumeroPedidos
from cliente c left join pedido p USING (codigo_cliente)
group by c.codigo_cliente;



/* ---------------------------------------------------------------------------------------------------
 * 3. Listado de Codigos de producto registrados en alg�n pedido en 2009 */

SELECT DISTINCT codigo_producto 
FROM detalle_pedido INNER JOIN pedido P USING (codigo_pedido)
WHERE year(fecha_pedido)=2009;


/* ---------------------------------------------------------------------------------------------------
 * 4. Listado de empleados que son representantes de ventas de algún cliente
 * (nombre completo, teléfono y extensión) con sede en España */

SELECT distinct pais from clientes;

SELECT distinct RV.Nombre, RV.Apellido1, O.Telefono, RV.Extension 
FROM cliente C JOIN empleado RV ON C.codigo_empleado_rep_ventas=RV.codigo_empleado
			JOIN oficina O USING (codigo_oficina)
WHERE C.Pais='Espa�a' OR C.Pais='Spain';



/* ---------------------------------------------------------------------------------------------------
 * 5.  Devuelve un listado de oficinas con el número de clientes
 * que tienen a su representante de ventas en esa oficina.*/

select codigo_oficina, count(codigo_cliente) AS numero_clientes_representados
from cliente right join empleado on codigo_empleado = codigo_empleado_rep_ventas
group by codigo_oficina
order by numero_clientes_representados;


/* ---------------------------------------------------------------------------------------------------
 * 6. De entre los pedidos registrados en 2009, mostrar aquel producto del que se han vendido menos unidades. 
 * No se tendrá en cuenta el estado del pedido. En caso de que sean varios con el mismo número de unidades,
 * se mostrarán todos ellos.
 *  */

WITH ventaspedido2009 AS (
	select codigo_producto, sum(cantidad) AS ventas
	from detalle_pedido JOIN pedido USING (codigo_pedido)
	WHERE year(fecha_pedido)=2009
GROUP BY codigo_producto
)
SELECT codigo_producto, ventas
from ventaspedido2009
where ventas = (select min(ventas) from ventaspedido2009);



/* ---------------------------------------------------------------------------------------------------
 * 7. Dinero total devuelto en los pedidos rechazados en 2009. */

SELECT distinct estado from pedidos;

SELECT sum(Cantidad * precio_unidad) as total
FROM detalle_pedido JOIN pedido USING (codigo_pedido)
WHERE year(fecha_pedido)=2009 AND Estado='Rechazado';



/* ---------------------------------------------------------------------------------------------------
 * 8. Productos que se piden, en media, en cantidades superiores a 100. */

select codigo_producto, Nombre
from detalle_pedido join producto USING (codigo_producto)
group by codigo_producto
having avg(Cantidad)>100


/* ---------------------------------------------------------------------------------------------------
 * 9. Listado de jefes (Código y nombre completo) */

SELECT codigo_empleado, nombre, apellido1, apellido2
FROM empleado
WHERE codigo_empleado IN (SELECT distinct codigo_jefe FROM empleado);



/* ---------------------------------------------------------------------------------------------------
 * 10. Codigos de pedidos que tienen fecha de entrega y han sido rechazados con
 * el nombre completo, teléfono y extensión del representante de ventas del cliente
 * que lo pidio.
 *  */
	
SELECT codigo_pedido, RV.Nombre, RV.Apellido1, O.Telefono, RV.Extension 
from pedido p JOIN cliente USING (Codigo_Cliente)
	JOIN empleado RV on Codigo_Empleado=codigo_empleado_rep_ventas
	JOIN oficina O USING (Codigo_Oficina)
WHERE estado='Rechazado' AND Fecha_Entrega IS NOT NULL;




	
	
	

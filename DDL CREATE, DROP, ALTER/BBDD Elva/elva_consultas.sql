/*---------------------------------------------------------------------------------------------
------------- Mostrar nombre y nombre comercial de ciertos clientes ---------
--------------------------------------------------------------------------------------------- */

SELECT nombre, nombre_comercial
FROM clientes
WHERE cod_cliente="000001"
	OR cod_cliente="000003"
	OR cod_cliente="000005"
	OR cod_cliente="000007";
    
SELECT nombre, nombre_comercial
FROM clientes
WHERE cod_cliente IN ("000001","000003","000005","000007");

/*------------------ para clientes con id impar -------------------------- */
SELECT nombre, nombre_comercial
FROM clientes
WHERE cod_cliente%2=1;
    
    

/*---------------------------------------------------------------------------------------------
------------- Mostrar todos los clientes de los que hay facturas registradas  ---------
--------------------------------------------------------------------------------------------- */

SELECT DISTINCT(cliente) FROM facturas;



/*---------------------------------------------------------------------------------------------
------------- Mostrar facturas con su número en formato de 4 cifras  ---------
--------------------------------------------------------------------------------------------- */

SELECT LPAD(num, 4, '0') AS "Número",
	fecha_factura AS Fecha,
    tipo_factura AS "Tipo Factura",
    importe,
    cliente
FROM facturas;


/*---------------------------------------------------------------------------------------------
------------- Mostrar facturas de 2020  ---------
--------------------------------------------------------------------------------------------- */

SELECT LPAD(num, 4, '0') AS "Número",
	fecha_factura AS Fecha,
    tipo_factura AS "Tipo Factura",
    importe,
    cliente
FROM facturas
WHERE year(fecha_factura)=2020;



/*---------------------------------------------------------------------------------------------
------------- Mostrar facturas entre 2 fechas ---------
--------------------------------------------------------------------------------------------- */

SELECT LPAD(num, 4, '0') AS numero,
	fecha_factura AS fecha,
    tipo_factura,
    importe,
    cliente
FROM facturas
WHERE fecha_factura>='2019-01-19' AND fecha_factura<='2020-02-19';

SELECT LPAD(num, 4, '0') AS numero,
	fecha_factura AS fecha,
    tipo_factura,
    importe,
    cliente
FROM facturas
WHERE fecha_factura BETWEEN '2019-01-19' AND '2020-02-19';


SELECT LPAD(num, 4, '0') AS numero,
	fecha_factura AS fecha,
    importe,
    cliente
FROM facturas
WHERE tipo_factura="A" AND
	importe BETWEEN 1500 AND 6000; 


/* Mostrar los abonos (devoluciones de facturas;  tipo_factura="D") 
entre marzo del 19 y febrero del 20 inclusive, con importes mayores a 500€ */


SELECT LPAD(num, 4, '0') AS numero,
	fecha_factura AS fecha,
    importe,
    cliente
FROM facturas
WHERE tipo_factura="D"
	AND fecha_factura BETWEEN "2019-03-01" AND "2020-02-28"
    AND importe<-500;
   

/* Ver todos lod pagos realizados por cada cliente */

SELECT cliente, P.fecha_pago, P.importe
FROM clientes C, pagos P
WHERE C.cod_cliente=P.cliente
ORDER BY cliente DESC;


/* Pago de mayor importe registrado */
SELECT max(importe)
FROM pagos;


/* Suma de importes de pagos registrados para cada cliente */
SELECT cliente, round(sum(importe),2) AS "Suma de pagos"
FROM pagos
GROUP BY cliente;



/* Ver todos los pagos realizados por el cliente 2 
ordenados por fecha con la más reciente arriba*/

SELECT P.fecha_pago, P.importe
FROM clientes C, pagos P
WHERE C.cod_cliente=P.cliente
	AND cliente=2
ORDER BY fecha_pago DESC; 

SELECT P.fecha_pago, P.importe
FROM clientes C INNER JOIN pagos P ON C.cod_cliente=P.cliente
WHERE cliente=2
ORDER BY fecha_pago DESC; 


/*

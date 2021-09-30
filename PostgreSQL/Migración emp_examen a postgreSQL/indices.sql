/* Las restricciones PK, FK o UNIQUE, requieren un índice que se crea con ellas.

El índice creado sobre la columna nss es:
"empleados_nss_key" UNIQUE CONSTRAINT, btree (nss)

Por ser una restricción (CONSTRAINT), para eliminarlo, tenemos que modificar la tabla:
*/
ALTER TABLE empleados DROP CONSTRAINT empleados_nss_key; -- Eliminamos el índice UNIQUE de nss

-- Comprobamos ahora el tiempo que tarda un filtrado sobre esa columna sin índice:
EXPLAIN ANALYSE SELECT * FROM empleados WHERE nss=36000;
SELECT * FROM empleados WHERE nss=36000;

-- Volviendo a crearlo:
CREATE UNIQUE INDEX empleados_nss_key ON empleados(nss);
-- Podemos ver cómo la consulta se acelera considerablemente
-- Para volver a eliminarlo, tras haberlo creado sin modificar la tabla:
DROP INDEX empleados_nss_key;


-- Probando con otra columna:
SELECT * FROM empleados WHERE nombre='Nombre36000';
CREATE INDEX emp_nombre_key ON empleados(nombre);

/* Las funciones almacenadas no permiten transacciones. Para realizar una transacción 
ha de usarse un procedimiento (o un bloque anónimo DO) 
https://www.postgresql.org/docs/13/plpgsql-transactions.html
*/


CREATE TABLE test1 (numero int);

DROP PROCEDURE transaction_test1;
CREATE PROCEDURE transaction_test1()
LANGUAGE plpgsql
AS $$
BEGIN
    FOR i IN 0..9 LOOP
        INSERT INTO test1 (numero) VALUES (i);
        IF i % 2 = 0 THEN
            COMMIT;
        ELSE
            ROLLBACK;
        END IF;
    END LOOP;
END;
$$;

CALL transaction_test1();
SELECT * FROM test1;



/* Crear un procedimiento que realiza una transacción.
 * Recibirá como parámetros la cuenta emisora, la receptora y la cantidad */

DROP TABLE IF EXISTS cuentas;
CREATE TABLE cuentas (
  cuenta INT PRIMARY KEY,
  saldo INT DEFAULT 0
);
INSERT INTO cuentas VALUES (1, 1000);
INSERT INTO cuentas VALUES (2, 1000);


CREATE OR REPLACE PROCEDURE transferencia
	(emisor INT, receptor INT, cantidad NUMERIC(7,2))
AS $$
BEGIN
    UPDATE cuentas SET saldo=saldo+cantidad WHERE cuenta=receptor;
    UPDATE cuentas SET saldo=saldo-cantidad WHERE cuenta=emisor;
    IF (SELECT saldo FROM cuentas WHERE cuenta=emisor) <0 THEN
   		RAISE NOTICE 'La cuenta % no tiene suficiente saldo', emisor;
   		ROLLBACK; -- También podría comprobarse con un IF y un RETURN al principio
   	END IF;
END; $$ LANGUAGE plpgsql;

CALL transferencia(1,2,200);
CALL transferencia(1,2,1200);
SELECT * FROM cuentas;
CALL transferencia(1,4,1200); -- Fallaría, necesario comprobar cuentas no existentes

UPDATE cuentas SET saldo=saldo+cantidad WHERE cuenta=4; -- No devuelve error, 
-- simplemente, la condición del WHERE devuelve cero filas


-- Si tenemos ya un check que no permita saldos negativos en la propia tabla:
ALTER TABLE cuentas ADD CHECK (saldo>0);

-- Deja de ser necesaria la comprobación del saldo, ya que ya saltará el error por el CHECK
CREATE OR REPLACE PROCEDURE transferencia
	(emisor INT, receptor INT, cantidad NUMERIC(7,2))
AS $$
BEGIN
    UPDATE cuentas SET saldo=saldo-cantidad WHERE cuenta=emisor;
   	IF NOT FOUND THEN 
   		RAISE EXCEPTION 'La cuenta de emisión(%) no existe', emisor;
   		-- ROLLBACK; -- Con EXCEPTION el ROLLBACK no sería necesario.
   	END IF;
    UPDATE cuentas SET saldo=saldo+cantidad WHERE cuenta=receptor;
   	IF NOT FOUND THEN 
   		RAISE EXCEPTION 'La cuenta de destino(%) no existe', receptor;
   		ROLLBACK;
   		RETURN;
   	END IF;
END; $$ LANGUAGE plpgsql;
-- Postgres realiza automáticamente el ROLLBACK si alguna de las operaciones del procedure falla.

CALL transferencia(1,2,200);
CALL transferencia(1,2,1200);
CALL transferencia(1,4,10);
CALL transferencia(1,NULL,10);
SELECT * FROM cuentas;


CALL transferencia(1,1,1200); -- Funciona, pero es absurda
/* Es recomendable evitar la realización de procesos innecesarios o cuyo 
resultado es anticipable para evitar consumir recursos, especialmente si el procedimiento
fuese costoso */

CALL transferencia(1,2,-10); -- Falla, no debería permitir números negativos
CALL transferencia(1,2,NULL); -- Falla


CREATE OR REPLACE PROCEDURE transferencia
	(emisor INT, receptor INT, cantidad NUMERIC(7,2))
AS $$
BEGIN
	IF emisor=receptor THEN 
		RAISE WARNING 'Esta transfiriendo de una cuenta a sí misma';
		RETURN;
	END IF;
	-- No mostramos error, pero evitamos gastar recursos
	IF cantidad<=0 OR cantidad IS NULL THEN -- Al comprobarlo al principio 
		RAISE EXCEPTION 'Cantidad inválida'; -- y lanzar excepción
	END IF; -- termina la ejecución, no siendo el ROLLBACK necesario
    UPDATE cuentas SET saldo=saldo+cantidad WHERE cuenta=receptor;
   	IF NOT FOUND THEN 
   		RAISE EXCEPTION 'La cuenta de destino(%) no existe', receptor;
   		ROLLBACK;
   	END IF;
    UPDATE cuentas SET saldo=saldo-cantidad WHERE cuenta=emisor;
   	IF NOT FOUND THEN 
   		RAISE EXCEPTION 'La cuenta de emisión(%) no existe', emisor;
   		ROLLBACK; -- Con EXCEPTION el ROLLBACK no sería necesario.
   	END IF;
END; $$ LANGUAGE plpgsql;


SELECT * FROM cuentas;
CALL transferencia(1,2,-1200);
CALL transferencia(1,2,NULL);

CALL transferencia(1,1,1200);




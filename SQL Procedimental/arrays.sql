/* Crear un procedimiento que realice una transaccion.
 * Recibira como parametros la cuenta emisora,
 * La receptora y la cantidad */

DROP PROCEDURE IF EXISTS realizarTransaccion(integer, integer, integer);
CREATE OR REPLACE PROCEDURE realizar_transaccion(emisora integer, receptora integer, cantidad integer)
AS $$
DECLARE
	numeros integer[];
	contas integer[];
BEGIN
	cuentas_existentes := ARRAY (SELECT num FROM cuentas);
	contas := ARRAY [emisora::integer, receptora::integer];

	IF (receptora <> emisora
		AND cantidad > 0
		AND cuentas_existentes <@ numeros -- https://www.postgresql.org/docs/current/functions-array.html
		AND (SELECT saldo FROM cuentas WHERE num = emisora) - cantidad >= 0) THEN
		
		UPDATE cuentas SET saldo = saldo + cantidad WHERE num = receptora;
		UPDATE cuentas SET saldo = saldo - cantidad WHERE num = emisora;
	END IF;

END;$$
LANGUAGE plpgsql;

SELECT * FROM cuentas c;
CALL realizar_transaccion(1, 2, 300);

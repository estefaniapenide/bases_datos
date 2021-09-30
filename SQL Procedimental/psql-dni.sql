/* Función basada en detección de errores */

create or replace function validadni(dni CHAR(10))
RETURNS boolean
as $$
DECLARE
	letrasValidas constant CHAR(23) := 'TRWAGMYFPDXBNJZSQVHLCKE';
	letraInput CHAR;
	numero INT;
	letraCorrecta CHAR;
	longitud INT;
begin
	IF dni=NULL THEN RETURN FALSE; END IF;
	longitud := length(dni);
	IF longitud<9 OR longitud>10 THEN
		RAISE WARNING 'EL DNI debe constar de 8 números y una letra';
		RETURN FALSE;
	END IF;
	letraInput := SUBSTR(dni, length(dni), 1); -- Extraemos el último caracter
	numero := (SUBSTR(dni, 1, 8))::int; -- Casteo a INT. Si no son números, lanza una excepción '22P02'
    /* Se separa primero el último caracter (letra) y los primeros 8 (números). 
	 * Si está con algún separador (caracter 9 cuando longitud 10), lo ignora  */
	letraCorrecta := SUBSTR(letrasValidas, MOD(numero, 23)+1, 1);
	IF (letraCorrecta = letraInput) THEN RETURN true;
		ELSE
			RAISE WARNING 'La letra de control no es correcta';
			RETURN false;
	END IF;
	-- Captura de la excepción si falla el casteo y devolución de false
	EXCEPTION WHEN sqlstate '22P02' THEN -- Para gestionar si el casteo no se lleva a cabo
        RAISE WARNING 'El dni debe empezar por 8 caracteres numéricos';
        RETURN false;
end; $$ language plpgsql

-- Podría substituirse el boolean por un INT, definiendo códigos que representen cada error !!


SELECT validadni('27694722P');
SELECT validadni('27694722A');
SELECT validadni('27694722-P');
SELECT validadni('2A694722-P');
SELECT validadni('2P');
SELECT validadni('2');
SELECT validadni('');
SELECT validadni(NULL);



/* Procedimiento basado en lanzamiento de excepciones.
 * Bastará llamar al procedimiento. Si algo falla, este devolverá una excepción indicando el error */

create or replace PROCEDURE pvalidadni(dni CHAR(10))
as $$
DECLARE
	letrasValidas constant CHAR(23) := 'TRWAGMYFPDXBNJZSQVHLCKE';
	letraInput CHAR;
	numero INT;
	letraCorrecta CHAR;
	longitud INT;
begin
	IF dni=NULL THEN
		RAISE EXCEPTION 'DNI inválido: %', dni
			USING HINT='DNI a validar no recibido';
	END IF;
	longitud := length(dni);
	IF longitud<9 OR longitud>10 THEN
		RAISE EXCEPTION 'DNI inválido: %', dni
			USING HINT='EL DNI debe constar de 8 números y una letra';
	END IF;
	letraInput := SUBSTR(dni, length(dni), 1);
	numero := (SUBSTR(dni, 1, 8))::int;
	letraCorrecta := SUBSTR(letrasValidas, MOD(numero, 23)+1, 1);
	IF (letraCorrecta != letraInput) THEN 
			RAISE EXCEPTION 'DNI inválido: %', dni
			USING HINT='La letra de control no es correcta';
	END IF;
	EXCEPTION WHEN sqlstate '22P02' THEN
        RAISE EXCEPTION  'DNI inválido: %', dni
			USING HINT='El dni debe empezar por 8 caracteres numéricos';
end; $$ language plpgsql


CALL pvalidadni('27694722P');
CALL pvalidadni('27694722A');
CALL pvalidadni('27694722-P');
CALL pvalidadni('2A694722-P');
CALL pvalidadni('2P');
CALL pvalidadni('2');
CALL pvalidadni('');
CALL pvalidadni(NULL);




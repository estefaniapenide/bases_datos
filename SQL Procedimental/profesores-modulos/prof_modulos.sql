



DROP FUNCTION IF EXISTS bloques_modulos;

CREATE OR REPLACE FUNCTION bloques_modulos (
	regimenes_in regimen[],
	especialidad_in VARCHAR(50)
	)
RETURNS TABLE (
		modulo1 text, modulo2 text, modulo3 text, modulo4 text,
		sesiones_out SMALLINT
	)
AS $$
DECLARE
	sesiones_min CONSTANT INT := 18;
	sesiones_max CONSTANT INT := 21;
BEGIN
RETURN QUERY

WITH MI AS (
	SELECT codigo, mc.ciclo, mc.regimen, m.siglas AS siglas_modulo,
		CONCAT(mc.ciclo, ' ', mc.regimen, ' - ', m.siglas) AS modulo, sesiones
	FROM modulos m JOIN modulos_ciclo mc ON m.cod=mc.modulo
		JOIN especialidades e on m.especialidad=e.cod
	WHERE regimen = ANY (regimenes_in) -- https://www.postgresql.org/docs/current/functions-array.html 
	AND e.nombre=especialidad_in
)

SELECT * FROM (
-- Bloques de 2 módulos:
	SELECT m1.modulo AS modulo1, m2.modulo AS modulo2, NULL, NULL,
			m1.sesiones + m2.sesiones as sesiones_t
	FROM MI m1, MI m2
	WHERE m1.codigo > m2.codigo

UNION
-- Bloques de 3 módulos
	SELECT m1.modulo AS modulo1, m2.modulo AS modulo2, m3.modulo AS modulo3, NULL,
			m1.sesiones + m2.sesiones + m3.sesiones as sesiones_t
	FROM MI m1, MI m2, MI m3
	WHERE m1.codigo<m2.codigo AND m2.codigo<m3.codigo
	
	
UNION
-- Bloques de 4 módulos
	SELECT m1.modulo AS modulo1, m2.modulo AS modulo2, m3.modulo AS modulo3, m4.modulo AS modulo4,
			m1.sesiones + m2.sesiones + m3.sesiones + m4.sesiones as sesiones_t
	FROM MI m1, MI m2, MI m3, MI m4
	WHERE m1.codigo>m2.codigo AND m2.codigo>m3.codigo AND m3.codigo>m4.codigo
) combinaciones
WHERE sesiones_t BETWEEN sesiones_min AND sesiones_max
-- ORDER BY m1.sesiones, m2.sesiones
;

END; $$ language plpgsql






SELECT * FROM bloques_modulos(array['Dual','Adultos','Distancia']::regimen[],'Informática');
SELECT * FROM bloques_modulos(array['Adultos']::regimen[],'Informática');









/**
 * No pudiendo ser iguales, los 6 casos repetidos son precisamente las variaciones de orden:
 * m1-m2-m3 / m1-m3-m2 / m2-m1-m3 / m2-m3-m1 / m3-m1-m2 / m3-m2-m1
 * Solo uno de ellos cumple la condición clave1>clave2>clave3, que también elimina los
 * casos del mismo módulo repetido en el mismo bloque (clave1=clave2...).
 */



	

DROP FUNCTION IF EXISTS bloques_modulos;

CREATE OR REPLACE FUNCTION bloques_modulos (
	regimenes_in regimen[],
	especialidad_in VARCHAR(50)
	)
RETURNS TABLE (
		modulo1 text,
		modulo2 text,
		sesiones_out SMALLINT
	)  AS $$
DECLARE
	sesiones_min CONSTANT INT := 18;
	sesiones_max CONSTANT INT := 21;
BEGIN

RETURN QUERY

WITH MI AS (
	SELECT codigo, CONCAT(mc.ciclo, ' ', mc.regimen, ' - ', m.siglas) AS modulo, sesiones
	FROM modulos m JOIN modulos_ciclo mc ON m.cod=mc.modulo
		JOIN especialidades e on m.especialidad=e.cod
	WHERE regimen = ANY (regimenes_in)
	AND e.nombre=especialidad_in
)
SELECT m1.modulo AS modulo1, m2.modulo AS modulo2, NULL::, NULL,
			m1.sesiones + m2.sesiones as sesiones_t
FROM MI m1, MI m2

;

END; $$ language plpgsql






SELECT * FROM bloques_modulos(array['Dual','Adultos','Distancia']::regimen[],'Informática');





/* Crear un procedimiento que inserte profesores
- La clave primaria no se pasará, se generará automáticamente.
- Debe comprobarse la validez del dni y del email. Si no son válidos, se mostrará un error.
- La fecha de incorporación podrá ser null, tomando por defecto la fecha en la que se ejecute la inserción.
- En caso de usar la fecha por defecto, se mostrará un WARNING.
- Mostrará un NOTICE con los datos de la fila que se ha insertado (haciéndo un SELECT para garantizar que
  efectivamente se han introducido los datos del modo deseado).
- La especialidad del profesor se pasará por su nombre, en caso de que esa especialidad no exista se mostrará
 un error y se sugerirán, de haberlas, aquellas cuyo nombre sea parecido.
 */


---Hecho por mi--
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
			RAISE WARNING 'La letra de control del DNI no es correcta';
			RETURN false;
	END IF;
	-- Captura de la excepción si falla el casteo y devolución de false
	EXCEPTION WHEN sqlstate '22P02' THEN -- Para gestionar si el casteo no se lleva a cabo
        RAISE WARNING 'El dni debe empezar por 8 caracteres numéricos';
        RETURN false;
end; $$ language plpgsql;

drop procedure insertarprofesores(char,varchar,varchar,varchar,int,DATE);

CREATE OR REPLACE PROCEDURE insertarprofesores(nif_ char, 
											nombre_ varchar, 
											apellido1_ varchar, 
											apellido2_ varchar,
											especialidad_ int,
											fechaincoorp DATE DEFAULT CURRENT_DATE
											) AS $$
DECLARE 
id_ int GENERATED always;
rec record;
BEGIN 

	IF NOT validadni(nif_) THEN
		RAISE EXCEPTION 'DNI no v�lido';
	END IF;
	IF fechaincoorp=current_date THEN
		INSERT INTO profesores VALUES(id_, nif_, nombre_, apellido1_, apellido2_ ,especialidad_);
			RAISE WARNING 'Se ha asignado como fecha de incoorporaci�n la fecha de hoy';
	ELSE
		INSERT INTO profesores VALUES(id_, nif_, nombre_, apellido1_, apellido2_ ,fecharincoorp ,especialidad_);
		SELECT * INTO rec FROM profesores WHERE id=id_;
			RAISE NOTICE 'Datos insertados: id %, nif %, nombre %, apellido1 %, apellido2 %, fecha %, especialidad %',
			rec.id, rec.nif, rec.nombre, rec.apellido1, rec.apellido2, rec.fecha_incorporación, rec.especialidad;
	END IF;	
END;
$$
LANGUAGE 'plpgsql';

CALL insertarprofesores('23232323J','A', 'apellido1_ varchar', 'apellido2_ varchar', 2);





    
    
    

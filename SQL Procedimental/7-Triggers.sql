
/* Un trigger es una función invocada automáticamente cuando sucede un evento como
 * actualizar una fila (UPDATE), insertarla (INSERT) o borrarla (DELETE) */


/* Función del trigger */
DROP FUNCTION notificador CASCADE;
CREATE OR REPLACE FUNCTION notificador() RETURNS trigger AS $$
BEGIN
	IF OLD.salario=NEW.salario THEN RETURN NEW; END IF;

	RAISE NOTICE 'El salario del empleado % ha pasado de % a %',
		NEW.id, OLD.salario, NEW.salario;
	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

/* Trigger */
DROP TRIGGER IF EXISTS notificador ON empleados;
CREATE TRIGGER notificador
  AFTER UPDATE ON empleados
  FOR EACH ROW
  EXECUTE PROCEDURE notificador();


SELECT * FROM empleados WHERE salario=2000;
UPDATE empleados SET salario=2030 WHERE id=1;

-- UPDATE empleados SET supervisor=1 WHERE id=6;
UPDATE empleados SET salario=salario+500 WHERE id=1;

 
  

/*******************************************************************************************/
/*******************************************************************************************/
/* 1. Trigger que notifica cada vez que se actualiza una fila de empleados */

/* Función del trigger */
DROP FUNCTION notificador CASCADE;
CREATE OR REPLACE FUNCTION notificador() RETURNS trigger AS $$
BEGIN
	IF OLD.salario=NEW.salario THEN -- Si no se modifica el salario
		RETURN NEW; -- Realizamos la operación sin más (acabamos aquí la ejecución de la función)
	ELSE 
	   IF NEW.salario>3000 THEN
		  RAISE WARNING 'El empleado % ya cobra mucho', OLD.id;
		  -- Si el salario una vez llevada a cabo la operación va a superar 3000
   		  RETURN NULL; -- Indicamos que no se lleve a cabo. Queda como estaba.
	   ELSE -- en caso contrario
		  RAISE NOTICE 'El salario va a pasar de % a % para el empleado %',
			OLD.salario, -- OLD es una referencia a la fila antes del evento
			NEW.salario, -- NEW es una referencia a la fila tras el evento
			NEW.id;  -- (aquí daría igual que fuese OLD)
		  RETURN NEW; -- Sí se lleva a cabo devolvemos la nueva fila
	   END IF;
    END IF;
END; $$ LANGUAGE plpgsql;


/* Trigger */
DROP TRIGGER IF EXISTS notificador ON empleados;
CREATE TRIGGER notificador
  BEFORE UPDATE -- El trigger se lanza ANTES de cada UPDATE...
  ON empleados -- ... en la tabla empleados
  FOR EACH ROW -- y se ejecuta para cada fila insertada (en un solo update se pueden modificar varias)
  EXECUTE PROCEDURE notificador();


  UPDATE empleados SET salario=1000 WHERE id<10;
  SELECT * FROM empleados;

UPDATE empleados SET salario=salario+500;
  

UPDATE empleados SET salario=2000 WHERE id=6;
UPDATE empleados SET supervisor=1 WHERE id=6;
UPDATE empleados SET salario=salario+500 WHERE id=6;
SELECT * FROM empleados WHERE id=6;



/*******************************************************************************************/
/*******************************************************************************************/
/* 2. Tabla que se actualiza automáticamente llevando un registro de los salarios de
 * empleados insertados y de modificaciones de salario de los existentes */


/* Tabla que se actualizará con cada inserción de empleados o actualización de su salario */
DROP TABLE IF EXISTS emp_log;
CREATE TABLE emp_log (
	emp_id INT NOT NULL,
	salario_old NUMERIC(7,2) DEFAULT NULL, -- Solo para UPDATES, NULL para INSERTS
	salario_new NUMERIC(7,2) NOT NULL,
	usuario name NOT NULL DEFAULT CURRENT_USER, -- Usuario de la BBDD que realiza la instrucción
	timestamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

/** Función que devuelve un trigger que actualiza la tabla "emp_log"*/
CREATE OR REPLACE FUNCTION rec_insert() RETURNS trigger AS $$
BEGIN
	INSERT INTO emp_log (emp_id, salario_new, timestamp) -- No sería necesario pasar el timestamp
         VALUES (NEW.id, NEW.salario, CURRENT_TIMESTAMP); -- ya que lo introduciría el DEFAULT
    RETURN NEW;  /* El valor devuelto es irrelevante cuando el trigger es AFTER */
END; $$ LANGUAGE 'plpgsql';


/** Trigger asociado a las inserciones en la tabla empleado que lanza la función anterior tras cada inserción */
DROP TRIGGER IF EXISTS auditoria_insert_empleado ON empleados;
CREATE TRIGGER auditoria_insert_empleado
  AFTER INSERT -- El trigger se lanza tras realizar un INSERT...
  ON empleados -- ... en la tabla empleados
  FOR EACH ROW -- y se ejecuta para cada fila insertada (en un solo insert se pueden insertar varias)
  EXECUTE PROCEDURE rec_insert(); -- el procedimiento rec_insert()

SELECT * FROM emp_log;

DELETE FROM empleados WHERE id IN (60,61);
-- Se insertan 2 filas en una sola instrucción
INSERT INTO empleados VALUES (60, '60000111A', 'Empleado60', 'Dep5 Apellido2', 602345678905, 1000.01, 'MUJER', '1988-01-14', 5, 5, 5),
(61, '61000111A', 'Empleado61', 'Dep5 Apellido2', 612345678905, 1000.01, 'MUJER', '1988-01-14', 5, 5, 5);


/*******************************************************************************************/
/* Actualizando el trigger anterior para que también funciones para UPDATES */

/** Función que devuelve un trigger que actualiza la tabla "emp_log" también para UPDATES */
CREATE OR REPLACE FUNCTION rec_insert()
	RETURNS trigger
AS $$
DECLARE
	-- salario_evento NUMERIC(7,2) := NULL;
BEGIN
    -- RAISE NOTICE 'Salario anterior= %', OLD.salario;
	IF OLD.salario=NEW.salario THEN RETURN NULL; END IF;
	
	-- IF TG_OP='UPDATE' THEN 
	-- salario_evento:=OLD.salario; --END IF;
	INSERT INTO emp_log (emp_id, salario_old, salario_new)
        	VALUES (NEW.id, OLD.salario, NEW.salario);
    RETURN NEW;
END; $$ LANGUAGE 'plpgsql';


DROP TRIGGER IF EXISTS auditoria_insert_empleado ON empleados;
CREATE TRIGGER auditoria_insert_empleado
  AFTER INSERT OR UPDATE ON empleados -- ... en la tabla empleados
  FOR EACH ROW
  EXECUTE FUNCTION rec_insert();

  
-- DROP FUNCTION update_prueba() CASCADE;
DELETE FROM emp_log;
SELECT * FROM emp_log;
DELETE FROM empleados WHERE id IN (60,61);


INSERT INTO empleados VALUES (60, '60000111A', 'Empleado60', 'Dep5 Apellido2', 602345678905, 1000.01, 'MUJER', '1988-01-14', 5, 5, 5),
(61, '61000111A', 'Empleado61', 'Dep5 Apellido2', 612345678905, 1000.01, 'MUJER', '1988-01-14', 5, 5, 5);

UPDATE empleados SET salario=2000 WHERE id=60;




/*******************************************************************************************/
/*******************************************************************************************/
/* 3. Trigger que evita UPDATES y DELETES en la tabla emp_log */

CREATE OR REPLACE FUNCTION no_updates_log() RETURNS trigger
AS $$
BEGIN
	IF TG_OP='UPDATE' THEN 
		RAISE EXCEPTION 'La tabla emp_log no admite modificaciones';
	ELSEIF TG_OP='DELETE' THEN 
		RAISE EXCEPTION 'La tabla emp_log no admite borrados';
	END IF;
	RETURN NULL;
END; $$ LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS no_updates_log ON emp_log;
CREATE TRIGGER no_updates_log
  BEFORE UPDATE OR DELETE ON emp_log
  FOR EACH ROW
  EXECUTE FUNCTION no_updates_log();

UPDATE emp_log SET salario_old=1000 WHERE salario_old IS NULL;
DELETE FROM emp_log WHERE emp_id=60;
SELECT * FROM emp_log;




/*******************************************************************************************/
/*******************************************************************************************/
/* 4. Trigger que comprueba que no se inserten ni actualicen 
 * DNI inválidos en la tabla empleados */


CREATE OR REPLACE FUNCTION check_dni() RETURNS trigger
AS $$
BEGIN
    IF (validadni(NEW.nif)) THEN 
        RETURN NEW;
    ELSE 
        RAISE WARNING 'DNI no válido';
        RETURN NULL;
    END IF;
END; $$ LANGUAGE 'plpgsql';


CREATE OR REPLACE FUNCTION check_dni() RETURNS trigger
AS $$
BEGIN
	CALL pvalidadni(NEW.nif);
	RETURN NEW;
    /* Entraría aquí si quisiésemos capturar las excepciones, pero también podemos
 		dejar que salten las que están */
	EXCEPTION WHEN OTHERS THEN 
		RAISE WARNING 'DNI no válido';
		RETURN NULL;
	/* Capurando la excepción y devolviendo NULL podemos hacer que solamente no
	 * se realicen las inserciones de filas NO válidas pero sí de las válidas.
	 * Si se devuelve una excepción, la acción se rechaza en su conjunto */
	 */
END; $$ LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS check_dni ON empleados;
CREATE TRIGGER check_dni
	BEFORE UPDATE OR INSERT ON empleados -- Sería lógico hacer uno idéntico para familiares
	FOR EACH ROW 
	EXECUTE FUNCTION check_dni();


DELETE FROM empleados WHERE id>59;
SELECT * FROM empleados;

INSERT INTO empleados VALUES (60, '27694722P', 'Empleado60', 'Dep5 Apellido2', 602345678905, 1000.01, 'MUJER', '1988-01-14', 5, 5, 5), -- Valido
	(61, '61000111A', 'Empleado61', 'Dep5 Apellido2', 612345678905, 1000.01, 'MUJER', '1988-01-14', 5, 5, 5); -- Inválido
UPDATE empleados SET salario=1000 WHERE id=6;
/* Si se usase desde el principio no debería saltar si no se toca la columna nif, pero
el fallo de diseño es previo */

INSERT INTO empleados VALUES (65, '27694722P', 'Empleado60', 'Dep5 Apellido2', 602345678905, 1000.01, 'MUJER', '1988-01-14', 5, 5, 5);



/*******************************************************************************************/
/*******************************************************************************************/
/* 5. En el supuesto de que consideremos que puedan darse NIF repetidos.
 * Trigger que lanza un warning cuando se introduce un DNI repetido */

--  Eliminamos las restricciones UNIQUE sobre NIF. Simplemente lanzaremos un WARNING
ALTER TABLE empleados DROP CONSTRAINT empleados_nif_key;
ALTER TABLE familiares DROP CONSTRAINT familiares_nif_key;

CREATE OR REPLACE FUNCTION dni_duplicado() RETURNS trigger
AS $$
DECLARE
	id_dup empleados.id%type;
	nombre_dup VARCHAR(255);
BEGIN
	SELECT id, nombre || ' ' || apellidos FROM empleados WHERE nif=NEW.nif
		INTO id_dup, nombre_dup;
	IF FOUND THEN
		RAISE WARNING 'NIF duplicado: Empleado con id % y nombre %',
			id_dup, nombre_dup;
		RETURN NEW; -- Lo insertamos igualmente
	END IF;
	SELECT id, nombre || ' ' || apellidos FROM familiares WHERE nif=NEW.nif
		INTO id_dup, nombre_dup;
	IF FOUND THEN
		RAISE NOTICE 'Exite un familiar con ese NIF: Familiar con id % y nombre %',
			id_dup, nombre_dup;
		RETURN NEW;
	END IF;
	RETURN NEW; -- También hay que insertarlo si no hay duplicados
END; $$ LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS dni_duplicado ON empleados;
CREATE TRIGGER dni_duplicado
	BEFORE INSERT ON empleados
	FOR EACH ROW 
	EXECUTE FUNCTION dni_duplicado();


DELETE FROM empleados WHERE id IN (66,67,70);
INSERT INTO empleados VALUES (66, '71446011F', 'Empleado60', 'Dep5 Apellido2', 609999999999, 1000.01, 'MUJER', '1988-01-14', 5, 5, 5);
INSERT INTO empleados VALUES (70, '71446011F', 'Empleado70', 'Apellido70', 12345678970, 6000.11, 'HOMBRE', '1988-01-01', 1, 1, NULL);

UPDATE empleados SET nif='27694722P' WHERE id=6;
























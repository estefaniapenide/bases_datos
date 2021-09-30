/*
 * Normas de entrega:
 * 
 * Todas las funciones, procedimientos o triggers deben tener un nombre con la forma nombreAlumno_nombreFuncion
 * El fichero debe nombrarse con el nombre del alumno/a siguiendo el formato "apellido1_nombre_3T.sql".
 * 
 * 
 * Nombre:
 * Grupo: [Adultos A o Adultos B]
 */


/**************************************************************************************************************************
 ***************************************************************************************************************************
 * 1. Función que recibe una cadena de texto de 8 cifras y devuelve un dni válido con su 
 * letra de control. Se comprobará que el valor introducido sea numérico y de 8 cifras, lanzando un
 * mensaje de error en caso contrario */

create or replace function creaDNI(dni CHAR(8))
RETURNS CHAR(9)
as $$
DECLARE
    letrasValidas constant CHAR(23) := 'TRWAGMYFPDXBNJZSQVHLCKE';
begin
    IF dni IS NULL length(dni)<>8 THEN
        RAISE EXCEPTION 'Debe introducir una cadena de 8 caracteres';
    END IF;
    RETURN dni || SUBSTR(letrasValidas, MOD((dni::int),23)+1, 1);
    EXCEPTION WHEN sqlstate '22P02' THEN -- Para gestionar si el casteo no se lleva a cabo
        RAISE EXCEPTION 'El dni debe constar de caracteres numéricos';
end; $$ language plpgsql

SELECT creaDNI(NULL);
SELECT creaDNI('1234567a');
SELECT creaDNI('1234567');
SELECT creaDNI('123456789');
SELECT creaDNI('12345678');
SELECT creaDNI('27694722');





/**************************************************************************************************************************
 **************************************************************************************************************************
 ** 2. Impedir que un profesor tenga un DNI inválido en la columna "nif" y que haya DNI duplicados. */

CREATE OR REPLACE FUNCTION check_dni() RETURNS trigger
AS $$
DECLARE
	id_dup profesores.id%type;
	nombre_dup VARCHAR(255);
BEGIN
	CALL pvalidadni(NEW.nif);
	IF OLD.nif = NEW.nif THEN RETURN NEW; END IF; 
	SELECT id, nombre FROM profesores WHERE nif=UPPER(NEW.nif)
		INTO id_dup, nombre_dup;
	IF FOUND THEN
		RAISE EXCEPTION 'NIF duplicado: Empleado con id % y nombre %',
			id_dup, nombre_dup;
	END IF;
	RETURN NEW;
END; $$ LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS check_dni ON empleados;
CREATE TRIGGER check_dni
	BEFORE INSERT OR UPDATE ON profesores
	FOR EACH ROW 
	EXECUTE FUNCTION check_dni();


UPDATE profesores SET nif = '11222333A' WHERE id = 101;
-- Aunque actualiza al que ya tenía, salta error por ser incorrecto
UPDATE profesores SET nif = '53170624Y' WHERE id = 101; -- nif valido
UPDATE profesores SET nif = '53170624Y' WHERE id = 101;

INSERT INTO profesores VALUES (10000, '53170624Y', 'George', 'Boole', NULL, '1986-09-16', 590107, 3000);
-- Duplicado tras previo UPDATE
INSERT INTO profesores VALUES (10000, '27694722P', 'George', 'Boole', NULL, '1986-09-16', 590107, 3000);


/* TODO: ahora mismo habría un problema con DNIs duplicados con letra minúscula en un caso y mayúscula en otro
y también con aquellos que utilicen o no separador (o separadores distintos) entre números y letra de control */

UPDATE profesores SET nif = '53170624-Y' WHERE id = 102; -- Debería fallar pero no contemplado
UPDATE profesores SET nif = '53170624y' WHERE id = 102; -- Debería fallar pero no contemplado



/**************************************************************************************************************************
 * 2b. Normalizando los DNI insertados */

CREATE OR REPLACE FUNCTION normaliza_dni(dni CHAR(10)) RETURNS CHAR(9) AS $$
BEGIN
	RETURN 
		(SUBSTR(dni, 1, 8)) -- La parte numeral 
		||  -- concatenada con
		UPPER(SUBSTR(dni, length(dni), 1)); -- el último caracter (la letra) pasada a mayúsculas
		-- De ese modo, se elimina el separador
END; $$ LANGUAGE 'plpgsql';
 
 
CREATE OR REPLACE FUNCTION check_dni() RETURNS trigger
AS $$
DECLARE
	id_dup profesores.id%type;
	nombre_dup VARCHAR(255);
BEGIN
	CALL pvalidadni(NEW.nif);
	NEW.nif:=normaliza_dni(NEW.nif);
	SELECT id, nombre FROM profesores WHERE normaliza_dni(nif)=NEW.nif
		INTO id_dup, nombre_dup;
	IF FOUND THEN
		RAISE EXCEPTION 'NIF duplicado: Empleado con id % y nombre %',
			id_dup, nombre_dup;
	END IF;
	RETURN NEW;
END; $$ LANGUAGE 'plpgsql';


UPDATE profesores SET nif = '53170624-Y' WHERE id = 102;
UPDATE profesores SET nif = '53170624y' WHERE id = 102;






/**************************************************************************************************************************
 ***************************************************************************************************************************
 * 3. Evitar que un profesor tenga asignadas más de 21 sesiones en total */

 
/***************************************************************************************************************************
 * 3a. BEFORE - SIN excepciones */

CREATE OR REPLACE FUNCTION maxSesionesProfesor()
RETURNS trigger AS $$
DECLARE 
	sesionesMaximas constant int := 21;
	sesionesTotales int;
	sesionesFinales int;
BEGIN
	IF NEW.profesor IS NULL THEN RETURN NEW; END IF; -- Para INSERTS sin profesor o UPDATES que no toquen ese campo
	
	SELECT sum(sesiones) INTO sesionesTotales FROM modulos_ciclo WHERE profesor=NEW.profesor;

	-- Si se actualizan las sesiones en el UPDATE (caso raro, probablemente debería restringirse por separado)
	IF OLD.sesiones <> NEW.sesiones THEN
		sesionesFinales := sesionesTotales - COALESCE(OLD.sesiones,0) + NEW.sesiones;
	/* Las sesiones totales tras la acción serán las que había, menos las de la fila que se actualiza
	(0 si son NULL en la fila que se actualiza o por ser INSERT) más las que se van a introducir */
	ELSE /* Casos normales: INSERT o UPDATE de profesor en fila ya existente sin modificar sesiones
	(no se restan las sesiones de esta ya que no eran del profesor en el momento de la totalización) */
		sesionesFinales := sesionesTotales + NEW.sesiones;
	END IF;
	
	IF sesionesFinales > sesionesMaximas THEN 
		RAISE WARNING 'Se ha superado el máximo de % sesiones, el total sería % sesiones', sesionesMaximas, sesionesFinales;
		RETURN NULL; 
	END IF;

	RETURN NEW;

END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS maxSesionesProfesor ON modulos_ciclo;
CREATE TRIGGER maxSesionesProfesor
  BEFORE INSERT OR UPDATE ON modulos_ciclo
  FOR EACH ROW EXECUTE PROCEDURE maxSesionesProfesor();
 
SELECT profesor, sum(sesiones) FROM modulos_ciclo GROUP BY profesor;
SELECT * FROM modulos_ciclo;

UPDATE modulos_ciclo SET profesor=NULL WHERE codigo=6;
UPDATE modulos_ciclo SET profesor=209 WHERE codigo=6;

INSERT INTO modulos_ciclo VALUES (99,'DAW','Adultos','MP0370',2,209); -- Correcto, pasa a 21
DELETE FROM modulos_ciclo WHERE codigo=99;
INSERT INTO modulos_ciclo VALUES (99,'DAW','Adultos','MP0370',3,209); -- Falla

 

/***************************************************************************************************************************
 * 3b. AFTER - CON excepciones */

CREATE OR REPLACE FUNCTION maxSesionesProfesor()
RETURNS trigger AS $$
DECLARE 
	sesionesMaximas constant int := 21;
	sesionesTotales int;
BEGIN
	IF NEW.profesor IS NULL THEN RETURN NEW; END IF; -- Para INSERTS sin profesor o UPDATES que no toquen ese campo
	
	SELECT sum(sesiones) INTO sesionesTotales FROM modulos_ciclo WHERE profesor=NEW.profesor;
	/* Al ser AFTER, ya están sumadas las nuevas */	
	IF sesionesTotales > sesionesMaximas THEN 
		RAISE EXCEPTION 'Se ha superado el máximo de % sesiones, el total sería % sesiones', sesionesMaximas, sesionesFinales;
	END IF; /* Ha de usarse una excepción, ya que un RETURN OLD no funcióna con AFTER */

	RETURN NEW;

END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS maxSesionesProfesor ON modulos_ciclo;
CREATE TRIGGER maxSesionesProfesor
  AFTER INSERT OR UPDATE ON modulos_ciclo
  FOR EACH ROW EXECUTE PROCEDURE maxSesionesProfesor();
 



/**************************************************************************************************************************
 ***************************************************************************************************************************
 * 4. Evitar que un módulo de 2º curso pueda ser prerrequisito */

CREATE OR REPLACE FUNCTION moduloSegundoNoPrerequisito() 
RETURNS trigger AS $$
DECLARE
	segundoCurso constant curso := '2º';
BEGIN
	PERFORM 1 FROM modulos WHERE cod=NEW.prerrequisito AND curso=segundoCurso;
	IF FOUND THEN 
		RAISE EXCEPTION 'El modulo % no puede ser prerequisito porque es de 2º curso', NEW.prerrequisito;
	END IF;	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER moduloSegundoNoPrerequisito
  BEFORE INSERT OR UPDATE ON prerrequisitos
  FOR EACH ROW EXECUTE PROCEDURE moduloSegundoNoPrerequisito();
 

INSERT INTO prerrequisitos (prerrequisito,modulo) VALUES ('MP0224','MP0226'); --presequisito de 2º
DELETE FROM prerrequisitos WHERE prerrequisito = 'MP0224' AND modulo = 'MP0226';

INSERT INTO prerrequisitos (prerrequisito,modulo) VALUES ('MP0221','MP0226'); --presequisito de 1º
DELETE FROM prerrequisitos WHERE prerrequisito = 'MP0221' AND modulo = 'MP0226';




/**************************************************************************************************************************
 ***************************************************************************************************************************
 * 5. Lanzar un WARNING cuando a un profesor se le asigna un módulo que no
 * sea de su especialidad */

/* Para completarse sería necesario aplicar triggers a las tablas profesores y modulos en caso de que se actualizasen especialidades. */


CREATE OR REPLACE FUNCTION avisoProfesorNoEspecialidad() RETURNS trigger AS $$
DECLARE 
	resultados int = 0;
	especialidadProfesor int; 
BEGIN	
	IF NEW.profesor IS NULL THEN RETURN NEW; END IF ; 
	SELECT especialidad INTO especialidadProfesor FROM profesores WHERE id=NEW.profesor;
	PERFORM 1 FROM modulos WHERE cod=NEW.modulo AND especialidad=especialidadProfesor; 
	IF NOT FOUND THEN
	 	RAISE WARNING 'Se ha asignado al profesor % un módulo de otra especialidad', NEW.profesor;
	END IF;
	RETURN NEW;
END; $$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS avisoProfesorNoEspecialidad ON modulos_ciclo;
CREATE TRIGGER avisoProfesorNoEspecialidad
  AFTER INSERT OR UPDATE ON modulos_ciclo
  FOR EACH ROW EXECUTE PROCEDURE avisoProfesorNoEspecialidad();

SELECT codigo, nombre, modulo, especialidad, profesor FROM modulos_ciclo mc JOIN modulos m ON m.cod=mc.modulo;
SELECT id, especialidad from profesores;
SELECT * FROM modulos_ciclo WHERE profesor = 101;

UPDATE modulos_ciclo SET profesor=103 WHERE codigo=6; -- Otra especialidad, salta el warning.
UPDATE modulos_ciclo SET profesor=306 WHERE codigo=6; -- válida


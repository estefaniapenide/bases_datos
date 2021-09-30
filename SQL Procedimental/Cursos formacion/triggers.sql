
/********************************************************************************************************/
/* 1. Garantizar que un empleado para ser profesor de un curso, 
 * tenga que tener la formación pedagógica y 
 * estar titulado en el curso que imparte */


/* Trigger que salte ante inserciones o actualizaciones de la tabla ediciones y solo permita asignar un empleado
 * como profesor cuando este cumpla tener a true su atributo formacion_pedagogica y estar referenciado en la
 * tabla empleado_titulado junto al curso de esa edición */

--Hecho por mi
DROP FUNCTION IF EXISTS fasignarprofesores();

CREATE OR REPLACE FUNCTION fasignarprofesores() RETURNS TRIGGER AS $$
DECLARE 
fp boolean;
BEGIN 
	
	IF NEW.empleado IS NULL THEN 
		RETURN NEW;
	END IF;

	PERFORM 1 FROM empleados WHERE id=NEW.profesor;
		IF NOT FOUND THEN 
			RAISE EXCEPTION 'El empleado % no existe', NEW.profesor;
		END IF;

	SELECT formacion_pedagogica INTO fp FROM empleados WHERE id=NEW.profesor;
		IF NOT fp THEN
			RAISE EXCEPTION E'El empleado % no tiene formaci�n pedag�gica.\nNo puede ser profesor', NEW.profesor;
		END IF;
	
	PERFORM 1 FROM empleado_titulado WHERE id_curso = NEW.id_curso;
		IF NOT FOUND THEN 
			RAISE EXCEPTION E'El empleado % no est� titulado en el curso %.\nNo puede ser profesor.', NEW.profesor, NEW.id_curso;
		END IF;
	RETURN NEW;
END;
$$ LANGUAGE 'plpgsql'; 

DROP IF EXISTS TRIGGER asignarprofesores ON ediciones;

CREATE TRIGGER asignarprofesores
BEFORE UPDATE OR INSERT ON ediciones
FOR EACH ROW 
EXECUTE PROCEDURE fasignarprofesores();

SELECT * FROM ediciones;
INSERT INTO ediciones VALUES (7, 5, '2021-05-15', 'Vigo',null);
UPDATE ediciones SET profesor = NULL WHERE id_edicion=7;



-----Soluciones de Alejandro------

CREATE OR REPLACE FUNCTION formacion_profesor() RETURNS TRIGGER AS $$
DECLARE
    fp boolean;
BEGIN
    -- RAISE NOTICE 'HOLA %', NEW.id;
    IF (OLD.profesor=NEW.profesor) THEN RETURN NEW; END IF;

    IF NEW IS NULL THEN 
        RAISE NOTICE 'Edicion no existente';
        RETURN NULL;
    END IF;

    
    SELECT formacion_pedagogica INTO fp FROM empleados WHERE id=NEW.profesor;
    IF NOT FOUND THEN -- IF fp IS NULL THEN
        RAISE NOTICE 'El empleado no existe';
        RETURN NULL;
    ELSEIF fp=FALSE THEN
        RAISE NOTICE 'El empleado no puede ser docente ya que no tiene la formación pegógica';
        RETURN NULL;
    END IF;

    PERFORM 1 FROM empleado_titulado WHERE id_empleado=NEW.profesor AND id_curso=OLD.id_curso;
    IF NOT FOUND THEN
        RAISE NOTICE 'El empleado no puede ser docente ya que no está titulado en ese curso';
        RETURN NULL;
    END IF;

END; $$ LANGUAGE 'plpgsql';


DROP TRIGGER formacion_profesor ON ediciones;
CREATE TRIGGER formacion_profesor
    BEFORE UPDATE OR INSERT ON ediciones
    FOR STATEMENT EXECUTE PROCEDURE formacion_profesor();


UPDATE ediciones SET profesor=100 WHERE id_edicion = 1; -- Empleado no existente
UPDATE ediciones SET profesor=1 WHERE id_edicion = 1; -- Empleado sin formación pedagógica
UPDATE ediciones SET profesor=4 WHERE id_edicion = 2; -- Empleado sin título
UPDATE ediciones SET profesor=4 WHERE id_curso = 1 AND fecha='2021-05-03'; -- Edición que no existe
UPDATE ediciones SET profesor=2 WHERE id_edicion = 1;
UPDATE ediciones SET profesor=NULL WHERE id_edicion = 1;

INSERT INTO ediciones VALUES(7, 1, NOW(), 'Vigo', 100); -- Empleado no existente
INSERT INTO ediciones VALUES(7, 1, NOW(), 'Vigo', 1); -- Empleado sin formación pedagógica
INSERT INTO ediciones VALUES(7, 1, NOW(), 'Vigo', 4); -- Empleado sin título 
INSERT INTO ediciones VALUES(8, 1, NOW(), 'Vigo', 2);










DROP FUNCTION IF EXISTS formacion_profesor() CASCADE;
CREATE OR REPLACE FUNCTION formacion_profesor() RETURNS trigger AS $$
DECLARE 
	fpedagogica empleados.formacion_pedagogica%type;
BEGIN
	-- Seteo a NULL permitido
	IF (NEW.profesor IS NULL) THEN RETURN NEW;
	END IF;

	SELECT formacion_pedagogica FROM empleados WHERE empleados.id = NEW.profesor
	INTO fpedagogica;
	
	-- Empleado referenciado no existente
	IF NOT FOUND THEN RETURN NEW; -- Dejamos que lance la excepción la propia regla de integridad
	END IF;
	-- Profesor sin formación pedagógica
	IF (NOT fpedagogica) THEN 
		RAISE EXCEPTION 'El empleado % no tiene formación pedagógica', NEW.profesor;
	END IF;

	-- Comprobamos si el empleado tiene el título de ese curso.
	PERFORM 1 FROM empleado_titulado WHERE id_curso=NEW.id_curso AND id_empleado=NEW.profesor;
	-- Utilizo PERFORM ya que no quiero devolver nada con la consulta, solo comprobar si encuentra algún registro
	IF NOT FOUND THEN
		RAISE EXCEPTION 'El empleado % no está títulado para impartir el curso %', NEW.profesor, NEW.id_curso;
	END IF;

	RETURN NEW;
END; $$ LANGUAGE 'plpgsql';
-- La comprobación (NEW.profesor = OLD.profesor) no tiene sentido ya que rara vez pasará.

CREATE TRIGGER formacion_profesor
	BEFORE UPDATE OR INSERT ON ediciones
	FOR EACH ROW EXECUTE PROCEDURE formacion_profesor();


-- PRUEBAS:

UPDATE ediciones SET profesor=100 WHERE id_edicion = 1; -- Empleado no existente
UPDATE ediciones SET profesor=1 WHERE id_edicion = 1; -- Empleado sin formación pedagógica
UPDATE ediciones SET profesor=4 WHERE id_edicion = 2; -- Empleado sin título
UPDATE ediciones SET profesor=4 WHERE id_curso = 1 AND fecha='2021-05-03';  -- Edición que no existe
UPDATE ediciones SET profesor=2 WHERE id_edicion = 1;
UPDATE ediciones SET profesor=NULL WHERE id_edicion = 1;

INSERT INTO ediciones VALUES(7, 1, NOW(), 'Vigo', 100); -- Empleado no existente
INSERT INTO ediciones VALUES(7, 1, NOW(), 'Vigo', 1); -- Empleado sin formación pedagógica
INSERT INTO ediciones VALUES(7, 1, NOW(), 'Vigo', 4); -- Empleado sin título 
INSERT INTO ediciones VALUES(8, 1, NOW(), 'Vigo', 2);




/********************************************************************************************************/
/* 2. Garantizar que un empleado no pueda ser al mismo tiempo alumno y profesor de la misma edición de un curso */

/*2a: Evitar añadir como alumno al profesor. Trigger sobre tabla de alumnos */

---Hecho por mi---

CREATE OR REPLACE FUNCTION falumnoNoprofesor() RETURNS TRIGGER AS $$
BEGIN 
	PERFORM 1 FROM ediciones WHERE profesor=NEW.id_empleado AND id_edicion=NEW.id_edicion;
	
	IF FOUND THEN
		RAISE EXCEPTION 'El empleado % es alumno de la edici�n del curso. No puede ser profesor.', NEW.id_empleado;
	END IF;

RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER alumnoNoprofesor
BEFORE UPDATE OR INSERT ON alumnos
FOR EACH ROW 
EXECUTE PROCEDURE falumnoNoprofesor();


-----Soluciones Alejandro-----

DROP FUNCTION IF EXISTS alumno_profesor() CASCADE;
CREATE OR REPLACE FUNCTION alumno_profesor() RETURNS trigger AS $$
BEGIN
	PERFORM 1 FROM ediciones WHERE id_edicion=NEW.id_edicion AND profesor=NEW.id_empleado;
	IF FOUND THEN
		RAISE EXCEPTION 'El alumno con el id % es profesor de la edicion %', NEW.id_empleado, NEW.id_edicion;
	END IF;
	RETURN NEW;
END; $$ LANGUAGE 'plpgsql';

CREATE TRIGGER alumno_profesor
	BEFORE INSERT OR UPDATE ON alumnos
	FOR EACH ROW EXECUTE PROCEDURE alumno_profesor();
/* Podríamos dejar fuera el update si asumimos que no se va a actualizar la PK o lo impedimos explícitamente
con otro trigger. */


-- PRUEBAS:

DELETE FROM alumnos;
UPDATE ediciones SET profesor=2 WHERE id_edicion = 1;
INSERT INTO alumnos VALUES(1, 1, false);
UPDATE alumnos SET id_empleado=2 WHERE id_empleado=1 AND id_edicion=1;
INSERT INTO alumnos VALUES(2, 1, false); -- Registro del profesor como alumno
INSERT INTO alumnos VALUES(2, 1000, false); -- Edición no existente
INSERT INTO alumnos VALUES(2000, 1, false); -- Alumno no existente


/*2b: Evitar añadir como profesor a un alumno. Trigger sobre tabla de ediciones */

---Hrecho por mi----
CREATE OR REPLACE FUNCTION fprofesorNoalumno() RETURNS TRIGGER AS $$
BEGIN
	PERFORM 1 FROM alumnos WHERE id_edicion=NEW.id_edicion AND id_empleado=NEW.id_profesor;
	IF FOUND THEN
		RAISE EXCEPTION 'El empleado % ya es alumno de la edicion % del curso. No puede ser profesor', NEW.id_profesor, NEW.id_edicion;
	END IF;
RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER profesorNoalumno
BEFORE UPDATE OR INSERT ON ediciones
FOR EACH ROW
EXECUTE PROCEDURE fprofesorNoalumno();


---Soluciones Alejandro-----

DROP FUNCTION IF EXISTS profesor_alumno() CASCADE;
CREATE OR REPLACE FUNCTION profesor_alumno() RETURNS trigger AS $$
BEGIN
	PERFORM 1 FROM alumnos WHERE id_edicion=NEW.id_edicion AND id_empleado=NEW.profesor;
	IF FOUND THEN 
		RAISE EXCEPTION 'El profesor con el id % ya es un alumno', NEW.profesor;
	END IF;
	RETURN NEW;
END; $$ LANGUAGE 'plpgsql';

CREATE TRIGGER profesor_alumno
	BEFORE UPDATE OR INSERT ON ediciones
	FOR EACH ROW EXECUTE PROCEDURE profesor_alumno();

SELECT * FROM alumnos;
INSERT INTO empleado_titulado VALUES (4,1);
INSERT INTO alumnos VALUES(4, 1, false);
UPDATE ediciones SET profesor=4 WHERE id_edicion=1;
UPDATE ediciones SET profesor=8 WHERE id_edicion=1;
UPDATE ediciones SET profesor=NULL WHERE id_edicion=1;




/********************************************************************************************************/
/* 3. Lanzar un WARNING cuando un empleado se matricula para ser alumno de un curso del que ya está titulado */

--Hecho por mi---

CREATE OR REPLACE FUNCTION fdoblematricula() RETURNS TRIGGER AS $$
BEGIN 
	PERFORM 1 FROM empleado_titulado WHERE id_empleado=NEW.id_empleado AND id_curso=(SELECT id_curso FROM ediciones WHERE id_edicion=NEW.id_edicion);

	IF FOUND THEN
		RAISE WARNING 'El empleado ya est� titulado en el curso. No se puede volver a matricular.';
			RETURN NULL;
	ELSE
			RETURN NEW;
	END IF;
END;
$$
LANGUAGE 'plpgsql';

DROP TRIGGER doblematricula ON alumnos;

CREATE TRIGGER doblematricula
BEFORE UPDATE OR INSERT ON alumnos
FOR EACH ROW 
EXECUTE PROCEDURE fdoblematricula();

SELECT * FROM alumnos;
SELECT *  FROM empleados;
SELECT * FROM ediciones;
SELECT * FROM empleado_titulado;

INSERT INTO alumnos VALUES(1,1,true);
UPDATE alumnos SET id_empleado=1 WHERE id_edicion=1;
INSERT INTO alumnos VALUES(2,4,false);


------Soluciones Alejandro-----

DROP FUNCTION IF EXISTS warning_alumno_titulado() CASCADE;
CREATE OR REPLACE FUNCTION warning_alumno_titulado() RETURNS trigger AS $$
BEGIN	
	PERFORM 1 FROM empleado_titulado WHERE id_empleado=NEW.id_empleado AND
		id_curso=(SELECT id_curso FROM ediciones WHERE id_edicion=NEW.id_edicion);
	
	
	/*SELECT E.id_edicion FROM ediciones E JOIN cursos C ON C.id = E.id_curso WHERE C.id = NEW.id_edicion INTO edicion;*/
	IF FOUND THEN
		RAISE WARNING 'AVISO: Este alumno ya está titulado en ese curso';
	RETURN NULL;
	END IF;
	RETURN NEW;
END; $$ LANGUAGE 'plpgsql';

DROP TRIGGER warning_alumno_titulado ON alumnos;
CREATE TRIGGER warning_alumno_titulado
	BEFORE INSERT OR UPDATE ON alumnos
	FOR EACH ROW EXECUTE PROCEDURE warning_alumno_titulado();

DELETE FROM alumnos;
INSERT INTO alumnos VALUES (1, 1, false); -- Ya titulado
INSERT INTO alumnos VALUES (2, 4, false); -- Ya titulado
INSERT INTO alumnos VALUES (2, 5, false);

SELECT id_empleado, A.id_edicion, id_curso FROM alumnos A JOIN ediciones E ON A.id_edicion=E.id_edicion;
SELECT * FROM ediciones;
SELECT * FROM empleado_titulado;



SELECT E.id_edicion, E.id_curso, C.id FROM ediciones E JOIN cursos C ON C.id = E.id_curso WHERE C.id = 1;





/********************************************************************************************************/
/* 4. Cuando un empleado es cualificado como apto en un curso, automáticamente se registra que está titulado 
 * para impartir ese curso */

---Hecho por mi---
CREATE OR REPLACE FUNCTION fempleadorecientitulado() RETURNS TRIGGER AS $$
DECLARE 
curso_aprobado int;
BEGIN
	PERFORM 1 FROM alumnos WHERE id_edicion=NEW.id_edicion AND id_empleado=NEW.id_empleado AND NEW.apto=true;
	IF FOUND THEN
		PERFORM 1 FROM empleado_titulado WHERE id_empleado=NEW.id_empleado;
			IF NOT FOUND THEN 
				SELECT id_curso INTO curso_aprobado FROM ediciones WHERE id_edicion=NEW.id_edicion;
				 INSERT INTO empleado_titulado values(NEW.id_empleado, curso_aprobado);
					RETURN NEW;
			END IF;
	END IF;
RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';


DROP TRIGGER empleadorecientitulado ON alumnos;

CREATE TRIGGER empleadorecientitulado
AFTER UPDATE OR INSERT ON alumnos
FOR EACH ROW 
EXECUTE PROCEDURE fempleadorecientitulado();

SELECT * FROM empleado_titulado;
SELECT * FROM alumnos;
SELECT * FROM empleados;

INSERT INTO alumnos VALUES(11,1,false);
UPDATE alumnos SET apto=TRUE WHERE id_edicion =1 AND id_empleado=11;

---Soluciones Alejandro----

DROP FUNCTION IF EXISTS registrar_titulado() CASCADE;
CREATE OR REPLACE FUNCTION registrar_titulado() RETURNS trigger AS $$
DECLARE
	id_curso_ ediciones.id_curso%type;
BEGIN
	IF (NEW.apto) THEN 
		SELECT id_curso INTO id_curso_ FROM ediciones WHERE id_edicion=NEW.id_edicion;
		-- Comprobamos si ya está titulado en el curso que acaba de aprobar
		PERFORM 1 FROM empleado_titulado 
				WHERE id_empleado=NEW.id_empleado AND id_curso=id_curso_;
		IF NOT FOUND THEN -- Si no lo está, lo añadimos
			INSERT INTO empleado_titulado SELECT NEW.id_empleado, id_curso_;
		END IF; -- Si insertamos sin comprobar, saltaría una excepción de PK duplicada que no queremos
	END IF;
	RETURN NEW;
END; $$ LANGUAGE 'plpgsql';

-- De modo más declarativo:
CREATE OR REPLACE FUNCTION registrar_titulado() RETURNS trigger AS $$
DECLARE
	id_curso_ ediciones.id_curso%type;
BEGIN
	IF (NEW.apto) THEN 
		SELECT id_curso INTO id_curso_ FROM ediciones WHERE id_edicion=NEW.id_edicion;
		INSERT INTO empleado_titulado SELECT NEW.id_empleado, id_curso_
			WHERE NOT EXISTS 
			(SELECT 1 FROM empleado_titulado 
				WHERE id_empleado=NEW.id_empleado AND id_curso=id_curso_);
	END IF;
	RETURN NEW;
END; $$ LANGUAGE 'plpgsql';

CREATE TRIGGER registrar_titulado
	AFTER UPDATE ON alumnos
	FOR EACH ROW EXECUTE PROCEDURE registrar_titulado();

SELECT * FROM alumnos;
SELECT * FROM empleado_titulado;
INSERT INTO alumnos VALUES (2, 5, false);
UPDATE alumnos SET apto=TRUE WHERE id_empleado=2 AND id_edicion=5;





/********************************************************************************************************/
/* 5. Trigger que impide matricular usuarios como aptos */

---Hechos por mi--
CREATE OR REPLACE FUNCTION fmatriculasinaptos() RETURNS TRIGGER AS $$
BEGIN
	IF (NEW.apto) THEN 
	RAISE EXCEPTION 'No se puede matricular los usuarios como aptos';
	END IF;
RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER matriculasinaptos
BEFORE INSERT ON alumnos
FOR EACH ROW 
EXECUTE PROCEDURE fmatriculasinaptos();

SELECT * FROM alumnos;
SELECT * FROM empleados;

INSERT INTO alumnos values(12,3,false);
UPDATE alumnos SET apto=TRUE WHERE id_edicion =3 AND id_empleado =12;
INSERT INTO alumnos values(13,3,true);


---Soluciones Alejandro---

CREATE OR REPLACE FUNCTION matricula_apto() RETURNS trigger AS $$
BEGIN
	IF (NEW.apto) THEN 
		RAISE EXCEPTION 'El alumno no puede matricularse como apto';
	END IF;
	RETURN NEW;
END; $$ LANGUAGE 'plpgsql';

CREATE TRIGGER matricula_apto
	BEFORE INSERT ON alumnos
	FOR EACH ROW EXECUTE PROCEDURE matricula_apto();

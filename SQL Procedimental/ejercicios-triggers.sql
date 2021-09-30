
/**************************************************************************************************
 *  Trigger que garantiza que un director pertenezca al departamento que dirije */


CREATE OR REPLACE FUNCTION fdirectordepartamento() RETURNS TRIGGER AS $$
DECLARE 
	dept_emp integer;
BEGIN 
	
	IF NEW.director IS NULL THEN RETURN NEW; END IF;

	SELECT departamento INTO dept_emp FROM empleados WHERE id=NEW.director;
	IF dept_emp <> NEW.num  THEN RAISE EXCEPTION 'Un director tiene que pertenercer su departamento.';
	ELSE RETURN NEW;
	END IF;
END; $$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS directordepartamento ON departamentos;
CREATE TRIGGER directordepartamento
BEFORE UPDATE ON departamentos
FOR EACH ROW EXECUTE PROCEDURE fdirectordepartamento();

---
SELECT * FROM departamentos;
SELECT * FROM empleados;

UPDATE departamentos SET director=11 WHERE num=6;
UPDATE departamentos SET director=6 WHERE num=6;
UPDATE departamentos SET director=NULL WHERE num=6;




/**************************************************************************************************
 *  Comprobar que el número total de horas que un empleado tiene asignadas a proyectos no supera las 40h */

DROP FUNCTION IF EXISTS fempleadosexplotados CASCADE;
CREATE OR REPLACE FUNCTION fempleadosexplotados() RETURNS TRIGGER AS $$
DECLARE 
	horas_max constant interval := '40h';
	horast interval;
BEGIN 
	SELECT sum(horas) INTO horast FROM proyectos_empleados WHERE empleado=NEW.empleado
		AND (fbaja IS NULL OR fbaja>current_date);
	/* Si se usa una excepción, el trigger puede ser AFTER, y de ese modo, horast ya es el resultado final */
	IF horast>horas_max THEN 
		RAISE EXCEPTION 'El empleado % está sobrecargado de trabajo', NEW.empleado;
	END IF;
	RETURN NEW;
END; $$ LANGUAGE plpgsql;

CREATE TRIGGER directordepartamento
AFTER INSERT OR UPDATE ON proyectos_empleados
FOR EACH ROW EXECUTE PROCEDURE fempleadosexplotados();


-- 
SELECT * FROM proyectos;
SELECT * FROM proyectos_empleados ORDER BY empleado, proyecto;
SELECT empleado, sum(horas) FROM proyectos_empleados WHERE (fbaja IS NULL OR fbaja>current_date) GROUP BY empleado;

DELETE FROM proyectos_empleados WHERE empleado=23;
INSERT INTO proyectos_empleados VALUES (10, 23, '35h', '2019-10-01', NULL); -- Suma 35. OK
INSERT INTO proyectos_empleados VALUES (11, 23, '10h', '2019-10-01', NULL); -- Suma 45. Salta la excepción

UPDATE proyectos_empleados SET horas='35h' WHERE proyecto=10 AND empleado=23;



/* Alternativa con BEFORE: */

DROP FUNCTION IF EXISTS fempleadosexplotados CASCADE;
CREATE OR REPLACE FUNCTION fempleadosexplotados() RETURNS TRIGGER AS $$
DECLARE 
	horas_max constant interval := '40h';
	horast interval;
	horas_old interval := '0'; -- Para INSERT, las horas previamente son 0
BEGIN
	SELECT sum(horas) INTO horast FROM proyectos_empleados WHERE empleado=NEW.empleado
		AND (fbaja IS NULL OR fbaja>current_date);
	/* Ahora "horast" no incluye la propia modificación que hace saltar el trigger
	 * Para contemplar el UPDATE, restamos las horas que había en la fila antes de la instrucción (OLD)
	 * y sumamos las nuevas. */
	IF TG_OP='UPDATE' THEN horas_old:=OLD.horas; END IF;
	IF horast-horas_old+NEW.horas>horas_max THEN 
		RAISE EXCEPTION 'El empleado % está sobrecargado de trabajo', NEW.empleado;
	END IF;
	RETURN NEW;
END; $$ LANGUAGE plpgsql;

CREATE TRIGGER directordepartamento
BEFORE INSERT OR UPDATE ON proyectos_empleados
FOR EACH ROW EXECUTE PROCEDURE fempleadosexplotados();


/* Alternativa con BEFORE, más declarativa: */

DROP FUNCTION IF EXISTS fempleadosexplotados CASCADE;
CREATE OR REPLACE FUNCTION fempleadosexplotados() RETURNS TRIGGER AS $$
DECLARE 
	horas_max constant interval := '40h';
	horast interval;
BEGIN
	SELECT sum(horas) INTO horast FROM proyectos_empleados WHERE empleado=NEW.empleado
		AND (fbaja IS NULL OR fbaja>current_date);
	/* Si es un INSERT, OLD será NULL y no queremos restar nada. Esto lo 
	 * podemos arreglar con un COALESCE que, si es NULL, devuelva o para ser restado */
	IF horast-COALESCE(OLD.horas,'0'::interval)+NEW.horas>horas_max THEN 
		RAISE WARNING 'El empleado % está sobrecargado de trabajo', NEW.empleado;
		RETURN NULL; -- Alternativa ignorando la acción para esa fila
	END IF;
	RETURN NEW;
END; $$ LANGUAGE plpgsql;

CREATE TRIGGER directordepartamento
BEFORE INSERT OR UPDATE ON proyectos_empleados
FOR EACH ROW EXECUTE PROCEDURE fempleadosexplotados();


-- 
SELECT * FROM proyectos;
SELECT * FROM proyectos_empleados ORDER BY empleado, proyecto;
SELECT empleado, sum(horas) FROM proyectos_empleados WHERE (fbaja IS NULL OR fbaja>current_date) GROUP BY empleado;

DELETE FROM proyectos_empleados WHERE empleado=23;
INSERT INTO proyectos_empleados VALUES (10, 23, '35h', '2019-10-01', NULL); -- Suma 35. OK
INSERT INTO proyectos_empleados VALUES (11, 23, '10h', '2019-10-01', NULL); -- Suma 45. Salta la excepción

UPDATE proyectos_empleados SET horas='41h' WHERE proyecto=10 AND empleado=23; -- Falla
UPDATE proyectos_empleados SET horas='40h' WHERE proyecto=10 AND empleado=23; -- Funciona 








/**************************************************************************************************
 * Garantizar que un empleado no se supervisa a sí mismo */





/**************************************************************************************************
 * Garantizar coherencia de familiares-empleados */


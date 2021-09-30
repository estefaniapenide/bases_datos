
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
 *  Comprobar que el nÃºmero total de horas que un empleado tiene asignadas a proyectos no supera las 40h */

DROP FUNCTION IF EXISTS fempleadosexplotados CASCADE;
CREATE OR REPLACE FUNCTION fempleadosexplotados() RETURNS TRIGGER AS $$
DECLARE 
	horas_max constant interval := '40h';
	horast interval;
BEGIN 
	SELECT sum(horas) INTO horast FROM proyectos_empleados WHERE empleado=NEW.empleado
		AND (fbaja IS NULL OR fbaja>current_date);
	--Creo que hay que diferenciar entre insert y update por las pruebas de abajo:
	IF TG_OP='INSERT' THEN
		IF (horast+NEW.horas)>horas_max THEN 
			RAISE WARNING 'El empleado % estÃ¡ sobrecargado de trabajo', NEW.empleado;
			RETURN NULL;
		END IF;
	END IF;
	IF TG_OP='UPDATE' THEN
		IF (horast-OLD.horas+NEW.horas)>horas_max THEN 
			RAISE WARNING 'El empleado % estÃ¡ sobrecargado de trabajo', NEW.empleado;
			RETURN NULL;
		END IF;
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

DELETE FROM proyectos_empleados WHERE empleado=23;--Borro los proyectos del empleado 3 para partir de cero
INSERT INTO proyectos_empleados VALUES (10, 23, '35h', '2019-10-01', NULL); -- Suma 35. OK
INSERT INTO proyectos_empleados VALUES (12, 23, '2h', '2019-10-01', NULL);--Más 2h en otro pryecto=37h en total
--Sin la modificación que propongo hay este problema:
UPDATE proyectos_empleados SET horas='30h' WHERE proyecto=10 AND empleado=23;--Si quiero cambiar las horas del prtoyecto 10, NO puedo, 
--cuando debería ya que el resultado FINAL NO superaría las 40h(con este cambio se quedaría en 32h totales).







/**************************************************************************************************
 * Garantizar coherencia de familiares-empleados */


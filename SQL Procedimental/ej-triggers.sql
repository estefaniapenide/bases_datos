
/* Trigger que garantiza que un director pertenezca al departamento que dirije */

--Como un director solo se puede asignar una vez se hayan hecho las inserciones de los departamentos y de 
--los empleados, el trigger s�lo saltar� en los update de la tabla departamentos 
--(no es necesario tener en cuenta las inserciones). Entiendo que el orden 1� insercion departamento sin director, 2� inserci�n
--empleado, 3� update de deparatmentos asignando director, deber�a gestionarse con procedimientos.

CREATE OR REPLACE FUNCTION fdirectordepartamento() RETURNS TRIGGER AS $$
DECLARE 
departamento_ integer;
BEGIN 
	
	IF NEW.director IS NULL THEN --Dejo la posibilidad de poder cambiar un director a null
		RAISE NOTICE 'Update realizado';
	  			RETURN NEW;
	ELSE

			SELECT e.departamento INTO departamento_ FROM empleados e
			LEFT JOIN departamentos d ON e.departamento=d.num
			WHERE e.id=NEW.director;

			IF departamento_ <> NEW.num  THEN 
	 			RAISE WARNING E'Un director tiene que pertenercer su departamento.\nNo se ha actualizado la tabla.';
					RETURN NULL;
		
			ELSEIF departamento_ = NEW.num THEN
	 			RAISE NOTICE 'Update realizado';
	  				RETURN NEW;
	  		
	  		END IF;
	 
	END IF;
END;
$$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS directordepartamento ON departamentos;

CREATE TRIGGER directordepartamento
BEFORE UPDATE ON departamentos
FOR EACH ROW 
EXECUTE PROCEDURE fdirectordepartamento();

---
SELECT * FROM departamentos;

UPDATE departamentos SET director=23 WHERE num=6;

CREATE OR REPLACE PROCEDURE asignaciondirectores() AS $$
BEGIN
END;
$$
LANGUAGE plpgsql;



/* Comprobar que el número total de horas que un empleado tiene asignadas a proyectos no supera las 40h */

--Funciones para comprobar las horas asignadas a cada empleado:

--Para un empleado concreto devuelve las horas asignadas y raise warning en caso de superarlas:
DROP FUNCTION IF EXISTS fempleadosexplotados();
CREATE OR REPLACE FUNCTION fempleadosexplotados(INOUT id_empleado int, 
												OUT horas_asignadas INTERVAL, 
												OUT horas_de_mas INTERVAL) 
AS $$
DECLARE 
limite INTERVAL:='40:00:00';
rec record;
BEGIN

		SELECT empleado, SUM(horas) AS horastotales INTO rec FROM proyectos_empleados
		WHERE empleado=id_empleado
		GROUP BY empleado;
	
		IF rec.horastotales IS NULL THEN
		RAISE NOTICE 'El empleado % no tiene horas asignadas.', id_empleado;
		
		ELSE
	
			horas_asignadas := rec.horastotales;
	
			IF rec.horastotales>limite THEN 
				horas_de_mas:= rec.horastotales-limite;
					RAISE NOTICE 'El empleado % tiene % horas asignadas.', rec.empleado, rec.horastotales;
					RAISE WARNING ' Est� trabajando % horas de m�s.', horas_de_mas;
			ELSE
				RAISE NOTICE 'El empleado % tiene % horas asignadas.',rec.empleado, rec.horastotales;
			END IF;	
		END IF;
	 
END;
$$
LANGUAGE plpgsql;


--Misma funci�n devolviendo todos los empelados que tienen asignadas horas de m�s, en caso de haberlos:
CREATE OR REPLACE FUNCTION fempleadosexplotados() 
RETURNS table(id_empleado SMALLINT,
			 horas_asignadas INTERVAL,
			 horas_de_mas interval)
AS $$
DECLARE
limite INTERVAL:='40:00:00';
rec record;
BEGIN
	FOR rec IN 
		SELECT empleado, SUM(horas) AS horastotales FROM proyectos_empleados
		GROUP BY empleado	
	LOOP	
		IF rec.horastotales>limite THEN 
			horas_de_mas:= rec.horastotales-limite;
				RAISE NOTICE 'El empleado % tiene % horas asignadas.', rec.empleado, rec.horastotales;
				RAISE WARNING ' Est� trabajando % horas de m�s.', horas_de_mas;
			RETURN query
			SELECT rec.empleado, rec.horastotales, horas_de_mas;
		END IF;	
	--En caso de no superar el l�mite de horas, devuelve una tabla vac�a.
	END LOOP;
END;
$$
LANGUAGE plpgsql;

--Comprobaciones:
SELECT * FROM fempleadosexplotados();
SELECT * FROM fempleadosexplotados(1);
SELECT * FROM fempleadosexplotados(23);
SELECT * FROM fempleadosexplotados(53);


--Trigger para evitar que se le asignen m�s de 40h a un empleado:
CREATE OR REPLACE FUNCTION flimitehoras() RETURNS TRIGGER AS $$
DECLARE
limite INTERVAL:='40:00:00';
rec record;
horas_totales INTERVAL;
BEGIN
	
	SELECT empleado, SUM(horas) AS horastotales INTO rec 
	FROM proyectos_empleados
	WHERE empleado= NEW.empleado
	GROUP BY empleado;
	
	IF TG_OP='UPDATE' THEN
	
		horas_totales:=rec.horastotales-OLD.horas+NEW.horas;	
	
		IF horas_totales>limite THEN 
			--Aunque las horas resultantes nuevas sean mayores de 40, si lo que se pretende es bajar el n�mero de horas asignadas, 
			--entonces lo permite.
				IF OLD.horas>NEW.horas THEN 
				--RAISE NOTICE 'UPDATE';
			RAISE NOTICE E'Al empleado % se le acaban de asignar % horas\nen el proyecto %.\nPasa a trabajar un total de % horas.',
				rec.empleado, NEW.horas, NEW.proyecto, horas_totales;
					RETURN NEW;
			--En cualquier otro caso, no se acepta el cambio.
				ELSE
				--RAISE NOTICE 'NO UPDATE';
				RAISE WARNING E'El empleado % no puede trabajar m�s de % horas.\nNo se han asigando las horas nuevas.',
				rec.empleado, limite;
					RETURN NULL;
				END IF;
		ELSE
			--RAISE NOTICE 'UPDATE';
			RAISE NOTICE E'Al empleado % se le acaban de asignar % horas\nen el proyecto %.\nPasa a trabajar un total de % horas.',
				rec.empleado, NEW.horas, NEW.proyecto, horas_totales;
					RETURN NEW;
		END IF;
	
	ELSEIF TG_OP='INSERT'THEN 
	
		horas_totales:=rec.horastotales+NEW.horas;
	
		IF horas_totales>limite THEN 
				--RAISE NOTICE 'NO INSERT';
				RAISE WARNING E'El empleado % no puede trabajar m�s de % horas.\nNo se han asigando las horas nuevas.',
				rec.empleado, limite;
					RETURN NULL;
		ELSE	
			--RAISE NOTICE 'INSERT';
			RAISE NOTICE E'Al empleado % se le acaban de asignar % horas\nen el proyecto %.\nPasa a trabajar un total de % horas.',
			NEW.empleado, NEW.horas, NEW.proyecto, horas_totales;
					RETURN NEW;
		END IF;

	END IF;

END;
$$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS limitehoras ON proyectos_empleados;

CREATE TRIGGER limitehoras
BEFORE UPDATE OR INSERT ON proyectos_empleados
FOR EACH ROW 
EXECUTE PROCEDURE flimitehoras();


--Procedimiento para asignar proyectos a empleados:

--Funci�n para saber si a un empleado ya le han asignado un determinado proyecto:
CREATE OR REPLACE FUNCTION proyectoyaasignadoaempleado(id_proyecto int, 
														id_empleado int) 
RETURNS INT														
AS $$
DECLARE 
rec record;
BEGIN 
	SELECT empleado, proyecto INTO rec
	FROM proyectos_empleados 
	WHERE empleado=id_empleado AND proyecto=id_proyecto;

	IF rec.empleado IS NULL OR rec.proyecto IS NULL THEN 
		RETURN NULL;
	ELSE 
		RETURN 1;
	END IF;
END;
$$
LANGUAGE plpgsql;

--Procedimiento para asignar proyectos a empleados:
DROP PROCEDURE IF EXISTS asignacionproyectosempleados;
CREATE OR REPLACE PROCEDURE asignacionproyectosempleados(id_proyecto int, 
														id_empleado int, 
														horas_asignadas interval) AS 
$$
DECLARE 

--nombre_proyecto proyectos.nombre%TYPE;
--fecha_de_inicio proyectos.fecha_inicio%TYPE := CURRENT_DATE;
--departamento_coordinador proyectos.dept_coord%TYPE;

fecha_incorporacion proyectos_empleados.fincorporacion%TYPE := CURRENT_DATE;
BEGIN 

	IF (SELECT id FROM proyectos WHERE id=id_proyecto) IS NULL THEN 
	RAISE WARNING'El proyecto % no existe.',id_proyecto;

	--RAISE NOTICE 'Se crea un proyecto con los valores por defecto.(Departamento 1)';
		--nombre_proyecto:='Proyecto '|| id_proyecto::VARCHAR(50);
		--departamento_coordinador:=1; --por ejemplo.
		--INSERT INTO proyectos VALUES (id_proyecto, nombre_proyecto, fecha_de_inicio, NULL, departamento_coordinador);
		--INSERT INTO proyectos_empleados VALUES(id_proyecto, id_empleado, horas_asignadas,fecha_incorporacion, NULL);	

	ELSEIF(SELECT id FROM empleados WHERE id=id_empleado) IS NULL THEN 
		RAISE WARNING 'El empleado % no existe.',id_empleado;
      
	ELSEIF proyectoyaasignadoaempleado(id_proyecto, id_empleado) = 1 THEN --Usando la funci�n creada m�s arriba, se sabe si hay que hacer un update o una inserci�n.
	 	UPDATE proyectos_empleados SET horas=horas_asignadas WHERE empleado=id_empleado AND proyecto=id_proyecto;
		--RAISE NOTICE 'Se han actualizado las horas del empleado % en el proyecto %.',id_empleado,id_proyecto;
	ELSE 
		--En fecha de incorporaci�n se a�aden valores por defecto para la fecha de incrporaci�n(actual) y la de baja(null).
		INSERT INTO proyectos_empleados VALUES(id_proyecto, id_empleado, horas_asignadas,fecha_incorporacion, NULL);
		--RAISE NOTICE 'Se han asiginado % horas al empleado % en el proyecto %.', horas_asignadas, id_empleado,id_proyecto;
	END IF;
END;
$$
LANGUAGE plpgsql;

--Comprobaciones:
SELECT * FROM proyectos_empleados;
CALL asignacionproyectosempleados(12,1,'5h');
SELECT * FROM fempleadosexplotados(1);

/*
--Trigger para asignar proyectos a empleados(no tiene mucho sentido)
DROP FUNCTION IF EXISTS fasignacionproyectosempleados;
CREATE OR REPLACE FUNCTION fasignacionproyectosempleados() RETURNS TRIGGER AS 
$$
BEGIN 
	
	PERFORM 1 FROM proyectos WHERE id=NEW.proyecto;
	IF NOT FOUND THEN 
	RAISE WARNING'El proyecto % no existe.',NEW.proyecto;
		RETURN NULL;
	END IF;
	
	PERFORM id FROM empleados WHERE id=NEW.empleado;
	IF NOT FOUND THEN 
		RAISE WARNING 'El empleado % no existe.',NEW.empleado;
		RETURN NULL;
	END IF;
    
	IF TG_OP='UPDATE' THEN
		PERFORM 1 FROM proyectos_empleados WHERE empleado=NEW.empleado AND proyecto=NEW.proyecto; 
			IF FOUND THEN
				RAISE NOTICE 'Se han actualizado las horas del empleado % en el proyecto %.',NEW.empleado,NEW.proyecto;
					RETURN NEW;
			END IF;
	END IF;

	IF TG_OP='INSERT' THEN
		PERFORM 1 FROM proyectos_empleados WHERE empleado=NEW.empleado AND proyecto=NEW.proyecto; 
			IF NOT FOUND THEN
				RAISE NOTICE 'Se han asiginado nuevas horas al empleado % en el proyecto %.',NEW.empleado,NEW.proyecto;
					RETURN NEW;
			END IF;
	END IF;
END;
$$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS asignacionproyectosempleados ON proyectos_empleados;

CREATE TRIGGER asignacionproyectosempleados
BEFORE UPDATE OR INSERT ON proyectos_empleados
FOR EACH ROW 
EXECUTE PROCEDURE fasignacionproyectosempleados();

UPDATE proyectos_empleados SET proyecto=10 WHERE empleado=1;*/


/* Trigger que garantiza coherencia de familiares-empleados */

-- Insertar un familiar: deber�a hacerse mediante un procedimiento que actualizase, 
--adem�s de la tabla de familiares, la NM de relaci�n con empleados. Las dos en una �nica 
--transacci�n.
CREATE OR REPLACE PROCEDURE insercionfamiliares(id familiares.id%type, 
												nif familiares.nif%type, 
												nombre familiares.nombre%type, 
												apellidos familiares.apellidos%type, 
												sexo familiares.sexo%TYPE DEFAULT null, 
												fnacimiento familiares.fnacimiento %TYPE
												id_empleado empleados.id%TYPE,
												parentesco familiares_emp.parentesco%type) AS $$
BEGIN 
	INSERT INTO familiares VALUES(id,nif,nombre,apellidos,sexo,fnacimiento);
	
END;
$$ LANGUAGE plpgsql;






























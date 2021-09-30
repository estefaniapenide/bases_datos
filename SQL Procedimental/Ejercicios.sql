
/* Mostrar la serie de fibonacci con WHILE (1a) y con FOR (1b) */



/* 1. Procedimiento que muestra la serie de fibonacci hasta un número dado */

create or replace procedure fibonacci(IN ultimo INT)
as $$
declare
   i integer := 0 ; 
   j integer := 1 ;
   suma integer;
begin
	if (ultimo < 1) then
	  raise notice 'Parámetro inválido: %', ultimo;
	else loop 
    	raise notice '%', i;
		suma := i + j ; 
		i:=j;
		j:=suma;
		exit when i > ultimo ; -- Condición de salida
	end loop;
	end if; 
end; $$ language plpgsql

call fibonacci(30);
call fibonacci(-3);
call fibonacci(1);


create or replace procedure fibonacci(IN ultimo INT)
as $$
declare
   i integer := 0 ; 
   j integer := 1 ;
   suma integer;
begin
	if (ultimo < 1) then
	  raise notice 'Parámetro inválido: %', ultimo;
	else 
		loop 
    		raise notice '%', i;
			suma := i + j ; 
			i:=j;
			j:=suma;
			exit when i > ultimo ; -- Condición de salida
		end loop;
	end if; 
end; $$ language plpgsql

call fibonacci(30);
call fibonacci(-3);
call fibonacci(1);


/* 2. Función que muestra la serie de fibonacci hasta un número dado y 
 * devuelve el último mostrado */

create or replace FUNCTION ffibonacci(IN ultimo INT)
RETURNS INT
as $$
declare
   i integer := 0 ; 
   j integer := 1 ;
   suma integer;
begin
	if (ultimo < 1) then
	  raise notice 'Parámetro inválido: %', ultimo;
	  RETURN NULL;
	else 
		loop 
    		raise notice '%', i;
			suma := i + j;
			i:=j;
			j:=suma;
			if suma > ultimo then
    			raise notice '%', i;
				return i;
			end if;
		end loop;
	end if; 
end; $$ language plpgsql

SELECT ffibonacci(30);
SELECT ffibonacci(-3);
SELECT ffibonacci(1);


/* 3. Función que muestra toda la serie de fibonacci en una sola línea hasta el
valor dado en función de un parámetro:
a- muestra la serie de fibonacci hasta un número dado y devuelve el último mostrado.
b- Si el valor no pertenece a la serie, muestra un error sugiriendo los valores 
anterior y posterior */

CREATE TYPE modo AS ENUM('A','B');

create or replace function ffibonacci(ultimo INT, modo modo='A')
RETURNS INT
as $$
declare
   i INT := 0 ; 
   j INT := 1 ;
   suma INT;
   mensaje VARCHAR(50) = '';
begin
	IF (ultimo IS NULL) then
	 raise exception 'Debe introducir un número' USING errcode='ERRO1';
	END if;
	if (ultimo<1) then
	  raise notice 'Parámetro inválido: %', ultimo;
	  RETURN NULL;
	end if;
	loop 
		suma := i + j ; 
		i:=j;
		j:=suma;
		exit when suma>ultimo;
    	mensaje := mensaje || ' ' || suma;
	end loop;
	if modo='B'AND i<>ultimo then
	  	raise exception 'Parámetro inválido: %.', ultimo
			-- USING hint='El número no pertenece a la serie, elija: '|| i || ' o ' || suma;
	  		USING errcode='ERRO2';
	else 
		raise notice '%', mensaje;
		RETURN i;
	end if;
	EXCEPTION 
		WHEN sqlstate '22001' THEN
			RAISE exception 'ERROR: El número introducido es demasiado largo'
				USING errcode='ERRO3';
end; $$ language plpgsql

SELECT ffibonacci(35, 'A');
SELECT ffibonacci(35, 'B');
SELECT ffibonacci(35);
SELECT ffibonacci(35, NULL);
SELECT ffibonacci(NULL, NULL);
SELECT ffibonacci(5000);
SELECT ffibonacci(35, 'C');



/**************************************************************************************/



/* 5. Función que busca un empleado por su nif y devuelve su salario.
 * Si no encuentra ese nif, muestra una excepción */

CREATE OR REPLACE FUNCTION busca_empleado(in_nif CHAR(9))
RETURNS NUMERIC(7,2) AS $$
declare
   salario_emp empleados.salario%type;
begin 
	IF NOT (SELECT validadni(in_nif)) THEN
  		RAISE EXCEPTION 'NIF no válido' USING errcode='ERRO1';
   END IF;
   select salario
   from empleados
   where nif=in_nif
   into salario_emp;
   IF NOT FOUND THEN 
  		RAISE EXCEPTION 'Empleado no encontrado' USING errcode='ERRO1';
   ELSE 
   		RETURN salario_emp;
   END IF;
end; $$ language plpgsql

SELECT busca_empleado('01999999A');
SELECT busca_empleado('ERRONEO');
SELECT busca_empleado('12345678Z');
SELECT busca_empleado('27694722P'); 



/* 6. Función sobrecargada que devuelve el número de proyectos de un departamento:
 * 6a. Recibiendo como parámetro el número de departamento.
 * 6b. Recibiendo como parámetro el número de departamento y una fecha. Contabilizando 
 * solo los proyectos con fecha de inicio posterior. */

CREATE OR REPLACE FUNCTION numProyectos(departamento INT, fecha date = '1900-01-01')
-- Si definimos un valor por defecto para la fecha, ya no necesitaríamos la primera función
RETURNS integer
AS $$
BEGIN 
	IF (departamento NOT IN (SELECT num FROM departamentos)) THEN
		RAISE EXCEPTION 'Departamento no existente' USING errcode='ERRO1';
	END IF;
	RETURN (SELECT count(id) FROM proyectos 
		WHERE dept_coord = departamento AND fecha_inicio > fecha);
END; $$ language plpgsql


SELECT numProyectos(1);
SELECT numProyectos(1, '2019-02-02');
SELECT numProyectos(9);



SELECT count(id) FROM proyectos 
    WHERE dept_coord = 1;







/* 7. Procedimiento que inserta un familiar, recibe los datos del familiar 
 * y el nif del empleado del que es familiar */

DROP PROCEDURE insert_familiar;
CREATE OR REPLACE PROCEDURE insert_familiar(
	nif_in familiares.nif%TYPE,
    nombre_in familiares.nombre%TYPE,
    apellidos_in familiares.apellidos%TYPE,
    sexo_in familiares.sexo%TYPE,
    fnacimiento_in familiares.fnacimiento%TYPE,
    nif_empleado_in empleados.nif%TYPE,
    parentesco_in familiares_emp.parentesco%TYPE)
AS $$
declare
	id_empleado empleados.id%TYPE;
	id_familiar familiares.id%TYPE;
begin
	CALL pvalidadni(nif_in);
	CALL pvalidadni(nif_empleado_in);
	SELECT id INTO id_empleado FROM empleados WHERE nif=nif_empleado_in;
	IF NOT FOUND THEN RAISE EXCEPTION 'DNI de empleado % no existente', nif_empleado_in; END IF;
	INSERT INTO familiares (nif, nombre, apellidos, sexo, fnacimiento) 
		VALUES (nif_in, nombre_in, apellidos_in, sexo_in, fnacimiento_in)
			 RETURNING id INTO id_familiar; -- Para recuperar la PK autogenerada de la fila recién creada
	INSERT INTO familiares_emp VALUES (id_empleado, id_familiar, parentesco_in); 
end; $$ language plpgsql


INSERT INTO empleados VALUES (70, '71446011F', 'Empleado70', 'Apellido70', 12345678970, 6000.11, 'HOMBRE', '1988-01-01', 1, 1, NULL);
CALL insert_familiar('27694722P', 'Familiar701', ' Apellido701', 'MUJER', '1988-01-14', '71446011F', 'ESPOSA');








/******************************************************************************
 * TODO
 * 
 */

CREATE TYPE jornada AS ENUM ('COMPLETA', 'MEDIA');

CREATE OR REPLACE FUNCTION jornada(IN id_empleado INT)
RETURNS jornada
	IF NOT FOUN





/* Creación de una columna jornada en la tabla empleados, 
 * infiriendo su valor de las horas trabajadas */
 */



do $$
begin
	ALTER TABLE empleados ADD COLUMN jornada jornada;
	INSERT INTO empleados (jornada) VALUES (
		SELECT )
	ALTER TABLE empleados MODIFY COLUMN jornada jornada NOT NULL;
end; $$

 
 
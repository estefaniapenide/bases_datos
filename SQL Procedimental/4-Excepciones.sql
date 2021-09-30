


/* no_data_found exception ******************************/


do $$ 
declare
   nif_emp empleados.nif%type;
   salario_emp empleados.salario%type;
begin 
   select nif, salario
   from empleados
   into STRICT nif_emp, salario_emp 
   where id=100;
   raise notice 'El empleado % cobra %€', nif_emp, salario_emp;
end; $$
/* Strict hace que salte un error en lugar de devolver NULL cuando la query no
devuelve filas */


/* Para capturar esa excepción: */

do $$ 
declare
   nif_emp empleados.nif%type;
   salario_emp empleados.salario%type;
begin 
   select nif, salario
   from empleados
   into STRICT nif_emp, salario_emp 
   where id=100;
   raise notice 'El empleado % cobra %€', nif_emp, salario_emp;
   exception -- catch exception
	   when no_data_found then 
	      raise notice 'No existe ese empleado';
end; $$



/* too_many_rows exception ******************************/

do $$ 
declare
   nif_emp empleados.nif%type;
   salario_emp empleados.salario%type;
begin 
   select nif, salario
   into STRICT nif_emp, salario_emp 
   from empleados
   where nombre LIKE 'Emp%';
   raise notice 'El empleado % cobra %€', nif_emp, salario_emp;
   exception -- catch exception
	   when too_many_rows then 
	      raise exception 'Más de un empleado con ese nombre';
end; $$



/* Gestión de varias excepciones ******************************/

do $$ 
declare
   rec record;
   in_salario numeric(7,2) := 1000.01;
begin 
   select nif, salario
   		into STRICT rec
   from empleados
   where salario=in_salario;
   raise notice 'El empleado % cobra %€', rec.nif, rec.salario;
   exception -- se puden definir también por su sqlstate
   	   when no_data_found then -- when sqlstate 'P0002' then 
	      raise notice 'No existe ese empleado';
	   when sqlstate 'P0003' then -- when too_many_rows then 
	      raise notice 'Más de un empleado con ese nombre';
	   when others then -- Cualquier otra excepción
	      raise notice 'capachao?';
end; $$


-- https://www.postgresql.org/docs/current/errcodes-appendix.html



CREATE OR REPLACE FUNCTION convert_to_integer(v_input text)
RETURNS INTEGER AS $$
DECLARE v_int_value INTEGER DEFAULT NULL;
BEGIN
     v_int_value := v_input::INTEGER;
	EXCEPTION WHEN sqlstate '22P02' THEN -- Para gestionar si el casteo no se lleva a cabo
        RAISE NOTICE 'Invalid integer value: "%".  Returning NULL.', v_input;
        RETURN NULL;
RETURN v_int_value;
END;
$$ LANGUAGE plpgsql;

select convert_to_integer('1234');
select convert_to_integer('');
select convert_to_integer('chicken');



/* EXCEPCIONES DEFINIDAS **********************************************************************/


CREATE OR REPLACE FUNCTION f_lanza_excepciones(modo int)
RETURNS VARCHAR(50) AS $$
BEGIN
	CASE modo
		-- El modo 0 simula que no saltan excepciones
		WHEN 0 THEN RETURN 'Todo ha salido bien';
		/* El resto de valores lanzan alguna excepción definida
por un código de 5 caracteres */
		WHEN 1 THEN RAISE EXCEPTION 'Error 1' USING errcode='ERRO1';
		WHEN 2 THEN RAISE EXCEPTION USING errcode='ERRO2';
		WHEN 3 THEN RAISE EXCEPTION 'Error3' USING HINT='Error no capturable, el mensaje se muestra como llega';
		ELSE RAISE EXCEPTION USING errcode='ERRO0';
	END CASE;
END; $$ LANGUAGE plpgsql;


/* Bloque que simula el funcionamiento de una capa superior (por ejemplo, una aplicación Java que 
se conecte a la BBDD para ejecurar la función previa) donde se puede capturar las excepciones
definidas (catch) para procesarlas */
do $$
declare
	modo int = 3;
	resultado VARCHAR(50);
begin
	SELECT * INTO resultado
	FROM f_lanza_excepciones(modo);
	RAISE NOTICE 'Mensaje recibido: %', resultado;
    EXCEPTION
    	WHEN sqlstate 'ERRO1' THEN RAISE NOTICE 'Ha pasado el error 1';
    	WHEN sqlstate 'ERRO2' THEN RAISE NOTICE 'Ha pasado el error 2';
    	-- WHEN sqlstate 'ERRO3' THEN RAISE NOTICE 'Ha pasado el error 3';
    	WHEN sqlstate 'ERRO0' THEN RAISE NOTICE 'Ha pasado otra cosa';
end; $$




/* EXCEPCIONES DEFINIDAS 2 **********************************************************************/



create or replace FUNCTION f1(nombre_in VARCHAR(50))
RETURNS INT
language plpgsql
as 
$$
DECLARE
	id_seleccionado INT;
BEGIN
	-- RAISE NOTICE '%', nombre_in;
	SELECT id FROM empleados WHERE nombre=nombre_in
 		INTO id_seleccionado;
	RETURN id_seleccionado;
	EXCEPTION
		WHEN no_data_found THEN
			RAISE NOTICE 'DATA NOT FOUND';
	   when others then 
	      raise exception 'No existe ese empleado en f2';
	     RETURN 0;
end; $$


create or replace FUNCTION f2(nombre_in VARCHAR(50))
RETURNS INT
language plpgsql
as 
$$
DECLARE
	id_recibido INT;
BEGIN
	-- ... hacemos cosas
	id_recibido := f1(nombre_in);
	RETURN id_recibido;
	-- ...

end; $$



do $$ -- bloque anónimo
DECLARE
	id_buscado INT;
begin
	id_buscado := f2('Empleado0');
	RAISE NOTICE 'ID devuelta a BA: %', id_buscado;
	EXCEPTION
		WHEN no_data_found THEN
			RAISE NOTICE 'DATA NOT FOUND';
	   when others then 
	      raise notice 'No existe ese empleado en bloque anónimo';
end $$;



/* EXCEPCIONES DEFINIDAS 2 **********************************************************************/

DROP FUNCTION f1;
create or replace FUNCTION f1(id_in empleados.id%TYPE)
RETURNS empleados.salario%type as $$
DECLARE
   salario_ empleados.salario%type;
begin 
   select salario from empleados where id=id_in
   		into salario_;
   IF NOT FOUND THEN -- Comprueba si el select anterior devuelve alguna fila
    	RAISE EXCEPTION 'Empleado no encontrado' USING errcode='ERRO1';
   ELSE 
   		raise notice 'El empleado % cobra %€',id_in, salario_;
   		RETURN salario_;
   END IF;
end; $$ language plpgsql


---- 

CREATE OR REPLACE PROCEDURE metodo_superior(id_in INT)
as $$
DECLARE
	var_salario NUMERIC(7,2);
BEGIN
	-- 
	SELECT f1(id_in) INTO var_salario;
	raise notice 'La llamada a la función f1 devolvió %', var_salario;
	 EXCEPTION
	 	WHEN SQLSTATE 'ERRO1' THEN 
	  		RAISE NOTICE 'Empleado no existe';
	  	WHEN OTHERS THEN 
	  		RAISE NOTICE 'Otro error';
end; $$ language plpgsql


CALL metodo_superior(100);





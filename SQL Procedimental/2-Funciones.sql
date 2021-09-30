
/** Parámetros *********************************************************************/


create or replace procedure phola(nombre_in VARCHAR(50)) 
-- Los parámetros por defecto son de entrada (IN)
as $$
BEGIN
	nombre_in := 'Pepe';
	raise notice 'hola %', nombre_in;
end; $$ 
language plpgsql

call phola('Alejandro');

create or replace procedure phola(IN nombre_in VARCHAR(50))
as $$
BEGIN
	nombre_in := 'Pepe';
	raise notice 'hola %', nombre_in;
end; $$
language plpgsql

call phola('Alejandro');


create or replace function fhola(nombre_in VARCHAR(50))
returns VARCHAR(50)
language plpgsql
as $$
begin
	return ('hola '|| nombre_in);
end $$;

SELECT fhola('Alejandro');


create or replace function fnum_empleados()
returns INT
language plpgsql
as $$
declare
  num_empleados integer := 0;
begin
   select count(*) 
   into num_empleados
   from empleados;
   raise notice 'El número de empleados es %', num_empleados;
   return num_empleados;
end; $$

SELECT fnum_empleados();



CREATE OR REPLACE FUNCTION random_between(low INT, high INT) 
   RETURNS INT AS
$$
BEGIN
	IF low IS NULL OR high IS NULL 
		THEN RAISE EXCEPTION 'Inputs cannot be NULL';
   	ELSE
   		RETURN floor(random() * (high-low + 1) + low);
  	END IF;
END;
$$ language 'plpgsql';
/* STRICT garantiza que, si algún parámetro es NULL, la función devuelve directamente 
NULL sin ejecutarse, mejorando el rendimiento */

SELECT random_between(1,10);
SELECT random_between(1,NULL);

DO $$
BEGIN
	RAISE NOTICE 'Número aleatorio: %', random_between(1, NULL);
	EXCEPTION
		WHEN OTHERS THEN
			RAISE NOTICE 'Inputs cannot be NULL';
END; $$



/* Una función puede no tener un RETURN si, en cambio, 
 * tiene parámtros OUT o INOUT */
DROP FUNCTION f_sal_max_min_avg(int);
create or replace function f_sal_max_min_avg (
    inout min_sal int,
    out max_sal int,
    out avg_sal numeric) 
language plpgsql
as $$
begin
  select -- min(salario),
         max(salario),
		 avg(salario)::NUMERIC(7,2)
  into  max_sal, avg_sal
  from empleados;
end;$$

SELECT f_sal_max_min_avg();
SELECT * FROM f_sal_max_min_avg(1000);


/******************************************************************
 * PARÁMETROS DE SALIDA */


DROP FUNCTION f_sal_max_min_avg();
create or replace function f_sal_max_min_avg (
            OUT minimo NUMERIC(7,2),
            OUT maximo NUMERIC(7,2),
            OUT media NUMERIC(7,2))
as $$
DECLARE
    rec record;
begin
  select min(salario),
         max(salario),
         avg(salario)::NUMERIC(7,2)
  from empleados
    INTO minimo,maximo,media;
end;$$ language plpgsql

SELECT f_sal_max_min_avg();
SELECT * FROM f_sal_max_min_avg();



SELECT f_sal_max_min_avg();
SELECT * FROM f_sal_max_min_avg() 
    AS f(min NUMERIC(7,2),max NUMERIC(7,2),avg NUMERIC(7,2));
DROP FUNCTION f_sal_max_min_avg();
create or replace function f_sal_max_min_avg ()
RETURNS record
language plpgsql
as $$
DECLARE
    rec record;
begin
  select min(salario)::NUMERIC(7,2),
         max(salario)::NUMERIC(7,2),
         avg(salario)::NUMERIC(7,2)
  from empleados
    INTO rec;
 RETURN rec;
end;$$

SELECT f_sal_max_min_avg();
SELECT * FROM f_sal_max_min_avg() 
    AS f(min NUMERIC(7,2),max NUMERIC(7,2),avg NUMERIC(7,2));



create or replace function swap(
	inout x int,
	inout y int
) 
language plpgsql	
as $$
begin
   select x,y into y,x;
end; $$;

SELECT swap(1,2);
select * from swap(10,20);



/** Sobrecarga de funciones ***************************************************************/

create or replace function fsobrecarga(nombre1 varchar(50) )
returns varchar(50)
language plpgsql	
as $$
begin
   return concat('hola ', nombre1);
end; $$;




create or replace function fsobrecarga(nombre1 varchar(50), nombre2 varchar(50))
returns varchar(50)
language plpgsql	
as $$
BEGIN
	IF nombre2 IS NULL THEN
   		return concat('hola ', nombre1);
   	ELSE
   		return concat('hola ', nombre1, ' y ', nombre2);
   	END IF;
end; $$;


SELECT fsobrecarga('Alejadnro');
SELECT fsobrecarga('Alejadnro', 'María');
SELECT fsobrecarga('Alejadnro', NULL);


create or replace function fsobrecarga(nombre1 varchar(50),
		nombre2 varchar(50))
returns varchar(50)
language plpgsql	
as $$
begin
   return concat('hola ', nombre1, ' y ', nombre2);
end; $$;


/* Parámetros con valor por defecto: */
-- create or replace function fsobrecarga(i int, j int = 2)
create or replace function fsobrecarga(i int, j int default 2)
returns varchar(50)
language plpgsql	
as $$
begin
   return concat('números: ', i, ' y ', j);
end; $$;

SELECT fsobrecarga('Alejandro');
SELECT fsobrecarga('Alejandro', 'María');
SELECT fsobrecarga(NULL);
SELECT fsobrecarga(0);
SELECT fsobrecarga(1, 3);
SELECT fsobrecarga(NULL, NULL);
SELECT fsobrecarga('Alejandro', 3);




/** Devolver una tabla (ResultSet) ***************************************************************/

drop function get_empleados_patron(varchar);
create or replace function get_empleados_patron (
  patron varchar
) 
	returns table (
		nif_emp empleados.nif%type,
		nombre_emp empleados.nombre%type,
		apellidos_emp empleados.apellidos%type
	) 
as $$
begin
	return query 
		select nif, nombre, apellidos
		FROM empleados
		WHERE apellidos LIKE patron;
end;$$ language plpgsql


SELECT * FROM get_empleados_patron('Dir%');


CREATE OR REPLACE FUNCTION get_sedes_superf(superf int)
  RETURNS setof sedes AS -- Define la tabla que devuelve con el formato de una ya existente.
$func$
BEGIN
RETURN QUERY EXECUTE
format('select *
		FROM sedes
		WHERE superficie>%s', superf);
END
$func$  LANGUAGE plpgsql;

SELECT * FROM get_sedes_superf(100);

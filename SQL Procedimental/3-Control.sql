/* https://www.postgresql.org/docs/current/plpgsql-control-structures.html */



/*****************************************************************************
** IF ***********************************************************************/


CREATE OR REPLACE function mayor (a INT, b INT)
RETURNS INT
language plpgsql
as $$
BEGIN
    IF a>b THEN 
   		RETURN a;
    ELSEIF b>a THEN 
   		RETURN b;
    ELSE 
    	RETURN NULL;
    END IF;
end; $$ STRICT 

SELECT mayor(2,NULL);
SELECT mayor(2,2);
SELECT mayor(2,3);


CREATE OR REPLACE function mayor (
	IN a INT, IN b INT)
RETURNS INT
as $$
BEGIN
    IF a>b THEN 
   		RETURN a;
    ELSEIF b>a THEN 
   		RETURN b;
    ELSE 
    	RETURN NULL;
    END IF;
end; $$ language plpgsql


do $$ 
DECLARE
   id_emp constant empleados.id%TYPE := 100;
   nif_emp empleados.nif%type;
begin 
   select nif from empleados where id=id_emp
   into nif_emp;
   IF NOT FOUND THEN -- Comprueba si el select anterior devuelve alguna fila
    	RAISE EXCEPTION 'Empleado no encontrado';
   ELSE 
   		raise notice 'El empleado % tiene como nif %',id_emp, nif_emp;
   END IF;
end; $$


/*****************************************************************************
** CASE ***********************************************************************/

/* Ver el uso de case dentro de consultas en las consultas 145 y 146 */

CREATE OR REPLACE function numero_to_letra(
	IN num INT)
RETURNS VARCHAR(50)
as $$
declare 
   uno constant VARCHAR(50) := 'Uno';
   dos constant VARCHAR(50) := 'Dos';
   tres constant VARCHAR(50) := 'Tres';
   otro constant VARCHAR(50) := 'Número no registado';
BEGIN
	CASE num WHEN 1 THEN RETURN uno; -- El uso del punto y coma cambia al usarlo en procedimental
		 	 WHEN 2 THEN RETURN dos;
		 	 WHEN 3 THEN RETURN tres;
		 	ELSE RETURN otro;
	END CASE;
	-- O también:
/*	CASE WHEN num=1 THEN RETURN uno;
		 WHEN num=2 THEN RETURN dos;
		 WHEN num=3 THEN RETURN tres;
		 ELSE RETURN otro;
	END CASE;*/
end; $$ language plpgsql


SELECT numero_to_letra(2);



/*****************************************************************************
** BUCLES **********************************************************************
*/

do $$ -- muestra la serie de fibonacci hasta la variable "ultimo"
declare
   ultimo constant int :=9;
   i integer := 0; 
   j integer := 1;
   suma integer;
BEGIN
	raise notice '--';
	if (ultimo>0) then
	loop -- Ejecuta un bucle infinito
		raise notice '%', i;
		suma := i+j ; 
		i:=j;
		j:=suma;
		-- exit when i>ultimo; -- Condición de salida
		if suma > ultimo then exit; end if; -- Equivalente
	end loop;
	end if; 
end; $$


do $$
declare
   ultimo constant int :=6;
   i integer := 0; 
   j integer := 1;
   suma integer;
BEGIN
	raise notice '--';
	if (ultimo>0) then
	WHILE i<=ultimo loop
    	raise notice '%', i;
		suma := i + j; 
		i:=j;
		j:=suma;
	end loop;
	end if; 
end; $$


do $$
declare 
   counter integer := 0;
begin
   while counter < 5 loop
      raise notice 'Contador %', counter;
	  counter := counter + 1;
   end loop;
end$$;

do $$
begin
   for counter in 1..5 loop
	raise notice 'Contador: %', counter;
   end loop;
end; $$

do $$
begin
   for counter in reverse 5..1 loop -- Orden invertido
      raise notice 'Contador: %', counter;
   end loop;
end; $$

do $$
begin 
  for counter in 1..6 by 2 loop -- De 2 en 2
    raise notice 'counter: %', counter;
  end loop;
end; $$


do $$
declare
  -- Variables de entrada
   end_i int = 5;
   end_j int = 3;
  -- Contadores
   i int = 0;
   j int = 0;
begin
  <<outer_loop>>
  for i in 1..6 loop
     for j in 1..6 loop
		if i=end_i AND j=end_j THEN 
			EXIT;
		end if;
		raise notice '(i,j): (%,%)', i, j;
	 end loop;
  end loop;
end; $$


do $$
declare
  -- Variables de entrada
  no_mostrar_i int = 2;
  no_mostrar_j int = 2;
  -- Contadores
   i int = 0;
   j int = 0;
begin
  <<outer_loop>>
  for i in 1..4 loop
     for j in 1..4 loop
        if i=no_mostrar_i AND j=no_mostrar_j THEN CONTINUE; end if;
		-- CONTINUE WHEN i=no_mostrar_i AND j=no_mostrar_j;
		raise notice '(i,j): (%,%)', i, j;
	 end loop;
  end loop;
end; $$




/*  Iterando sobre varias filas de una consulta */
do
$$
declare
	rec record; /* Permite declarar una fila sin especificar tipos */
begin
	FOR rec IN 
		select nif, nombre, apellidos from empleados
			where salario > 2000
	loop
		raise notice '% % %', rec.nif, rec.nombre, rec.apellidos;
	END LOOP;
end;
$$
language plpgsql;



do $$
declare
	rec record;
begin
	for rec in -- bucle for; para cada fila recuperada de la siguiente consulta
		(select *   -- Recuperamos un listado de records
	    from empleados
   		where salario>6000)
	loop -- y en bucle, para cada uno, sacamos un mensaje
		raise notice '% (%)', rec.nif, rec.salario;	
	end loop;
end;
$$








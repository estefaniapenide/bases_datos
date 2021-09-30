
/* 
Extensi√≥n procedimental de SQL:
Primero aparece PL/SQL de Oracle, en el que se basa el est√°ndar 
SQL/PSM(SQL/Persistent Stored Modules) de ISO
Postgres incorpora PL/pgSQL, basado en PL/SQL y muy parecido a este.

https://www.postgresql.org/docs/current/plpgsql.html
https://www.postgresqltutorial.com/postgresql-plpgsql/
*/




/** Ejemplos b√°sicos: ***************************************************************/

create or replace procedure pholamundo() -- Procedimiento almacenado
language plpgsql
as 
$$ -- Delimitador, indica donde empieza y termina el cuerpo del procedimiento o funci√≥n
begin
	RAISE NOTICE 'Mi primer procedimiento almacenado en PL/pgSQL';
end; $$

call pholamundo(); -- Llamada al procedimiento


create or replace function fholamundo() -- Funci√≥n
returns VARCHAR(50) AS $$
begin
	RAISE NOTICE 'Mi primer procedimiento almacenado en PL/pgSQL';
	RETURN 'Mi primera funci√≥n en PL/pgSQL' AS saludo;
end; $$
language plpgsql;

SELECT fholamundo();

--Pruebas hechas por mi--
CREATE OR REPLACE PROCEDURE pholamundo()
LANGUAGE plpgsql
AS 
$$
BEGIN 
	RAISE NOTICE 'Hola mundo';
END; $$

CALL pholamundo();

CREATE OR REPLACE FUNCTION fholamundo()
RETURNS VARCHAR(50)
LANGUAGE plpgsql
AS $$
BEGIN
	RAISE NOTICE 'Hola mundo';
	RETURN 'Hola mundo en return' AS elreturn;
END;$$

SELECT fholamundo();



/** Estructura ***********************************************************************/

CREATE or replace FUNCTION somefunc() RETURNS integer AS $$
<< outerblock >>
DECLARE -- declaraci√≥n de variables
    quantity integer := 30;
   	var_1declaracion integer := 10;
BEGIN
    RAISE NOTICE 'Quantity here is %', quantity;  -- Prints 30
    quantity := 50;
    --
    -- Create a subblock
    --
    DECLARE
        quantity integer := 80;
    BEGIN
        RAISE NOTICE 'Quantity here is %', quantity;  -- Prints 80
        RAISE NOTICE 'Outer quantity here is %', outerblock.quantity;  -- Prints 50
        RAISE NOTICE 'var_1decalracion here is %', var_1declaracion;  -- Prints 50
    END;

    RAISE NOTICE 'Quantity here is %', quantity;  -- Prints 50

    RETURN quantity;
END;
$$ LANGUAGE plpgsql;


SELECT somefunc();

--Pruebas hechas por mi--
CREATE OR REPLACE FUNCTION fbloques() RETURNS integer AS $$
<<bloquedefuera>>
DECLARE 
 cantidad integer:=23;
 otracantidad integer:=12;
BEGIN
	RAISE NOTICE 'El bloque de fuera devuelve la cantidad %', cantidad;
	cantidad:=104;
	
	DECLARE
	cantidad integer :=40;
	BEGIN
		RAISE NOTICE 'La cantidad de este bloque es %',cantidad;
		RAISE NOTICE 'La cantidad del bloque de fuera es % porque se modificÛ.', bloquedefuera.cantidad;
		RAISE NOTICE 'El valor de la variable que se definiÛ fuera y no se repitiÛ su nombre es %',otracantidad;
	
	END;
	
	RAISE NOTICE 'El bloque de fuera ahora devuleve la cantidad %',cantidad;

	RETURN cantidad;
END; 
$$ LANGUAGE plpgsql;

SELECT fbloques();



/** Bloque an√≥nimo ***********************************************************************/

do $$ 
<<bloque_anonimo>>
declare
  num_empleados integer;
  sal_max NUMERIC(7,2);
begin
   select count(*), max(salario)
   into num_empleados, sal_max -- Insertando valores devueltos por un select en variables
   from empleados;
   raise notice E'N√∫mero de empleados: %\nSalario: %',
  			num_empleados, sal_max;
end bloque_anonimo $$;
/* La E antes de un literal se utiliza para mostrar caracteres extendidos; en este
 * caso, para poder incluir un salto de l√≠nea */

--Pruebas hechas por mi--
DO $$
<<bloqueanonimo>>
DECLARE 
numero_empleados integer;
salario_medio numeric(7,2);
BEGIN
	SELECT count(*), avg(salario) INTO numero_empleados, salario_medio
	FROM empleados;
	RAISE NOTICE 'La empresa tiene % empleados y con un salario medio de % Ä.', numero_empleados, salario_medio;
END $$;


/** Equivalentes: ***********************************************************************/

create or replace FUNCTION num_empleados()
RETURNS void
language plpgsql
as $$
declare
  num_empleados integer := 0;
begin
   select count(*) 
   into num_empleados
   from empleados;
   raise notice 'El n√∫mero de empleados es %', num_empleados;
end; $$

select num_empleados();


create or replace procedure pnum_empleados()
language plpgsql
as $$
declare
  num_empleados integer := 0;
begin
   num_empleados := (select count(*) from empleados); -- Otro modo de hacerlo
   raise notice 'El n√∫mero de empleados es %', num_empleados;
end; $$

call pnum_empleados();

--Pruebas hechas por mi--
CREATE OR REPLACE FUNCTION fnumeroempleados() RETURNS void
LANGUAGE plpgsql
AS 
$$
DECLARE 
num_empleados integer;
BEGIN
	SELECT count(*) INTO num_empleados 
	FROM empleados;
	RAISE NOTICE 'En la empresa hay % empleados', num_empleados;
	
END;
$$

CREATE OR REPLACE PROCEDURE pnumeroempleados()
LANGUAGE plpgsql
AS 
$$
DECLARE 
num_empleados integer;
BEGIN
	SELECT count(*) INTO num_empleados 
	FROM empleados;
	RAISE NOTICE 'En la empresa hay % empleados', num_empleados;
	
END;
$$

SELECT fnumeroempleados();
CALL pnumeroempleados();

/** Variables **********************************************************************/

do $$ 
declare
   counter    integer := 1;
   first_name varchar(50) := 'John';
   last_name  varchar(50) := 'Doe';
   payment    numeric(11,2) := 20.5;
begin 
   raise notice '% % % has been paid % USD', 
       counter, first_name, last_name, payment;
end $$;

--Pruebas hechas por mi --
DO
$$
DECLARE
id integer:=12;
nombre varchar(50):='Antonio';
apellidos varchar(50):='Gonz·lez Castro';
salario numeric(7,2):=1000.45;
BEGIN
	RAISE NOTICE 'El empleado con id %, % %, tiene un salario de % Ä.', id, nombre, apellidos, salario;
end$$;


/** Record *************************************************************************/

do $$
declare
	rec record; /* Permite declarar una fila sin especificar tipos */
begin
	select nif, nombre, apellidos
	into rec
	from empleados
	where id = 2;
	raise notice '% % %', rec.nif, rec.nombre, rec.apellidos;
end;
$$
language plpgsql;

--Pruebas hechas por mi --
DO
$$
DECLARE 
rec record;
BEGIN
	SELECT nif, nombre, apellidos, salario INTO rec 
	FROM empleados;
	RAISE NOTICE 'El empleado con NIF %, % %, tiene un salario de % Ä.', rec.nif, rec.nombre, rec.apellidos,rec.salario;
END $$;
LANGUAGE plpgsql;



/** Lectura de tipos de una tabla ***************************************************/

do $$ 
declare
   nif_emp empleados.nif%type; -- Declara una variable con el tipo de una columna
   salario_emp empleados.salario%type;
begin 
   select nif, salario from empleados
   		into nif_emp, salario_emp
   where id=100;
   raise notice 'El empleado % cobra %', nif_emp, salario_emp;
end; $$

do $$
declare
   empleado empleados%rowtype; -- Declaraci√≥n de fila completa de una tabla con sus tipos
begin
   select * from empleados where id=1
   		into empleado;
   raise notice 'El nombre del empleado es % %',
      empleado.nombre,
      empleado.apellidos;
end; $$

--Pruebas hechas por mi--

DO
$$
DECLARE
nif_ empleados.nif%TYPE;
nombre_ empleados.nombre%TYPE;
apellidos_ empleados.apellidos%TYPE;
salario_ empleados.salario%TYPE;
BEGIN
	SELECT nif, nombre, apellidos, salario INTO nif_, nombre_, apellidos_, salario_
	FROM empleados
	WHERE id=24;
	RAISE NOTICE 'El empleado con NIF %, % %, tiene un salario de % Ä.', nif_, nombre_, apellidos_, salario_;
end$$;

DO
$$
DECLARE
empleados_ empleados%rowtype;
BEGIN
	SELECT * INTO empleados_
	FROM empleados
	WHERE id=24;
	RAISE NOTICE 'El empleado con NIF %, % %, tiene un salario de % Ä.', empleados_.nif, empleados_.nombre, empleados_.apellidos, empleados_.salario;
end$$;


/** Constantes *********************************************************************/

do $$ 
declare
   iva constant numeric := 0.21; -- Constante
   precio		numeric := 10;
BEGIN
   raise notice 'El pvp es %', precio * ( 1 + iva );
end $$;


-- Funci√≥n que recibe un precio y lo devuelve sum√°ndole un IVA fijo
DROP function if exists pvp(numeric);
create or replace function pvp(precio numeric(7,2))
returns numeric(7,2)
language plpgsql
as $$
declare
   iva constant numeric := 0.21; -- Constante
begin
   return precio*(1+iva);
end $$;

select pvp(10.00);


--Pruebas hechas por mi--
DO
$$
DECLARE
iva constant numeric(3,2):=0.21;
precio numeric(7,2):=12;
solucion numeric(7,2);
BEGIN
	precio:=24;
	solucion:=precio*(1+iva);
	RAISE NOTICE 'El pvp del artÌculo es de % Ä',solucion;
end$$;

CREATE OR REPLACE FUNCTION fpvp(precio NUMERIC(7,2)) RETURNS numeric(7,2)
LANGUAGE plpgsql
AS 
$$
DECLARE
iva constant numeric(3,2):=0.21;
solucion numeric(7,2);
BEGIN
	solucion:=precio*(1+iva);
	RAISE NOTICE 'El pvp del artÌculo es de % Ä',solucion;
		RETURN solucion;
end;
$$

SELECT fpvp(12.7);


/** PERFORM ************************************************************************/

CREATE FUNCTION hola_void(nombre_in VARCHAR(50)) RETURNS void AS $$
    BEGIN
		raise notice 'hola %', nombre_in;
    END;
$$ LANGUAGE plpgsql;

SELECT hola_void('Alejandro');
PERFORM hola_void('Alejandro');

DROP FUNCTION foo;
CREATE OR REPLACE FUNCTION foo()
RETURNS int AS $$
BEGIN
  RAISE NOTICE 'Hello from void function';
 	RETURN 1;
END;
$$ LANGUAGE plpgsql;

SELECT foo(); -- Para una llamada directa, se usa SELECT (aunque no devuelve nada)
PERFORM foo();

-- in PLpgSQL
DO $$
DECLARE
	var int;
BEGIN
  SELECT foo() INTO var; 
  --PERFORM foo(); -- Desde dentro de otra rutina, se utiliza perform
END;
$$;

-- https://www.postgresql.org/docs/13/plpgsql-statements.html
-- https://stackoverflow.com/questions/42920998/pl-pgsql-perform-vs-execute





/**************************************************************************
 * MENSAJES **************************************************************/

do $$ 
begin 
  raise info 'information message %', now() ;
  raise log 'log message %', now(); -- No se muestra al cliente
  raise debug 'debug message %', now();  -- No se muestra al cliente
  raise warning 'warning message %', now();
  raise notice 'notice message %', TO_CHAR(now(), 'DD-MM-YYYY HH24:MI');
end $$;
/* Para modificar los niveles que se muestran, deben configurarse los par√°metros de
 * configuraci√≥n client_min_messages y log_min_messages */



/**************************************************************************
 * ASSERT **************************************************************
 * Instrucci√≥n para depurar */


do $$
declare 
   num_dep integer;
begin
   select count(*) into num_dep from departamentos d2;
   assert num_dep>7, 'No hay suficientes departamentos';
end$$;
 
 
 
 
 
 
/**************************************************************************
 * STRICT ***************************************************************/
 
 
DROP INDEX IF EXISTS empleados_nss_key; 
 
DROP FUNCTION IF EXISTS fprueba1_strict;
CREATE OR REPLACE function fprueba1_strict(parametro INT)
RETURNS INT
language plpgsql
as $$
declare
	id_ int; -- No se puede solo hacer un select sin asignarlo a nada
BEGIN
	SELECT id into id_ FROM empleados WHERE nss=36; -- Consulta costosa
	RETURN id_;
end; $$ STRICT
/* Si un input NULL implica un resultado a NULL, 
con STRICT ya no realiza la operaci√≥n, mejorando el rendimiento */


SELECT fprueba1_strict(NULL);



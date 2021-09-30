
/* 1. Tabla auditoría que almacena en cada insert el día y el numero de empleados */
 
DROP TABLE IF EXISTS auditoria;
CREATE TABLE auditoria (
    -- id INT,
    dia DATE DEFAULT CURRENT_DATE,
    num_empleados INT DEFAULT fnum_empleados()
);

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
   raise notice 'Actualizada tabla auditoria con num_empleados = %', num_empleados;
   return num_empleados;
end; $$

SELECT fnum_empleados();


INSERT INTO auditoria (id) VALUES (1);
INSERT INTO auditoria VALUES (CURRENT_DATE, fnum_empleados());
SELECT * FROM auditoria;


/* 1b. Incluyendo todo en un procedimiento */


create or replace procedure pnum_empleados()
as $$
declare
  num_empleados integer := 0;
BEGIN
    INSERT INTO auditoria 
        select current_date, count(*)  from empleados;
   raise notice 'Actualizada tabla auditoria con num_empleados = %', num_empleados;

end; $$ language plpgsql

CALL pnum_empleados();

SELECT * FROM auditoria;







/******************************************************************/

/** 2. Función que actualiza una tabla auditoría con el número de empleados y los
 * salarios máximo, mínimo y medio */

DROP TABLE IF EXISTS auditoria;
CREATE TABLE auditoria (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	dia DATE DEFAULT CURRENT_DATE,
	num_empleados INT DEFAULT fnum_empleados(),
	salario_max NUMERIC(7,2) NOT NULL,
	salario_min NUMERIC(7,2) NOT NULL,
	salario_avg NUMERIC(7,2) NOT NULL
);
 
DROP function IF EXISTS actualiza_auditoria();
create or replace function actualiza_auditoria()
returns void as $$
begin
	INSERT into auditoria (num_empleados, salario_max, salario_min, salario_avg)
        (select count(*), max(salario), min(salario), avg(salario)
                from empleados);
end; $$ language plpgsql


SELECT actualiza_auditoria();
SELECT * FROM auditoria;

-- Alternativa utilizando la función f_sal_max_min_avg():

create or replace PROCEDURE actualiza_auditoria()
as $$
begin
	INSERT into auditoria (num_empleados, salario_min, salario_max,salario_avg)
	(
	SELECT (SELECT count(*) FROM empleados), * 
		FROM f_sal_max_min_avg()
	);
end; $$ language plpgsql

call actualiza_auditoria();
SELECT * FROM auditoria;

SELECT (SELECT count(*) FROM empleados), * 
        FROM f_sal_max_min_avg();


    
/** 3. */

DROP TABLE IF EXISTS salarios_altos;
CREATE TABLE salarios_altos (
	id INTEGER GENERATED ALWAYS AS IDENTITY  PRIMARY KEY,
	nif_empleado CHAR(9) NOT NULL,
	salario NUMERIC(7,2) NOT NULL,
	timestamp timestamp DEFAULT CURRENT_TIMESTAMP
)

DROP FUNCTION salarios_altos;
create or replace PROCEDURE salarios_altos(IN salario_cota INT)
as $$
declare
	rec record;
begin
	for rec in select *   -- Recuperamos un listado de records
	    from empleados
   		where salario>salario_cota
	loop
		INSERT INTO salarios_altos (nif_empleado, salario) VALUES (rec.nif, rec.salario);	
	end loop;
end; $$ language plpgsql


CALL salarios_altos(6000);

SELECT * FROM salarios_altos;




/* Función que comprueba si un NIF ya existe en la tabla */


create or replace function is_nif_existente(IN nif_in CHAR(9))
RETURNS BOOL
as $$
begin
	if 
		(SELECT count(*) FROM empleados WHERE nif=nif_in)=1
	then
		RETURN TRUE;
	else
		RETURN FALSE;
	end if;
end; $$ language plpgsql

SELECT nif_existente('1');
SELECT nif_existente('01999999A');







-- TODO: mostrarlo
-- TODO: gestionarlo con excepciones?


/* 




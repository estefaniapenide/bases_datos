
CREATE OR REPLACE FUNCTION random_between(low INT ,high INT) 
   RETURNS INT AS
$$
BEGIN
   RETURN floor(random() * (high-low + 1) + low);
END;
$$ language 'sql/psm' STRICT;


SELECT (CURRENT_DATE - '1 day'::INTERVAL *(RANDOM()*10000+10000)::int);


DELETE FROM empleados
WHERE id NOT IN (SELECT director FROM departamentos
				WHERE director IS NOT NULL);
			
DELETE FROM empleados
WHERE id>5;

			

INSERT INTO empleados
	SELECT id, -- id
		LPAD(id::text, 8, '0') || 'A',  -- nif
		'Nombre' || id, 
		'Apellidos' || id, 
		id,  -- nss
		(RANDOM()*10000+1000)::numeric(7,2), -- salario
		(enum_range(NULL::sexo))[(RANDOM()::int)+1], -- sexo
		(CURRENT_DATE - (interval '1d')*(RANDOM()*10000+8000)::int), -- fnacimiento
		random_between(1,6), -- departamento
		random_between(1,6), -- sede
		NULL -- supervisor
FROM generate_series(100001,500000) id;

SELECT RANDOM()*10000+10000;



UPDATE empleados SET supervisor=random_between(10,40000) WHERE id>10 ;
UPDATE empleados SET supervisor=NULL WHERE random_between(0,200)<100;

SELECT (enum_range(NULL::sexo));

SELECT *
FROM generate_series(10,40) id;





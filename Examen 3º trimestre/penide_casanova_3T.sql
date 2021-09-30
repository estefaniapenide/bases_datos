/*
 * Normas de entrega:
 * 
 * Todas las funciones, procedimientos o triggers deben tener un nombre con la forma nombreAlumno_nombreFuncion
 * El fichero debe nombrarse con el nombre del alumno/a siguiendo el formato "apellido1_nombre_3T.sql".
 * 
 * 
 * Nombre: Estefania Penide Casanova
 * Grupo: Adultos A 
 */


/**************************************************************************************************************************
 * 1. Función que recibe un VARCHAR de 8 cifras y devuelve un dni válido con su letra de control.
 * Se comprobará que el valor introducido sea numérico y de 8 cifras, lanzando un
 * mensaje de error en caso contrario */
 drop function if exists estefaniapenide_fletradni(varchar(8));

CREATE OR REPLACE FUNCTION estefaniapenide_fletradni(dni varchar(8)) returns varchar(10) as $$
	DECLARE
	letrasValidas constant CHAR(23) := 'TRWAGMYFPDXBNJZSQVHLCKE';
	numero INT;
	letraCorrecta CHAR;
	longitud INT;
	dni_final varchar(10);
begin
	IF dni=NULL THEN RETURN FALSE; END IF;

	longitud := length(dni);
	IF longitud<>8  THEN
		RAISE EXCEPTION 'EL DNI debe constar de 8 números';
	ELSE
		numero := dni::int; -- Casteo a INT. Si no son números, lanza una excepción '22P02'	
		letraCorrecta := SUBSTR(letrasValidas, MOD(numero, 23)+1, 1);
		dni_final:=dni||letraCorrecta;
		return dni_final;
	END IF;
	-- Captura de la excepción si falla el casteo y devolución de false
	EXCEPTION WHEN sqlstate '22P02' THEN -- Para gestionar si el casteo no se lleva a cabo
       RAISE WARNING 'El dni debe empezar por 8 caracteres numéricos';
       RETURN NULL;
end;
$$
language 'plpgsql';

select * from fletradni('abcdrtyt');
select * from fletradni('53191630');
select * from fletradni('5319163089898');



/**************************************************************************************************************************
 * 2. Impedir que un profesor tenga un DNI inválido en la columna "nif" 
 * y que haya DNI duplicados. */

drop function if exists estefaniapenide_fvalidadni(char);

create or replace function estefaniapenide_fvalidadni(dni CHAR(10))
RETURNS boolean
as $$
DECLARE
	letrasValidas constant CHAR(23) := 'TRWAGMYFPDXBNJZSQVHLCKE';
	letraInput CHAR;
	numero INT;
	letraCorrecta CHAR;
	longitud INT;
begin
	IF dni=NULL THEN RETURN FALSE; END IF;
	longitud := length(dni);
	IF longitud<9 OR longitud>10 THEN
		RAISE WARNING 'EL DNI debe constar de 8 números y una letra';
		RETURN FALSE;
	END IF;
	letraInput := SUBSTR(dni, length(dni), 1); -- Extraemos el último caracter
	numero := (SUBSTR(dni, 1, 8))::int; -- Casteo a INT. Si no son números, lanza una excepción '22P02'
    /* Se separa primero el último caracter (letra) y los primeros 8 (números). 
	 * Si está con algún separador (caracter 9 cuando longitud 10), lo ignora  */
	letraCorrecta := SUBSTR(letrasValidas, MOD(numero, 23)+1, 1);
	IF (letraCorrecta = letraInput) THEN RETURN true;
		ELSE
			RAISE WARNING 'La letra de control no es correcta';
			RETURN false;
	END IF;
	-- Captura de la excepción si falla el casteo y devolución de false
	EXCEPTION WHEN sqlstate '22P02' THEN -- Para gestionar si el casteo no se lleva a cabo
        RAISE WARNING 'El dni debe empezar por 8 caracteres numéricos';
        RETURN false;
end; $$ language plpgsql;

drop function if exists estefaniapenide_fdnicorrecto();

create or replace function estefaniapenide_fdnicorrecto() returns trigger as $$
begin
	if not validadni(new.nif) then 
		raise exception 'El dni del profesor % no es válido',new.id;
	end if;
	perform 1 from profesores where nif=new.nif;
		if found then 
			raise exception 'El dni que intenta introducir ya existe en la tabla';
		end if;	
	return new;
end;
$$
language 'plpgsql';

drop trigger if exists estefaniapenide_dnicorrecto on profesores;

create trigger estefaniapenide_dnicorrecto
BEFORE INSERT OR UPDATE ON profesores
FOR EACH ROW EXECUTE PROCEDURE estefaniapenide_fdnicorrecto();

select * from profesores;
insert into profesores values (99,'11111111J', 'a','b','c','1986-10-17',590107,3000);
insert into profesores values (99,'53191630J', 'a','b','c','1986-10-17',590107,3000);
insert into profesores values (98,'53191630J', 'a','b','c','1986-10-17',590107,3000);
DELETE FROM profesores WHERE id=98;
update profesores set nif='53191630J' where id=101;
update profesores set nif='11111111J' where id=101;



/**************************************************************************************************************************
 * 3. Evitar que un profesor tenga asignadas más de 21 sesiones en total */

drop function if exists estefaniapenide_fhorasdetrabajo();

create or replace function estefaniapenide_fhorasdetrabajo() returns trigger as $$
declare 
horas int;
horas_max int;
begin
	horas_max:=21;
	select sum(sesiones) into horas from modulos_ciclo where profesor=new.profesor;
IF TG_OP='INSERT' THEN
		IF (horas+NEW.sesiones)>horas_max THEN 
			RAISE EXCEPTION 'El profesor % tiene asignadas más de 21h', NEW.profesor;
		END IF;
	END IF;
	IF TG_OP='UPDATE' THEN
		IF (horas-OLD.sesiones+NEW.sesiones)>horas_max THEN 
			RAISE EXCEPTION 'El profesor % tiene asignadas más de 21h', NEW.profesor;
		END IF;
	END IF;
	RETURN NEW;
end;
$$
language 'plpgsql';

drop trigger if exists estefaniapenide_horasmaxtrabajo on modulos_ciclo;

create trigger estefaniapenide_horasmaxtrabajo
BEFORE INSERT OR UPDATE ON modulos_ciclo
FOR EACH ROW EXECUTE PROCEDURE  estefaniapenide_fhorasdetrabajo();

/**/
select * from modulos_ciclo;
select sum(sesiones) from modulos_ciclo where profesor=205;
update modulos_ciclo set sesiones=9 where profesor=205 and codigo=15;


/**************************************************************************************************************************
 * 4. Evitar que un módulo de 2º curso pueda ser prerrequisito */

drop function if exists estefaniapenide_fsegundonoprerrequisito();

create or replace function estefaniapenide_fsegundonoprerrequisito() returns trigger as $$
declare 
curso_ modulos.curso%type;
begin 
	select curso into curso_ from modulos where cod=new.prerrequisito;
	if curso_='2º' then 
	 raise exception 'El módulo % es de 2º, por lo tanto no puede ser prerrequisito', new.prerrequisito;
	else
	 return new;
	end if;
end;
$$
language 'plpgsql';

drop trigger if exists estefaniapenide_segundonoprerrequisito

create trigger estefaniapenide_segundonoprerrequisito
BEFORE INSERT OR UPDATE ON prerrequisitos
FOR EACH ROW EXECUTE PROCEDURE estefaniapenide_fsegundonoprerrequisito();

select * from prerrequisitos;
select * from modulos where curso='2º';
select * from modulos where curso='1º';

delete from prerrequisitos where prerrequisito='MP0224';
insert into prerrequisitos values ('MP0224','MP0221');
update prerrequisitos set prerrequisito='MP0224' where modulo='MP0226';


/**************************************************************************************************************************
 * 5. Lanzar un WARNING cuando a un profesor se le asigna un módulo que no
 * sea de su especialidad */

drop function if exists estefaniapenide_asignacionacordeaespecialidad();

create or replace function estefaniapenide_asignacionacordeaespecialidad() returns trigger as $$
begin

	perform 1 from modulos_ciclo mc left join profesores p on p.id=new.profesor
	left join modulos m on m.cod=new.modulo where p.especialidad=m.especialidad;
	if found then 
		return new;
	else
		raise warning 'El módulo % asignado al profesor %, no es de su especialidad.',new.modulo,new.profesor;
	return new;
	end if;
end;
$$
language 'plpgsql';

drop trigger if exists estefaniapenide_asignacionacordeaespecialidad on modulos_ciclo;

create trigger estefaniapenide_asignacionacordeaespecialidad
BEFORE INSERT OR UPDATE ON modulos_ciclo
FOR EACH ROW EXECUTE PROCEDURE estefaniapenide_asignacionacordeaespecialidad();


INSERT INTO modulos_ciclo (ciclo, regimen, modulo, sesiones, profesor) VALUES ('ASIR', 'Adultos', 'MP0228', 3, 307);
INSERT INTO modulos_ciclo (ciclo, regimen, modulo, sesiones, profesor) VALUES ('ASIR', 'Adultos', 'MP0228', 3, 102);
update modulos_ciclo set modulo='MP0225' where profesor=307;
update modulos_ciclo set modulo='MP0225' where profesor=102;

select p.id, p.especialidad, m.cod, m.especialidad from modulos_ciclo mc left join profesores p on p.id=mc.profesor
left join modulos m on m.cod=mc.modulo where p.especialidad=m.especialidad;

select id, especialidad from profesores;
select cod, especialidad from modulos;


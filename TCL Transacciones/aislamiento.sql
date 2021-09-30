/**
 * TRANSACCIONES EN SQL
 * 
 * https://es.wikipedia.org/wiki/ACID
 * 
 */


/* BBDD y tabla de pruebas */
DROP DATABASE IF EXISTS cuentas1;
CREATE DATABASE cuentas1;
USE cuentas1;
CREATE TABLE cuentas (
  cuenta INT PRIMARY KEY,
  saldo INT DEFAULT 0,
  CONSTRAINT chk1 CHECK (saldo>=0) -- Ponemos nombre al check
);
INSERT INTO cuentas VALUES (1, 1000);
INSERT INTO cuentas VALUES (2, 1000);

/* Uso básico del MySQL shell en Windows:
 * MySQL  JS > \connect root@localhost:3306/cuentas1 -- Conexión con la 
 * MySQL  localhost:33060+ ssl  prof_mod_ciclos_3  JS > \sql
 */
 


/* Aislamiento (Isolation)
 * https://es.wikipedia.org/wiki/Aislamiento_(ACID)
 * 
 * Niveles de aislamiento (definen cómo los cambios hecho spor una transacción son visibles a otras):
 * 
 * READ UNCOMITTED:
 * Una transacción puede ver los cambios que se están llevando a cabo en otra aún antes de hacer commit.
 * Las sentencias SELECT son efectuadas sin realizar bloqueos.
 * 
 * READ COMITTED:
 * Una transacción solo lee cambios de los que se ha hecho commit. Realiza bloqueos de escritura.
 * Pero los datos leidos por una transacción pueden ser modificados en otra.
 * 
 * REPEATABLE READ
 * SERIALIZABLE
 * 
 */


/* Nivel de aislamiento en MySQL: */
SELECT @@transaction_ISOLATION; /* Comprueba el nivel de aislamiento de la sesión
Es equivalente a SELECT @@SESSION.transaction_isolation;
 
También se puede comprobar el nivel definido como GLOBAL:
SELECT @@GLOBAL.transaction_isolation
*/

-- Para cambiar el nivel de aislamiento para la sesión
SET SESSION TRANSACTION ISOLATION LEVEL serializable;
SET transaction_isolation = 'READ-UNCOMMITTED';



/* PROBLEMA 0 de acceso concurrente: Dirty Write (escritura sucia):
 * Una transacción modifica datos que está modificando otra. No tiene ninguna utilidad legítima,
 * por lo que no es permitido por ningún DBMS. */


/* Sesión 1: ejecuta una transferencia de 200€ del cliente 1 al 2 */
/*S1*/ START TRANSACTION;
/*S1*/ update cuentas set saldo=0 where cuenta=2;

/* Sesión 2: por error, intenta ejecutar la misma transferencia */
/*S2*/ update cuentas set saldo=200 where cuenta=2; 
/* Espera a que termine la primera transacción ya que, en caso contrario,
 * podría quedar sin efecto por acciones posteriores */

/*S1*/ update cuentas set saldo=saldo+300 where cuenta=2; COMMIT;


/* Si intentásemos realizar una modificación de los mismos registros desde S2,
 * nos encontramos que éstos sí están bloqueados para escritura hasta que S1 termine. */



/* PROBLEMA 1 de acceso concurrente:
 * Dirty Read (Lectura sucia): Una transacción lee datos escritos por una transacción que no ha hecho COMMIT. */

-- Partimos del nivel de aislamiento menos restrictivo, que permite los tres errores: Read Uncommitted
/*S2*/ SET SESSION TRANSACTION ISOLATION LEVEL read uncommitted;


/* Sesión 1: ejecuta una transferencia de 1200€ del cliente 1 al 2 */
/*S1*/ START TRANSACTION;
/*S1*/ update cuentas set saldo=saldo+1200 where cuenta=2;

/* Sesión 2: el cliente 2 quiere comprobar si ha recibido la transferencia y ejecuta la consulta en el momento 
 * en que se realiza. El cliente piensa que la transferencia se ha realizado correctamente  */
/*S2*/ SELECT saldo FROM cuenta WHERE cliente=2; -- Resultado 2200: la transferencia se ha realizado
 

-- Segunda instrucción de la transacción
/*S1*/ update cuentas set saldo=saldo-1200 where cuenta=1; /* Falla por violar la restricción del CHECK
así que se realiza un ROLLBACK */
/*S1*/ ROLLBACK; -- La transferencia no se ha realizado pero el cliente 2 cree que sí.

/* Una diferencia importante es que en PosgreSQL, un commit hace automáticamente ROLLBACK si alguna instrucción
de la transacción ha fallado */
BEGIN TRANSACTION ISOLATION LEVEL read uncommitted;
-- ...
COMMIT;

/* Cambiando el nivel de aislamiento a READ COMMITTED, se soluciona el problema, ya que ahora,
 * cada transacción solo puede ver los datos de los que se ha hecho commit */
/*S2*/ SET SESSION TRANSACTION ISOLATION LEVEL read committed;

/* Usos legítimos del Dirty Read: 
 * Auditoría, por ejemplo ejecutando count(*) recurrentemente mientras otra transacción 
 * introduce datos para mostrar la velocidad y el proceso de introducción de datos
 */



/* PROBLEMA 2 de acceso concurrente: Nonrepeateable Read (Lectura no repetible). 
 * Una transacción vuelve a leer datos que leyó previamente y encuentra que han sido modificados por otra transacción. 
 * Este problema se puede dar en READ UNCOMMITED, pero también con READ COMMITED */

-- Eliminamos el check
ALTER TABLE cuentas DROP CONSTRAINT chk1;
UPDATE cuentas SET saldo=-100 WHERE cuenta=1;

/*S2*/ START TRANSACTION; -- El banco revisa si el cliente 1 está en números rojos
/*S2*/ SELECT saldo FROM cuentas WHERE cuenta=1; -- Lo está

/*S1*/ update cuentas set saldo=saldo+800 where cuenta=1; -- Se realiza un ingreso al ciente 1, que deja de estar en descubierto

/*S2*/ SELECT saldo FROM cuentas WHERE cuenta=1; COMMIT; -- La lectura ahora da un valor distinto

/* Usos legítimos: hay casos en los que la agregación de datos realizada en una transacción debe ser
 * coherente con el momento enq ue se realizó, pero en otros casos, lo importante es que esos datos
 * estén lo más actualizados posibles pese a que el resultado no se corresponda realmente con ningún momento concreto  */


/* Cambiando el nivel de aislamiento a REPEATABLE READ, se soluciona el problema (como su nombre indica), ya que ahora,
 * los datos leidos se bloquean para la transacción hasta que esta termine */
/*S2*/ SET SESSION TRANSACTION ISOLATION LEVEL repeatable read;


/* PROBLEMA 3 de acceso concurrente: Phantom Read (Lectura fantasma). */

/*S2*/ BEGIN; select cuenta from cuentas;
/*S1*/ insert into cuentas values (3, 900);
/*S2*/ select cuenta from cuentas; COMMIT;


/* Alternativa */
/*S2*/ BEGIN; select cuenta from cuentas;
/*S1*/ insert into cuentas values (3, 900);
/*S2*/ select cuenta from cuentas; COMMIT;


/* Cambiando el nivel de aislamiento a SERIALIZABLE, se soluciona el problema */
/*S2*/ SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
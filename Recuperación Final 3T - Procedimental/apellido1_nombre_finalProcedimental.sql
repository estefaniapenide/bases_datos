/*
 * Normas de entrega:
 * Todas las funciones, procedimientos o triggers deben tener un nombre con la forma nombreAlumno_nombreFuncion
 * El nombre del fichero debe seguir el formato "apellido1_nombre_finalProcedimental.sql".
 * 
 * Nombre:
 * Grupo: [Adultos A o Adultos B]
 */


/***************************************************************************************
 *  1. Procedimiento que realiza una transferencia entre cuentas. Recibirá el iban de la cuenta 
 * que emite la transferencia, el de la cuenta receptora y una cantidad que ha de ser positiva.
 * Debe lanzar un error si se hace un movimiento de una cuenta a si misma.
 */


/****************************************************************************************
 * 2. Trigger que registre todos los cambios de saldo realizados en las cuentas en la tabla
 * "historico_cuentas". 
 * - Ante cualquier modificación del saldo, se registrará el iban, el saldo que había antes
 * de la modificación, el saldo posterior y el timestamp de cuándo se realizó la operación.
 * - Si se trata de una creación de cuenta nueva, "saldo_anterior" quedará a NULL.
 * - El campo timestamp siempre debe insertar el valor del momento en que se realiza la acción.
*/


/****************************************************************************************
 * 3. Trigger que impide operaciones que dejen a un cliente con una deuda total superior
 * a la permitida (campo "deuda_permitida" de la tabla "clientes")
 */


 
/****************************************************************************************
 * 4. Trigger que mantiene actualizado el número de cuentas de cada cliente (campo num_cuentas)
 */ 
 

/****************************************************************************************
 * 5. Función que recibe una fecha y un nif de un cliente y devuelve las cuentas de ese cliente con el
 * saldo de cada una. Además, mostrará un WARNING por cada cuenta que esté en número rojos (negativos) */
 
 
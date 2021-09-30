DROP DATABASE IF EXISTS emp_exam;
CREATE SCHEMA emp_exam;
USE emp_exam;


CREATE TABLE sedes(
	id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    superficie INT UNSIGNED NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    localidad VARCHAR(200) NOT NULL,
    provincia VARCHAR(40) NOT NULL,
    telefono BIGINT NOT NULL,
    telefono2 BIGINT
);

CREATE TABLE empleados(
nif CHAR(10) PRIMARY KEY,
nombre VARCHAR(200) NOT NULL,
nss BIGINT NOT NULL UNIQUE,
salario DECIMAL(9,2) NOT NULL,
sexo ENUM("HOMBRE","MUJER","OTRO") NOT NULL,
fnacimineto DATE NOT NULL,
departamento SMALLINT UNSIGNED NOT NULL,
supervisor CHAR(10),
FOREIGN KEY (supervisor) REFERENCES empleados(nif)
);


CREATE TABLE  departamentos(
id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(200) NOT NULL,
fcreacion DATE NOT NULL,
prima DECIMAL(8,2) NOT NULL,
director CHAR(10) NOT NULL,
FOREIGN KEY (director) REFERENCES empleados(nif)
);

/*ALTER TABLE empleados ADD
	FOREIGN KEY(departamento) REFERENCES departamento(id);
    */


DROP TABLE IF EXISTS clientes CASCADE;
CREATE TABLE clientes (
  id INT generated by default as identity PRIMARY KEY,
  nif VARCHAR(10) NOT NULL,
  nombre VARCHAR(255) NOT NULL,
  deuda_permitida NUMERIC(8,2) DEFAULT 0, -- Deuda máxima que puede acumular el cliente entre sus cuentas
  telefono int NOT NULL,
  num_cuentas smallint DEFAULT 0, -- numero de cuentas que tiene ese cliente
  CHECK (deuda_permitida<0)
);

INSERT INTO clientes VALUES (1, '11111111A', 'Cliente01', -1000, 666999661, 0);
INSERT INTO clientes VALUES (2, '22222222A', 'Cliente02', -1000, 666999662, 0);
INSERT INTO clientes VALUES (3, '33333333A', 'Cliente03', -1000, 666999663, 0);
INSERT INTO clientes VALUES (4, '44444444A', 'Cliente04', -1000, 666999664, 0);
INSERT INTO clientes VALUES (5, '55555555A', 'Cliente05', -1000, 666999665, 0);
INSERT INTO clientes VALUES (6, '66666666A', 'Cliente06', -1000, 666999666, 0);
INSERT INTO clientes VALUES (7, '77777777A', 'Cliente07', -1000, 666999667, 0);


DROP TABLE IF EXISTS cuentas CASCADE;
CREATE TABLE cuentas (
  iban CHAR(24) PRIMARY KEY,
  id_cliente INT NOT NULL,
  fechacreacion DATE NOT NULL DEFAULT CURRENT_DATE,
  saldo NUMERIC(15,0) DEFAULT 0,
  FOREIGN KEY (id_cliente) REFERENCES clientes(id)
);

INSERT INTO cuentas VALUES ('ES5400753398110628610358', 1, '2013-06-07', 1000);
INSERT INTO cuentas VALUES ('ES3800787833376411098308', 2, '2013-06-07', 1000);
INSERT INTO cuentas VALUES ('ES3520806225221793357181', 3, '2013-06-07', 1000);
INSERT INTO cuentas VALUES ('ES6801304055684910742850', 4, '2013-06-07', 1000);
INSERT INTO cuentas VALUES ('ES5121055300034311246365', 5, '2013-06-07', 1000);
INSERT INTO cuentas VALUES ('ES8320800103413290594392', 6, '2013-06-07', 1000);
INSERT INTO cuentas VALUES ('ES3230586281582672269175', 7, '2013-06-07', 1000);
INSERT INTO cuentas VALUES ('ES5630580218521563582730', 1, '2013-06-07', 1000);
INSERT INTO cuentas VALUES ('ES4021055549862335108701', 2, '2013-06-07', 1000);
INSERT INTO cuentas VALUES ('ES8100757232414965724657', 3, '2013-06-07', 1000);


DROP TABLE IF EXISTS historico_cuentas;
CREATE TABLE historico_cuentas (
	iban CHAR(24) NOT NULL,
	saldo_anterior NUMERIC(9,2),
	saldo_posterior NUMERIC(9,2) NOT NULL,
	timestamp timestamp DEFAULT current_timestamp,
	FOREIGN KEY (iban) REFERENCES cuentas(iban)
);
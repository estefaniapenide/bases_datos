DROP DATABASE IF EXISTS prof_mod_ciclos_3;
CREATE DATABASE prof_mod_ciclos_3;
USE prof_mod_ciclos_3;


CREATE TABLE especialidades (
	cod MEDIUMINT UNSIGNED PRIMARY KEY,
	nombre VARCHAR(200) NOT NULL UNIQUE
);

INSERT INTO especialidades VALUES (590107, "Informática");
INSERT INTO especialidades VALUES (591227, "Sistemas e aplicacións informáticas");
INSERT INTO especialidades VALUES (590105, "Formación e orientación laboral");


CREATE TABLE ciclos (
	cod CHAR(5) PRIMARY KEY,
	nombre VARCHAR(200) NOT NULL UNIQUE
);

INSERT INTO ciclos VALUES ("SMR", "Sistemas microinformáticos e redes");
INSERT INTO ciclos VALUES ("ASIR", "Administración de sistemas informáticos en rede");
INSERT INTO ciclos VALUES ("DAM", "Desenvolvemento de aplicacións multiplataforma");
INSERT INTO ciclos VALUES ("DAW", "Desenvolvemento de aplicacións web");



CREATE TABLE modulos (
	cod CHAR(6) UNIQUE PRIMARY KEY,
	curso ENUM('1','2') NOT NULL,
	siglas CHAR(8) NOT NULL,
	nombre VARCHAR(100) NOT NULL,
	sesiones_anuales SMALLINT UNSIGNED NOT NULL,
	especialidad MEDIUMINT UNSIGNED,
	FOREIGN KEY (especialidad) REFERENCES especialidades(cod)
);

CREATE TABLE prerrequisitos (
	prerrequisito CHAR(6),
	modulo CHAR(6),
	FOREIGN KEY (modulo) REFERENCES modulos(cod),
	FOREIGN KEY (prerrequisito) REFERENCES modulos(cod),
	PRIMARY KEY (modulo, prerrequisito)
);

CREATE TABLE profesores (
	id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nif CHAR(20) NOT NULL,
    nombre VARCHAR(400) NOT NULL,
    apellido1 VARCHAR(100) NOT NULL,
    apellido2 VARCHAR(100),
    fecha_incorporación DATE DEFAULT (CURDATE()),
    especialidad MEDIUMINT UNSIGNED NOT NULL,
    FOREIGN KEY (especialidad) REFERENCES especialidades(cod),
   	salario DECIMAL(7,2) NOT NULL
);

INSERT INTO profesores VALUES (101, "11222333A", "George", "Boole", NULL, "2019-09-16", 590107, 2000);
INSERT INTO profesores VALUES (102, "12222333A", "Georg", "Cantor", NULL, "2019-09-16", 590107, 2000);
INSERT INTO profesores VALUES (103, "13222333A", "Rudolf", "Carnap", NULL, "2019-09-16", 590107, 2000);
INSERT INTO profesores VALUES (104, "14222333A", "Alonzo", "Church", NULL, "2019-09-16", 590107, 2000);
INSERT INTO profesores VALUES (105, "15222333A", "Augustus", "DeMorgan", NULL, "2019-09-16", 590107, 2000);
INSERT INTO profesores VALUES (106, "16222333A", "Gottlob", "Frege", NULL, "2019-09-16", 590107, 2000);
INSERT INTO profesores VALUES (107, "17222333A", "Karl Friedrich", "Gauss", NULL, "2019-09-16", 590107, 2000);
INSERT INTO profesores VALUES (108, "18222333A", "David", "Hilbert", NULL, "2019-09-16", 590107, 2000);
INSERT INTO profesores VALUES (109, "19222333A", "Grace", "Hopper", NULL, "2019-09-16", 590107, 2000);
INSERT INTO profesores VALUES (110, "10222333A", "Gottfried", "Leibniz", NULL, "2019-09-16", 590107, 2000);

INSERT INTO profesores VALUES (201, "11122333A", "Claude", "Shannon", NULL, "2019-09-16", 590107, 2000);
INSERT INTO profesores VALUES (202, "11322333A", "Dennis", "Ritchie", NULL , "2019-09-16", 590107, 2000);
INSERT INTO profesores VALUES (203, "11422333A", "Tim", "Berners-Lee", NULL, "2019-09-16", 590107, 2000);
INSERT INTO profesores VALUES (204, "11522333A", "Kurt", "Godel", NULL, "2019-09-16", 590107, 2000);
INSERT INTO profesores VALUES (205, "11622333A", "Alan", "Turin", NULL, "2019-09-16", 590107, 2000);
INSERT INTO profesores VALUES (206, "11722333A", "John", "Von Neumann", NULL, "2019-09-16", 590107, 2000);
INSERT INTO profesores VALUES (207, "11822333A", "John", "McCarthy", NULL, "2019-09-16", 590107, 2000);
INSERT INTO profesores VALUES (208, "11922333A", "Linus", "Torvalds", NULL, "2019-09-16", 590107, 2000);
INSERT INTO profesores VALUES (209, "11022333A", "Alejandro", "Vidal", "Domínguez", "2019-09-16", 590107, 2000);
INSERT INTO profesores VALUES (210, "11992333A", "Alan", "Kay", NULL, "2019-09-16", 590107, 2000);

INSERT INTO profesores VALUES (301, "11222333A", "Ada", "Lovelace", NULL, "2019-09-16", 591227, 2000);
INSERT INTO profesores VALUES (302, "11222334A", "G.E.", "Moore", NULL, "2019-09-16", 591227, 2000);
INSERT INTO profesores VALUES (303, "11222335A", "Willard V.", "Quine", NULL, "2019-09-16", 591227, 2000);
INSERT INTO profesores VALUES (304, "11222336A", "Bertrand", "Russell", NULL, "2019-09-16", 591227, 2000);
INSERT INTO profesores VALUES (305, "11222337A", "Saul", "Kripke", NULL, "2019-09-16", 591227, 2000);
INSERT INTO profesores VALUES (306, "11222338A", "Ludwig", "Wittgenstein", NULL, "2019-09-16", 591227, 2000);
INSERT INTO profesores VALUES (307, "11022333A", "Alejandro", "Vidal", "Domínguez", "2019-09-16", 590107, 2000);


CREATE TABLE modulos_ciclo (
    ciclo CHAR(5) NOT NULL,
	regimen ENUM("Ordinario", "Adultos", "Distancia", "Dual") NOT NULL,
	modulo CHAR(6) NOT NULL,
	sesiones TINYINT UNSIGNED NOT NULL, -- Sesiones semanales
    profesor SMALLINT UNSIGNED,
	FOREIGN KEY (ciclo) REFERENCES ciclos(cod), 
	FOREIGN KEY (modulo) REFERENCES modulos(cod),
	FOREIGN KEY (profesor) REFERENCES profesores(id) ON DELETE SET NULL,
    PRIMARY KEY (modulo, ciclo, regimen)
);



/* SMR */

INSERT INTO modulos VALUES ("MP0221", 1, "MME", "Montaxe e mantemento de equipamentos", 240, 591227);
INSERT INTO modulos VALUES ("MP0222", 1, "SOM", "Sistemas operativos monoposto", 160, 591227);
INSERT INTO modulos VALUES ("MP0223", 1, "AO", "Aplicacións ofimáticas", 240, 591227);
INSERT INTO modulos VALUES ("MP0225", 1, "RL", "Redes locais", 213, 590107);
INSERT INTO modulos VALUES ("MP0229", 1, "FOL", "Formación e orientación laboral", 107, 590105);

INSERT INTO modulos VALUES ("MP0224", 2, "SOR", "Sistemas operativos en rede", 157, 591227);
INSERT INTO modulos VALUES ("MP0226", 2, "SGI", "Seguridade informática", 140, 590107);
INSERT INTO modulos VALUES ("MP0227", 2, "SR", "Servizos en rede", 157, 590107);
INSERT INTO modulos VALUES ("MP0228", 2, "AW", "Aplicacións web", 123, 590107);
INSERT INTO modulos VALUES ("MP0230", 2, "EIE", "Empresa e iniciativa emprendedora", 53, 590105);
INSERT INTO modulos VALUES ("MP0231", 2, "FCT", "Formación en centros de traballo", 410, NULL);

INSERT INTO modulos_ciclo VALUES ("SMR", "Adultos", "MP0221", 9, 101);
INSERT INTO modulos_ciclo VALUES ("SMR", "Adultos", "MP0222", 6, 101);
INSERT INTO modulos_ciclo VALUES ("SMR", "Adultos", "MP0223", 9, 101);
INSERT INTO modulos_ciclo VALUES ("SMR", "Adultos", "MP0225", 8, 206);
INSERT INTO modulos_ciclo VALUES ("SMR", "Adultos", "MP0229", 4, NULL);

INSERT INTO modulos_ciclo VALUES ("SMR", "Adultos", "MP0224", 6, NULL);
INSERT INTO modulos_ciclo VALUES ("SMR", "Adultos", "MP0226", 5, 207);
INSERT INTO modulos_ciclo VALUES ("SMR", "Adultos", "MP0227", 5, 206);
INSERT INTO modulos_ciclo VALUES ("SMR", "Adultos", "MP0228", 5, 210);
INSERT INTO modulos_ciclo VALUES ("SMR", "Adultos", "MP0230", 2, NULL);
INSERT INTO modulos_ciclo VALUES ("SMR", "Adultos", "MP0231", 3, NULL);

INSERT INTO prerrequisitos VALUES ("MP0222", "MP0224");
INSERT INTO prerrequisitos VALUES ("MP0225", "MP0224");
INSERT INTO prerrequisitos VALUES ("MP0225", "MP0226");
INSERT INTO prerrequisitos VALUES ("MP0225", "MP0227");
INSERT INTO prerrequisitos VALUES ("MP0225", "MP0228");


/* ASIR */

INSERT INTO modulos VALUES ("MP0369", 1, "ISO", "Implantación de sistemas operativos", 213, 591227);
INSERT INTO modulos VALUES ("MP0370", 1, "PAR", "Planificación e administración de redes", 213, 590107);
INSERT INTO modulos VALUES ("MP0371", 1, "FH", "Fundamentos de hardware", 107, 591227);
INSERT INTO modulos VALUES ("MP0372", 1, "XBD", "Xestión de bases de datos", 187, 590107);
INSERT INTO modulos VALUES ("MP0373", 1, "LMSXI", "Linguaxes de marcas e sistemas de xestión de información", 133, 590107);
INSERT INTO modulos VALUES ("MP0380", 1, "FOL", "Formación e orientación laboral", 107, 590105);

INSERT INTO modulos VALUES ("MP0374", 2, "ASO", "Administración de sistemas operativos", 140, 591227);
INSERT INTO modulos VALUES ("MP0375", 2, "SRI", "Servizos de rede e internet", 140, 590107);
INSERT INTO modulos VALUES ("MP0376", 2, "IAW", "Implantación de aplicacións web", 122, 590107);
INSERT INTO modulos VALUES ("MP0377", 2, "ASXBD", "Administración de sistemas xestores de bases de datos", 70, 590107);
INSERT INTO modulos VALUES ("MP0378", 2, "SAD", "Seguridade e alta dispoñibilidade", 105, 590107);
INSERT INTO modulos VALUES ("MP0381", 2, "EIE", "Empresa e iniciativa emprendedora", 53, 590105);
INSERT INTO modulos VALUES ("MP0379", 2, "PFC-ASIR", "Proxecto de administración de sistemas informáticos en rede", 26, NULL);
INSERT INTO modulos VALUES ("MP0382", 2, "FCT", "Formación en centros de traballo", 384, NULL);

INSERT INTO modulos_ciclo VALUES ("ASIR", "Adultos", "MP0369", 8, NULL);
INSERT INTO modulos_ciclo VALUES ("ASIR", "Adultos", "MP0370", 8, 207);
INSERT INTO modulos_ciclo VALUES ("ASIR", "Adultos", "MP0371", 4, NULL);
INSERT INTO modulos_ciclo VALUES ("ASIR", "Adultos", "MP0372", 7, 205);
INSERT INTO modulos_ciclo VALUES ("ASIR", "Adultos", "MP0373", 5, 208);
INSERT INTO modulos_ciclo VALUES ("ASIR", "Adultos", "MP0380", 4, NULL);

INSERT INTO modulos_ciclo VALUES ("ASIR", "Adultos", "MP0374", 4, NULL);
INSERT INTO modulos_ciclo VALUES ("ASIR", "Adultos", "MP0375", 4, 206);
INSERT INTO modulos_ciclo VALUES ("ASIR", "Adultos", "MP0376", 5, 210);
INSERT INTO modulos_ciclo VALUES ("ASIR", "Adultos", "MP0377", 3, 203);
INSERT INTO modulos_ciclo VALUES ("ASIR", "Adultos", "MP0378", 4, 207);
INSERT INTO modulos_ciclo VALUES ("ASIR", "Adultos", "MP0381", 4, NULL);
INSERT INTO modulos_ciclo VALUES ("ASIR", "Adultos", "MP0379", 4, NULL);
INSERT INTO modulos_ciclo VALUES ("ASIR", "Adultos", "MP0382", 3, 207);


INSERT INTO prerrequisitos VALUES ("MP0369", "MP0374");
INSERT INTO prerrequisitos VALUES ("MP0370", "MP0375");
INSERT INTO prerrequisitos VALUES ("MP0370", "MP0378");
INSERT INTO prerrequisitos VALUES ("MP0372", "MP0377");


/* DAM */

INSERT INTO modulos VALUES ("MP0483", 1, "SI", "Sistemas informáticos", 186, 591227);
INSERT INTO modulos VALUES ("MP0484", 1, "BD", "Bases de datos", 187, 590107);
INSERT INTO modulos VALUES ("MP0485", 1, "PR", "Programación", 240, 590107);
INSERT INTO modulos VALUES ("MP0487", 1, "CD", "Contornos de desenvolvemento", 107, 590107);
INSERT INTO modulos VALUES ("MP0493", 1, "FOL", "Formación e orientación laboral", 107, 590105);

INSERT INTO modulos VALUES ("MP0486", 2, "AD", "Acceso a datos", 157, 590107);
INSERT INTO modulos VALUES ("MP0488", 2, "DI", "Desenvolvemento de interfaces", 140, 591227);
INSERT INTO modulos VALUES ("MP0489", 2, "PMDM", "Programación multimedia e dispositivos móbiles", 123, 590107);
INSERT INTO modulos VALUES ("MP0490", 2, "PSP", "Programación de servizos e procesos", 70, 590107);
INSERT INTO modulos VALUES ("MP0491", 2, "SXE", "Sistemas de xestión empresarial", 87, 591227);
INSERT INTO modulos VALUES ("MP0494", 2, "EIE", "Empresa e iniciativa emprendedora", 53, 590105);
INSERT INTO modulos VALUES ("MP0492", 2, "PFC-DAM", "Proxecto de desenvolvemento de aplicacións multiplataforma", 26, NULL);
INSERT INTO modulos VALUES ("MP0495", 2, "FCT", "Formación en centros de traballo", 384, NULL);


INSERT INTO modulos_ciclo VALUES ("DAM", "Adultos", "MP0484", 7, 209);
INSERT INTO modulos_ciclo VALUES ("DAM", "Adultos", "MP0483", 7, NULL);
INSERT INTO modulos_ciclo VALUES ("DAM", "Adultos", "MP0487", 4, 204);
INSERT INTO modulos_ciclo VALUES ("DAM", "Adultos", "MP0373", 5, 210);
INSERT INTO modulos_ciclo VALUES ("DAM", "Adultos", "MP0485", 9, 208);

INSERT INTO modulos_ciclo VALUES ("DAM", "Adultos", "MP0490", 3, 205);
INSERT INTO modulos_ciclo VALUES ("DAM", "Adultos", "MP0491", 3, NULL);
INSERT INTO modulos_ciclo VALUES ("DAM", "Adultos", "MP0488", 5, NULL);
INSERT INTO modulos_ciclo VALUES ("DAM", "Adultos", "MP0489", 5, 209);
INSERT INTO modulos_ciclo VALUES ("DAM", "Adultos", "MP0486", 6, 208);
INSERT INTO modulos_ciclo VALUES ("DAM", "Adultos", "MP0493", 4, NULL);
INSERT INTO modulos_ciclo VALUES ("DAM", "Adultos", "MP0494", 2, NULL);
INSERT INTO modulos_ciclo VALUES ("DAM", "Adultos", "MP0492", 3, NULL);

INSERT INTO modulos_ciclo VALUES ("DAM", "Dual", "MP0484", 7, 209);
INSERT INTO modulos_ciclo VALUES ("DAM", "Dual", "MP0483", 7, NULL);
INSERT INTO modulos_ciclo VALUES ("DAM", "Dual", "MP0487", 4, 204);
INSERT INTO modulos_ciclo VALUES ("DAM", "Dual", "MP0373", 6, 201);
INSERT INTO modulos_ciclo VALUES ("DAM", "Dual", "MP0485", 7, 202);

INSERT INTO prerrequisitos VALUES ("MP0485", "MP0486");
INSERT INTO prerrequisitos VALUES ("MP0485", "MP0489");
INSERT INTO prerrequisitos VALUES ("MP0485", "MP0490");
INSERT INTO prerrequisitos VALUES ("MP0485", "MP0488");
INSERT INTO prerrequisitos VALUES ("MP0484", "MP0486");
INSERT INTO prerrequisitos VALUES ("MP0484", "MP0491");
INSERT INTO prerrequisitos VALUES ("MP0373", "MP0489");


/* DAW */
INSERT INTO modulos VALUES ("MP0617", 1, "FOL", "Formación e orientación laboral", 107, 590105);

INSERT INTO modulos VALUES ("MP0612", 2, "DWCC", "Desenvolvemento web en contorno cliente", 157, 591227);
INSERT INTO modulos VALUES ("MP0613", 2, "DWCS", "Desenvolvemento web en contorno servidor", 175, 590107);
INSERT INTO modulos VALUES ("MP0614", 2, "DAW", "Despregamento de aplicacións web", 88, 590107);
INSERT INTO modulos VALUES ("MP0615", 2, "DIW", "Deseño de interfaces web", 157, 591227);
INSERT INTO modulos VALUES ("MP0618", 2, "EIE", "Empresa e iniciativa emprendedora", 53, 590105);
INSERT INTO modulos VALUES ("MP0616", 2, "PFC-DAW", "Proxecto de desenvolvemento de aplicacións web", 26, NULL);
INSERT INTO modulos VALUES ("MP0619", 2, "FCT", "Formación en centros de traballo", 384, NULL);

INSERT INTO modulos_ciclo VALUES ("DAW", "Adultos", "MP0484", 7, 205);
INSERT INTO modulos_ciclo VALUES ("DAW", "Adultos", "MP0483", 7, NULL);
INSERT INTO modulos_ciclo VALUES ("DAW", "Adultos", "MP0487", 4, 204);
INSERT INTO modulos_ciclo VALUES ("DAW", "Adultos", "MP0373", 5, 210);
INSERT INTO modulos_ciclo VALUES ("DAW", "Adultos", "MP0485", 9, 202);

INSERT INTO modulos_ciclo VALUES ("DAW", "Adultos", "MP0612", 7, NULL);
INSERT INTO modulos_ciclo VALUES ("DAW", "Adultos", "MP0613", 7, 204);
INSERT INTO modulos_ciclo VALUES ("DAW", "Adultos", "MP0614", 3, 110);
INSERT INTO modulos_ciclo VALUES ("DAW", "Adultos", "MP0615", 6, NULL);
INSERT INTO modulos_ciclo VALUES ("DAW", "Adultos", "MP0618", 7, NULL);
INSERT INTO modulos_ciclo VALUES ("DAW", "Adultos", "MP0619", 3, 205);


INSERT INTO prerrequisitos VALUES ("MP0485", "MP0613");
INSERT INTO prerrequisitos VALUES ("MP0484", "MP0613");
INSERT INTO prerrequisitos VALUES ("MP0485", "MP0612");
INSERT INTO prerrequisitos VALUES ("MP0373", "MP0612");
INSERT INTO prerrequisitos VALUES ("MP0373", "MP0615");
	













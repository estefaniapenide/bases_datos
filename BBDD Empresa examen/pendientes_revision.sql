



/*63- POR CADA PROYECTO EN LA EMPRESA  (TODOS)
    OBTENER:
   SU CLAVE Y NOMBRE, 
   NOMBRE DEL DEPARTAMENTO QUE LO CREA, 
   CANTIDAD DE EMPLEADOS TRABAJANDO EN EL PROYECTO */
   

SELECT  P.NUMERO AS CLAVE_PROYECTO,
        P.NOMBRE AS PROYECTO,
        D.NOMBRE AS DEPARTAMENTO,
        COUNT(EP.EMPLEADO) AS NUMERO_EMPLEADOS_TRABAJAN,
        SUM(EP.NUM_HORAS) AS TOTAL_HORAS_TRABAJO
     FROM PROYECTOS AS P INNER JOIN DEPARTAMENTOS AS D
                           ON P.DEPARTAMENTO=D.NUMERO /*(1,1)**/
                              LEFT JOIN EMPLEADOS_PROYECTOS AS EP
                                ON P.NUMERO=EP.PROYECTO /*(0,N)**/
     GROUP BY P.NUMERO;
    
                         
 





/***64 D- MISMO INFORME PERO PARA LOS EMPLEADOS DE LOS DEPARTAMENTOS
     2,3 Y 5        CONDICIÓN DE TUPLA***/


SELECT  E.ID_EMPLEADO AS CLAVE_EMPLEADO,
        E.NOMBRE AS EMPLEADO,
        E.SALARIO AS SALARIO_EMPLEADO,
        ED.NOMBRE AS SU_DIRECTOR,
        ED.SALARIO AS SALARIO_SU_DIRECTOR,
        COUNT(DISTINCT EP.PROYECTO) AS NUMERO_DE_PROYECTOS,
        ES.NOMBRE AS SU_SUPERVISOR,
        COUNT(DISTINCT F.ID_FAMILIA) AS NUMERO_DE_FAMILIARES 
        
     FROM EMPLEADOS AS E INNER JOIN DEPARTAMENTOS AS D
                           ON E.DEPARTAMENTO=D.NUMERO
                            INNER JOIN EMPLEADOS AS ED
                             ON  D.DIRECTOR=ED.ID_EMPLEADO
                                LEFT JOIN EMPLEADOS_PROYECTOS AS EP
                                    ON E.ID_EMPLEADO=EP.EMPLEADO
                                     LEFT JOIN EMPLEADOS AS ES
                                       ON E.SUPERVISOR=ES.ID_EMPLEADO
                                        LEFT JOIN FAMILIARES AS F
                                         ON F.EMPLEADO=E.ID_EMPLEADO
     WHERE E.DEPARTAMENTO IN (2,3,5)
     GROUP BY E.ID_EMPLEADO,EP.EMPLEADO
     ORDER BY E.ID_EMPLEADO;

/* CUÁNTOS EMPLEADOS HAY EN LOS DEPARTAMENTOS 2,3,5)*/


  SELECT COUNT(*)
   FROM EMPLEADOS 
   WHERE DEPARTAMENTO IN (2,3,5);

SELECT  E.ID_EMPLEADO AS CLAVE_EMPLEADO,
        E.NOMBRE AS EMPLEADO,
        E.SALARIO AS SALARIO_EMPLEADO,
        ED.NOMBRE AS SU_DIRECTOR,
        ED.SALARIO AS SALARIO_SU_DIRECTOR,
        COUNT(DISTINCT EP.PROYECTO) AS NUMERO_DE_PROYECTOS,
        ES.NOMBRE AS SU_SUPERVISOR,
        COUNT(DISTINCT F.ID_FAMILIA) AS NUMERO_DE_FAMILIARES 
        
     FROM EMPLEADOS AS E INNER JOIN DEPARTAMENTOS AS D
                           ON  E.DEPARTAMENTO IN (2,3,5)
                                AND
                               E.DEPARTAMENTO=D.NUMERO
                            INNER JOIN EMPLEADOS AS ED
                             ON  D.DIRECTOR=ED.ID_EMPLEADO
                                LEFT JOIN EMPLEADOS_PROYECTOS AS EP
                                    ON E.ID_EMPLEADO=EP.EMPLEADO
                                     LEFT JOIN EMPLEADOS AS ES
                                       ON E.SUPERVISOR=ES.ID_EMPLEADO
                                        LEFT JOIN FAMILIARES AS F
                                         ON F.EMPLEADO=E.ID_EMPLEADO
     
     GROUP BY E.ID_EMPLEADO,EP.EMPLEADO
     ORDER BY E.ID_EMPLEADO;

/** tengo dos formas de localizar (seleccionar) a los supervisores**/

/**a*/
   SELECT    ES.NOMBRE AS SUPERVISOR,
             COUNT(*) AS NUMERO_SUPERVISADOS,
             AVG(E.SALARIO) AS SALARIO_MEDIO_SUPERVISADOS
      FROM EMPLEADOS AS ES INNER JOIN EMPLEADOS  AS E
                          ON ES.ID_EMPLEADO=E.SUPERVISOR
      GROUP BY ES.ID_EMPLEADO;
/**B**/
  /*  SELECT
       FROM  EMPLEADOS
       WHERE ID_EMPLEADO IN (/**LISTA DE CLAVES DE SUPERVISORES);*/
  
    SELECT    NOMBRE, SALARIO
       FROM  EMPLEADOS
       WHERE ID_EMPLEADO IN (SELECT   DISTINCT SUPERVISOR
                             FROM EMPLEADOS
                             WHERE SUPERVISOR IS NOT NULL);




/**65- PARA LOS EMPLEADOS QUE SON SUPERVISORES  OBTENER:

    NOMBRE, SALARIO, NOMBRE DE SU DEPARTAMENTO 
    Y CLAVE DE SU DIRECTOR
    CANTIDAD DE EMPLEADOS A LOS QUE SUPERVISA,
    MEDIA DE SALARIO DE SUS SUPERVISADOS,  
    CANTIDAD DE PROYECTOS  EN LOS QUE TRABAJA***/



SELECT    ES.NOMBRE  AS SUPERVISOR,
          ES.SALARIO AS SALARIO,
          D.NOMBRE AS SU_DEPARTAMENTO,
          D.DIRECTOR AS CLAVE_DE_SU_DIRECTOR,
          COUNT(DISTINCT E.ID_EMPLEADO) AS NUMERO_SUPERVISADOS,
          AVG(E.SALARIO) AS SALARIO_MEDIO_SUPERVISADOS,
          COUNT(DISTINCT EP.PROYECTO) AS NUMERO_PROYECTOS
          
     FROM EMPLEADOS AS ES INNER JOIN EMPLEADOS AS E
                                 ON ES.ID_EMPLEADO=E.SUPERVISOR
                                   INNER JOIN DEPARTAMENTOS AS D
                                      ON ES.DEPARTAMENTO=D.NUMERO
                                       LEFT JOIN EMPLEADOS_PROYECTOS AS EP
                                          ON ES.ID_EMPLEADO=EP.EMPLEADO


     GROUP BY ES.ID_EMPLEADO
     ORDER BY NUMERO_SUPERVISADOS DESC,SUM(EP.NUM_HORAS);


/***65 B- AÑADIR AL INFORME ANTERIOR CANTIDAD DE DEPARTAMENTOS
     DISTINTOS DE LOS SUPERVISADOS DE CADA SUPERVISOR**/
SELECT    ES.NOMBRE  AS SUPERVISOR,
          ES.SALARIO AS SALARIO,
          D.NOMBRE AS SU_DEPARTAMENTO,
          D.DIRECTOR AS CLAVE_DE_SU_DIRECTOR,
          COUNT(DISTINCT E.ID_EMPLEADO) AS NUMERO_SUPERVISADOS,
          AVG(E.SALARIO) AS SALARIO_MEDIO_SUPERVISADOS,
          COUNT(DISTINCT E.DEPARTAMENTO)  AS NUMERO_DEP_SUPERVISADOS,
          COUNT(DISTINCT EP.PROYECTO) AS NUMERO_PROYECTOS
          
     FROM EMPLEADOS AS ES INNER JOIN EMPLEADOS AS E
                                 ON ES.ID_EMPLEADO=E.SUPERVISOR
                                   INNER JOIN DEPARTAMENTOS AS D
                                      ON ES.DEPARTAMENTO=D.NUMERO
                                       LEFT JOIN EMPLEADOS_PROYECTOS AS EP
                                          ON ES.ID_EMPLEADO=EP.EMPLEADO


     GROUP BY ES.ID_EMPLEADO
     ORDER BY NUMERO_SUPERVISADOS DESC,SUM(EP.NUM_HORAS);


/**66- POR CADA DEPARTAMENTO (TODOS),
    SU CLAVE, SU NOMBRE,
    NOMBRE DE SU DIRECTOR,
    CANTIDAD DE EMPLEADOS ASIGNADOS,
    SALARIO MEDIO DEPARTAMENTO 
    CANTIDAD DE PROYECTOS CREADOS**/


SELECT    D.NUMERO AS CLAVE_DEPARTAMENTO,
          D.NOMBRE AS DEPARTAMENTO,
          ED.NOMBRE AS DIRECTOR,
          COUNT(DISTINCT E.ID_EMPLEADO) AS NUMERO_EMPLEADOS,
          AVG(E.SALARIO),
          COUNT(DISTINCT P.NUMERO)
     FROM DEPARTAMENTOS AS D INNER JOIN EMPLEADOS AS ED
                              ON D.DIRECTOR=ED.ID_EMPLEADO
                               LEFT JOIN EMPLEADOS AS E
                                      ON D.NUMERO=E.DEPARTAMENTO
                                         LEFT JOIN PROYECTOS AS P  
                                           ON D.NUMERO=P.DEPARTAMENTO
     GROUP BY D.NUMERO;                                  
                                        
 /*** AQUÍ OTRA**/


/**67- PARA CADA DIRECTOR/RA, 
    SU NOMBRE Y SALARIO,
    CANTIDAD DE EMPLEADOS DEL DEPARTAMENTO QUE DIRIGE,
    CANTIDAD DE PROYECTOS CREADOS POR SU DEPARTAMENTO
    Y CANTIDAD DE PROYECTOS EN LOS QUE TRABAJA EL DIRECTOR/RA**/   



SELECT DIR.NOMBRE, DIR.SALARIO, 
	COUNT(DISTINCT E.ID_EMPLEADO) AS NUM_EMP_DIRIGIDOS,
    COUNT(DISTINCT P.NUMERO) AS PROYECTOS
FROM DEPARTAMENTOS D, EMPLEADOS DIR, EMPLEADOS E, PROYECTOS P
WHERE D.DIRECTOR=DIR.ID_EMPLEADO
	AND E.DEPARTAMENTO=D.NUMERO
    AND P.DEPARTAMENTO=D.NUMERO
GROUP BY E.DEPARTAMENTO






/***67 B- AÑADIR CANTIDAD DE EMPLEADOS SUPERVISADOS DE SU
     DEPARTAMENTO**/



/**Los siguientes enunciados hasta el 68 son el 67 y 67B hechos poco a poco e incompletos**/

/**** NOMBRE Y SALARIO DE LOS DIRECTORES DE DEPARTAMENTO**/


SELECT   NOMBRE,
         SALARIO 
    FROM EMPLEADOS
    WHERE ID_EMPLEADO IN (SELECT  DIRECTOR
                            FROM DEPARTAMENTOS
                          );

/* ES UNA SUBCONSULTA ,  LA  SUBCONSULTA SE EJECUTA UNA VEZ***/


SELECT  ED.NOMBRE,
        ED.SALARIO
     FROM EMPLEADOS ED  INNER JOIN   DEPARTAMENTOS   D
                          ON  ED.ID_EMPLEADO=D.DIRECTOR ;/*(0,1)**/

/*** EN ESTE CASO, NO NECESITAMOS INFORMACIÓN DEL LADO DEPARTAMNETO,
     NO ES PRECISO COMBINAR LAS TUPLAS
     MÁS EFICIENTE PRIMERA FORMA**/


/** PARA LOS DIRECTORES DE DEPARTAMENTO,
     NOMBRE, SALARIO  Y CANTIDAD DE PROYECTOS 
     EN LOS QUE ESTÁ TRABAJANDO**/



SELECT    ED.NOMBRE,
          ED.SALARIO,
          COUNT(EP.PROYECTO) AS NUMERO_DE_PROYECTOS_TRABAJAN
    FROM EMPLEADOS AS ED  LEFT JOIN  EMPLEADOS_PROYECTOS AS EP
                              ON ED.ID_EMPLEADO=EP.EMPLEADO /*(0,N)**/
    WHERE ED.ID_EMPLEADO IN (
                              SELECT  DIRECTOR
                                FROM DEPARTAMENTOS 
                            )
 
    GROUP BY ED.ID_EMPLEADO;


/** PARA LOS DIRECTORES QUE TRABAJAN EN ALGÚN PROYECTO
     NOMBRE, SALARIO Y CANTIDAD DE PROYECTOS */

SELECT    ED.NOMBRE,
          ED.SALARIO,
          COUNT(EP.PROYECTO) AS NUMERO_DE_PROYECTOS_TRABAJAN
    FROM EMPLEADOS AS ED  INNER JOIN  EMPLEADOS_PROYECTOS AS EP
                        ON  ED.ID_EMPLEADO IN (
                                               SELECT  DIRECTOR
                                              FROM DEPARTAMENTOS 
                                              )
                                 AND
                            ED.ID_EMPLEADO=EP.EMPLEADO /*(0,N)**/
    
 
    GROUP BY ED.ID_EMPLEADO;



SELECT    ED.NOMBRE,
          ED.SALARIO,
          COUNT(EP.PROYECTO) AS NUMERO_DE_PROYECTOS_TRABAJAN
    FROM EMPLEADOS AS ED  INNER JOIN  EMPLEADOS_PROYECTOS AS EP
                              ON ED.ID_EMPLEADO=EP.EMPLEADO /*(0,N)**/
    WHERE ED.ID_EMPLEADO IN (
                              SELECT  DIRECTOR
                                FROM DEPARTAMENTOS 
                            )
 
    GROUP BY ED.ID_EMPLEADO;


/*** PARA LOS EMPLEADOS QUE SON SUPERVISORES, OBTENER:
     SU NOMBRE
     SU SALARIO,
     MES Y AÑO DE NACIMIENTO,
     LA CANTIDAD DE PROYECTOS EN LOS QUE TRABAJAN***/

 

SELECT   ES.NOMBRE,
         ES.SALARIO,
         MONTH(ES.FECHA_NAC),
         YEAR(ES.FECHA_NAC),
         COUNT(EP.PROYECTO) AS NUMERO_DE_PROYECTOS_TRABAJA
          
     FROM  EMPLEADOS AS ES  LEFT JOIN EMPLEADOS_PROYECTOS AS EP
                             ON ES.ID_EMPLEADO=EP.EMPLEADO

     WHERE ES.ID_EMPLEADO IN ( SELECT    DISTINCT SUPERVISOR
                               FROM EMPLEADOS
                               WHERE SUPERVISOR IS NOT NULL
                              )
    GROUP BY ES.ID_EMPLEADO  ;


/*** SUBCONSULTA***/

SELECT    DISTINCT SUPERVISOR
     FROM EMPLEADOS
     WHERE SUPERVISOR IS NOT NULL;


/*** OTRA FORMA SIN COMBINAR TABLA EMPLEADOS_PROYECTOS**/



SELECT   ES.NOMBRE,
         ES.SALARIO,
         MONTH(ES.FECHA_NAC),
         YEAR(ES.FECHA_NAC),
         (SELECT COUNT(*)
           FROM EMPLEADOS_PROYECTOS
           WHERE EMPLEADO=ES.ID_EMPLEADO
         )  AS NUMERO_PROYECTOS 
          
     FROM  EMPLEADOS AS ES  

     WHERE ES.ID_EMPLEADO IN ( SELECT    DISTINCT SUPERVISOR
                               FROM EMPLEADOS
                               WHERE SUPERVISOR IS NOT NULL
                              )
     ;

/***68- CANTIDAD DE PROYECTOS EN LOS QUE TRABAJAN LOS EMPLEADOS
     QUE SON DEL DEPARTAMNETO DE VENTAS Y  DE ADMINISTRACIÓN**/



SELECT
    FROM EMPLEADOS_PROYECTOS
    WHERE EMPLEADO IN (/**LISTA DE CLAVES DE EMPLEADO
                        ASIGNADOS A VENTAS Y A ADMINISTRACIÓ**/);



SELECT    COUNT(DISTINCT PROYECTO) AS NUMERO_DE_PROYECTOS
    FROM EMPLEADOS_PROYECTOS
    WHERE EMPLEADO IN (SELECT   ID_EMPLEADO
                        FROM EMPLEADOS
                        WHERE DEPARTAMENTO =(SELECT NUMERO
                                              FROM DEPARTAMENTOS
                                              WHERE NOMBRE='VENTAS'
                                             )
                              OR 
                              DEPARTAMENTO =(SELECT  NUMERO
                                              FROM DEPARTAMENTOS
                                              WHERE NOMBRE='ADMINISTRACION'
                                             )
                       );

/** DE FORMA PARECIDA*/

SELECT    COUNT(DISTINCT PROYECTO) AS NUMERO_DE_PROYECTOS
    FROM EMPLEADOS_PROYECTOS
    WHERE EMPLEADO IN (SELECT   ID_EMPLEADO
                        FROM EMPLEADOS
                        WHERE DEPARTAMENTO  
                              IN (SELECT NUMERO
                                    FROM DEPARTAMENTOS
                                    WHERE NOMBRE IN ('VENTAS','ADMINSTRACION')
                                                       
                                  )
                              
                       );

 /**69-PARA CADA PROYECTO OBTENER:
    (SÓLO PROYECTOS CON EMPLEADOS   
    TRABAJANDO EN ÉL)
    LA CANTIDAD DE EMPLEADOS QUE TIENE ASIGNADOS,
    EL NOMBRE DEL DEPARTAMENTO QUE LO CREA**/




 SELECT  EP.PROYECTO AS CLAVE_PROYECTO,
         COUNT(*) AS NUMERO_EMPLEADOS_ASIGNADOS,
         (SELECT  NOMBRE
           FROM DEPARTAMENTOS
           WHERE NUMERO = (SELECT  DEPARTAMENTO
                            FROM PROYECTOS
                            WHERE NUMERO=EP.PROYECTO
                          )
          )   AS DEPARTAMENTO
    FROM EMPLEADOS_PROYECTOS AS EP
    GROUP BY PROYECTO;
         
/***70- para los proyectos creados por dep de ventas, obtner total horas de trabajao
     y cantidad de empleados trabajando**//**69 B-
   MISMO INFORME:
    A) SIN TENER EN CUENTA EL TRABAJO DE LOS DIRECTORES
**/


SELECT  EP.PROYECTO AS CLAVE_PROYECTO,
         COUNT(*) AS NUMERO_EMPLEADOS_ASIGNADOS,
         (SELECT  NOMBRE
           FROM DEPARTAMENTOS
           WHERE NUMERO = (SELECT  DEPARTAMENTO
                            FROM PROYECTOS
                            WHERE NUMERO=EP.PROYECTO
                          )
          )   AS DEPARTAMENTO
    FROM EMPLEADOS_PROYECTOS AS EP
    WHERE EMPLEADO NOT IN ()
    GROUP BY PROYECTO;

/**** 69 C-MISMO INFORME:
     b) SÓLO PARA LOS PROYECTOS EN LOS QUE TRABAJEN MÁS DE 3 
        EMPLEADOS**/


/** 69 D-MISMO INFORME
     C) SÓLO PARA LOS PROYECTOS CREADOS POR DEPARTAMENTOS
        DE MÁS DE 3 EMPLEADOS
**/









SELECT  COUNT(DISTINCT EMPLEADO ) AS NUMERO_EMPLEADOS,
        SUM(NUM_HORAS) AS TOTAL_HORAS,
        COUNT(DISTINCT PROYECTO) AS NUMERO_DE_PROYECTOS
        
    FROM EMPLEADOS_PROYECTOS
    WHERE PROYECTO IN(SELECT  NUMERO
                       FROM PROYECTOS
                       WHERE DEPARTAMENTO=(SELECT NUMERO
                                             FROM DEPARTAMENTOS
                                             WHERE NOMBRE='VENTAS'
                                            )                                         
                     );




/* 71-PARA CADA PROYECTO CREADO POR  EL DEP DE VENTAS, NUMERO DE EMPLEADOS
    TRABAJANDO Y TOTAL HORAS DE TRABAJO**/

SELECT   PROYECTO AS CLAVE_PROYECTO,
         COUNT(*) AS NUMERO_EMPLEADOS,
         SUM(NUM_HORAS) AS TOTAL_HORAS_PROYECTO
    
        
    FROM EMPLEADOS_PROYECTOS
    WHERE PROYECTO IN(SELECT  NUMERO
                       FROM PROYECTOS
                       WHERE DEPARTAMENTO=(SELECT NUMERO
                                             FROM DEPARTAMENTOS
                                             WHERE NOMBRE='VENTAS'
                                            )                                         
                     )
   GROUP BY PROYECTO;





        72-  INFORME DE:
        POR CADA EMPLEADO(TODOS) OBTENER:
        SU CLAVE, NOMBRE Y SALARIO
        NOMBRE DE SU DEPARTAMENTO,
        CANTIDAD DE PROYECTOS EN LOS QUE TRABAJA,
        CANTIDAD DE EMPLEADOS A LOS QUE SUPERVISA



SELECT     E.ID_EMPLEADO  AS CLAVE_EMPLEADO,
           E.NOMBRE AS EMPLEADO,
           E.SALARIO AS SUELDO,
           D.NOMBRE AS  SU_DEPARTAMENTO,
           COUNT( DISTINCT EP.PROYECTO) AS NUMERO_PROYECTOS_TRABAJA,
           COUNT(DISTINCT ESADOS.ID_EMPLEADO)  AS NUMERO_DE_SUPERVISADOS
     FROM EMPLEADOS AS E INNER JOIN DEPARTAMENTOS AS D
                          ON E.DEPARTAMENTO=D.NUMERO
                            LEFT JOIN EMPLEADOS_PROYECTOS AS EP
                                   ON  E.ID_EMPLEADO=EP.EMPLEADO
                                    LEFT JOIN EMPLEADOS AS ESADOS
                                      ON ESADOS.SUPERVISOR=E.ID_EMPLEADO
     GROUP BY E.ID_EMPLEADO;



/***********************************************************/


CREATE VIEW VISTA_EMPLEADOS
          AS  SELECT     E.ID_EMPLEADO  AS CLAVE_EMPLEADO,
                         E.NOMBRE AS EMPLEADO,
                         E.SALARIO AS SUELDO,
                         D.NOMBRE AS  SU_DEPARTAMENTO,
                         COUNT( DISTINCT EP.PROYECTO) AS NUMERO_PROYECTOS_TRABAJA,
                         COUNT(DISTINCT ESADOS.ID_EMPLEADO)  AS NUMERO_DE_SUPERVISADOS
              FROM EMPLEADOS AS E INNER JOIN DEPARTAMENTOS AS D
                          ON E.DEPARTAMENTO=D.NUMERO
                            LEFT JOIN EMPLEADOS_PROYECTOS AS EP
                                   ON  E.ID_EMPLEADO=EP.EMPLEADO
                                    LEFT JOIN EMPLEADOS AS ESADOS
                                      ON ESADOS.SUPERVISOR=E.ID_EMPLEADO
              GROUP BY E.ID_EMPLEADO; 
 /** CONSULTAMOS SOBRE LA VISTA**/

/**73- OBTENER PARA LOS EMPLEADOS QUE SON SUPERVISORES 
     Y QUE TRABAJA EN MÁS DE 2 PROYECTOS
    SU CLAVE. SALARIO, CANTIDAD DE PROYECTOS
    Y CANTIDAD DE SUPERVISADOS**/


/** HAY CREADA UNA VISTA LLAMADA VISTA_EMPLEADOS Y TENEMOS ACCESO A ELLA**/
SELECT        CLAVE_EMPLEADO,
              SUELDO,
              NUMERO_PROYECTOS_TRABAJA
     FROM  VISTA_EMPLEADOS
     WHERE  NUMERO_DE_SUPERVISADOS !=0
            AND
            NUMERO_PROYECTOS_TRABAJA>2;



   SELECT     CLAVE_EMPLEADO,
              SUELDO,
              NUMERO_PROYECTOS_TRABAJA,
              NUMERO_DE_SUPERVISADOS
       FROM VISTA_EMPLEADOS
       WHERE  NUMERO_PROYECTOS_TRABAJA>2;
 


/* 74- NOMBRES DE EMPLEADO CUYO SALARIO
    ES MAYOR QUE EL SALARIO  MEDIO DE LA EMPRESA**/


    SELECT  NOMBRE
         FROM EMPLEADOS
         WHERE SALARIO>(SELECT AVG(SALARIO)
                        FROM EMPLEADOS);

/** HEMOS UTILIZADO UNA SUBCONSULTA, SE EJECUTA PRIMERO Y UNA VEZ**/


/**75-NOMBRES DE EMPLEADOS
   CUYO SALARIO ES MAYOR QUE 
  EL SALARIO MEDIO  SELECT DE SU DEPARTAMENTO**/ 


SELECT   NOMBRE
    FROM EMPLEADOS AS E
    WHERE E.SALARIO>(SELECT AVG(SALARIO)
                    FROM EMPLEADOS
                    WHERE DEPARTAMENTO=E.DEPARTAMENTO);




/***** INTENTAR HACER*****/
/****76- PARA LOS EMPLEADOS 
      CUYO SALARIO SEA MAYOR QUE EL SALARIO
      MEDIO DE SU DEPARTAMENTO, OBTENER:
      SU CLAVE
      LA CANTIDAD DE  PROYECTOS EN LOS QUE TRAbaja
      LA CANTIDAD DE HORAS QUE TRABAJA 
      EN LOS DISTINTOS PROYECTOS
**/

SELECT   ID_EMPLEADO,
         NOMBRE,
         COUNT(EP.PROYECTO) AS NUMERO_PROYECTOS,
         SUM(NUM_HORAS) AS TOTAL_HORAS_TRABAJO
     FROM EMPLEADOS E LEFT JOIN EMPLEADOS_PROYECTOS EP
                       ON E.ID_EMPLEADO=EP.EMPLEADO
     WHERE E.ID_EMPLEADO IN (SELECT E2.ID_EMPLEADO
                             FROM EMPLEADOS E2
                             WHERE E2.SALARIO>
                                     (SELECT AVG(SALARIO)
                                       FROM EMPLEADOS
                                       WHERE DEPARTAMENTO=E2.DEPARTAMENTO
                                     )
                            )
     GROUP BY E.ID_EMPLEADO;   

/**77-  LA MISMA CONSULTA MEJOR TODAVÍA***/


SELECT   ID_EMPLEADO,
         NOMBRE,
         COUNT(EP.PROYECTO) AS NUMERO_PROYECTOS,
         SUM(NUM_HORAS) AS TOTAL_HORAS_TRABAJO
     FROM EMPLEADOS E LEFT JOIN EMPLEADOS_PROYECTOS EP
                       ON E.ID_EMPLEADO=EP.EMPLEADO
     WHERE E.SALARIO>  (SELECT AVG(SALARIO)
                         FROM EMPLEADOS
                         WHERE DEPARTAMENTO=E.DEPARTAMENTO
                       )
                            
     GROUP BY E.ID_EMPLEADO;   



SELECT   ID_EMPLEADO,
         NOMBRE,
         COUNT(EP.PROYECTO) AS NUMERO_PROYECTOS,
         SUM(NUM_HORAS) AS TOTAL_HORAS_TRABAJO
     FROM  EMPLEADOS_PROYECTOS EP  RIGHT JOIN  EMPLEADOS E
                       ON EP.EMPLEADO=E.ID_EMPLEADO
     WHERE E.ID_EMPLEADO IN (SELECT E2.ID_EMPLEADO
                             FROM EMPLEADOS E2
                             WHERE E2.SALARIO>
                                     (SELECT AVG(SALARIO)
                                       FROM EMPLEADOS
                                       WHERE DEPARTAMENTO=E2.DEPARTAMENTO
                                     )
                            )
     GROUP BY E.ID_EMPLEADO;  


/*** VAMOS A CREAR UNA VISTA PARA JEFE DE VENTAS*****/
    /**78-PARA CADA EMPLEADO ASIGNADO AL DEPARTAMENTO DE VENTAS
       SU CLAVE.
       SU NOMBRE,
       SU SALARIO,
       SU NIF ** UNICO*
       SU NSS ++UNICO
       CLAVE DE SU SUPERVISOR

**/

SELECT   ID_EMPLEADO,
         NOMBRE,
         COUNT(EP.PROYECTO) AS NUMERO_PROYECTOS,
         SUM(NUM_HORAS) AS TOTAL_HORAS_TRABAJO
     FROM EMPLEADOS E LEFT JOIN EMPLEADOS_PROYECTOS EP
                       ON E.ID_EMPLEADO=EP.EMPLEADO
     WHERE E.ID_EMPLEADO IN (SELECT E2.ID_EMPLEADO
                             FROM EMPLEADOS E2
                             WHERE E2.SALARIO>
                                     (SELECT AVG(SALARIO)
                                       FROM EMPLEADOS
                                       WHERE DEPARTAMENTO=E2.DEPARTAMENTO
                                     )
                            )
     GROUP BY E.ID_EMPLEADO;   

/**** NOMBRE DEPARTAMENTO TIENE RESTRICCIÓN DE UNICIDAD*/

CREATE VIEW EMPLEADOS_VENTAS 
   AS SELECT   ID_EMPLEADO,
               NOMBRE,
               NIF,
               NSS,
               SALARIO,
               SUPERVISOR
         FROM EMPLEADOS
         WHERE DEPARTAMENTO=(SELECT NUMERO
                              FROM DEPARTAMENTOS
                              WHERE NOMBRE='VENTAS') ; 
               
/*** ESTA VISTA (PARA EL JEFE DE VENTAS) ES ACTUALIZABLE--->
     DESDE ELLA PUEDO ACTUALIZAR LA TABLA EMPLEADOS**/

SELECT * FROM EMPLEADOS_VENTAS;

/**79- SUBIR EL SALARIO A LOS EMPLEADOS DE VENTAS
    A LOS EMPLEADOS SIN SUPERVISOR*/ 
 
  UPDATE EMPLEADOS_VENTAS
    SET SALARIO=SALARIO+SALARIO*1.2/100
    WHERE SUPERVISOR IS NULL ;
          
   
CREATE VIEW EMPLEADOS_MARKETING 
   AS SELECT   ID_EMPLEADO,
               NOMBRE,
               NIF,
               NSS,
               SALARIO,
               SUPERVISOR
         FROM EMPLEADOS
         WHERE DEPARTAMENTO=(SELECT NUMERO
                              FROM DEPARTAMENTOS
                              WHERE NOMBRE='MARKETING'); 


SELECT * FROM EMPLEADOS_MARKETING;


/****80- para cada empleado que sea supervisor, obtener
     su clave, nombre,salario, 
     vista_empleadosnumero de proyectos en los que trabaja,
     numero de supervisados y
     cantidad de familiares que ha registrado
 ***/
/***** a) disponemos de acceso a la vista vista_empleados**/

  SELECT   VE.CLAVE_EMPLEADO,
           VE.EMPLEADO,
           VE.SUELDO,
           VE.NUMERO_PROYECTOS_TRABAJA,
           VE.NUMERO_DE_SUPERVISADOS,
           COUNT(F.ID_FAMILIA) AS NUMERO_FAMILIARES
      FROM VISTA_EMPLEADOS AS VE LEFT JOIN  FAMILIARES AS F
                                 ON VE.CLAVE_EMPLEADO=F.EMPLEADO 
      WHERE NUMERO_DE_SUPERVISADOS!=0
      GROUP BY VE.CLAVE_EMPLEADO, F.EMPLEADO;




/**** B) REALIZAR CONSULTA SIN USO DE LA VISTA, NO EXISTE LA VISTA
      O NO DIPONEMOS DE ACCESO A ELLA

     para cada empleado que sea supervisor, obtener
     su clave, nombre,salario, numero de proyectos en los que trabaja,
     numero de supervisados y cantidad de familiares que
 **/

SELECT     ES.ID_EMPLEADO,
           ES.NOMBRE,
           ES.SALARIO,
           COUNT(DISTINCT EP.PROYECTO) AS NUMERO_DE_PROYECTOS_TRABAJA,
           COUNT(DISTINCT E.ID_EMPLEADO) AS NUMERO_SUPERVISADOS,
           COUNT(DISTINCT F.ID_FAMILIA) AS NUMERO_DE_FAMILIARES
   FROM EMPLEADOS AS ES INNER JOIN EMPLEADOS AS E
                         ON ES.ID_EMPLEADO=E.SUPERVISOR
                            LEFT JOIN EMPLEADOS_PROYECTOS AS EP
                              ON ES.ID_EMPLEADO=EP.EMPLEADO
                                 LEFT JOIN FAMILIARES AS F
                                   ON ES.ID_EMPLEADO=F.EMPLEADO

   GROUP BY ES.ID_EMPLEADO;



/***81- VAMOS A SUPONER QUE OS DIGO::
      NO COMBINAR LA TABLA FAMILIARES**/

SELECT     ES.ID_EMPLEADO,
           ES.NOMBRE,
           ES.SALARIO,
           COUNT(DISTINCT EP.PROYECTO) AS NUMERO_DE_PROYECTOS_TRABAJA,
           COUNT(DISTINCT E.ID_EMPLEADO) AS NUMERO_SUPERVISADO,
           (SELECT COUNT(*)
              FROM  FAMILIARES
              WHERE EMPLEADO=ES.ID_EMPLEADO
           )                             AS NUMERO_DE_FAMILIARES
           
   FROM EMPLEADOS AS ES INNER JOIN EMPLEADOS AS E
                         ON ES.ID_EMPLEADO=E.SUPERVISOR
                            LEFT JOIN EMPLEADOS_PROYECTOS AS EP
                              ON ES.ID_EMPLEADO=EP.EMPLEADO
                                 

   GROUP BY ES.ID_EMPLEADO;



/******* las vista empleados_ventas y empleados_marketing
         son actualizables******/

/***82- al empleado de clave 10 le cambiamos su supervisor pasa a ser el empleado de
     clave 3**/


select * from empleados_marketing;


update empleados_marketing
   set supervisor=3
   where id_empleado=10;

select * from empleados
      where id_empleado=10;

select * from empleados_marketing;



alter table empleados
     add foreign key(departamento) references departamentos(numero)
           on delete restrict
           on update cascade;

alter table empleados_proyectos
      add foreign key(empleado) references empleados(id_empleado)
           on delete cascade
           on update cascade;

/*** soy usuario "jefe de ventas", no tengo acceso a tabla empleados
     si a vista empleados_ventas***/


/***83- eliminar  DE LA BASE DE DATOS  al empleado de clave 18



**/



select * from empleados_ventas;

select count(*) from empleados_proyectos
      where empleado= 18;

DELETE FROM EMPLEADOS_VENTAS
WHERE ID_EMPLEADO=18; 


SELECT * FROM EMPLEADOS
    WHERE ID_EMPLEADO=18; 
/**** SE EJECUTO UN BORRADO EN CASCADA EN TABLA EMPLEADOS_PROYECTOS**/
 select count(*) from empleados_proyectos
      where empleado= 18;


/***84- AHORA VAMOS A INTENTAR REGISTRAR UNA NUEVA TUPLA EN EMPLEADOS
     PERO DESDE VISTA  EMPLEADOS_VENTAS****/
     


drop view empleados_ventas;


create view empleados_ventas
as  SELECT   ID_EMPLEADO,
               NOMBRE,
               NIF,
               NSS,
               SALARIO,
               SUPERVISOR, 
               DEPARTAMENTO
         FROM EMPLEADOS
         WHERE DEPARTAMENTO=(SELECT NUMERO
                              FROM DEPARTAMENTOS
                              WHERE NOMBRE='VENTAS') ; 
               

INSERT INTO EMPLEADOS_VENTAS
(ID_EMPLEADO,NOMBRE,NIF,NSS,SALARIO, SUPERVISOR,DEPARTAMENTO)
VALUES
(NULL, 'ANA MARIA FERNANDEZ GIMENEZ','888888888','000088888888',2300,NULL,2);



SELECT * FROM EMPLEADOS
  WHERE ID_EMPLEADO=24;
/** LA VEMOS EN TABLA EMPLEADOS**/





/***85- OBTENER UNA VISTA DENOMINADA VISTA_PROYECTOS
   QUE OBTENGA PARA CADA PROYECTO
    SU CLAVE Y NOMBRE
    CLAVE Y NOMBRE DEL DEPARTAMENTO QUE LO CREA,
    CANTIDAD DE EMPLEADOS TRABAJANDO EN ÉL EN ESTE INSTANTE,
    CANTIDAD DE DEPARTAMENTOS IMPLICADOS EN EL PROYECTO,
    MES , DIA Y AÑO DE LA FECHA MÁS ANTIGUA DE TRABAJO EN ÉL
    CANTIDAD DE DÍAS TRANSCURRIDOS DESDE FECHA PRIMERA
    A DIA DE HOY

*****/

SELECT   P.NUMERO AS CLAVE_PROYECTO,
         P.NOMBRE AS PROYECTO,
         D.NOMBRE AS DEPARTAMENTO_CREA, 
         COUNT(*) AS NUMERO_EMPLEADOS_TRABAJAN,
         MONTH(MIN(EP.FECHA_INICIO)) AS PRIMER_MES_TRABAJO,
         YEAR(MIN(EP.FECHA_INICIO)) AS PRIMER_AÑO_TRABAJO
           
    FROM PROYECTOS AS P INNER JOIN DEPARTAMENTOS AS D
                         ON P.DEPARTAMENTO=D.NUMERO
                           LEFT JOIN EMPLEADOS_PROYECTOS AS EP
                             ON P.NUMERO=EP.PROYECTO

   GROUP BY P.NUMERO;
/**86-LA MISMA CONSULTA SIN COMBINAR TABLA DEPARTAMENTOS***/


SELECT   P.NUMERO AS CLAVE_PROYECTO,
         P.NOMBRE AS PROYECTO,
         (
           SELECT   NOMBRE
            FROM DEPARTAMENTOS
            WHERE NUMERO=P.DEPARTAMENTO
          
          )  AS DEPARTAMENTO_CREA,
         COUNT(*) AS NUMERO_EMPLEADOS_TRABAJAN,
         MONTH(MIN(EP.FECHA_INICIO)) AS PRIMER_MES_TRABAJO,
         YEAR(MIN(EP.FECHA_INICIO)) AS PRIMER_AÑO_TRABAJO
         
           
    FROM PROYECTOS AS P 
                           LEFT JOIN EMPLEADOS_PROYECTOS AS EP
                             ON P.NUMERO=EP.PROYECTO

   GROUP BY P.NUMERO;

/*** SEGUIMOS... PARA SOLUCIÓN**/
SELECT   P.NUMERO AS CLAVE_PROYECTO,
         P.NOMBRE AS PROYECTO,
         (
           SELECT   NOMBRE
            FROM DEPARTAMENTOS
            WHERE NUMERO=P.DEPARTAMENTO
          
          )  AS DEPARTAMENTO_CREA,
         COUNT(*) AS NUMERO_EMPLEADOS_TRABAJAN,
         MONTH(MIN(EP.FECHA_INICIO)) AS PRIMER_MES_TRABAJO,
         YEAR(MIN(EP.FECHA_INICIO)) AS PRIMER_AÑO_TRABAJO,
         COUNT(DISTINCT E.DEPARTAMENTO) AS NUMERO_DEPARTAMENTOS_IMPLICADOS,
         DATEDIFF(CURRENT_DATE(),MIN(EP.FECHA_INICIO)) AS NUMERO_DIAS_TRABAJO
           
    FROM PROYECTOS AS P LEFT JOIN EMPLEADOS_PROYECTOS AS EP
                             ON P.NUMERO=EP.PROYECTO
                                 INNER JOIN EMPLEADOS AS E
                                   ON EP.EMPLEADO=E.ID_EMPLEADO

   GROUP BY P.NUMERO;



CREATE VIEW VISTA_PROYECTOS
    AS 
       SELECT   P.NUMERO AS CLAVE_PROYECTO,
         P.NOMBRE AS PROYECTO,
         (
           SELECT   NOMBRE
            FROM DEPARTAMENTOS
            WHERE NUMERO=P.DEPARTAMENTO
          
          )  AS DEPARTAMENTO_CREA,
         COUNT(*) AS NUMERO_EMPLEADOS_TRABAJAN,
         MONTH(MIN(EP.FECHA_INICIO)) AS PRIMER_MES_TRABAJO,
         YEAR(MIN(EP.FECHA_INICIO)) AS PRIMER_AÑO_TRABAJO,
         COUNT(DISTINCT E.DEPARTAMENTO) AS NUMERO_DEPARTAMENTOS_IMPLICADOS,
         DATEDIFF(CURRENT_DATE(),MIN(EP.FECHA_INICIO)) AS NUMERO_DIAS_TRABAJO
           
    FROM PROYECTOS AS P LEFT JOIN EMPLEADOS_PROYECTOS AS EP
                             ON P.NUMERO=EP.PROYECTO
                                 INNER JOIN EMPLEADOS AS E
                                   ON EP.EMPLEADO=E.ID_EMPLEADO

   GROUP BY P.NUMERO; 




/*** LISTA DE SALARIOS DE LOS DIRECTORES***/


SELECT   SALARIO
     FROM EMPLEADOS
     WHERE ID_EMPLEADO IN (    SELECT   DIRECTOR
                                  FROM DEPARTAMENTOS
                           );

/****** ASÍ PORQUE COLUMNA DIRECTOR TIENE RESTRICCCIÓN DE UNICIDAD**/


/*** LA COLUMNA DIRECTOR NO ES ÚNICO    

SELECT DISTINCT DIRECTOR FROM DEPARTAMENTOS;
     ***/


/**87- NOMBRES DE EMPLEADOS CUYO SALARIO ES = AL SALARIO
    DE ALGÚN DIRECTOR****/ 

SELECT   NOMBRE
    FROM EMPLEADOS
    WHERE ID_EMPLEADO NOT IN (SELECT   DIRECTOR
                               FROM DEPARTAMENTOS
                             )
          AND

          SALARIO IN ( 
                        SELECT   SALARIO
                    FROM EMPLEADOS
                     WHERE ID_EMPLEADO IN (    SELECT   DIRECTOR
                                                 FROM DEPARTAMENTOS
                                           )
                      );

/**88- NOMBRES DE LOS EMPLEADOS CUYO SALARIO
   ES MAYOR QUE EL DE ALGÚN DIRECTOR**/

SELECT   NOMBRE
    FROM EMPLEADOS
    WHERE ID_EMPLEADO NOT IN (SELECT   DIRECTOR
                               FROM DEPARTAMENTOS
                             )
          AND

          SALARIO >ANY ( 
                        SELECT   SALARIO
                        FROM EMPLEADOS
                        WHERE ID_EMPLEADO IN ( SELECT   DIRECTOR
                                                FROM DEPARTAMENTOS
                                              )
                      );


/**89- CUÁNTOS EMPLEADOS HAY CUYO SALARIO ES MAYOR QUE EL SALARIO DE UN DIRECTOR*/

SELECT   COUNT(*)
    FROM EMPLEADOS
    WHERE ID_EMPLEADO NOT IN (SELECT   DIRECTOR
                               FROM DEPARTAMENTOS
                             )
          AND

          SALARIO >ALL ( 
                        SELECT   SALARIO
                        FROM EMPLEADOS
                        WHERE ID_EMPLEADO IN ( SELECT   DIRECTOR
                                                FROM DEPARTAMENTOS
                                              )
                      );










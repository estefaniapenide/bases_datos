/*---- Para 1:N -----*/

SELECT L.titulo, LL.nombre
FROM libros L, bibliotecas LL
WHERE L.id_biblioteca=LL.id_biblioteca 
	AND L.id_biblioteca=1;

SELECT L.titulo, LL.nombre
FROM libros L INNER JOIN bibliotecas LL ON L.id_biblioteca=LL.id_biblioteca
WHERE L.id_biblioteca=1;

SELECT L.titulo, LL.nombre
FROM libros L INNER JOIN bibliotecas LL USING (id_biblioteca)
WHERE L.id_biblioteca=1;

/* --------------- N:M ---------------- */

SELECT L.titulo, B.nombre
FROM libros L, bibliotecas B, libros_bibliotecas LB
WHERE L.id_libro=LB.id_libro AND B.id_biblioteca=LB.id_biblioteca;

SELECT L.titulo, B.nombre
FROM libros L INNER JOIN libros_bibliotecas LB ON L.id_libro=LB.id_libro
	INNER JOIN bibliotecas B ON B.id_biblioteca=LB.id_biblioteca;
    
SELECT L.titulo, B.nombre
FROM libros L INNER JOIN libros_bibliotecas LB USING (id_libro)
	INNER JOIN bibliotecas B USING (id_biblioteca);




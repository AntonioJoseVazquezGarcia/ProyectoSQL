--01.Crea el esquema de la BBDD.

--(el esquema de la base de datos se ha recogido en fichero independiente, al tratarse de una imagen de
--las tablas junto con las relaciones entre las mismas. Así, aparecerá como un fichero entregable independiente).

--02.Muestra nombres de todas las películas con una clasificación por edades de 'R'.

SELECT "title"
FROM "film"
WHERE "rating" ='R'
;

--03.Encuentra los nombres de los actores que tengan un "actor_id" entre 30 y 40.

SELECT "actor_id", CONCAT("first_name", ' ', "last_name") AS "Nombre_Actor" --usamos el alias para añadir claridad en el resultado
FROM "actor"
WHERE "actor_id" BETWEEN 30 AND 40
ORDER BY "actor_id"  ASC  --hemos incluido en el listado el campo actor_id para comprobar los resultados y ordenarlos
;

--04.Obtén las películas cuyo idioma coincide con el idioma original.

SELECT f."title"
FROM "film" f 
INNER JOIN "language" l 
	ON l."language_id" = f."language_id"
;

--05.Ordena las películas por duración de forma ascendente.

SELECT f."title" AS "Título", f."length" AS "Duración"
FROM "film" f 
ORDER BY f."length" ASC, f."title" ASC --hemos incluido una ordenación alfabética para los films con la misma duración
;

--06.Encuentra el nombre y apellido de los actores que tengan 'Allen' en su apellido.

SELECT CONCAT(a."first_name",' ',a."last_name") AS "Nombre_Actor"
FROM "actor" a 
WHERE a."last_name" LIKE '%ALLEN%' --en el enunciado de la consulta indica 'Allen', y si lo ponemos como tal NO se obtienen
;                                  --resultados ya que los valores en los nombres de la base de datos están en mayúsculas.
								   --Entendemos se trata de una errata y, con objeto de obtener resultados, hemos puesto
								   --el apellido en mayúsculas.
								   			
--07.Encuentra la cantidad total de películas en cada clasificación de la tabla "film" y muestra la clasificación junto
--con el recuento.

SELECT f."rating" AS "Clasificación", COUNT(f."rating") AS "Recuento"
FROM "film" f
GROUP BY f."rating"
ORDER BY f."rating" 
;

--08.Encuentra el título de todas las películas que son 'PG-13' o tienen una duración mayor a 3 horas en la tabla film.

SELECT f."title" AS "Título", f."rating" AS "Clasificación", f."length" AS "Duración"
FROM "film" f
WHERE f."rating" = 'PG-13' OR f."length">(3*60) 
ORDER BY f."length", f."rating"  --hemos incluido estas columnas adicionales para comprobar los datos devueltos por la consulta,
;                                --pero podrían omitirse una vez realizada la comprobación. 

--09.Encuentra la variabilidad de lo que costaría reemplazar las películas.

SELECT ROUND(VARIANCE(f."replacement_cost"),2) AS "Varianza", --aunque la variabilidad se mide con la Varianza, para una mejor
       ROUND(AVG(f."replacement_cost"),2) AS "Coste_Promedio", --comprensión de los resultados, es muy aclarativo incluir
	   ROUND(STDDEV(f."replacement_cost"),2) AS "Desviación_Estándar",--otros indicadores como los que hemos agregado en
       ROUND(MAX(f."replacement_cost"),2) AS "Coste_Máximo",     --esta consulta, a saber: promedio, desviación estándar,
       ROUND(MIN(f."replacement_cost"),2) AS "Coste_Mínimo"    --máximo y mínimo. Además, hemos redondeado los resultados  
FROM "film" f                                    --porque un exceso de decimales no nos aporta más valor a nuestro análisis. 
;
	
--10.Encuentra la mayor y menor duración de una película de nuestra BBDD.

SELECT MIN(f."length") AS "Duración_mínima", Max(f."length") AS "Duración_Máxima"
FROM "film" f 
;

--11.Encuentra lo que costó el antepenúltimo alquiler ordenado por día.

SELECT r."rental_id", r."rental_date" --Montamos primero una consulta que busca el antepenúltimo alquiler ordenado
FROM "rental" r                     --por día e incluimos el id para comprobar que se obtiene el resultado deseado.  
ORDER BY r."rental_date" DESC       --Después la usaremos como subconsulta en el WHERE de la consulta 
LIMIT 1                             --principal. Al usarla, sólo dejaremos una variable en el SELECT porque nos tiene
OFFSET 2                            --que devolver un único valor)
;

SELECT f."rental_rate", r."rental_id", r."rental_date", f."film_id" --Hemos incluido algunos campos adicionales
FROM "film" f 														--que nos permiten comprobar los resultados	
INNER JOIN "inventory" i ON i."film_id" =f."film_id"                --pero si queremos aligerar la consulta, podemos
INNER JOIN "rental" r ON r."inventory_id" = i."inventory_id"        --prescindir de ellos.
WHERE r."rental_id" = 												--Aquí lo más importante entendemos que es enlazar
		(SELECT r."rental_id" 										--las tablas y la subconsulta correctamente.
		FROM "rental" r                      
		ORDER BY r."rental_date" DESC
		LIMIT 1
		OFFSET 2)
;

--12.Encuentra el título de las películas en la tabla "film" que no sean ni "NC-17" ni "G" en cuanto a su clasificación

SELECT f."title", f."rating"                        --Como en anteriores consultas, incluimos el campo de clasificación
FROM "film" f										--para luego comprobar que los resultados son correctos, aunque no
WHERE f."rating" <> 'NC-17' AND f."rating" <>'G'    --se solicite expresamente en el enunciado de la consulta.
ORDER BY f."rating" ASC 
;

--13.Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la 
--clasificación junto con el promedio de duración.

SELECT f."rating" AS "Clasificación", Round(AVG(f."length"),2) AS "Promedio_Duración"
FROM "film" f 
GROUP BY f."rating"
ORDER BY f."rating"
;

--14.Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.

SELECT f."title", f."length"
FROM "film" f
WHERE f."length" >180
;

--15.¿Cuánto dinero ha generado en total la empresa?

SELECT SUM(p."amount") AS "Total_pagos"   --Entendemos que el dinero generado se corresponde con el total de los ingresos
FROM "payment" p                          --efectivamente computados.
;

--16.Muestra los 10 clientes con mayor valor de id.

SELECT c."customer_id"
FROM "customer" c 
ORDER BY c."customer_id" DESC
LIMIT 10
;

--17.Encuentra el nombre y apellido de los actores que aparecen en la película con título 'Egg Igby'

SELECT concat(a.first_name,' ', a.last_name) AS Nombre_actor, f.title AS "Película"
FROM actor a
INNER JOIN film_actor fa ON fa.actor_id =a.actor_id 
INNER JOIN film f ON fa.film_id =f.film_id 
WHERE f.title ='EGG IGBY'            
;

--18.Selecciona todos los nombres de las películas únicos.

SELECT DISTINCT (f.title)
FROM film f 
;

--19.Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla "film"

SELECT f."title" AS "Título", f."length" AS "Duración", c."name" AS Categoría
FROM film f 
INNER JOIN film_category fc ON fc.film_id = f.film_id
INNER JOIN category c ON fc.category_id =c.category_id
WHERE c."name" ='Comedy' AND f.length>180
;

--20.Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre
--de la categoría junto con el promedio de duración.

SELECT c."name" AS "Cat_Peli", Round(AVG(f."length"),0) AS "Duración" 
FROM film f 
INNER JOIN film_category fc ON fc.film_id = f.film_id
INNER JOIN category c ON fc.category_id =c.category_id
WHERE  f.length>110
GROUP BY c."name"
ORDER BY c."name"
;

--21.¿Cuál es la media de duración del alquiler de las películas?

SELECT round(AVG(f.rental_duration),1) AS Dur_Med_Alq
FROM film f 
;

--22.Crea una columna con el nombre y apellidos de todos los actores y actrices.

SELECT CONCAT(first_name, ' ', last_name) AS Nom_Actor_Actriz
FROM actor a 
ORDER BY Nom_Actor_Actriz
;

--23.Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.

SELECT COUNT(r.rental_id) AS "Num_Alq_Dia", CAST(r.rental_date AS DATE) AS "Dia"
FROM rental r 
GROUP BY CAST(r.rental_date AS DATE)           --En este caso, como queremos ordenar por día y el campo que tenemos es
ORDER BY "Num_Alq_Dia" DESC                      --fecha-hora, tenemos que hacer una conversión de datos para quedarnos sólo
;                                              --con la parte de la fecha. Para ello, usamos la función CAST.

--24.Encuentra las películas con una duración superior al promedio.

CREATE VIEW Duración_Media AS                   --Hemos creado una vista que nos calcula la duración media de las películas,
	SELECT ROUND(AVG(f.length),2)               --y ya la tenemos generada por si nos hace falta en algún otro momento,
	FROM film f 
	;

SELECT f.title, f.length                        --y luego la usamos en la consulta principal como una condición en el WHERE.
FROM film f 
WHERE f.length > (SELECT *
                  FROM Duración_Media)
ORDER BY F.length
;

--25.Averigua el número de alquileres registrados por mes.

SELECT COUNT(r."rental_id") AS "Num_Alq_Mes", EXTRACT (MONTH FROM CAST(r.rental_date AS DATE)) AS "Mes",
											EXTRACT (YEAR FROM CAST(r.rental_date AS DATE)) AS "Año"
FROM "rental" r 
GROUP BY "Mes","Año"                    --En este caso, como queremos ordenar por mes y el campo que tenemos es
ORDER BY "Año","Mes"                    --fecha-hora, tenemos que hacer una conversión de datos para quedarnos sólo
;                                       --con la parte que nos interesa, de ahí que combinemos EXTRACT con MONTH y YEAR.

--26.Encuentra el promedio, la desviación estándar y varianza del total pagado.

SELECT ROUND(AVG(p.amount),2) AS Promedio_Pagado, 
       ROUND(STDDEV(p.amount),2) AS Desv_Est, 
       ROUND(VARIANCE(p.amount),2) AS Varianza
FROM payment p 
;

--27.¿Qué películas se alquilan por encima del precio medio?

CREATE VIEW  Precio_Medio_Alquiler AS 						--Creo una vista con el valor del Precio_Medio_Alquiler,
		SELECT round(AVG(f.rental_rate),2) 					--y lo tengo por si necesito usarlo más adelante.	
		FROM  film f 
;

SELECT f.title AS Título, f.rental_rate AS Precio_Alquiler
FROM film f 
WHERE f.rental_rate > (SELECT *
						FROM Precio_Medio_Alquiler)
ORDER BY f.title
;

--28.Muestra el id de los actores que hayan participado en más de 40 películas.

SELECT fa.actor_id AS Id_Actor, count(fa.film_id) AS Pelis_Actor --Si buscamos por el Id de los actores obtenemos
FROM film_actor fa                                               --sólo dos actores que cumplen con el criterio. 
GROUP BY id_actor 
HAVING count(fa.film_id)>40
ORDER BY id_actor 
;

SELECT concat(a."first_name",' ',a."last_name") AS "Nombre_Actor", count(fa.film_id) AS "Pelis_Actor" 
FROM actor a                                              
INNER JOIN film_actor fa ON a.actor_id =fa.actor_id     --Pero si buscamos por nombre de actor, vemos que obtenemos
GROUP BY "Nombre_Actor"                                 --tres resultados. Y, revisando los datos de actores, podemos
HAVING count(fa.film_id)>40                             --comprobar que hay dos actores que se llaman igual, o bien,
ORDER BY "Nombre_Actor"                                 --en la base de datos un mismo actor se ha creado dos veces
;                                                       --con dos identificadores distintos.
												--En el caso de ser el mismo actor, cumpliría la condición de haber
												--participado en más de 40 películas. En el otro caso, no cumpliría.
												
--29.Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.

SELECT f.title AS Titulo, count(f.film_id) AS "Num_Disponibles"
FROM inventory i
RIGHT JOIN film f ON i.film_id =f.film_id          --Usamos un RIGHT JOIN en este caso porque la columna de la derecha
GROUP BY f.title                                   --es la que contiene los títulos de las películas, para que nos los
HAVING count(f.film_id)>0                          --dé todos, junto con el conteo de los disponibles en cada una de ellas.
ORDER BY f.title
;

--30.Obtener los actores y el número de películas en las que ha actuado.

SELECT concat(a."first_name",' ',a."last_name") AS "Nombre_Actor", count(fa.film_id) AS "Pelis_Actor" 
FROM actor a                                              
INNER JOIN film_actor fa ON a.actor_id =fa.actor_id     --Como ya comentamos anteriormente, tenemos un caso extraño,
GROUP BY "Nombre_Actor"                                 --ya que tenemos dos identificadores diferentes para un mismo
ORDER BY "Nombre_Actor"                                 --nombre de actor. Si consideramos que el actor es el mismo
;                                                       --tenemos el resultado de esta consulta.

SELECT a.actor_id, concat(a."first_name",' ',a."last_name") AS "Nombre_Actor", count(fa.film_id) AS "Pelis_Actor" 
FROM actor a                                              
INNER JOIN film_actor fa ON a.actor_id =fa.actor_id     --Pero si consideramos que el actor 101-Susan Davis y el 
GROUP BY a.actor_id, "Nombre_Actor"                     --110-Susan Davis son actores diferentes con el mismo nombre
ORDER BY "Nombre_Actor"                                 --entonces el resultado perseguido sería el de esta otra consulta.
;

--31.Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen
--actores asociados.

SELECT f.title AS "Titulo", concat(a.first_name, ' ', a.last_name) AS "Nombre_Actor"
FROM film f 
LEFT JOIN film_actor fa ON fa.film_id=f.film_id 
INNER JOIN actor a ON a.actor_id = fa.actor_id 
ORDER BY f.title
;

--32.Obtener todos los actores y mostras las películas en las que han actuado, incluso si algunos actores no han
--actuado en ninguna película.

SELECT concat(a.first_name, ' ', a.last_name) AS "Nombre_Actor", f.title AS "Titulo"
FROM film f 
RIGHT JOIN film_actor fa ON fa.film_id=f.film_id 
INNER JOIN actor a ON a.actor_id = fa.actor_id 
ORDER BY "Nombre_Actor" 
;

--33.Obtener todas las películas que tenemos y todos los registros de alquiler.

SELECT  r.rental_id "Registro_Alquiler", f.title "Titulo"
FROM rental r                                                --En esta consulta, si ordenamos por orden descendente los
FULL JOIN inventory i ON i.inventory_id = r.inventory_id     --resultados, podemos comprobar que algunas películas nunca
FULL JOIN film f ON f.film_id = i.film_id                    --han sido alquiladas.
ORDER BY r.rental_id desc
;

--34.Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.

SELECT p.customer_id, sum(p.amount)AS Gasto_Cliente, concat(c.first_name,' ',c.last_name) AS "Nombre_cliente"
FROM payment p
INNER JOIN customer c ON p.customer_id =c.customer_id 
GROUP BY p.customer_id, "Nombre_cliente"
ORDER BY Gasto_Cliente DESC 
LIMIT 5
;

--35.Selecciona todos los actores cuyo primer nombre es 'Johnny'

SELECT a.actor_id AS "Id_Actor", a.first_name AS "Nombre",a.last_name AS "Apellido"
FROM actor a 
WHERE a.first_name ='JOHNNY'
;

--36.Renombra la columna 'first_name' como Nombre y 'last_name' como Apellido.

SELECT a.actor_id AS "Id_Actor", a.first_name AS "Nombre",a.last_name AS "Apellido"
FROM actor a                                      --Entiendo que quiere la tabla de actores completa a diferencia
ORDER BY "Apellido" ,"Nombre"                     --del apartado anterior donde se restringía a los actores con un
;                                                 --determinado nombre. 

--37.Encuentra el ID del actor más bajo y más alto en la tabla actor.

SELECT max(actor_id)AS "MaxID", min(actor_id) AS "MinId"
FROM actor a
;

--38.Cuántos actores hay en la tabla "actor"

SELECT count(a.actor_id) AS "Num_Actores"
FROM actor a 
;

--39.Selecciona todos los actores y ordénalos por apellido en orden ascendente.

SELECT a.actor_id AS "Id_Actor", a.first_name AS "Nombre", a.last_name AS "Apellido"
FROM actor a
ORDER BY "Apellido" ASC, "Nombre" ASC
;

--40.Selecciona las 5 primeras películas de la tabla "film"

SELECT f.film_id AS "Id_Peli",f.title AS "Película"
FROM film f 
ORDER BY "Id_Peli" ASC
LIMIT 5
;

--41.Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?

WITH NombreRepetido AS (
    SELECT
        first_name,
        COUNT(*) AS numero_actores_con_ese_nombre,
        RANK() OVER (ORDER BY COUNT(*) DESC) as rank_repeticiones       --Usamos esta función para establecer un ranking
    FROM                                                                --de apariciones y quedarnos con los que más 
        actor a                                                         --aparecen, pudiendo ser más de uno, como es el caso.
    GROUP BY
        first_name)
SELECT
    first_name, numero_actores_con_ese_nombre
FROM
    NombreRepetido
WHERE
    rank_repeticiones = 1;

--42.Encuentra todos los alquileres y los nombres de los clientes que los realizaron.

SELECT r.rental_id, r.customer_id, concat(c.first_name, ' ' ,c.last_name) AS "Nombre_Cliente"
FROM rental r 
INNER JOIN customer c ON c.customer_id = r.customer_id
;

--43.Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.

SELECT  c.customer_id, concat(c.first_name, ' ' ,c.last_name) AS "Nombre_Cliente", r.rental_id
FROM customer c 
LEFT JOIN rental r ON c.customer_id = r.customer_id
ORDER BY "Nombre_Cliente"
;

--44.Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la 
--consulta la contestación.

SELECT f.title AS "Titulo", c."name" AS "Cat"--Hemos hecho un CROSS JOIN con una campo de cada tabla por claridad para la explicación.
FROM film f                 --Vemos que esta unión nos viene a decir que todas las películas son de todas las categorías,
CROSS JOIN category c       --lo cual NO nos dice nada ya que una película debe ser de una sóla categoría.
;

--45.Encuentra los actores que han participado en películas de la categoría 'Action'.

SELECT DISTINCT (a.actor_id), concat(a.first_name,' ',a.last_name), c.name AS "Categoria"
FROM film f 
INNER JOIN film_category fc ON f.film_id =fc.film_id
INNER JOIN category c ON c.category_id = fc.category_id
INNER JOIN film_actor fa ON fa.film_id =f.film_id
INNER JOIN actor a ON a.actor_id =fa.actor_id
WHERE c.name='Action'
;

--46.Encuentra todos los actores que no han participado en películas.

SELECT a.actor_id AS "Id_Actor", concat(a.first_name,' ',a.last_name)AS "Actor", count(fa.film_id) AS "Num_Pelis_Part"
FROM actor a
LEFT JOIN film_actor fa ON fa.actor_id = a.actor_id
GROUP BY "Id_Actor", "Actor"                             --Según nuestra consulta, todos los actores has participado
HAVING count(fa.film_id) =0                              --en alguna película.
ORDER BY "Id_Actor"
;

--47.Selecciona el nombre de los actores y la cantidad de películas en las que han participado.

SELECT a.actor_id AS "Id_Actor", concat(a.first_name,' ',a.last_name)AS "Actor", count(fa.film_id) AS "Num_Pelis_Part"
FROM actor a
LEFT JOIN film_actor fa ON fa.actor_id = a.actor_id
GROUP BY "Id_Actor", "Actor"                                                       
ORDER BY "Id_Actor"
;

--48.Crea una vista llamada "actor_num_películas" que muestre los nombres de los actores y el número de películas en las
--que han participado.

CREATE VIEW actor_num_peliculas AS 
	SELECT a.actor_id AS "Id_Actor", concat(a.first_name,' ',a.last_name)AS "Actor", count(fa.film_id) AS "Num_Pelis_Part"
	FROM actor a
	LEFT JOIN film_actor fa ON fa.actor_id = a.actor_id            --En este bloque creamos la vista.
	GROUP BY "Id_Actor", "Actor"                                                       
	ORDER BY "Id_Actor";

SELECT *
FROM actor_num_peliculas                                           --En este otro bloque hacemos la llamada a la vista.
;

--49.Calcula el número total de alquileres realizado por cada cliente.

SELECT concat(c.first_name,' ', c.last_name) AS "NombreCliente", count(rental_id )AS "Numero_Alquileres"
FROM  rental r 
RIGHT JOIN customer c ON c.customer_id = r.customer_id
GROUP BY "NombreCliente" 
ORDER BY "NombreCliente" 
;

--50.Calcula la duración total de las películas de la categoría 'Action'

SELECT sum(f.length) AS "Duración_Total_Peliculas_Acción"
FROM film f 
INNER JOIN film_category fc ON fc.film_id =f.film_id  
INNER JOIN category c ON c.category_id =fc.category_id
WHERE c."name" ='Action'
;

--51.Crea una tabla temporal llamada "clientes_rentas_temporal" para almacenar el total de alquileres por cliente.

WITH clientes_rentas_temporal AS(
	SELECT concat(c.first_name,' ', c.last_name) AS "NombreCliente", count(rental_id )AS "Numero_Alquileres"
	FROM  rental r 
	RIGHT JOIN customer c ON c.customer_id = r.customer_id
	GROUP BY "NombreCliente" 
	ORDER BY "NombreCliente" 
)
SELECT "NombreCliente", "Numero_Alquileres"
FROM clientes_rentas_temporal
;

--52.Crea una tabla temporal llamada "peliculas_alquiladas" que almacene las películas que han sido alquiladas 
--al menos 10 veces.

WITH peliculas_alquiladas as(
	SELECT f.film_id, f.title AS "Titulo", count(r.rental_id)AS "Recuento_Alquileres" 
	FROM film f 
	INNER JOIN inventory i ON i.film_id = f.film_id
	INNER JOIN rental r ON r.inventory_id =i.inventory_id
	GROUP BY f.film_id, f.title
	HAVING count(r.rental_id)>=10
	ORDER BY f.film_id
	)
	SELECT "Titulo","Recuento_Alquileres"
	FROM peliculas_alquiladas
;

--53.Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre 'Tammy Sanders'
--y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.

SELECT f.title AS "Título"
FROM film f 
INNER JOIN inventory i ON f.film_id =i.film_id
INNER JOIN rental r ON r.inventory_id =i.inventory_id
INNER JOIN customer c ON c.customer_id =r.customer_id
WHERE c.first_name ='TAMMY' AND c.last_name ='SANDERS' AND  r.return_date IS  NULL
ORDER BY "Título"
;

--54.Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría "Sci-Fi".
--Ordena los resultados alfabéticamente por apellido.

SELECT DISTINCT concat(a.last_name,', ', a.first_name) AS "Nombre_Actor"
FROM actor a 
INNER JOIN film_actor fa ON fa.actor_id =a.actor_id
INNER JOIN film f ON f.film_id =fa.film_id
INNER JOIN film_category fc ON fc.film_id =f.film_id
INNER JOIN category c ON c.category_id =fc.category_id
WHERE c.name='Sci-Fi'
ORDER BY "Nombre_Actor"
;

--55.Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película
--'Spartacus Cheaper' se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.

SELECT EXTRACT(YEAR FROM r.rental_date) AS "Año_Alquiler_1", f.film_id, F.title
FROM film f 
INNER JOIN inventory i ON i.film_id = f.film_id                --Esta consulta calcula el año en el que se 
INNER JOIN rental r ON r.inventory_id = i.inventory_id         --alquiló por primera vez la película indicada 
WHERE f.title = 'SPARTACUS CHEAPER'                            --y que usaremos a continuación en la consulta
ORDER BY r.rental_date ASC                                     --principal, como subconsulta en el WHERE.
LIMIT 1
;


SELECT DISTINCT concat(a.last_name, ', ', a.first_name)AS "Nombre_Actor"
FROM actor a 
INNER JOIN film_actor fa ON a.actor_id =fa.actor_id
INNER JOIN film f ON f.film_id = fa.film_id
WHERE f.release_year > (SELECT EXTRACT(YEAR FROM r.rental_date) AS "Año_Alquiler_1"
						FROM film f 
						INNER JOIN inventory i ON i.film_id = f.film_id
						INNER JOIN rental r ON r.inventory_id = i.inventory_id
						WHERE f.title = 'SPARTACUS CHEAPER'
						ORDER BY r.rental_date ASC
						LIMIT 1)
ORDER BY "Nombre_Actor" ASC
;

--56.Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría 'Music'

SELECT f.film_id, c.name                                     --Primero montamos una consulta que nos da los Id de los
FROM film f 												 --films de la categoría 'Music', para luego usarla como						
INNER JOIN film_category fc ON f.film_id =fc.film_id         --subconsulta en el WHERE de la consulta principal y 
INNER JOIN category c ON c.category_id =fc.category_id       --buscar los actores que NO han participado en películas
WHERE c.name='Music'                                         --de esta categoría.
;

SELECT DISTINCT CONCAT(a.first_name,' ',a.last_name) AS "Nombre_Actor"
FROM actor a
INNER JOIN film_actor fa ON a.actor_id =fa.actor_id
WHERE fa.film_id NOT IN (
					SELECT f.film_id
					FROM film f 
					INNER JOIN film_category fc ON f.film_id =fc.film_id
					INNER JOIN category c ON c.category_id =fc.category_id
					WHERE c.name='Music'
					)
;

--57.Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.

SELECT DISTINCT f.title, (r.return_date::date- r.rental_date::date) AS "Dias_Alq"
FROM film f
INNER JOIN inventory i ON f.film_id = i.film_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
WHERE (r.return_date::date- r.rental_date::date) > 8
  AND r.return_date IS NOT NULL                                -- Para asegurar que la película ha sido devuelta.
ORDER BY f.title                                               -- Ordenamos por film, y añadimos los días de alquiler
;                                                              -- como dato para comprobación de resultados. 

--58.Encuentra el título de todas las películas que son de la misma categoría que 'Animation'

SELECT f.title, c.name
FROM film f 
INNER JOIN film_category fc ON fc.film_id = f.film_id
INNER JOIN category c ON c.category_id =fc.category_id
WHERE c.name ='Animation'
ORDER BY f.title
;

--59.Encuentra los nombres de las películas que tienen la misma duración que la película con el título 'Dancing Fever'
--Ordena los resultados alfabéticamente por título de película.

SELECT f.length AS "Duración_Peli"             --Con esta consulta puedo calcular la duración de la película de
FROM film f                                    --referencia y usarla como subconsulta posteriormente como condición
WHERE f.title ='DANCING FEVER'                 --en el WHERE de la consulta principal.
;

SELECT f.title AS "Titulo", f.length                 --Incluimos el campo longitud como comprobación para comparar
FROM film f                                          --con el resultado de la subconsulta.
WHERE f.length = (
				SELECT f.length AS "Duración_Peli"
				FROM film f 
				WHERE f.title ='DANCING FEVER')
ORDER BY f.title asc
;

--60.Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados 
--alfabéticamente por apellido.

SELECT concat(c.last_name,', ', c.first_name) AS "Nombre_cliente", count(DISTINCT i.film_id)AS "Num_Alquileres"
FROM customer c 
INNER JOIN rental r ON r.customer_id =c.customer_id
INNER JOIN inventory i ON i.inventory_id =r.inventory_id
GROUP BY "Nombre_cliente" 
HAVING count(DISTINCT i.film_id )>=7
ORDER BY "Nombre_cliente" 
;

--61.Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el
--recuento de alquileres

SELECT c."name" AS "Categoria", count(rental_id) AS "Num_Alq"
FROM rental r 
INNER JOIN inventory i ON r.inventory_id =i.inventory_id
INNER JOIN film f ON f.film_id =i.film_id 
INNER JOIN film_category fc ON fc.film_id  =f.film_id 
INNER JOIN category c ON c.category_id =fc.category_id
GROUP BY "Categoria" 
ORDER BY "Categoria" 
;

--62.Encuentra el número de películas por categoría estrenadas en 2006.

SELECT c."name" AS "Categoria", count(f.film_id) AS "Num_Pelis"
FROM  film f  
INNER JOIN film_category fc ON fc.film_id  =f.film_id 
INNER JOIN category c ON c.category_id =fc.category_id
WHERE f.release_year =2006
GROUP BY "Categoria" 
ORDER BY "Categoria" 
;

--63.Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.

SELECT s.staff_id, concat (s.first_name,' ', s.last_name) AS "Nombre_Operario", s2.store_id
FROM staff s 
CROSS JOIN store s2 
;
	
--64.Encuentra la cantidad total de películas alquiladas por cada cliente y muestre el ID del cliente, su
--nombre y su apellido, junto con la cantidad de películas alquiladas.

SELECT c.customer_id AS "Id_Cliente", 
	concat(c.first_name,' ',c.last_name) AS "Nombre_Cliente", 
	count(r.rental_id) AS "Num_Alq"
FROM customer c 
INNER JOIN rental r ON r.customer_id = c.customer_id
GROUP BY "Id_Cliente", "Nombre_Cliente"
ORDER BY "Nombre_Cliente"
;




-- 1

-- Agrego valores acordes a los requerimientos en DDL.

SELECT id, nombre, telefono 
FROM 
(SELECT i.id AS id_info
FROM informacion_medica AS i 
WHERE i.contacto_emergencia IS NULL 
OR i.contacto_emergencia = 'cargar@despues.com') AS c 
JOIN empleado ON id_info = informacion_medica_id;


-- 2

SELECT id AS id_cli, nombre AS nombre_cli, telefono AS telefono_cli
FROM (SELECT * FROM cliente WHERE date_part('year', age(fecha_nac)) > 50) AS clientes_mayores_50
UNION
SELECT c.id AS id_cli, c.nombre AS nombre_cli, c.telefono AS telefono_cli
FROM cliente AS c 
JOIN venta AS v 
ON c.id = v.cliente 
JOIN  producto AS p 
ON v.producto = p.id
WHERE p.tipo = 'Tercera edad'
;



-- 3


SELECT COUNT(*) AS cantidad_ventas, ROUND(AVG(producto.precio-venta.descuentos)) AS precio_promedio
FROM venta
JOIN producto
ON venta.producto = producto.id
WHERE tipo = 'Perfume'
AND fecha >= '01/01/2020';

/*Se utiliza ROUND para eliminar los decimales.*/



-- 4


SELECT empleado.id, nombre, tienda_id
FROM empleado
JOIN informacion_medica
ON empleado.id = informacion_medica.id
WHERE grupo_sanguineo = 'O-'
ORDER BY (nombre, tienda_id) ASC;



-- 5 

-- Agrego valores acordes a los requerimientos en DDL.
       

SELECT producto.nombre
FROM producto
JOIN venta
ON producto.id = venta.producto
WHERE tipo = 'Camisa'
AND precio > 800
AND fecha NOT BETWEEN '01/10/2020' AND '31/10/2020';



-- 6 


-- Agrego valores acordes a los requerimientos en DDL.

SELECT tienda.nombre    
FROM tienda
JOIN venta
ON tienda.id = venta.tienda
JOIN producto
ON venta.producto = producto.id
WHERE (producto.nombre = 'La separadedos'
OR producto.nombre = 'El pie fresco')
AND descuentos = 50

INTERSECT

SELECT tienda.nombre
FROM tienda
JOIN venta
ON tienda.id = venta.tienda
JOIN producto
ON venta.producto = producto.id
WHERE producto.tipo = 'Zapatilla'
AND descuentos > 0;


/*Selecciono las tiendas que hayan hecho un 50% de descuento en La separadedos o El pie fresco, y hago una interseccion con las que hayan hecho un descuento sobre Zapatillas*/



-- 7


-- Agrego valores acordes a los requerimientos en DDL.

SELECT tienda.nombre
FROM tienda
JOIN producto
ON tienda.id = producto.tienda_id
WHERE tipo = 'Traje'

EXCEPT

SELECT tienda.nombre
FROM tienda
JOIN producto
ON tienda.id = producto.tienda_id
WHERE tipo = 'Corbata';



/*Selecciono todas las tiendas que vendan trajes, y les resto las que vendan corbatas*/



-- 8 


SELECT tienda.nombre
FROM tienda
JOIN producto
ON tienda.id = producto.tienda_id
ORDER BY precio DESC
LIMIT 3;



-- 9


-- Agrego valores acordes a los requerimientos en DDL.

SELECT producto.nombre , ROUND(AVG(producto.precio)) AS precio_promedio, local.tamaño
FROM producto
JOIN tienda
ON producto.tienda_id = tienda.id
JOIN local
ON local.id = tienda.local
WHERE producto.nombre = 'Aromas del arrabal'
GROUP BY producto.nombre, local.tamaño
ORDER BY local.tamaño DESC;



-- 10

-- Agrego la creacion del view en DDL.

SELECT * FROM las_cinco_tiendas_con_mas_ventas_de_septiembre;




-- 11


-- Agrego valores acordes a los requerimientos en DDL.
	   

SELECT cliente.nombre, dni, telefono, SUM (precio - descuentos/100) AS sumatoria_de_compras
FROM cliente
JOIN venta
ON cliente.id = venta.cliente
JOIN producto
ON venta.producto = producto.id
GROUP BY cliente.nombre, dni, telefono
HAVING (SUM(precio - descuentos/100) > 100000);



-- 12


/*se crea una view para simplificar la consulta.
Se toma como mas exitosas a las 5 tiendas con mayor monto vendido desde el inicio del shopping, ya que no se especifica en este punto.*/


SELECT empleado.nombre
FROM las_cinco_tiendas_mas_exitosas
JOIN empleado
ON las_cinco_tiendas_mas_exitosas.id = empleado.tienda_id




-- 13


-- Agrego valores acordes a los requerimientos en DDL.


SELECT empleado.id, empleado.nombre 
FROM empleado
WHERE direccion IN (
SELECT direccion FROM empleado 
GROUP BY direccion
HAVING COUNT(*)>1);



-- 14


SELECT dni, COUNT(id) AS cantidad_de_puntos FROM(
SELECT dni,cliente.id, SUM(producto.precio-venta.descuentos) AS costo_de_compra
FROM venta
JOIN cliente
ON venta.cliente = cliente.id
JOIN producto
ON venta.producto = producto.id
GROUP BY cliente.id, venta.fecha
HAVING (SUM(precio - descuentos/100) > 500)
AND EXTRACT('year' from fecha)= 2020) AS clientes_con_puntos
GROUP BY clientes_con_puntos.dni
ORDER BY cantidad_de_puntos DESC;   -- esto no lo pedia el enunciado, pero me sirvio para corroborar los datos que devolvia



-- 15



-- Agrego valores acordes a los requerimientos en DDL.



SELECT id, local, dias_de_actividad
FROM tienda





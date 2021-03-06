
-- Creación de base de datos

CREATE DATABASE tp_carrevedo;

-- Conexión a base de datos

/*

Este TP se realizó utilizando la interfaz gráfica pgAdmin.
En este caso la conexion es a través de constraseña y nombre de base de datos.

En caso de usar consola, se utiliza:
/c nombre_base_de_datos

*/



-- Creación de tablas

/*
Profesores: me jugó una mala pasada haber puesto DEFAULT en los datos que ingresé. Durante todo el tiempo que estuve realizando la práctica, trabajé con los números que me había asignado de una manera (por ejemplo, los números de venta me los asignó a partir del número 9, y los números de producto, a partir de 20, o algo similiar), pero cuando terminé la práctica y quise correr todo el DDL en una base nueva para simular lo que harán ustedes, la nueva asignación fue en todos los casos a partir del 1. Eso hizo que dejaran de funcionar algunas cosas las cuales corregí a mano. Las consultas funcionan, pero es posible que en algún ejemplo no haya un "caso para mostrar". Gracias.
*/

CREATE TABLE cliente(
id SERIAL PRIMARY KEY,
nombre VARCHAR(20) NOT NULL,
fecha_nac DATE NOT NULL,
telefono INT NOT NULL,
dni INT NOT NULL
);


CREATE TABLE informacion_medica(
id SERIAL PRIMARY KEY,
grupo_sanguineo VARCHAR(5) NOT NULL,
alergias VARCHAR(200) NOT NULL,
obra_social VARCHAR(20) NOT NULL
);

CREATE TABLE empleado (
id SERIAL PRIMARY KEY,
nombre VARCHAR(20) NOT NULL,
telefono INT NOT NULL,
direccion VARCHAR(20) NOT NULL,
-- id_tienda (FOREIGN KEY TIENDA.ID) esta linea se deja a modo recordatorio, pero no puede ser ejecutada, ya que la tabla tienda aún no existe
rol VARCHAR(20) NOT NULL,
informacion_medica_id INT NOT NULL, 
CONSTRAINT fk_informacion_medica FOREIGN KEY (informacion_medica_id) REFERENCES informacion_medica(id)
);

CREATE TABLE tienda(
id SERIAL PRIMARY KEY,
nombre VARCHAR(20) NOT NULL,
local INT NOT NULL,
encargado_id INT NOT NULL,
CONSTRAINT fk_encargado_id FOREIGN KEY (encargado_id) REFERENCES empleado(id)
);

ALTER TABLE empleado     -- ahora teniendo la tabla tienda, puedo agregar la FK que quedó pendiente
ADD COLUMN tienda_id INT NOT NULL;

ALTER TABLE empleado
ADD CONSTRAINT fk_tienda_id FOREIGN KEY (tienda_id) REFERENCES tienda(id);

CREATE TABLE producto(
id SERIAL PRIMARY KEY,
tienda_id INT NOT NULL,
tipo VARCHAR(20) NOT NULL,
nombre VARCHAR(20) NOT NULL,
precio INT NOT NULL,
CONSTRAINT fk_tienda_id FOREIGN KEY (tienda_id) REFERENCES tienda(id)
);

CREATE TABLE ventas(  -- el nombre es modificado mas adelante por uno en singular
cliente INT,
producto INT,
tienda INT,
fecha DATE NOT NULL,    -- modifico DATETIME porque no es valido
descuentos INT NOT NULL,
CONSTRAINT pk_venta PRIMARY KEY (cliente, producto, tienda),  -- se coloca de esta manera para agregar mas de un atributo como PK
CONSTRAINT fk_cliente FOREIGN KEY (cliente) REFERENCES cliente(id),
CONSTRAINT fk_producto FOREIGN KEY (producto) REFERENCES producto(id),
CONSTRAINT fk_tienda FOREIGN KEY (tienda) REFERENCES tienda(id)
);


ALTER TABLE informacion_medica
ADD contacto_emergencia VARCHAR(50);

CREATE TABLE locales(   -- el nombre es modificado mas adelante por uno en singular
id SERIAL PRIMARY KEY,
sector VARCHAR(20) NOT NULL,
tamaño DECIMAL NOT NULL
);

ALTER TABLE ventas RENAME TO venta;

ALTER TABLE locales RENAME TO local;


-- Carga de datos

INSERT INTO cliente (id, nombre, fecha_nac, telefono, dni)
VALUES  (DEFAULT, 'David', '24/05/1989', 1154875632, 34517494),  
	(DEFAULT, 'Damaris', '09/01/1992', 1145678963, 36993841),
	(DEFAULT, 'Ciro', '14/11/1995', 1125693451, 40237864),
	(DEFAULT, 'Leonor', '22/09/1954', 1127645855, 11368893),
	(DEFAULT, 'Carolina', '03/09/1980', 113899988, 305448766),
	(DEFAULT, 'Maximiliano', '12/08/1981', 1124584455, 30677846),
	(DEFAULT, 'Evangelina', '13/11/1977', 1169665011, 25746989),
	(DEFAULT, 'Ariel', '18/12/1975', 1157776100, 24864571);
	

INSERT INTO informacion_medica (id, grupo_sanguineo, alergias, obra_social, contacto_emergencia)
VALUES (DEFAULT, 'A+', 'No posee','TVSalud', 'Damaris@gmail.com'),
       (DEFAULT, 'A-', 'No posee', 'TVSalud', 'David@gmail.com'),
       (DEFAULT, 'O+', 'Animales, Mani', 'TVSalud', 'David@gmail.com'),
       (DEFAULT, 'O-', 'No posee', 'ANDAR', 'Caro@gmail.com'),
       (DEFAULT, 'A+', 'Cambio de clima', 'IOMA', 'Maxi@gmail.com'),
       (DEFAULT, 'A-', 'Polen', 'IOMA', 'Caro@gmail.com'),
       (DEFAULT, 'O+', 'Citricos', 'Osecac', 'Ariel@gmail.com'),
       (DEFAULT, 'O-', 'No posee', 'Osecac', 'Eva@gmail.com');


INSERT INTO local (id, sector, tamaño)
VALUES (DEFAULT, 'Norte', 33.7),
       (DEFAULT, 'Sur', 47.1),
       (DEFAULT, 'Este', 38.9),
       (DEFAULT, 'Oeste', 50.0),
       (DEFAULT, 'Norte', 52.0),
       (DEFAULT, 'Este', 75.5);

/*en las siguiente carga de datos, se agregan valores NULL para completar la columna
que tiene una FOREIGN KEY con otra tabla aún no creada*/

ALTER TABLE tienda
ALTER COLUMN encargado_id DROP NOT NULL;  -- tuve que quitar la restriccion not null puesta en el inicio

INSERT INTO tienda (id, nombre, local, encargado_id)
VALUES (DEFAULT, 'Adidas', 1, NULL),    
       (DEFAULT, 'Cristobal Colon', 2, NULL),
       (DEFAULT, 'Stock Center', 3, NULL),
       (DEFAULT, 'Nike', 4, NULL),
       (DEFAULT, 'Kappa', 5, NULL),
       (DEFAULT, 'Garbarino', 6, NULL),
	   (DEFAULT, 'Fravega', 7 , NULL)
	   ;


INSERT INTO empleado (id, nombre, telefono, direccion, rol, informacion_medica_id, tienda_id)
VALUES (DEFAULT, 'Pedro', 321654987, 'Heredia 6361', 'Encargado', 1, 2),
       (DEFAULT, 'Juan', 335544778, 'Heredia 6358', 'Encargado', 2, 3),
       (DEFAULT, 'Carla', 221144556, 'San Martin 453', 'Encargado', 3, 4),
       (DEFAULT, 'Marcela', 156987456, 'Aguero 4665', 'Encargado', 4, 5),
       (DEFAULT, 'Fernando', 112236549, 'Mitre 1422', 'Encargado', 5, 6),
       (DEFAULT, 'Romina', 110325641, 'Martinto 134', 'Encargado', 6, 7),
       (DEFAULT, 'Esteban', 110389658, 'Onsari 1122', 'Vendedor', 7, 2),
       (DEFAULT, 'Luisa', 116998557, 'San Carlos 145', 'Vendedor', 8, 3);
       

-- modifico la tabla tienda, para asignar los encargados

UPDATE tienda
SET encargado_id = 1
WHERE id = 2
;

UPDATE tienda
SET encargado_id = 2
WHERE id = 3
;

UPDATE tienda
SET encargado_id = 3
WHERE id = 4
;

UPDATE tienda
SET encargado_id = 4
WHERE id = 5
;

UPDATE tienda
SET encargado_id = 5
WHERE id = 6
;


INSERT INTO producto (id, tienda_id, tipo, nombre, precio)
VALUES (DEFAULT, 7, 'Indumentaria', 'Conjunto Deportivo', 5000),
       (DEFAULT, 7, 'Calzado', 'La separadedos', 1000),
       (DEFAULT, 2, 'Accesorio', 'Cinturon', 500),
       (DEFAULT, 2, 'Perfume', 'El Perfume', 3000),
       (DEFAULT, 3, 'Tercera edad', 'Florero', 2000),
       (DEFAULT, 3, 'Indumentaria', 'Remera', 1000),
       (DEFAULT, 4, 'Calzado', 'Sandalia', 2500),
       (DEFAULT, 4, 'Accesorio', 'Soquete', 200),
       (DEFAULT, 5, 'Perfume', 'Linda Fragancia', 4000),
       (DEFAULT, 5, 'Tercera edad', 'Chaleco', 3000),
       (DEFAULT, 6, 'Indumentaria', 'Pantalon', 2000),
       (DEFAULT, 6, 'Calzado', 'El pie fresco', 5000);

/*Por consultas de comapañeros en clases, se sabia de la necesidad de tener productos llamados La separadedos y El pie fresco*/


INSERT INTO venta(cliente, producto, tienda, fecha, descuentos)
VALUES (1, 1, 2, '20/11/2020', 0),    
       (1, 2, 3, '11/11/2020', 0),
       (2, 3, 4, '04/11/2020', 0),
       (2, 4, 5, '05/11/2020', 15),
       (3, 5, 6, '06/11/2020', 10),
       (3, 6, 7, '12/11/2020', 0),
       (4, 7, 2, '11/10/2020', 20),
       (4, 8, 3, '03/10/2020', 0),
       (5, 9, 4, '04/10/2020', 0),
       (5, 10, 5, '05/10/2020', 10),
       (6, 11, 6, '06/10/2020', 0),
       (6, 12, 7, '10/10/2020', 0),
       (7, 1, 2, '20/09/2020', 0),
       (7, 2, 3, '10/09/2020', 40),
       (8, 3, 4, '13/09/2020', 0),
       (8, 4, 5, '09/09/2020', 0);



-- MODIFICACIONES REALIZADAS A LA PAR DE LA RESOLUCION DE DML


-- 1

-- Modifico algunos datos para obtener resultados

UPDATE informacion_medica
SET contacto_emergencia = 'cargar@despues.com'
WHERE contacto_emergencia = 'David@gmail.com' 
OR contacto_emergencia = 'Eva@gmail.com'
;

ALTER TABLE empleado
ALTER COLUMN direccion DROP NOT NULL;  -- tuve que quitar la restriccion not null puesta en el inicio

UPDATE empleado
SET direccion = NULL
WHERE direccion = 'Heredia 6361'
OR direccion = 'Heredia 6358'
;


-- 5

-- Agrego valores acordes a los requerimientos.

INSERT INTO producto (id, tienda_id, tipo, nombre, precio)
VALUES (DEFAULT, 7, 'Camisa', 'Camisa Lisa', 2000),
       (DEFAULT, 7, 'Camisa', 'Camisa Cuadrille', 3000),
       (DEFAULT, 5, 'Camisa', 'Camisa Verde', 500);

INSERT INTO venta(cliente, producto, tienda, fecha, descuentos)
VALUES (1, 13, 7, '20/10/2020', 0),    
       (4, 14, 7, '11/10/2020', 0),
       (5, 15, 5, '04/11/2020', 0),
       (2, 13, 7, '05/09/2020', 15),
       (3, 14, 7, '06/08/2020', 10);
	   
	 
-- 6 


-- Agrego valores acordes a los requerimientos.

INSERT INTO producto (id, tienda_id, tipo, nombre, precio)
VALUES (DEFAULT, 3, 'Zapatilla', 'Zapatilla Negra', 2000),
       (DEFAULT, 7, 'Zapatilla', 'Zapatilla Deportiva', 7000);

INSERT INTO venta(cliente, producto, tienda, fecha, descuentos)
VALUES (1, 2, 7, '20/10/2020', 50),    
       (4, 12, 6, '11/10/2020', 0),
       (2, 16, 3, '15/10/2020', 20),
       (3, 17, 7, '15/07/2020', 20);


-- 7


-- Agrego valores acordes a los requerimientos.

INSERT INTO producto (id, tienda_id, tipo, nombre, precio)
VALUES (DEFAULT, 3, 'Traje', 'Traje Negro', 50000),
       (DEFAULT, 3, 'Corbata', 'Corbata Azul', 2000),
       (DEFAULT, 5, 'Traje', 'Traje Blanco', 50000);



-- 9


-- Agrego valores acordes a los requerimientos.

INSERT INTO producto (id, tienda_id, tipo, nombre, precio)
VALUES (DEFAULT, 6, 'Perfume', 'Aromas del arrabal', 3000),
       (DEFAULT, 2, 'Perfume', 'Aromas del arrabal', 3500),
       (DEFAULT, 4, 'Perfume', 'Aromas del arrabal', 4000);


-- 10

-- Creo view

CREATE VIEW las_cinco_tiendas_con_mas_ventas_de_septiembre AS (
SELECT tienda.nombre, COUNT (venta.cliente) AS total_de_ventas, SUM (precio) AS total_vendido_en_pesos
FROM tienda
JOIN venta
ON tienda.id = venta.tienda
JOIN producto
ON venta.producto = producto.id
WHERE fecha
BETWEEN '01/09/2020' AND '30/09/2020'
GROUP BY tienda.nombre
ORDER BY total_vendido_en_pesos DESC);




-- 11


-- Agrego valores acordes a los requerimientos.



INSERT INTO venta(cliente, producto, tienda, fecha, descuentos)
VALUES (1, 18, 3, '20/11/2020', 0),    
       (1, 20, 5, '11/11/2020', 0),
       (2, 18, 3, '04/11/2020', 0),
       (2, 20, 5, '04/11/2020', 0);


-- 12

-- Creo view

CREATE VIEW las_cinco_tiendas_mas_exitosas AS (
SELECT tienda.nombre, tienda.id, COUNT (venta.cliente) AS total_de_ventas, SUM (precio) AS total_vendido_en_pesos
FROM tienda
JOIN venta
ON tienda.id = venta.tienda
JOIN producto
ON venta.producto = producto.id
GROUP BY tienda.nombre, tienda.id
ORDER BY total_vendido_en_pesos DESC);



-- 13


-- Agrego valores acordes a los requerimientos.


INSERT INTO informacion_medica (id, grupo_sanguineo, alergias, obra_social, contacto_emergencia)
VALUES (17, 'A+', 'No posee','TVSalud', 'Damaris@gmail.com');


INSERT INTO empleado (id, nombre, telefono, direccion, rol, informacion_medica_id, tienda_id)
VALUES (DEFAULT, 'Alan', 40253698, 'San Carlos 145', 'Vendedor', 17, 2);


-- 15



-- Modifico segun requerimientos


ALTER TABLE tienda
ADD COLUMN dias_de_actividad varchar(50);

UPDATE tienda
SET dias_de_actividad = 'miercoles, viernes y domingo'
WHERE (local%2=0)
;


UPDATE tienda
SET dias_de_actividad = 'martes, jueves y sábado'
WHERE (local%2=1)
;



























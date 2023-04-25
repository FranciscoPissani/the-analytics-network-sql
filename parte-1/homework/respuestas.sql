-- cLASE 1--

--1
select * from stg.product_master
where categoria = 'Electro'

--2
select * from stg.product_master
where origen = 'China'

--3 
select * from stg.product_master
where categoria = 'Electro' 
order by nombre asc 

--4
select * from stg.product_master
where subcategoria = 'TV'
AND is_active= 'True'

--5
select * from stg.store_master
where pais= 'Argentina'
order by fecha_apertura asc

--6   
select * from stg.order_line_sale
order by fecha desc
limit 5

--7
select * from stg.super_store_count
order by fecha asc 
limit 10

--8 
select * from stg.product_master
where categoria= 'Electro' 
and subsubcategoria not in ('Control remoto','Soporte')

--9
select * from stg.order_line_sale
where venta >100000 
and moneda ='ARS'

--10
select * from stg.order_line_sale
where FECHA BETWEEN '2022-10-01' AND '2022-10-31'

--11
select * from stg.PRODUCT_MASTER
WHERE EAN IS NOT NULL

--12
select * from stg.order_line_sale
where FECHA BETWEEN '2022-10-01' AND '2022-11-10'

--cLASE 2--

--1 
select DISTINCT(PAIS) FROM stg.STORE_MASTER

--2
selECT count( distinct codigo_producto), subcategoria FROM stg.PRODUCT_MASTER
WHERE IS_ACTIVE ='True'
group by 2;

--3
select * from stg.order_line_sale
where venta >100000 
and moneda ='ARS'

--4
select sum(descuento), moneda from stg.order_line_sale 
where descuento is not null 
and fecha between '2022-11-01' and '2022-11-30'
group by moneda

--5 
select sum(impuestos) as impuestos_pagados
from stg.order_line_sale 
where moneda= 'EUR'
AND extract (year from fecha)='2022'

--6
select count (distinct orden) as orden_c_credito 
from stg.order_line_sale 
where creditos is not null

--7
select tienda,  (sum(coalesce(descuento,0)*-1)/(sum (coalesce (venta,1)))) as porcentaje_dscto 
from stg.order_line_sale 
group by 1
order by tienda

--8
select tienda, fecha, avg(inicial+final)/2 as inventario_promedio 
from stg.inventory
group by 1,2
order by tienda,fecha asc

--9



--10


--11


--12


--13



--14




--Clase 3--















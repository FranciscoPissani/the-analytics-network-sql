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


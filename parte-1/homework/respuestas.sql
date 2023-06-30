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
select 
producto, 
sum(coalesce(VENTA,0)-COALESCE(DESCUENTO,0*-1)) AS Venta_neta,
sum (coalesce(descuento*-1,0))/(sum (coalesce(venta))) as Porcentaje_dcto
from stg.order_line_sale 
where moneda='ARS'
group by producto
order by producto asc

--10
select tienda, date(fecha::TEXT), conteo from stg.market_count 
union 
select tienda, date(fecha::TEXT), conteo from stg.super_store_count

--11
select * from stg.product_master
where is_active='true'
and nombre LIKE '%PHILIPS%'

--12
select tienda, sum(venta) venta, moneda from stg.order_line_sale   
group by tienda, moneda
order by  venta desc

--13
select producto ,moneda, sum(venta)/sum(cantidad) as promedio
from stg.order_line_Sale
group by producto,moneda

--14
select orden, sum(impuestos)/sum(venta)*100 Tasa_impuestos 
from stg.order_line_sale   
group by orden


--Clase 3--

--1 
select nombre, codigo_producto, categoria, coalesce(color,'Unknown') 
from stg.product_master
where nombre like '%SAMSUNG%' or nombre like '%PHILIPS%'

--2 
select pais, provincia, moneda, sum(venta) ventas_brutas, sum(impuestos) impuestos 
from stg.order_line_sale s
left join stg.store_master sm on s.tienda=sm.codigo_tienda
group by 1,2,3

--3
select subcategoria, sum(venta) ventas, moneda 
from stg.order_line_sale s
left join stg.product_master pm on s.producto=pm.codigo_producto
group by 1,3
order by subcategoria asc, moneda asc

--4
select subcategoria, sum(cantidad) unidades_vendidas, concat (pais,'-',provincia) pais_prov 
from stg.order_line_sale s
left join stg.product_master pm on s.producto=pm.codigo_producto
left join stg.store_master sm on sm.codigo_tienda=s.tienda
group by 1,3
order by pais_prov asc

--5
create or replace view stg.super_store as
select sm.nombre as tienda, sum(conteo) as entradas 
from stg.store_master sm
inner join stg.market_count mk on mk.tienda=sm.codigo_tienda
where date(mk.fecha::TEXT) >= date(sm.fecha_apertura::TEXT)
gROUP BY 1

--6
select sm.nombre TIENDA, tienda Codigo_tienda, sku, DATE(date_trunc('month', fecha)) mes_año, avg(inicial+final)/2 as inventario_promedio 
from stg.inventory I
left join stg.store_master sm on i.tienda=sm.codigo_tienda
group by 1,2,3,4
order by tienda, sku asc

--7
select initcap(coalesce(material,'Unknown')) material, sum(cantidad) unidades_vendidas
from stg.order_line_sale s
left join stg.product_master pm on s.producto=pm.codigo_producto
group by 1

--8
select s.*,
case
when S.moneda='ARS' THEN VENTA/COTIZACION_USD_PESO
when S.moneda='EUR' THEN VENTA/COTIZACION_USD_EUR
when S.moneda='URU' THEN VENTA/COTIZACION_USD_URU
END AS VENTA_BRUTA_DOLARES
from stg.order_line_sale S
left join stg.monthly_average_fx_rate TC on tc.mes=date_trunc('month',s.fecha)

--9
select SUM(r.VENTA_BRUTA_DOLARES)AS  VENTA_TOTAL_DOLARES FROM 
(SELECT S.*,
case
when S.moneda='ARS' THEN VENTA/COTIZACION_USD_PESO
when S.moneda='EUR' THEN VENTA/COTIZACION_USD_EUR
when S.moneda='URU' THEN VENTA/COTIZACION_USD_URU
END AS VENTA_BRUTA_DOLARES
from stg.order_line_sale S
left join stg.monthly_average_fx_rate TC on tc.mes=date_trunc('month',s.fecha)) r

--10
SELECT S.*,C.costo_promedio_usd,
case
when S.moneda='ARS' THEN (VENTA+COALESCE (DESCUENTO,0))/COTIZACION_USD_PESO - COSTO_PROMEDIO_USD*CANTIDAD
when S.moneda='EUR' THEN (VENTA+COALESCE (DESCUENTO,0))/COTIZACION_USD_EUR- COSTO_PROMEDIO_USD*CANTIDAD
when S.moneda='URU' THEN (VENTA+COALESCE (DESCUENTO,0))/COTIZACION_USD_URU- COSTO_PROMEDIO_USD*CANTIDAD
END AS Margen
from stg.order_line_sale S
left join stg.monthly_average_fx_rate TC on tc.mes=date_trunc('month',s.fecha)
LEFT JOIN STG.COST C ON C.CODIGO_PRODUCTO=S.PRODUCTO

--11
select orden, subsubcategoria, count(distinct(s.producto)) productos
from stg.order_line_sale S
left join stg.product_master PM on PM.Codigo_producto=s.producto 
group by 1,2

Clase 4

--1
create schema if not exists bkp;
Select * into bkp.product_master_20230630
From stg.product_master

--2


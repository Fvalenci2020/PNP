--crea tablas de indexacion que se utiliza dentro del modelo PNP y la que se utiliza en nuevo modelo de calculo
--IndexadoresModeloPNP
--IndexadoresContratos

create PROCEDURE [013_PROC_INDEXACION]
					@FECHA DATE,@Version varchar(150)
AS

--use pnp_2
--DECLARE @FECHA DATE='2020-08-01'
--DECLARE @Version varchar(45)='V1'

IF OBJECT_ID('combustibletemp', 'U') IS NOT NULL DROP TABLE combustibletemp
--drop table if exists combustibletemp

select	t1.IdIndexC,t1.fecha,t1.IdTipoCombustible,TC.TipoCombustible,t1.Valor,
		(t1.Valor+t2.Valor+t3.Valor)/3 X3,
		(t1.Valor+t2.Valor+t3.Valor+t4.valor)/4 X4,
		(t1.Valor+t2.Valor+t3.Valor+t4.valor+t5.valor+t6.valor)/6 X6
into combustibletemp
from IndexacionCombustible t1
left join tipocombustible TC on t1.IdTipoCombustible=TC.IdTipoCombustible
left join IndexacionCombustible t2 on t2.Fecha=DATEADD(month,-1,t1.fecha) and t2.IdTipoCombustible=t1.IdTipoCombustible
left join IndexacionCombustible t3 on t3.Fecha=DATEADD(month,-2,t1.fecha) and t3.IdTipoCombustible=t1.IdTipoCombustible
left join IndexacionCombustible t4 on t4.Fecha=DATEADD(month,-3,t1.fecha) and t4.IdTipoCombustible=t1.IdTipoCombustible
left join IndexacionCombustible t5 on t5.Fecha=DATEADD(month,-4,t1.fecha) and t5.IdTipoCombustible=t1.IdTipoCombustible
left join IndexacionCombustible t6 on t6.Fecha=DATEADD(month,-5,t1.fecha) and t6.IdTipoCombustible=t1.IdTipoCombustible
WHERE T1.Fecha=@FECHA

IF OBJECT_ID('CPITemp', 'U') IS NOT NULL DROP TABLE CPITemp
--drop table if exists CPITemp

select	t1.IdCPI,t1.fecha,t1.Valor,
		(t1.Valor+t2.Valor+t3.Valor+t4.Valor)/4 X4,
		(t1.Valor+t2.Valor+t3.Valor+t4.Valor+t5.Valor+t6.Valor)/6 X6,
		(t1.Valor+t2.Valor+t3.Valor+t4.Valor+t5.Valor+t6.Valor+t7.Valor+t8.Valor+t9.Valor)/9 X9
into CPITemp
from indexacionCPI t1
left join indexacionCPI t2 on t2.Fecha=DATEADD(month,-1,t1.fecha)
left join indexacionCPI t3 on t3.Fecha=DATEADD(month,-2,t1.fecha)
left join indexacionCPI t4 on t4.Fecha=DATEADD(month,-3,t1.fecha)
left join indexacionCPI t5 on t5.Fecha=DATEADD(month,-4,t1.fecha)
left join indexacionCPI t6 on t6.Fecha=DATEADD(month,-5,t1.fecha)
left join indexacionCPI t7 on t7.Fecha=DATEADD(month,-6,t1.fecha)
left join indexacionCPI t8 on t8.Fecha=DATEADD(month,-7,t1.fecha)
left join indexacionCPI t9 on t9.Fecha=DATEADD(month,-8,t1.fecha)
WHERE T1.Fecha=@FECHA

DELETE FROM IndexadoresContratos WHERE Fecha=@FECHA and version=@Version
INSERT into IndexadoresContratos
select @Version,* from (
	select	t1.fecha,'DIESEL'		Tipo,t1.Valor		from combustibletemp t1 where t1.IdTipoCombustible=1 union all
	select	t1.fecha,'DIESEL_3m'	Tipo,CASE WHEN round(t1.x3,3,1) - round(t1.x3,2,1) = 0.005 THEN round(t1.x3,2,1) ELSE round(t1.x3,2) END Valor 
														from combustibletemp t1 where t1.IdTipoCombustible=1 union all
	select	t2.fecha,'FUEL N° 6'	Tipo,t2.valor		from combustibletemp t2 where t2.IdTipoCombustible=2 union all
	select	t3.fecha,'CARBÓN'		Tipo,t3.Valor		from combustibletemp t3 where t3.IdTipoCombustible=3 union all
	select	t3.fecha,'Carbón_6m'	Tipo,CASE WHEN round(t3.x6,3,1) - round(t3.x6,2,1) = 0.005 THEN round(t3.x6,2,1) ELSE round(t3.x6,2) END
														from combustibletemp t3 where t3.IdTipoCombustible=3 union all
	select	t4.fecha,'GNL'			Tipo,t4.Valor		from combustibletemp t4 where t4.IdTipoCombustible=4 union all
	select	t4.fecha,'GNL_6m'		Tipo,CASE WHEN round(t4.X6,3,1) - round(t4.X6,2,1) = 0.005 THEN round(t4.X6,2,1) ELSE round(t4.X6,2) END
														from combustibletemp t4 where t4.IdTipoCombustible=4 union all
	select	t4.fecha,'GNL_4m'		Tipo,CASE WHEN round(t4.X4,3,1) - round(t4.X4,2,1) = 0.005 THEN round(t4.X4,2,1) ELSE round(t4.X4,2) END
														from combustibletemp t4 where t4.IdTipoCombustible=4 union all
	select	t5.fecha,'Brent'		Tipo,t5.Valor		from combustibletemp t5 where t5.IdTipoCombustible=5 union all
	select	t5.fecha,'Brent_6m'		Tipo,CASE WHEN round(t5.x6,3,1) - round(t5.x6,2,1) = 0.005 THEN round(t5.x6,2,1) ELSE round(t5.x6,2) END
														from combustibletemp t5 where t5.IdTipoCombustible=5 union all
	select	fecha,'CPI'				Tipo,Valor		from CPITemp union all
	select	fecha,'CPI_4m'			Tipo,CASE WHEN round(round(CPITemp.X4,4) - round(CPITemp.X4,3),4) = 0.0005 THEN round(CPITemp.X4,3,1)+0.001 ELSE round(CPITemp.X4,3) END
														from CPITemp union all
	select	fecha,'CPI_6m'			Tipo,CASE WHEN round(round(CPITemp.X6,4) - round(CPITemp.X6,3),4) = 0.0005 THEN round(CPITemp.X6,3,1)+0.001 ELSE round(CPITemp.X6,3) END
														from CPITemp union all
	select	fecha,'CPI_9m'			Tipo,CASE WHEN round(round(CPITemp.X9,4) - round(CPITemp.X9,3),4) = 0.0005 THEN round(CPITemp.X9,3,1)+0.001 ELSE round(CPITemp.X9,3) END
														from CPITemp
)t1

SELECT * FROM combustibletemp 
SELECT * FROM CPItemp 

--if (select fecha from CPITemp WHERE Fecha=@FECHA) is null print 'No están todos los antecedentes CPI para fecha' else print ''

drop table combustibletemp
drop table CPITemp

--select CASE WHEN round(256.0885,4,1) - round(256.0885,3,1) = 0.0005 THEN round(256.0885,3,1)+0.001 ELSE round(256.0885,3) END

--select * from CPITemp where fecha='2019-07-01'
--select round(256.0885,3)
--select round(256.0885,3,1)+0.001

--select x4,round(CPITemp.X4,3), round(CPITemp.X4,4),
--round(round(CPITemp.X4,4) - round(CPITemp.X4,3),4),
--CASE WHEN round(round(CPITemp.X4,4) - round(CPITemp.X4,3),4) = 0.0005 THEN round(CPITemp.X4,3,1)+0.001 ELSE round(CPITemp.X4,3) END
--from CPITemp where fecha='2019-07-01'
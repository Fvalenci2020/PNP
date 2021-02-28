USE PNP_3

--CÁLCULO PARA Estimación fondo PEC Noviembre-Diciembre 2020
--05:52

--DEFINICIÓN DE VERSIONES A EJECUTAR
	-- SON 4 VERSIONES, 2 ESTABILIZADA, Y 2 NO ESTABILIZADA

--SELECT * FROM versionrecdetalle WHERE REGISTRO='VersionEfact' AND ValorTexto in ('2011V2','2012V2','2011V2_SinIdDespacho=4','2012V2_SinIdDespacho=4')

IF OBJECT_ID('versiontemp', 'U') IS NOT NULL DROP TABLE versiontemp

SELECT iD= ROW_NUMBER() OVER(ORDER BY(SELECT NULL)),IdVersion
into versiontemp
FROM versionrecdetalle 
WHERE REGISTRO='VersionEfact' AND ValorTexto in ('2011V2','2012V2','2011V2_SinIdDespacho=4','2012V2_SinIdDespacho=4')

--Validación de existencia de todos los antecedentes
--/*
	--Factores de pérdida
select distinct t1.*,t2.fecha,t2.Version from (
SELECT T1.IdVersion,T1.ValorFecha,t2.ValorTexto
FROM versionrecdetalle T1
INNER JOIN versionrecdetalle T2 ON T1.IdVersion=T2.IdVersion
WHERE T1.Registro='FECHAPerdida' AND T1.IdVersion in (select IdVersion from versiontemp)
and t2.Registro='VersionPerdida') t1
left join perdidazonal T2 on t1.ValorFecha=t2.Fecha and t1.ValorTexto=t2.Version
	--Registros Precios PNP
select t1.*,t2.* from (
SELECT T1.IdVersion,T1.ValorFecha,t2.ValorTexto VersionPNP,t3.ValorTexto TipoPNP
FROM versionrecdetalle T1
INNER JOIN versionrecdetalle T2 ON T1.IdVersion=T2.IdVersion
inner join versionrecdetalle T3 ON T1.IdVersion=T3.IdVersion
WHERE T1.Registro='FECHAPNP' 
AND T1.IdVersion in (select IdVersion from versiontemp) and t2.Registro='VersionPNP' and t3.Registro='TipoPNP') t1
left join (select MesIndexacion,versionindex,[version],count(MesIndexacion) CantRegistrosPNP
			from pnp group by MesIndexacion,versionindex,[version]) t2 
					on t1.VersionPNP=t2.VersionIndex and t1.ValorFecha=t2.MesIndexacion and t1.TipoPNP=t2.[Version]

	--Registros Precios PNP para IdCodigoContrato
select *
from (select t2.idversion,t1.IdVersion IdVersionEfact,t1.Fecha,t1.IdCodigoContrato,t1.CantRegistros
			from (		SELECT T1.IdVersion,T1.ValorFecha,t3.IdVersion IdVersionEfact 
						FROM versionrecdetalle T1
						INNER JOIN versionrecdetalle T2 ON T1.IdVersion=T2.IdVersion
						inner join versionefact t3 on t3.Descripcion=t2.ValorTexto
						WHERE T1.Registro='FECHAEFACT' 
						AND T1.IdVersion in (select IdVersion from versiontemp) 
						and t2.Registro='VersionEfact') t2 
			left join (	select IdVersion,fecha,IdCodigoContrato,count(IdVersion) CantRegistros 
						from efact where IdTipoDespacho in (1,5) group by IdVersion,fecha,IdCodigoContrato )t1
			on t1.IdVersion=t2.IdVersionEfact and t1.Fecha=t2.ValorFecha) t1
left join 
	(select t1.IdVersion,t2.* 
			from (		SELECT T1.IdVersion,T1.ValorFecha,t2.ValorTexto VersionPNP,t3.ValorTexto TipoPNP
						FROM versionrecdetalle T1
						INNER JOIN versionrecdetalle T2 ON T1.IdVersion=T2.IdVersion
						inner join versionrecdetalle T3 ON T1.IdVersion=T3.IdVersion
						WHERE T1.Registro='FECHAPNP' 
						AND T1.IdVersion in (select IdVersion from versiontemp) 
						and t2.Registro='VersionPNP' and t3.Registro='TipoPNP') t1
			left join (select MesIndexacion,versionindex,[version],IdCodigoContrato
			from pnp group by MesIndexacion,versionindex,[version],IdCodigoContrato) t2 
					on t1.VersionPNP=t2.VersionIndex and t1.ValorFecha=t2.MesIndexacion and t1.TipoPNP=t2.[Version]) t2 
	on t1.IdCodigoContrato=t2.IdCodigoContrato and t1.IdVersion=t2.IdVersion
where t2.IdCodigoContrato is null

	--Registros CMG
select t1.*,t2.* from (
SELECT T1.IdVersion,t1.ValorTexto VersionCMG FROM versionrecdetalle T1 
WHERE T1.Registro='VersionCMG' AND idversion in (select IdVersion from versiontemp) 
) t1
left join (select VersionCMg,Fecha,count(IdBarraNacional) CantRegistros from CMGPromedio group by VersionCMg,Fecha) t2 
					on t1.VersionCMG=t2.VersionCMG 

	--Registros Precios PNPIndex para IdCodigoContrato
select *
from (select t2.idversion,t1.IdVersion IdVersionEfact,t1.Fecha,t1.IdCodigoContrato,t1.CantRegistros
			from (		SELECT T1.IdVersion,T1.ValorFecha,t3.IdVersion IdVersionEfact 
						FROM versionrecdetalle T1
						INNER JOIN versionrecdetalle T2 ON T1.IdVersion=T2.IdVersion
						inner join versionefact t3 on t3.Descripcion=t2.ValorTexto
						WHERE T1.Registro='FECHAEFACT' AND T1.IdVersion in (137,138,139,140) --(select IdVersion from versiontemp) 
						and t2.Registro='VersionEfact') t2 
			left join (	select IdVersion,fecha,IdCodigoContrato,count(IdVersion) CantRegistros 
						from efact where IdTipoDespacho in (4) group by IdVersion,fecha,IdCodigoContrato )t1
			on t1.IdVersion=t2.IdVersionEfact and t1.Fecha=t2.ValorFecha) t1
left join 
	(select t1.IdVersion,t2.* 
			from (		SELECT T1.IdVersion,T1.ValorFecha,t2.ValorTexto VersionPNP,t3.ValorTexto TipoPNP
						FROM versionrecdetalle T1
						INNER JOIN versionrecdetalle T2 ON T1.IdVersion=T2.IdVersion
						inner join versionrecdetalle T3 ON T1.IdVersion=T3.IdVersion
						WHERE T1.Registro='FECHAPNP' AND T1.IdVersion in (137,138,139,140) --(select IdVersion from versiontemp) 
						and t2.Registro='VersionPNP' and t3.Registro='TipoPNP') t1
			left join (select MesIndexacion,versionindex,[version],IdCodigoContrato
			from pnpindex group by MesIndexacion,versionindex,[version],IdCodigoContrato) t2 
					on t1.VersionPNP=t2.VersionIndex and t1.ValorFecha=t2.MesIndexacion and t1.TipoPNP=t2.[Version]) t2 
	on t1.IdCodigoContrato=t2.IdCodigoContrato and t1.IdVersion=t2.IdVersion
where t2.IdCodigoContrato is null

--*/

--CUIDADO CON IDTIPODESPACHO=4 CUANDO "VERSION CONTRATOS PNP" NO CONSIDERÓ ESTA SITUACIÓN
	--SE CONSIDERA REPLICAR idversion in(21,22), pero modificando IdDespacho=4 reemplazando por 1
/*
	--INSERT INTO versionefact values ('2011V2_SinIdDespacho=4')
	--INSERT INTO versionefact values ('2012V2_SinIdDespacho=4')--
	insert into efact
	select	[IdEfact], 23 [IdVersion],[Fecha],[IdDistribuidora],[IdGeneradora],[IdCodigoContrato],[IdPuntoRetiro],[Distribuidora],[Generadora],[CodigoContrato],[PuntoRetiro]
				,case when [IdTipoDespacho]=4 then 1 else [IdTipoDespacho] end [IdTipoDespacho],[Energia],[Potencia],[Observacion]
	from efact where IdVersion=21
		insert into efact
	select	[IdEfact], 24 [IdVersion],[Fecha],[IdDistribuidora],[IdGeneradora],[IdCodigoContrato],[IdPuntoRetiro],[Distribuidora],[Generadora],[CodigoContrato],[PuntoRetiro]
				,case when [IdTipoDespacho]=4 then 1 else [IdTipoDespacho] end [IdTipoDespacho],[Energia],[Potencia],[Observacion]
	from efact where IdVersion=22
--*/

DECLARE @i INT =1
DECLARE @IDVERSION INT
WHILE @i<=(select max(id) from versiontemp)
BEGIN
	--PARA REALIZAR RECAUDACIÓN
	select @IDVERSION=IdVersion from versiontemp where id=@i
	Exec [011_PROC_RECAUDACION] @IDVERSION

	--incremental
	set @i=@i+1
END;

--select * from recaudaciondetalle where IdVersion in (137,138,139,140)
select	idversion,FechaEfact,IdVersionEFact,
		sum(Energia*FactorFR) Energia,sum(potencia*FactorFR) potencia,
		sum(EPC) EnergiaPC,sum(PPC)PotenciaPC,sum(ERec_Peso) EnergiaRecPeso,sum(PRec_Peso) PotenciaRecPeso
from Recaudaciondetalle
where IdVersion in (select idversion from versiontemp)
group by idversion,FechaEfact,IdVersionEFact
order by idversion,FechaEfact,IdVersionEFact

--borrar tablas temporales
IF OBJECT_ID('versiontemp', 'U') IS NOT NULL DROP TABLE versiontemp

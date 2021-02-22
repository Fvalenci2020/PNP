--PROCEDIMIENTO PARA INDEXACION DE CONTRATOS.

--/*
alter PROCEDURE [014_PROC_INDEXACONTRATO]
					@VersionIndex		varchar(255),
					@MesIndexacion		date,
					@Version			varchar(255),
					@TipoIndexacion		varchar(255),
					@VersionFijacion	varchar(255),
					@MesFijacion		date,					
					@FECHAPNCP			date
AS
--*/

--PARA EJECUCIÓN LOCAL
/*
use pnp_3
declare @VersionIndex		varchar(255)='Carla1'--version del mes que toma la referencia de los factores de indexación, es equivalente al mes sobre el cual se están indexando los contratos.
declare @MesIndexacion		date='2020-10-01'--mes que toma la referencia de los factores de indexación, es equivalente al mes sobre el cual se están indexando los contratos.
declare @Version			varchar(255)='Mes'--indica si son precios del contratos PNP o contratos definitiva. Cuando es ITD, se fuerzan precios de contratos futuros que estén activos hasta 6 meses depsués de mes indexación
--Cuando se realiza la indexación para el mes a ser utilizado para el modelo PNP, se debe indicar el mes de indexación (para el caso de enero 2021, sería octubre 2020 y tipo pnp=ITD, entonces cuando se transfiere  a la tabla "PNP" se le coloca el mes de referencia.
declare @TipoIndexacion			varchar(255)='V1'--indica elementos de IndexadoresContratos para indexar los contratos. se utiliza en caso de simulaciones de indexadores.
declare @VersionFijacion	varchar(255)='ITPV1'--version del mes de fijación, para comparación de límite del 10%.
declare @MesFijacion		date='2020-10-01'--mes de fijación, para comparación de límite del 10%.
declare @FECHAPNCP			date='2020-10-01'--Fecha del PNCP utilizado.

--Debería entregar como resultado la tabla "PNP", es decir precios para contratos
--Version	IdPNP	Fecha	Version	RExBases	DecPNudo	Modalidad	Licitacion	TipoBloque	BLOQUE	Distribuidora	PtoOferta	Generadora	PtoCompra	PE	PP	CET_USD	PE_Index_USD	PP_Index_USD	Observacion
--*/

	--UNIFCA TODOS LOS ELEMENTOS NECESARIOS para realizar indexación de contratos
delete from IndexacionContratoDetalle where MesIndexacion=@MesIndexacion AND VersionIndex=@VersionIndex and Version=@Version

	--Versión='Mes'
insert into IndexacionContratoDetalle
select	@VersionIndex VersionIndex,@MesIndexacion MesIndexacion,@Version Version
		,t1.IdLicitacionGx,t1.Licitacion,t1.Generadora,t1.TipoBloque,t1.Bloque,t1.PtoOferta,t1.PrecioEnergia PrecioEnergiaBase
		,t1.IdDecrPNudo,t1.DecPNudo,t1.TipoDecreto,t3.Precio
		,t4.tipoindex,t4.[index],t1.MesReferencia,t4.rezago,t4.Ponderador
		,t5.fecha FechaBase
		,case	when t9.valor is not null then t9.valor 
				else t5.Valor end ValorBase
		,dateadd(month,(-t4.rezago),@MesIndexacion) FechaActual,t6.Valor ValorActual
		,case	--when t6.Valor is null or t5.Valor is null then 0 
				when t6.Valor is not null and t5.Valor is not null and t9.valor is not null then t6.Valor/t9.Valor 
				when t6.Valor is not null and t5.Valor is not null and t9.valor is null  then t6.Valor/t5.Valor end FactorIndexacion		
		,case	when Tipoindex='P' then t6.Valor/t5.Valor*t4.Ponderador*t3.Precio 
				when Tipoindex!='P'  and t6.Valor is not null and t5.Valor is not null and t9.valor is not null then t6.Valor/t9.Valor*t4.Ponderador*t1.PrecioEnergia 
				when Tipoindex!='P'  and t6.Valor is not null and t5.Valor is not null							then t6.Valor/t5.Valor*t4.Ponderador*t1.PrecioEnergia end PrecioIndexadoPonderado
		,case	when t6.Valor is null or t5.Valor is null then 1 
				else 0 end FlagInd	
		,case	when t9.valor is not null or t1.Observacion is not null then concat(t1.Observacion,t9.Observacion) 
				else '' end Observacion
from LicitacionGx t1--Gx,lictación contiene precio ofertado
left join PrecioNudoLicitacion t3 on t3.IdDecPNudo=t1.IdDecrPNudo and t3.Tipo='Pp' and t3.TipoDecreto=t1.Tipodecreto--precios Decreto PN, se usa los de potencia
left join LicitacionGxIndexacion t4 on t4.IdLicitacionGx=t1.IdLicitacionGx-- relación Licitación-Gx indica info de indexación
left join IndexadoresContratos t5 on t5.fecha=dateadd(month,(-t4.rezago),t1.MesReferencia) and t4.[index]=t5.Tipo and t5.Version=@TipoIndexacion--extrae indexadores base
left join IndexadoresContratos t6 on t6.fecha=dateadd(month,(-t4.rezago),@MesIndexacion) and t4.[index]=t6.Tipo and t6.Version=@TipoIndexacion--extrae indexadores del mes
left join LicitacionGxIndexEsp t9 on t9.IdLicitacionGx =t1.IdLicitacionGx and t9.tipo=t5.tipo--indexación situaciones especiales
where	t1.VigenciaInicio<=@MesIndexacion and @MesIndexacion<=t1.VigenciaFin--que contrato esté activo
		and @Version='Mes'

	--Versión='ITD'
insert into IndexacionContratoDetalle
select	@VersionIndex VersionIndex,@MesIndexacion MesIndexacion,@Version Version
		,t1.IdLicitacionGx,t1.Licitacion,t1.Generadora,t1.TipoBloque,t1.Bloque,t1.PtoOferta,t1.PrecioEnergia PrecioEnergiaBase
		,t1.IdDecrPNudo,t1.DecPNudo,t1.TipoDecreto,t3.Precio PrecioPotenciaBase
		,t4.tipoindex,t4.[index],t1.MesReferencia,t4.rezago,t4.ponderador
		,t5.fecha FechaBase
		,case	when t9.valor is not null then t9.valor 
				else t5.Valor end ValorBase
		,dateadd(month,(-t4.rezago),@MesFijacion) FechaActual,t6.Valor ValorActual
		,case	--when t6.Valor is null or t5.Valor is null then 0 
				when t6.Valor is not null and t5.Valor is not null and t9.valor is not null then t6.Valor/t9.Valor 
				when t6.Valor is not null and t5.Valor is not null and t9.valor is null  then t6.Valor/t5.Valor end FactorIndexacion		
		,case	when Tipoindex='P' then t6.Valor/t5.Valor*t4.ponderador*t3.Precio 
				when Tipoindex!='P'  and t6.Valor is not null and t5.Valor is not null and t9.valor is not null  then t6.Valor/t9.Valor*t4.ponderador*t1.PrecioEnergia 
				when Tipoindex!='P'  and t6.Valor is not null and t5.Valor is not null  then t6.Valor/t5.Valor*t4.ponderador*t1.PrecioEnergia end PrecioIndexadoPonderado
		,case	when t6.Valor is null or t5.Valor is null then 1 
				else 0 end FlagInd
		,case	when t9.valor is not null or t1.Observacion is not null then concat(t1.Observacion,t9.Observacion) 
				else '' end Observacion
from LicitacionGx t1--Gx,lictación contiene precio ofertado
left join PrecioNudoLicitacion t3 on t3.IdDecPNudo=t1.IdDecrPNudo and t3.Tipo='Pp' and t3.TipoDecreto=t1.Tipodecreto--precios Decreto PN, se usa los de potencia
left join LicitacionGxIndexacion t4 on t4.IdLicitacionGx=t1.IdLicitacionGx-- relación Licitación-Gx indica info de indexación
left join IndexadoresContratos t5 on t5.fecha=dateadd(month,(-t4.rezago),t1.MesReferencia) and t4.[index]=t5.Tipo and t5.Version=@TipoIndexacion--extrae indexadores base
left join IndexadoresContratos t6 on t6.fecha=dateadd(month,(-t4.rezago),@MesFijacion) and t4.[index]=t6.Tipo and t6.Version=@TipoIndexacion--extrae indexadores del mes de la última fijación
left join LicitacionGxIndexEsp t9 on t9.IdLicitacionGx =t1.IdLicitacionGx and t9.tipo=t5.tipo--indexación situaciones especiales
where	dateadd(month,-6,t1.VigenciaInicio)<=@MesIndexacion and @MesIndexacion<=t1.VigenciaFin--que contrato esté activo en periodo de Decreto PNP
		and @Version='ITD'
--select * from IndexacionContratoDetalle where MesIndexacion=@MesIndexacion AND VersionIndex=@VersionIndex and tipopnp=@TipoPNP--para ver lo que se ´va a trabajar

--TEMPORAL PARA UNIFICAR ERRORES DE CRUCE DE DATOS QUE SIGNIFCA QUE FALTAN VALORES BASE O MES INDEXADOS
--drop table if exists temperrores
IF OBJECT_ID('temperrores', 'U') IS NOT NULL DROP TABLE temperrores

DECLARE @STRUCTURED_VALUES TABLE (
    idlicitaciongx int,FechaBase date,FechaActual date,[Index] VARCHAR(MAX) NULL,VALUENUMBER BIGINT,VALUECOUNT INT
);

INSERT INTO @STRUCTURED_VALUES
SELECT   idlicitaciongx,FechaBase,FechaActual,[Index]
        ,ROW_NUMBER() OVER (PARTITION BY idlicitaciongx,FechaBase,FechaActual ORDER BY [Index]) AS VALUENUMBER
        ,COUNT(*) OVER (PARTITION BY idlicitaciongx,FechaBase,FechaActual)    AS VALUECOUNT
FROM    IndexacionContratoDetalle
where FlagInd=1 and MesIndexacion=@MesIndexacion AND VersionIndex=@VersionIndex and Version=@Version;
;
WITH CTE AS (
    SELECT   SV.idlicitaciongx,SV.FechaBase,SV.FechaActual,SV.[Index],SV.VALUENUMBER,SV.VALUECOUNT
    FROM    @STRUCTURED_VALUES SV
    WHERE   VALUENUMBER = 1

    UNION ALL

    SELECT   SV.idlicitaciongx,SV.FechaBase,SV.FechaActual
            ,CTE.[Index] + '-' + SV.[Index] AS [Index]
            ,SV.VALUENUMBER,SV.VALUECOUNT
    FROM    @STRUCTURED_VALUES SV
    JOIN    CTE 
        ON  SV.idlicitaciongx=CTE.idlicitaciongx and SV.FechaBase=CTE.FechaBase and SV.FechaActual=CTE.FechaActual
        AND SV.VALUENUMBER = CTE.VALUENUMBER + 1
)

SELECT   idlicitaciongx,FechaBase,FechaActual,[Index] FlagInd
into temperrores
FROM    CTE
WHERE   VALUENUMBER = VALUECOUNT
ORDER BY idlicitaciongx,FechaBase,FechaActual
;
select *,'Contratos con indexadores faltantes' Observacion from temperrores

--CREAR INDEXACIÓN DEL MES EQUIVALENTE
	--Para cada idlicitacioncontrato, pondera los factores de Energía 
--drop table if exists FactorEnergiaTemp
IF OBJECT_ID('FactorEnergiaTemp', 'U') IS NOT NULL DROP TABLE FactorEnergiaTemp
select	t1.idlicitaciongx
		,sum(FactorIndexacion*ponderador)*(CASE WHEN COUNT(FactorIndexacion)<COUNT(*) THEN null ELSE 1 END) FactorIndexacionEnergia
		,sum(PrecioIndexadoPonderado)*(CASE WHEN COUNT(FactorIndexacion)<COUNT(*) THEN null ELSE 1 END) PrecioEnergiaIndexado
		,t2.FlagInd
into FactorEnergiaTemp
from IndexacionContratoDetalle t1 
left join temperrores t2 on t1.idlicitaciongx=t2.idlicitaciongx
where tipoindex !='P' and MesIndexacion=@MesIndexacion AND VersionIndex=@VersionIndex and Version=@Version
group by t1.idlicitaciongx,t2.FlagInd
--select * from FactorEnergiaTemp order by idlicitaciongx

	--Para cada idlicitacioncontrato, pondera los factores de Potencia 
--drop table if exists FactorPotenciaTemp
IF OBJECT_ID('FactorPotenciaTemp', 'U') IS NOT NULL DROP TABLE FactorPotenciaTemp
select	t1.idlicitaciongx
		,sum(FactorIndexacion*ponderador)*(CASE WHEN COUNT(FactorIndexacion)<COUNT(*) THEN null ELSE 1 END) FactorIndexacionPotencia
		,sum(PrecioIndexadoPonderado)*(CASE WHEN COUNT(FactorIndexacion)<COUNT(*) THEN null ELSE 1 END) PrecioPotenciaIndexado
into FactorPotenciaTemp
from IndexacionContratoDetalle t1 where tipoindex ='P' and MesIndexacion=@MesIndexacion AND VersionIndex=@VersionIndex and Version=@Version
group by t1.idlicitaciongx
--select *from FactorPotenciaTemp

	--Para cada idlicitacioncontrato, obtiene antecedentes únicos del licitacióncontrato
--drop table if exists IndexacionContratoDetalleTemp
IF OBJECT_ID('IndexacionContratoDetalleTemp', 'U') IS NOT NULL DROP TABLE IndexacionContratoDetalleTemp
select t1.versionIndex,t1.MesIndexacion,t1.Version,t1.idlicitaciongx,t1.Licitacion,t1.Generadora,t1.TipoBloque,t1.Bloque,t1.PtoOferta
		,t1.PrecioEnergiaBase,t1.IdDecrPNudo,t1.DecPNudo,t1.TipoDecreto,t1.PrecioPotenciaBase,'' Observacion--t1.Observacion
		,count(idlicitaciongx) Cantidad
into IndexacionContratoDetalleTemp
from IndexacionContratoDetalle t1
where MesIndexacion=@MesIndexacion AND VersionIndex=@VersionIndex and Version=@Version
group by t1.versionIndex,t1.MesIndexacion,t1.Version,t1.idlicitaciongx,t1.Licitacion,t1.Generadora,t1.TipoBloque,t1.Bloque,t1.PtoOferta
		,t1.PrecioEnergiaBase,t1.IdDecrPNudo,t1.DecPNudo,t1.TipoDecreto,t1.PrecioPotenciaBase--,t1.Observacion
--select * from IndexacionContratoDetalleTemp

	--Asigna Factores de energía y potencia a cada licitacióncontrato
--drop table if exists ICtemp
IF OBJECT_ID('ICtemp', 'U') IS NOT NULL DROP TABLE ICtemp
select t1.versionIndex,t1.MesIndexacion,t1.Version,t1.idlicitaciongx,t1.Licitacion,t1.Generadora,t1.TipoBloque,t1.Bloque,t1.PtoOferta
		,t1.PrecioEnergiaBase,t1.IdDecrPNudo,t1.DecPNudo,t1.TipoDecreto,t1.PrecioPotenciaBase		
		,FactorIndexacionPotencia,FactorIndexacionEnergia 
		,PrecioEnergiaIndexado,PrecioPotenciaIndexado
		,case when t3.FlagInd is null then '' else t3.FlagInd end FlagInd,'' Observacion--t1.Observacion
into ICtemp
from IndexacionContratoDetalleTemp t1
left join FactorEnergiaTemp t2	on t1.idlicitaciongx=t2.idlicitaciongx 
left join temperrores t3		on t1.idlicitaciongx=t3.idlicitaciongx
left join FactorPotenciaTemp t4 on t1.idlicitaciongx=t4.idlicitaciongx 
where t1.MesIndexacion=@MesIndexacion AND t1.VersionIndex=@VersionIndex and t1.Version=@Version
order by idlicitaciongx
--select * from ICtemp

--VALIDACIÓN DE RESTRICCIONES DE LÍMITE DEL 10% O SI ES MES DE FIJACIÓN
delete from IndexacionContrato where MesIndexacion=@MesIndexacion and versionindex=@VersionIndex and Version=@Version

	--INDEXACIÓN CONTRATO PARA MES CON FIJACIÓN y Version='Mes'
insert into IndexacionContrato 
select	t1.versionIndex,t1.MesIndexacion Fecha,t1.Version,t1.idlicitaciongx,t1.Licitacion,t1.Generadora
		,t1.TipoBloque,t1.Bloque,t1.PtoOferta,t1.PrecioEnergiaBase,t1.IdDecrPNudo,t1.DecPNudo,t1.TipoDecreto,t1.PrecioPotenciaBase
		,t1.FactorIndexacionPotencia,t1.FactorIndexacionEnergia,t1.PrecioEnergiaIndexado,t1.PrecioPotenciaIndexado,t1.FlagInd
		,'ConFijacion' FlagFij
		,t1.MesIndexacion MesFijacion,t1.PrecioEnergiaIndexado PrecioEnergiaFijacion,t1.PrecioPotenciaIndexado PrecioPotenciaFijacion,0 VariacionE,0 VariacionP
		,0 IndexE
		,0 IndexP
		,t1.PrecioEnergiaIndexado PrecioEnergia
		,t1.PrecioPotenciaIndexado PrecioPotencia
		,t1.Observacion Observacion
from ICtemp t1
where	month(@MesIndexacion) in (4,10)--ABRIL Y OCTUBRE MESES CON FIJACIÓN
		and @Version='Mes'
--select * from IndexacionContrato  where MesIndexacion=@MesIndexacion and versionindex=@VersionIndex and Version=@Version

	--INDEXACIÓN CONTRATO PARA MES SIN FIJACIÓN y Version='Mes'
insert into IndexacionContrato 
select	t1.versionIndex,t1.MesIndexacion,t1.Version,t1.idlicitaciongx,t1.Licitacion,t1.Generadora
		,t1.TipoBloque,t1.Bloque,t1.PtoOferta,t1.PrecioEnergiaBase,t1.IdDecrPNudo,t1.DecPNudo,t1.TipoDecreto,t1.PrecioPotenciaBase
		,t1.FactorIndexacionPotencia,t1.FactorIndexacionEnergia,t1.PrecioEnergiaIndexado,t1.PrecioPotenciaIndexado,t1.FlagInd
		,case when t2.MesFijacion is null then 'SinFijacion' else '' end FlagFij,
		t2.MesFijacion,t2.precioenergia PrecioEnergiaFijacion,t2.preciopotencia PrecioPotenciaFijacion
		,t1.PrecioEnergiaIndexado/t2.precioenergia-1 VariacionE
		,t1.PrecioPotenciaIndexado/t2.preciopotencia-1 VariacionP
		,case when abs(t1.PrecioEnergiaIndexado/t2.precioenergia-1)>0.1 then 1 else 0 end IndexE
		,case when abs(t1.PrecioPotenciaIndexado/t2.preciopotencia-1)>0.1 then 1 else 0 end IndexP
		,case when abs(t1.PrecioEnergiaIndexado/t2.precioenergia-1)>0.1 then t1.PrecioEnergiaIndexado else t2.precioenergia end PrecioEnergia
		,case when abs(t1.PrecioPotenciaIndexado/t2.preciopotencia-1)>0.1 then t1.PrecioPotenciaIndexado else t2.preciopotencia end PrecioPotencia
		,''
from ICtemp t1
left join (select * from IndexacionContrato where MesIndexacion=@MesFijacion and VersionIndex=@VersionFijacion and Version='Mes')t2 
			on t1.idlicitaciongx=t2.idlicitaciongx
where	month(@MesIndexacion) not in (4,10)
		and @Version='Mes'

	--INDEXACIÓN CONTRATO PARA MES SIN FIJACIÓN y Version='ITD'
insert into IndexacionContrato 
select	t1.versionIndex,t1.MesIndexacion,t1.Version,t1.idlicitaciongx,t1.Licitacion,t1.Generadora
		,t1.TipoBloque,t1.Bloque,t1.PtoOferta,t1.PrecioEnergiaBase,t1.IdDecrPNudo,t1.DecPNudo,t1.TipoDecreto,t1.PrecioPotenciaBase
		,t1.FactorIndexacionPotencia,t1.FactorIndexacionEnergia,t1.PrecioEnergiaIndexado,t1.PrecioPotenciaIndexado,t1.FlagInd
		,case when t2.MesFijacion is null then 'FijacionITD' else '' end FlagFij
		,case when t2.MesFijacion is null then @MesFijacion else t2.MesFijacion end FlagFij
		,t2.precioenergia PrecioEnergiaFijacion,t2.preciopotencia PrecioPotenciaFijacion
		,0 VariacionE--Se fuerza 0 como si fuera mes con fijación
		,0 VariacionP--Se fuerza 0 como si fuera mes con fijación
		,0 IndexE
		,0 IndexP
		,t1.PrecioEnergiaIndexado PrecioEnergia
		,t1.PrecioPotenciaIndexado PrecioPotencia
		,''
from ICtemp t1
left join (select * from IndexacionContrato where MesIndexacion=@MesFijacion and VersionIndex=@VersionFijacion and Version='Mes')t2 
			on t1.idlicitaciongx=t2.idlicitaciongx
where	@Version='ITD'
--select * from IndexacionContrato  where MesIndexacion=@MesIndexacion and versionindex=@VersionIndex and Version=@Version

select * from IndexacionContrato where MesIndexacion=@MesIndexacion and versionindex=@VersionIndex and Version=@Version and FlagIndx!=''--Registros con indexación incompleta 

--INDEXACION DE CET

delete from IndexacionCET where MesIndexacion=@MesIndexacion and versionindex=@VersionIndex and Version=@Version

	--INDEXACIÓN CONTRATO PARA Version='Mes'
insert into IndexacionCET
select	@VersionIndex VersionIndex,@MesIndexacion MesIndexacion,@Version [Version],t1.*,t2.fecha FechaBase,t2.Valor ValorBase
		,t3.fecha FechaActual,t3.Valor ValorActual
		,t3.Valor/t2.Valor FactorIndexacion
		,t3.Valor/t2.Valor*CET0 ValorCET
from CET t1
left join IndexadoresContratos t2 on t2.fecha=dateadd(month,(-t1.rezago),t1.MesReferencia) and t2.Tipo=t1.[Index] and t2.Version=@TipoIndexacion
left join IndexadoresContratos t3 on t3.fecha=dateadd(month,(-t1.rezago),@MesIndexacion) and t3.Tipo=t1.[Index] and t3.Version=@TipoIndexacion
where @version='Mes'

	--INDEXACIÓN CONTRATO PARA Version='ITD'
insert into IndexacionCET
select	@VersionIndex VersionIndex,@MesIndexacion MesIndexacion,@Version [Version],t1.*,t2.fecha FechaBase,t2.Valor ValorBase
		,t3.fecha FechaActual,t3.Valor ValorActual
		,t3.Valor/t2.Valor FactorIndexacion
		,t3.Valor/t2.Valor*CET0 ValorCET
from CET t1
left join IndexadoresContratos t2 on t2.fecha=dateadd(month,(-t1.rezago),t1.MesReferencia) and t2.Tipo=t1.[Index] and t2.Version=@TipoIndexacion
left join IndexadoresContratos t3 on t3.fecha=dateadd(month,(-t1.rezago),@MesFijacion) and t3.Tipo=t1.[Index] and t3.Version=@TipoIndexacion
where @version='ITD'

--select * from IndexacionCET where MesIndexacion=@MesIndexacion and versionindex=@VersionIndex and Version=@Version

--CONTRATOS EN PUNTO DE COMPRA CON CET

	--CREACION DE CODIGOCONTRATO temporal
--DROP TABLE IF EXISTS CodigoContrato1
IF OBJECT_ID('CodigoContrato1', 'U') IS NOT NULL DROP TABLE CodigoContrato1
SELECT	t3.IdCodigoContrato,t3.CODIGOCONTRATO
		,T1.IdLicitacionGx,t1.IdLicitacion,t1.IdGeneradora,t2.IdDistribuidora,t1.IdDecrPNudo
		,t1.Licitacion,T1.Generadora,IdPtoOferta,PtoOferta,T1.TipoBloque,T1.BLOQUE
		,T2.IdLicitacionDx,T1.RExBases,T1.DecPNudo,T1.Modalidad,T3.Distribuidora
		,t1.VigenciaInicio,t1.VigenciaFin
into CodigoContrato1
from codigocontrato t3
--inner join VigenciaContrato t8 on t3.Licitacion=t8.Licitacion and t8.Gx=t3.Generadora and t8.bloque=t3.BLOQUE
left join LicitacionGx t1 on	t3.licitacion=t1.Licitacion and t3.generadora=t1.Generadora and t3.bloque=t1.BLOQUE 
								and t3.tipobloque=t1.TipoBloque
left join LicitacionDx t2 on t3.Licitacion=t2.Licitacion and t2.Distribuidora=t3.Distribuidora
where VigenciaInicio<=@MesIndexacion and @MesIndexacion<=VigenciaFin--que contrato esté activo

--APERTURAR CONTRATOS INDEXADOS A TODOS LOS PUNTOS DE COMPRA
delete from indexacioncontratoFM  where MesIndexacion=@MesIndexacion and versionindex=@VersionIndex and [Version]=@Version

insert into indexacioncontratoFM
select	t1.VersionIndex,t1.MesIndexacion,t1.[Version],t0.IDCodigoContrato,t0.CodigoContrato,t1.[Licitacion],t1.TipoBloque,t1.[Bloque]
		,t0.Distribuidora,t1.[Generadora],t0.idptooferta,t1.PtoOferta,t3.idbarranacional,t3.BarraNacional
		,t1.[PrecioEnergia],t1.[PrecioPotencia],t4.ValorCET
		,right(t0.RExBases,4) RExBasesAno
		,case	when right(t0.RExBases,4)<2013 and t11.PtoCompra is not null then concat('DecretoPN ', t0.DecPNudo)
				when right(t0.RExBases,4)<2013 and t11.PtoCompra is null then concat('DecretoPNCP ',@FECHAPNCP)
				when right(t0.RExBases,4)>=2013 then concat('DecretoPNCP ',@FECHAPNCP)
				end OrigenFMO
		,case	when right(t0.RExBases,4)<2013 and t11.PtoCompra is not null then t5.valor
				when right(t0.RExBases,4)<2013 and t11.PtoCompra is null then t7.FME
				when right(t0.RExBases,4)>=2013 then t7.FME
				end FMEOferta
		,case	when right(t0.RExBases,4)<2013 and t11.PtoCompra is not null then t6.valor
				when right(t0.RExBases,4)<2013 and t11.PtoCompra is null then t7.FMP
				when right(t0.RExBases,4)>=2013 then t7.FMP
				end FMPOferta
		,case	when right(t0.RExBases,4)<2013 and t11.PtoCompra is not null then t8.valor
				when right(t0.RExBases,4)<2013 and t11.PtoCompra is null then t10.FME
				when right(t0.RExBases,4)>=2013 then t10.FME
				end FMESuministro
		,case	when right(t0.RExBases,4)<2013 and t11.PtoCompra is not null then t9.valor
				when right(t0.RExBases,4)<2013 and t11.PtoCompra is null then t10.FMP
				when right(t0.RExBases,4)>=2013 then t10.FMP
				end FMPSuministro
		,0 PE,0 PP,'' Observacion
from CodigoContrato1 t0--extrae combinaciones únicas de códigos de contratos activos
left join IndexacionContrato t1 on t1.IdLicitacionGx=t0.IdLicitacionGx--agrega precios de E y P de códigos de contrato indexados.
left join IndexacionCET t4 on	t4.IdLicitacionDx=t0.IdLicitacionDx and t4.IdGeneradora=t0.IdGeneradora 
								and t1.MesIndexacion=t4.MesIndexacion and t4.VersionIndex=t1.VersionIndex and t4.Version=t1.Version--Agrega CET indexado
left join BarraNacional t3 on t3.idBarraNacional=t3.idBarraNacional--Apertura a todas las barras nacionales disponibles (quizás de ahi liminar a la combinación Dx-BarraNacional que viene de Efact, pero queda muy puntual)
left join licitaciongxdxptocompra t11 on t11.IdLicitacionDx=t0.IdLicitacionDx and t11.IdLicitacionGx=t0.IdLicitacionGx and t11.IdPtoCompra=t3.IdBarraNacional--asigna puntos de compra
left join FactorModulacion t5 on t5.idBarraNacional=t0.idPtoOferta and t0.IdDecrPNudo=t5.IdDecreto and t5.Tipo='E'--factores de modulación por decreto P nudo y punto de oferta--Energía
left join FactorModulacion t6 on t6.idBarraNacional=t0.idPtoOferta and t0.IdDecrPNudo=t6.IdDecreto and t6.Tipo='P'--factores de modulación por decreto P nudo y punto de oferta--Potencia
left join PNCP t7 on t7.idnudo=t0.IdPtoOferta and t7.Mes=@FECHAPNCP--info de PNCP, obtiene factores de modulación para puntos de oferta.
inner join PNCP t10 on t10.Mes=@FECHAPNCP and t10.idnudo=t3.IdBarraNacional--info de PNCP, obtiene factores de modulación para puntos de compra.
left join FactorModulacion t8 on t8.idBarraNacional=t3.idBarraNacional and t0.IdDecrPNudo=t8.IdDecreto and t8.Tipo='E'--factores de modulación por decreto P nudo y punto de compra--Energía
left join FactorModulacion t9 on t9.idBarraNacional=t3.idBarraNacional and t0.IdDecrPNudo=t9.IdDecreto and t9.Tipo='P'--factores de modulación por decreto P nudo y punto de compra--Potencia
where t1.MesIndexacion=@MesIndexacion and t1.versionindex=@VersionIndex and t1.Version=@Version

--ACTUALIZAR PE y PP
	--Basado en toda la información previamente cargada a la tabla
update indexacioncontratoFM set PNELP=([PrecioEnergia]-ISNULL(ValorCET, 0 ))*FMESuministro/FMEOferta where MesIndexacion=@MesIndexacion and versionindex=@VersionIndex and Version=@Version
update indexacioncontratoFM set PNPLP=([PrecioPotencia])*FMPSuministro/FMPOferta where MesIndexacion=@MesIndexacion and versionindex=@VersionIndex and Version=@Version

--select * from indexacioncontratoFM  where MesIndexacion=@MesIndexacion and versionindex=@VersionIndex and [Version]=@Version

--Borrar tablas temporales

drop table temperrores
drop table FactorEnergiaTemp
drop table FactorPotenciaTemp
drop table IndexacionContratoDetalleTemp
drop table ICtemp
DROP TABLE CodigoContrato1
--*/

--CGE Distribucion
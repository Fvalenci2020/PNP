use pnp_3

--PROTOTIPO DE DESPACHO DE CONTRATOS

--pendiente de trabajar despacho de mataquito "Traspaso Excedentes".
--Pendiente trabajar con tipodespacho=Dx con contratos Holding. Cachar si se debe agregar a demanda de empresa Holding no más. puntos de retiro compartidos

/****** Object:  StoredProcedure [dbo].[014_PROC_INDEXACONTRATO]    Script Date: 06-05-2021 10:40:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[015_PROC_DESPACHO]
					@VersionD VARCHAR(45),
					@VersionPZ VARCHAR(45),
					@PeriodoFR VARCHAR(45),
					@Ano int,
					@DemandaDespacho VARCHAR(45)
AS

--DEFINIFICÓN DATOS DE CÁLCULO
/*
DECLARE @VersionD VARCHAR(45)='2007ProyV1' --segundo semestre 2020
DECLARE @VersionPZ VARCHAR(45)='Estimado' -- utiliza pérdida estimada
DECLARE @PeriodoFR VARCHAR(45)='Segundo Semestre 2020'-- indica cuáles factores de referenciación utiliza
DECLARE @Ano int=2020-- año de análisis.
DECLARE @DemandaDespacho VARCHAR(45)='Despacho2007ProyV1' -- utiliza pérdida estimada
--*/

--SELECCIONAR DEMANDA QUE SE VA A UTILIZAR EN ESTE DESPACHO
IF OBJECT_ID('tempdemanda', 'U') IS NOT NULL DROP TABLE tempdemanda
SELECT * 
INTO tempdemanda
FROM DespachoDemanda WHERE VersionDemandaDespacho=@DemandaDespacho
--select * from tempdemanda

--LLEVAR DEMANDA A PUNTO DE COMPRA
--Relación Demmanda Pto Retiro y Barra Nacional, se utiliza para al final para transformar relación idcontrato/BarraNacional a IdContrato/Ptoretiro
--/*
--IF OBJECT_ID('Demanda_PtoRetiro_PtoCompra', 'U') IS NOT NULL DROP TABLE Demanda_PtoRetiro_PtoCompra
delete from Demanda_PtoRetiro_PtoCompra where VersionDemandaDespacho=@DemandaDespacho
insert into Demanda_PtoRetiro_PtoCompra
SELECT	t1.VersionDemandaDespacho,t1.VersionDemanda,t1.IdDistribuidora,t1.Mes,t1.IdPuntoRetiro,t1.IdSistemaZonal,t2.Version VersionPZ,t3.Periodo PeriodoFR
		,t3.IdBarraNacional,T1.IdTipoDespacho,T1.IdDistribuidoraDespacho
		,t1.Demanda DemandaPR
		,t2.Factor FactorPZ,t3.Factor FactorR,t2.Factor*t3.Factor FactorBN ,(Demanda*t2.Factor*t3.Factor*1000) EnergiaPC
		,(Demanda*t2.Factor*t3.Factor*1000)/(sum((Demanda*t2.Factor*t3.Factor*1000)) over (partition by t1.VersionDemanda,t1.IdDistribuidora,t1.Mes,t3.IdBarraNacional)) Factor
--into Demanda_PtoRetiro_PtoCompra
FROM tempdemanda  T1
LEFT JOIN PerdidaZonal T2 ON T1.IdSistemaZonal=T2.IdSistemaZonal and t1.Mes=t2.Fecha and t2.TipoFactor='FEPE' and T2.Version=@VersionPZ 
Left join	factorreferenciacion t3 on t3.IdPuntoRetiro=t1.IdPuntoRetiro and t3.Periodo=@PeriodoFR		
--select * from Demanda_PtoRetiro_PtoCompra
--*/

--DISTRIBUCIÓN DE DEMANDA PARA PODER TRABAJAR ASIGNACIONES

--Demanda_Dx_PtoCompra. Demanda de cada distribuidora referenciada a Puntos de Compra por mes.  con Factor % de Energia por pto de compra sobre mes-Dx
--/*
IF OBJECT_ID('Demanda_Dx_PtoCompra', 'U') IS NOT NULL DROP TABLE Demanda_Dx_PtoCompra

select	t1.VersionDemandaDespacho,t1.versiondemanda,t1.IdDistribuidora,t1.mes,t1.IdBarraNacional,t1.IdDistribuidoraDespacho,t1.IdTipoDespacho,t1.EnergiaPC EnergiaPC
		,t1.EnergiaPC/sum(t1.EnergiaPC) over (partition by t1.versiondemanda,t1.IdDistribuidoraDespacho,t1.mes) FactPtoCompra
into Demanda_Dx_PtoCompra
from (	select t1.VersionDemandaDespacho,t1.versiondemanda,t1.IdDistribuidora,t1.mes,t1.IdBarraNacional,t1.IdDistribuidoraDespacho,t1.IdTipoDespacho,sum(t1.EnergiaPC) EnergiaPC 
		from  Demanda_PtoRetiro_PtoCompra t1 group by t1.VersionDemandaDespacho,t1.versiondemanda,t1.IdDistribuidora,t1.mes,t1.IdBarraNacional,t1.IdDistribuidoraDespacho,t1.IdTipoDespacho
	)t1
group by t1.versiondemanda,t1.IdDistribuidora,t1.mes,t1.IdBarraNacional,t1.EnergiaPC,t1.VersionDemandaDespacho,t1.IdDistribuidoraDespacho,t1.IdTipoDespacho
--select * from Demanda_Dx_PtoCompra
--*/

--Demanda_Dx. Demanda en pto compra de cada distribuidora por mes
--/*
IF OBJECT_ID('Demanda_Dx', 'U') IS NOT NULL DROP TABLE Demanda_Dx

select VersionDemandaDespacho,VersionDemanda,IdDistribuidora,Mes,IdDistribuidoraDespacho,IdTipoDespacho,sum(EnergiaPC) EnergiaPC
into Demanda_Dx
from Demanda_Dx_PtoCompra
group by VersionDemanda,IdDistribuidora,Mes,VersionDemandaDespacho,IdDistribuidoraDespacho,IdTipoDespacho
--select * from Demanda_Dx
--*/

--1 DESPACHO LICITACION y Dx con contratos Holding

--Participación de Energía para cada distribuidora por Modalidad y año
--/*
--IF OBJECT_ID('EModalidad', 'U') IS NOT NULL DROP TABLE EModalidad
delete from EModalidad where ano=@Ano
insert into EModalidad
select Modalidad,Ano,IdDistribuidora,EnergiaAnual,EnergiaAnual/sum(EnergiaAnual) over (partition by Ano,IdDistribuidora) Factor
--into EModalidad
from (
select t3.Modalidad,t1.Ano,t2.IdDistribuidora,sum(EnergiaAnual) EnergiaAnual
				from EAdjAnual t1
				inner join codigocontrato t2 on t1.IdCodigoContrato=t2.IdCodigoContrato
				inner join licitaciongx t3 on t2.IdGeneradora=t3.IdGeneradora and t2.IdLicitacion=t3.IdLicitacion and t3.Bloque = t2.Bloque and t3.TipoBloque=t2.TipoBloque
				where t1.Ano=@Ano
				group by t3.Modalidad,t1.Ano,t2.IdDistribuidora
) t1
group by Modalidad,Ano,IdDistribuidora,EnergiaAnual
--select * from EModalidad
--*/
--Energía AdjudicadaMensual por distribuidora
--/*
IF OBJECT_ID('EAdjMensDxTB', 'U') IS NOT NULL DROP TABLE EAdjMensDxTB

select Modalidad,IdDistribuidora,t2.TipoBloque,fecha,sum(EnergiaMensual)*1000 EAdjMensual
into EAdjMensDxTB
from EAdjAnualDistrMensual t1
inner join codigocontrato t2 on t1.IdCodigoContrato=t2.IdCodigoContrato
inner join licitaciongx t3 on t2.IdGeneradora=t3.IdGeneradora and t2.IdLicitacion=t3.IdLicitacion and t2.Bloque=t3.Bloque and t2.TipoBloque=t3.TipoBloque
where YEAR(fecha)=@Ano and fecha in (select distinct Mes from tempdemanda)
group by  t3.Modalidad,t2.idDistribuidora,t2.TipoBloque,fecha
--select * from EAdjMensDxTB
--*/
--Determinacion de participación de Re 704BB en despacho  a nivel Dx
--/*
--IF OBJECT_ID('DespMod', 'U') IS NOT NULL DROP TABLE DespMod
delete from DespMod where VersionDemandaDespacho=@DemandaDespacho
insert into DespMod
select t1.VersionDemandaDespacho,t1.versiondemanda,t1.IdDistribuidora,t1.mes,t2.modalidad,t1.IdDistribuidoraDespacho,t1.IdTipoDespacho,Concat('Re 704',t2.TipoBloque) Asignacion,t1.EnergiaPC
		,t3.Factor FactorMod
		,t1.EnergiaPC*t3.Factor EnergiaPCMod,EadjMensual
		,case when t1.EnergiaPC*t3.Factor <=EadjMensual then 1 else EadjMensual/(t1.EnergiaPC*t3.Factor) end [Desp%]
		,case when t1.EnergiaPC*t3.Factor <=EadjMensual then t1.EnergiaPC*t3.Factor else EadjMensual  end EDespachada		
--into DespMod
from Demanda_Dx t1
inner join EAdjMensDxTB t2 on t1.IdDistribuidoraDespacho=t2.iddistribuidora and t1.mes=t2.fecha and t2.TipoBloque='BB' 
left join EModalidad t3 on t1.IdDistribuidoraDespacho=t3.IdDistribuidora and year(t1.mes)=t3.ano and t3.Modalidad=t2.Modalidad
--select * from DespMod
--*/
--Determinacion de participación de Re 704BV en despacho a nivel Dx
--/*
insert into DespMod
select t1.VersionDemandaDespacho,t1.versiondemanda,t1.iddistribuidora,t1.mes,t2.modalidad,t1.IdDistribuidoraDespacho,t1.IdTipoDespacho,concat('Re 704',t2.TipoBloque) Asignacion,t1.EnergiaPC
		,t3.Factor,t1.EnergiaPC*t3.Factor EnergiaPCRe704,t2.EadjMensual
		,case	when t1.EnergiaPC*t3.Factor-t4.EDespachada=0 then 0
				when t1.EnergiaPC*t3.Factor-t4.EDespachada<=t2.EadjMensual then 1 
				else t2.EadjMensual/(t1.EnergiaPC*t3.Factor) end [Desp%]
		,case	when t1.EnergiaPC*t3.Factor-t4.EDespachada<=t2.EadjMensual then t1.EnergiaPC*t3.Factor-t4.EDespachada 
				else t2.EadjMensual  end EDespachada				
from Demanda_Dx t1
inner join EAdjMensDxTB t2 on t1.IdDistribuidoraDespacho=t2.iddistribuidora and t1.mes=t2.fecha and t2.TipoBloque='BV'
left join EModalidad t3 on t1.IdDistribuidoraDespacho=t3.iddistribuidora and year(t1.mes)=t3.ano  and t3.Modalidad=t2.Modalidad
left join DespMod t4 on t4.versiondemanda=t1.versiondemanda and t4.iddistribuidora=t1.iddistribuidora and t1.mes=t4.mes
--select * from DespMod
--*/

--Energía para despachar por DS4 que viene de Re 704  a nivel Dx
--/*
insert into DespMod
select VersionDemandaDespacho,versiondemanda,IdDistribuidora,mes,'DS 4' modalidad,IdDistribuidoraDespacho,IdTipoDespacho,'Re 704' ,EnergiaPC,FactorMod,EnergiaPCMod
 ,(1-sum([Desp%]))*EnergiaPCMod EadjMensual
 ,(1-sum([Desp%])) [Desp%]
 ,(1-sum([Desp%]))*EnergiaPCMod	EDespachada
from DespMod
group by versiondemanda,IdDistribuidora,mes,modalidad,EnergiaPC,FactorMod,EnergiaPCMod,VersionDemandaDespacho,IdDistribuidoraDespacho,IdTipoDespacho
having sum([Desp%])<1
--select * from DespMod
--*/
--Energía para ser despachada por CortoPlazo a nivel Dx
--/*
insert into DespMod
select t1.VersionDemandaDespacho,t1.versiondemanda,t1.IdDistribuidora,t1.mes,'CortoPlazo' Modalidad,IdDistribuidoraDespacho,IdTipoDespacho,'CortoPlazo' Asignacion,t1.EnergiaPC
		,1 FactorMod
		,t1.EnergiaPC EnergiaPCMod
		,t1.EnergiaPC EadjMensual
		,1 [Desp%]
		,t1.EnergiaPC EDespachada
from Demanda_Dx t1
where t1.IdTipoDespacho=2
--select * from DespMod
--*/

--Energía para ser despachada por DS4 a nivel Dx
--/*
insert into DespMod
select t1.VersionDemandaDespacho,t1.versiondemanda,t1.IdDistribuidora,t1.mes, Modalidad,IdDistribuidoraDespacho,IdTipoDespacho,Modalidad Asignacion,t1.EnergiaPC
		,t3.Factor FactorMod
		,t1.EnergiaPC*t3.Factor EnergiaPCMod
		,t1.EnergiaPC*t3.Factor EadjMensual
		,1 [Desp%]
		,t1.EnergiaPC*t3.Factor  EDespachada
from Demanda_Dx t1
inner join EModalidad t3 on t1.IdDistribuidoraDespacho=t3.IdDistribuidora and year(t1.mes)=t3.ano
where Modalidad='DS 4'
--select * from DespMod
--*/

--Asignación Energía Adjudicada Mensual por modalidad Re 704 y tipo de bloque para cada CodigoContrato 
--/*
IF OBJECT_ID('EAdjMensDxTB_CC', 'U') IS NOT NULL DROP TABLE EAdjMensDxTB_CC

select	t4.Modalidad,t2.IdDistribuidora,t1.idcodigocontrato,t2.TipoBloque,t1.fecha,t1.EnergiaMensual*1000 EAdjMensual
		,t3.EadjMensual EadjMensualDxTB
		,t1.EnergiaMensual*1000/t3.EadjMensual FactEAdjMensual
into EAdjMensDxTB_CC
from (select idcodigocontrato,Fecha,sum(EnergiaMensual) EnergiaMensual from EAdjAnualDistrMensual t1 group by idcodigocontrato,Fecha) t1
inner join CodigoContrato t2 on t1.idcodigocontrato=t2.idcodigocontrato
inner join licitaciongx t4 on t2.IdGeneradora=t4.IdGeneradora and t2.IdLicitacion=t4.IdLicitacion and t2.Bloque=t4.Bloque and t2.TipoBloque	=t4.TipoBloque
inner join EAdjMensDxTB t3 on t3.IdDistribuidora=t2.IdDistribuidora and t1.fecha=t3.fecha and t2.TipoBloque=t3.Tipobloque
where YEAR(t1.fecha)=@Ano and t1.fecha in (select distinct Mes from tempdemanda)
order by t1.idcodigocontrato
--select * from EAdjMensDxTB_CC
--*/
--Despacho contratos Re 704
--/*
--IF OBJECT_ID('Despacho', 'U') IS NOT NULL DROP TABLE Despacho
delete from Despacho where VersionDemandaDespacho=@DemandaDespacho
insert into Despacho
select	t1.VersionDemandaDespacho,t2.versiondemanda,t2.IdDistribuidora,t2.mes,t2.IdBarraNacional,t1.modalidad,t1.IdDistribuidoraDespacho,t1.IdTipoDespacho,Asignacion,t3.idcodigocontrato,t2.EnergiaPC
		,t1.FactorMod,t1.[Desp%],t3.FactEAdjMensual,t1.FactorMod*t1.[Desp%]*t2.EnergiaPC*t3.FactEAdjMensual EnergiaPCDesp
--into Despacho
from DespMod t1
inner join Demanda_Dx_PtoCompra t2 on t1.IdDistribuidoraDespacho=t2.IdDistribuidoraDespacho and t1.mes=t2.mes
left join EAdjMensDxTB_CC t3 on t3.IdDistribuidora=t1.IdDistribuidoraDespacho and t3.fecha=t1.mes and t1.IdDistribuidora=t2.IdDistribuidora
where t1.modalidad='Re 704' and t1.Asignacion='Re 704BB' and t3.TipoBloque='BB'
union all
select	t1.VersionDemandaDespacho,t2.versiondemanda,t2.IdDistribuidora,t2.mes,t2.IdBarraNacional,t1.modalidad,t1.IdDistribuidoraDespacho,t1.IdTipoDespacho,Asignacion,t3.idcodigocontrato,t2.EnergiaPC
		,t1.FactorMod,t1.[Desp%],t3.FactEAdjMensual,t1.FactorMod*t1.[Desp%]*t2.EnergiaPC*t3.FactEAdjMensual EnergiaPCDesp
from DespMod t1
inner join Demanda_Dx_PtoCompra t2 on t1.IdDistribuidoraDespacho=t2.IdDistribuidoraDespacho and t1.mes=t2.mes and t1.IdDistribuidora=t2.IdDistribuidora
left join EAdjMensDxTB_CC t3 on t3.IdDistribuidora=t1.IdDistribuidoraDespacho and t3.fecha=t1.mes
where t1.modalidad='Re 704' and t1.Asignacion='Re 704BV' and t3.TipoBloque='BV'
--select * from Despacho

--*/
--Participación de contratos DS 4 En energía a despachar
--/*
IF OBJECT_ID('EAdjCCAnual', 'U') IS NOT NULL DROP TABLE EAdjCCAnual

select Modalidad,IdDistribuidora,IdCodigoContrato,Ano,EnergiaAnual/(sum(EnergiaAnual) over (partition by Modalidad,IdDistribuidora,Ano)) FactEAdjAnual
into EAdjCCAnual
from (
select	t1.IdDistribuidora,t1.IdCodigoContrato,t2.Modalidad,t3.Ano,sum(EnergiaAnual) EnergiaAnual
from codigocontrato t1
inner join licitaciongx t2 on t1.IdLicitacion=t2.IdLicitacion and t1.TipoBloque=t2.TipoBloque and t1.IdGeneradora=t2.IdGeneradora and t1.Bloque=t2.Bloque
inner join eadjanual t3 on t3.IdCodigoContrato=t1.IdCodigoContrato
where t2.Modalidad='DS 4' and t3.Ano=@Ano
group by t1.IdDistribuidora,t1.IdCodigoContrato,t2.Modalidad,t3.Ano
) t 
--select * from EAdjCCAnual
--*/

--Despacho contratos DS 4
--/*
insert into Despacho
select	t2.VersionDemandaDespacho,t2.versiondemanda,t2.IdDistribuidora,t2.mes,t2.IdBarraNacional,t1.modalidad,t1.IdDistribuidoraDespacho,t1.IdTipoDespacho,Asignacion,t3.idcodigocontrato,t2.EnergiaPC
		,t1.FactorMod,t1.[Desp%],t3.FactEAdjAnual,t1.FactorMod*t1.[Desp%]*t2.EnergiaPC*t3.FactEAdjAnual EnergiaPCDesp
from DespMod t1
inner join Demanda_Dx_PtoCompra t2 on t1.IdDistribuidoraDespacho=t2.IdDistribuidoraDespacho and t1.mes=t2.mes and t1.IdDistribuidora=t2.IdDistribuidora
left join EAdjCCAnual t3 on t3.IdDistribuidora=t1.IdDistribuidoraDespacho and year(t1.mes)=Ano
where t1.modalidad='DS 4'
--select * from Despacho
--*/

--Despacho contratos CortoPlazo
--/*
insert into Despacho
select	t2.VersionDemandaDespacho,t2.versiondemanda,t2.IdDistribuidora,t2.mes,t2.IdBarraNacional,t1.modalidad,t1.IdDistribuidoraDespacho,t1.IdTipoDespacho,Asignacion,0,t2.EnergiaPC
		,t1.FactorMod,t1.[Desp%],1,t1.FactorMod*t1.[Desp%]*t2.EnergiaPC EnergiaPCDesp
from DespMod t1
inner join Demanda_Dx_PtoCompra t2 on t1.IdDistribuidoraDespacho=t2.IdDistribuidoraDespacho and t1.mes=t2.mes and t1.IdDistribuidora=t2.IdDistribuidora
where t1.modalidad='CortoPlazo'
--*/

--llevar despacho a Punto de Retiro
--/*
IF OBJECT_ID('DespachoPtoRetiro', 'U') IS NOT NULL DROP TABLE DespachoPtoRetiro
--delete from DespachoPtoRetiro where VersionDemandaDespacho=@DemandaDespacho
--insert into DespachoPtoRetiro
select t1.VersionDemandaDespacho,t1.VersionDemanda,t1.IdDistribuidora,t1.Mes Fecha,t2.IdPuntoRetiro,t1.IdCodigoContrato,sum(t1.EnergiaPCDesp*t2.Factor/t2.FactorPZ) Energia,t1.IdTipoDespacho, '' Potencia,'' Observacion
into DespachoPtoRetiro
from (	select versionDemandaDespacho,VersionDemanda,IdDistribuidora,Mes,IdCodigoContrato,IdTipoDespacho,IdBarraNacional,sum(EnergiaPCDesp) EnergiaPCDesp 
		from Despacho 
		group by versionDemandaDespacho,VersionDemanda,IdDistribuidora,Mes,IdCodigoContrato,IdTipoDespacho,IdBarraNacional) t1
inner join Demanda_PtoRetiro_PtoCompra t2 on t1.VersionDemandaDespacho=t2.VersionDemandaDespacho and t1.versiondemanda=t2.versiondemanda and t1.IdDistribuidora=t2.IdDistribuidora and t1.Mes=t2.Mes 
			and t1.IdBarraNacional=t2.IdBarraNacional and t1.IdTipoDespacho=t2.IdTipoDespacho
group by t1.VersionDemandaDespacho,t1.VersionDemanda,t1.IdDistribuidora,t1.Mes,t2.IdSistemaZonal,t2.IdPuntoRetiro,t1.IdCodigoContrato,t1.IdTipoDespacho
--*/

--ELIMINAR TABLAS TEMPORALES
--/*
DROP TABLE tempdemanda
DROP TABLE Demanda_Dx_PtoCompra
DROP TABLE EAdjMensDxTB
DROP TABLE Demanda_Dx
DROP TABLE EAdjMensDxTB_CC
DROP TABLE EAdjCCAnual
--*/
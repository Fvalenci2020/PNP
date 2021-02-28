use pnp_3

--PROTOTIPO DE DESPACHO DE CONTRATOS

--pendientes c�mo trabajar con contratos de corto plazo.
--pendiente de trabajar despacho de mataquito y su particularidad.

--DEFINIFIC�N DATOS DE C�LCULO
DECLARE @VersionD VARCHAR(45)='2007ProyV1' --segundo semestre 2020
DECLARE @VersionPZ VARCHAR(45)='Estimado' 
DECLARE @PeriodoFR VARCHAR(45)='Segundo Semestre 2020'
DECLARE @Ano int=2020

--Demanda_Dx_PtoCompra.
--/*
IF OBJECT_ID('Demanda_Dx_PtoCompra', 'U') IS NOT NULL DROP TABLE Demanda_Dx_PtoCompra

select VersionDemanda,IdDistribuidora,Mes,IdSistemaZonal,VersionPZ,PeriodoFR,IdBarraNacional,sum(EnergiaPC) EnergiaPC
into Demanda_Dx_PtoCompra
from(
SELECT	t1.Version VersionDemanda,t1.IdDistribuidora,t1.Mes,t1.IdSistemaZonal,t2.Version VersionPZ,t3.Periodo PeriodoFR,t3.IdBarraNacional,Demanda*t2.Factor*t3.Factor*1000 EnergiaPC
FROM DEMANDA T1
LEFT JOIN PerdidaZonal T2 ON T1.IdSistemaZonal=T2.IdSistemaZonal and t1.Mes=t2.Fecha
Left join	factorreferenciacion t3 on t3.IdPuntoRetiro=t1.IdPuntoRetiro
WHERE	T1.Version=@VERSIOND
		AND T2.Version=@VersionPZ and t2.TipoFactor='FEPE'
		and t3.Periodo=@PeriodoFR
		) t1
group by VersionDemanda,IdDistribuidora,Mes,IdSistemaZonal,VersionPZ,PeriodoFR,IdBarraNacional
--*/

--Demanda_Dx.
--/*
IF OBJECT_ID('Demanda_Dx', 'U') IS NOT NULL DROP TABLE Demanda_Dx

select VersionDemanda,IdDistribuidora,Mes,sum(EnergiaPC) EnergiaPC
into Demanda_Dx
from Demanda_Dx_PtoCompra
group by VersionDemanda,IdDistribuidora,Mes
--select * from Demanda_Dx
--*/
--Demanda_Dx_PtoCompra con Factor % de Energia por pto de compra sobre mes-Dx
--/*
IF OBJECT_ID('Demanda_Dx_PtoCompra_F', 'U') IS NOT NULL DROP TABLE Demanda_Dx_PtoCompra_F

select t1.versiondemanda,t1.IdDistribuidora,t1.mes,t1.IdBarraNacional,sum(t1.EnergiaPC) EnergiaPC,sum(t1.EnergiaPC)/t2.EnergiaPC FactPtoCompra
into Demanda_Dx_PtoCompra_F
from Demanda_Dx_PtoCompra t1
left join Demanda_Dx t2 on t2.versiondemanda=t1.versiondemanda and t2.iddistribuidora=t1.IdDistribuidora and t2.mes=t1.mes
group by t1.versiondemanda,t1.IdDistribuidora,t1.mes,t1.IdBarraNacional,t2.EnergiaPC
--select * from Demanda_Dx_PtoCompra_F
--*/

--Participaci�n Energ�a por Modalidad
--/*
IF OBJECT_ID('EModalidad', 'U') IS NOT NULL DROP TABLE EModalidad

select	t1.ano,t1.IdDistribuidora
		,case when t2.EnergiaAnual is null then 0 else t2.EnergiaAnual/(t1.EnergiaAnual+t2.EnergiaAnual) end FactorERe704
into EModalidad 
from	(	select t3.Modalidad,t1.Ano,t2.IdDistribuidora,sum(EnergiaAnual) EnergiaAnual
				from EAdjAnual t1
				inner join codigocontrato t2 on t1.IdCodigoContrato=t2.IdCodigoContrato
				inner join licitaciongx t3 on t2.IdGeneradora=t3.IdGeneradora and t2.IdLicitacion=t3.IdLicitacion
				where t1.Ano=@Ano and Modalidad='DS 4'
				group by t3.Modalidad,t1.Ano,t2.IdDistribuidora
		) t1
left join (	select t3.Modalidad,t1.Ano,t2.IdDistribuidora,sum(EnergiaAnual) EnergiaAnual
				from EAdjAnual t1
				inner join codigocontrato t2 on t1.IdCodigoContrato=t2.IdCodigoContrato
				inner join licitaciongx t3 on t2.IdGeneradora=t3.IdGeneradora and t2.IdLicitacion=t3.IdLicitacion
				where t1.Ano=@Ano and Modalidad='Re 704'
				group by t3.Modalidad,t1.Ano,t2.IdDistribuidora
		) t2 
		on t1.ano=t2.ano and t1.IdDistribuidora=t2.IdDistribuidora
--*/

--Energ�a AdjudicadaMensual
--/*
IF OBJECT_ID('EAdjMensDxTB', 'U') IS NOT NULL DROP TABLE EAdjMensDxTB

select Modalidad,Distribuidora,t2.TipoBloque,fecha,sum(EnergiaMensual)*1000 EAdjMensual
into EAdjMensDxTB
from EAdjAnualDistrMensual t1
inner join codigocontrato t2 on t1.IdCodigoContrato=t2.IdCodigoContrato
inner join licitaciongx t3 on t2.IdGeneradora=t3.IdGeneradora and t2.IdLicitacion=t3.IdLicitacion
where YEAR(fecha)=@Ano and fecha in (select distinct Mes from demanda where Version=@VersionD)
group by  t3.Modalidad,t2.Distribuidora,t2.TipoBloque,fecha
--*/

--Determinacion de participaci�n de Re704BB en despacho
/*
Drop table if exists DespMod
select t1.versiondemanda,t1.distribuidora,t1.mes,t2.modalidad,Concat('Re704',t2.TipoBloque) Asignacion,t1.EnergiaPC
		,t3.FactorERe704 FactorMod
		,t1.EnergiaPC*t3.FactorERe704 EnergiaPCMod,EadjMensual
		,case when t1.EnergiaPC*t3.FactorERe704<=EadjMensual then t1.EnergiaPC*t3.FactorERe704 else EadjMensual  end EDespachada
		,case when t1.EnergiaPC*t3.FactorERe704 <=EadjMensual then 1 else EadjMensual/(t1.EnergiaPC*t3.FactorERe704) end [Desp%]
into DespMod
from DdaDxPtoCompra t1
inner join EAdjMensualDxTB t2 on t1.distribuidora=t2.distribuidora and t1.mes=t2.fecha and t2.TipoBloque='BB'
left join EnergiaModalidad t3 on t1.distribuidora=t3.distribuidora and year(t1.mes)=t3.ano

--Determinacion de participaci�n de Re704BV en despacho
insert into DespMod
select t1.versiondemanda,t1.distribuidora,t1.mes,t2.modalidad,concat('Re704',t2.TipoBloque) Asignacion,t1.EnergiaPC
		,t3.FactorERe704,t1.EnergiaPC*t3.FactorERe704 EnergiaPCRe704,t2.EadjMensual
		,case	when t1.EnergiaPC*t3.FactorERe704-t4.EDespachada<=t2.EadjMensual then t1.EnergiaPC*t3.FactorERe704-t4.EDespachada 
				else t2.EadjMensual  end EDespachada		
		,case	when t1.EnergiaPC*t3.FactorERe704-t4.EDespachada=0 then 0
				when t1.EnergiaPC*t3.FactorERe704-t4.EDespachada<=t2.EadjMensual then 1 
				else t2.EadjMensual/(t1.EnergiaPC*t3.FactorERe704-t4.EDespachada) end [Desp%]
from DdaDxPtoCompra t1
inner join EAdjMensualDxTB t2 on t1.distribuidora=t2.distribuidora and t1.mes=t2.fecha and t2.TipoBloque='BV'
left join EnergiaModalidad t3 on t1.distribuidora=t3.distribuidora and year(t1.mes)=t3.ano
left join DespMod t4 on t4.versiondemanda=t1.versiondemanda and t4.distribuidora=t1.distribuidora and t1.mes=t4.mes
--*/

--Energ�a Disponibles despu�s de despacho de Re704
/*
drop table if exists Edisp704
select	versiondemanda,distribuidora,mes,'Re704' Asignacion
		,1-sum([Desp%]) [Desp%Disp]
		,case when sum([Desp%])=0 then 0 else (1-sum([Desp%]))*sum(EDespachada)/sum([Desp%]) end EDisponible
into Edisp704
from DespMod
group by versiondemanda,distribuidora,mes
having sum([Desp%])<1

--Ver Energ�a Despachada que viene de RE704 para ser despachada por DS4
insert into DespMod
select t1.versiondemanda,t1.distribuidora,t1.mes,'DS 4' modalidad, Asignacion,t1.EDisponible
		,1 FactorMod
		,t1.EDisponible EnergiaPCMod
		,t1.EDisponible EadjMensual
		,t1.EDisponible EDespachada
		,1 [Desp%]
from Edisp704 t1
left join EnergiaModalidad t3 on t1.distribuidora=t3.distribuidora and year(t1.mes)=t3.ano

--Ver Energ�a para ser despachada por DS4 a nivel Dx
insert into DespMod
select t1.versiondemanda,t1.distribuidora,t1.mes,'DS 4' Modalidad,'DS 4' Asignacion,t1.EnergiaPC
		,(1-t3.FactorERe704) FactorMod
		,t1.EnergiaPC*(1-t3.FactorERe704) EnergiaPCMod
		,t1.EnergiaPC*(1-t3.FactorERe704) EadjMensual
		,t1.EnergiaPC*(1-t3.FactorERe704)  EDespachada
		,1 [Desp%]
from DdaDxPtoCompra t1
inner join EnergiaModalidad t3 on t1.distribuidora=t3.distribuidora and year(t1.mes)=t3.ano
--*/

--Energ�a AdjudicadaMensual Re704
/*
Drop table if exists EAdjMensualDxTBCC
select	t2.Modalidad,t2.Distribuidora,t1.idcodigocontrato,t2.TipoBloque,t1.fecha,EnergiaMensual*1000 EAdjMensual
		,t3.EadjMensual EadjMensualDxTB
		,EnergiaMensual*1000/t3.EadjMensual FactEAdjMensual
into EAdjMensualDxTBCC
from (select idcodigocontrato,Fecha,sum(EnergiaMensual) EnergiaMensual from EAdjAnualDistrMensual t1 group by idcodigocontrato,Fecha) t1
inner join CodigoContrato t2 on t1.idcodigocontrato=t2.idcodigocontrato
left join EAdjMensualDxTB t3 on t3.distribuidora=t2.distribuidora and t1.fecha=t3.fecha and t2.TipoBloque=t3.Tipobloque
where YEAR(t1.fecha)=2020 and month(t1.fecha)>=6
order by t1.idcodigocontrato
--*/

--Despacho contratos Re704
/*
Drop table if exists DespachoTemp
select t1.VersionDemanda,t1.Mes
	,t2.VersionIndex,t2.Version,t2.IDCodigoContrato,t2.CodigoContrato,t2.Licitacion,t2.TipoBloque,t2.PtoOferta,t1.Distribuidora,t2.Generadora,t1.BarraNacional
	,t3.modalidad
	,t1.EnergiaPC
	,t2.Pe, t2.Pp
	,t4.Asignacion,t4.FactorMod,t4.EDespachada,t4.[Desp%]
	,t5.FactEAdjMensual
	,t1.FactPtoCompra
	,t4.EDespachada*t5.FactEAdjMensual*t1.FactPtoCompra EDespPtoCompra
into DespachoTemp
from DemandaPtoCompra t1
left join CodigoContratoFM t2 on t1.mes=t2.MesIndexacion and t1.Distribuidora=t2.Distribuidora and t1.BarraNacional=t2.BarraNacional and VersionIndex='ITPV1'
left join CodigoContrato t3 on t3.idcodigocontrato=t2.IDCodigoContrato
left join DespMod t4 on t4.versiondemanda=t1.Versiondemanda and t4.Distribuidora=t1.Distribuidora and t4.mes=t1.mes and t4.modalidad=t3.modalidad and t4.Asignacion=concat('Re704',t2.tipobloque)
left join EAdjMensualDxTBCC t5 on t5.idcodigocontrato=t2.IDCodigoContrato and t5.fecha=t1.Mes
left join DdaDxPtoCompra t6 on t6.versiondemanda=t1.versiondemanda and t6.distribuidora=t1.distribuidora and  t6.mes=t1.mes
where t3.modalidad='RE 704'
--*/

--Energ�a Licitada por Distribuidora y Modalidad para todos los a�os
/*
Drop table if exists EAdjDxAnual
select t1.Ano,t2.Distribuidora,sum(EnergiaAnual) EnergiaAnual
into EAdjDxAnual
from EAdjAnual t1
inner join CodigoContrato t2 on t1.idcodigocontrato=t2.idcodigocontrato
group by t1.Ano,t2.Distribuidora
--*/

--Energ�a por Contrato para DS 4, adem�s de su factor de participaci�n
/*
Drop table if exists EAdjCCAnual
select	t2.Modalidad,t2.Distribuidora,t1.IdCodigoContrato,t1.Ano
		,Sum(t1.EnergiaAnual)*1000 EnergiaAnual
		,Sum(t1.EnergiaAnual)/(t3.EnergiaAnual*(1-t4.FactorERe704)) FActCCAnual		
into EAdjCCAnual
from EAdjAnual t1
left join CodigoContrato t2 on t1.IdCodigoContrato=t2.IDCodigoContrato
left join EAdjDxAnual t3 on t1.Ano=t3.Ano and t3.Ano=t1.Ano and t3.Distribuidora=t2.Distribuidora
left join EnergiaModalidad t4 on t4.ano=t1.Ano and t4.distribuidora=t2.Distribuidora
where t2.Modalidad='DS 4' and t1.Ano=2020
group by t2.Modalidad,t2.Distribuidora,t1.IdCodigoContrato,t1.Ano,t3.EnergiaAnual,t4.FactorERe704
--*/

--Despacho contratos DS 4
/*
insert into DespachoTemp
select t1.VersionDemanda,t1.Mes
	,t2.VersionIndex,t2.Version,t2.IDCodigoContrato,t2.CodigoContrato,t2.Licitacion,t2.TipoBloque,t2.PtoOferta,t1.Distribuidora,t2.Generadora,t1.BarraNacional
	,t3.modalidad
	,t1.EnergiaPC
	,t2.Pe, t2.Pp
	,t4.Asignacion,t4.FactorMod,t4.EDespachada,t4.[Desp%]
	,t7.FactCCAnual
	,t1.FactPtoCompra
	,t4.EDespachada*t7.FactCCAnual*t1.FactPtoCompra EDespPtoCompra
from DemandaPtoCompra t1
left join CodigoContratoFM t2 on t1.mes=t2.MesIndexacion and t1.Distribuidora=t2.Distribuidora and t1.BarraNacional=t2.BarraNacional and VersionIndex='ITPV1'
left join CodigoContrato t3 on t3.idcodigocontrato=t2.IDCodigoContrato
left join DespMod t4 on t4.versiondemanda=t1.Versiondemanda and t4.Distribuidora=t1.Distribuidora and t4.mes=t1.mes and t4.modalidad=t3.modalidad
left join DdaDxPtoCompra t6 on t6.versiondemanda=t1.versiondemanda and t6.distribuidora=t1.distribuidora and  t6.mes=t1.mes
left join EAdjCCAnual t7 on t7.idcodigocontrato=t2.IDCodigoContrato and t7.ano=year(t1.mes) and t7.Distribuidora=t1.Distribuidora
where t3.modalidad='DS 4'
--*/

--select * from DespachoTemp
--select * from EAdjCCAnual where ano=2020 and Distribuidora='CEC'
--select * from CodigoContrato where IDCodigoContrato in (6,7)
--select * from CodigoContratoFM where IDCodigoContrato=960--2015/02_BS4C_BB_Socoepa_Aela Generaci�n S.A.
--select * from VigenciaContrato where Licitacion='2015/02' and


-- Pendientes contratos de corto plazo
-- Pendientes asignaci�n de filiales Enel

--fALTAN en indexacioncontrato
--select T1.IDCODIGOCONTRATO,T2.*
--from EAdjCCAnual T1
--LEFT JOIN CodigoContrato T2 ON T1.IDCODIGOCONTRATO=T2.IDCODIGOCONTRATO
--where T1.idcodigocontrato not in (select distinct idcodigocontrato from DespachoTemp)

--select * from CodigoContrato where Modalidad='DS 4' and Generadora in ('PANGUIPULLI','ENDESA','PUYEHUE') and TipoBloque='BB'
--and Licitacion in ('SIC 2013/01','CHL 2010/01','CHQ 2010/01','SIC 2013/01 (Enelsa)','SIC 2013/01 (Emetal)','SIC 2013/01 (Emelectric)')

--SELECT * FROM LicitacionGx where Generadora in ('PANGUIPULLI','ENDESA','PUYEHUE') and TipoBloque='BB'
--and Licitacion in ('SIC 2013/01','CHL 2010/01','CHQ 2010/01','SIC 2013/01 (Enelsa)','SIC 2013/01 (Emetal)','SIC 2013/01 (Emelectric)')

--select * from VigenciaContrato  where Gx in ('PANGUIPULLI','ENDESA','PUYEHUE')
--and Licitacion in ('SIC 2013/01','CHL 2010/01','CHQ 2010/01','SIC 2013/01 (Enelsa)','SIC 2013/01 (Emetal)','SIC 2013/01 (Emelectric)')


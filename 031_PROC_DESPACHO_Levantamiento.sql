use pnp_3

--PROTOTIPO DE DESPACHO DE CONTRATOS

--pendiente de trabajar despacho de mataquito "Traspaso Excedentes".
--Pendiente trabajar con tipodespacho=Dx con contratos Holding. Cachar si se debe agregar a demanda de empresa Holding no más. puntos de retiro compartidos

--DEFINIFICÓN DATOS DE CÁLCULO
DECLARE @VersionD VARCHAR(45)='2007ProyV1' --segundo semestre 2020
DECLARE @VersionPZ VARCHAR(45)='Estimado' -- utiliza pérdida estimada
DECLARE @PeriodoFR VARCHAR(45)='Segundo Semestre 2020'-- indica cuáles factores de referenciación utiliza
DECLARE @Ano int=2020-- año de análisis.

--Definición Vector de precios PNP
IF OBJECT_ID('TempPNP', 'U') IS NOT NULL DROP TABLE TempPNP--Precios del ITD deben ser
select * 
into TempPNP
from pnp
where version='ITD' and MesIndexacion='2020-07-01' and VersionIndex='2101V3'

--Definición de demanda Se debe indicar forma de despacho para cada distribuidora y casos puntuales de puntos de retiro.
IF OBJECT_ID('TempDEMANDA', 'U') IS NOT NULL DROP TABLE TempDEMANDA
SELECT	IdDemanda,Version,IdDistribuidora,Distribuidora,Mes,t2.IdSistemaZonal,t2.Ano,t1.IdPuntoRetiro,PuntoRetiro,Demanda
		,case when t1.IdSistemaZonal<>t2.IdSistemaZonal then t1.Observacion+' Sistema zonal informado no coincide con relacionde Pto retiro en DB' else t1.Observacion end Observacion
		,TipoDemanda
		,case	when IdDistribuidora in(45) then 4--45	Mataquito
				when IdDistribuidora in(12,13,15) then 5--12	EEC--13	TIL TIL--15	LUZ ANDES
				when IdDistribuidora in (20) then 2--20	COOPERSOL
				when IdDistribuidora in (34) and t1.IdPuntoRetiro in (8) then 2--Coelcha-Pangue 066
				when IdDistribuidora in (34) and t1.IdPuntoRetiro not in (8) then 1--Coelcha
				when IdDistribuidora in (22) and t1.IdPuntoRetiro in (8) then 2--FRontel-Pangue 066
				when IdDistribuidora in (22) and t1.IdPuntoRetiro not in (8) then 1--FRontel
				when IdDistribuidora in (1,2,3,4,6,7,8,9,10,14,18,21,23,24,25,26,28,29,31,32,33,35,36,39,40,44) then 1 end IdTipoDespacho--Licitacion
into TempDemanda
FROM DEMANDA T1
inner join ptoretirosistema t2 on t1.IdPuntoRetiro=t2.IdPuntoRetiro and t2.Ano=@Ano
WHERE	T1.Version=@VERSIOND

--update TempDemanda set Demanda=demanda--solamente para hacer pruebas

--Relación Demmanda Pto REtiro y Barra Nacional, se utiliza para al final para transformar relación idcontrato/BarraNacional a IdContrato/Ptoretiro
/*
IF OBJECT_ID('Demanda_PtoRetiro_PtoCompra', 'U') IS NOT NULL DROP TABLE Demanda_PtoRetiro_PtoCompra

SELECT	t1.Version VersionDemanda,t1.IdDistribuidora,t1.Mes,t1.IdPuntoRetiro,t1.IdSistemaZonal,t2.Version VersionPZ,t3.Periodo PeriodoFR,t3.IdBarraNacional
		,t1.Demanda DemandaPR
		,t2.Factor FactorPZ,t3.Factor FactorR,t2.Factor*t3.Factor FactorBN ,(Demanda*t2.Factor*t3.Factor*1000) EnergiaPC
		,(Demanda*t2.Factor*t3.Factor*1000)/(sum((Demanda*t2.Factor*t3.Factor*1000)) over (partition by t1.Version,t1.IdDistribuidora,t1.Mes,t1.IdSistemaZonal,t3.IdBarraNacional)) Factor
into Demanda_PtoRetiro_PtoCompra
FROM TempDEMANDA  T1
LEFT JOIN PerdidaZonal T2 ON T1.IdSistemaZonal=T2.IdSistemaZonal and t1.Mes=t2.Fecha
Left join	factorreferenciacion t3 on t3.IdPuntoRetiro=t1.IdPuntoRetiro
WHERE	T2.Version=@VersionPZ and t2.TipoFactor='FEPE'
		and t3.Periodo=@PeriodoFR
		and t1.IdTipoDespacho in (1)--solamente despacho por licitación
--select * from Demanda_PtoRetiro_PtoCompra
--*/
--Demanda_Dx_PtoCompra. Demanda de cada distribuidora referenciada a Puntos de Compra por mes.  con Factor % de Energia por pto de compra sobre mes-Dx
/*
IF OBJECT_ID('Demanda_Dx_PtoCompra', 'U') IS NOT NULL DROP TABLE Demanda_Dx_PtoCompra

select t1.versiondemanda,t1.IdDistribuidora,t1.mes,t1.IdBarraNacional,t1.EnergiaPC EnergiaPC,t1.EnergiaPC/sum(t1.EnergiaPC) over (partition by t1.versiondemanda,t1.IdDistribuidora,t1.mes) FactPtoCompra
into Demanda_Dx_PtoCompra
from (select t1.versiondemanda,t1.IdDistribuidora,t1.mes,t1.IdBarraNacional,sum(t1.EnergiaPC) EnergiaPC from  Demanda_PtoRetiro_PtoCompra t1 group by t1.versiondemanda,t1.IdDistribuidora,t1.mes,t1.IdBarraNacional)
t1
group by t1.versiondemanda,t1.IdDistribuidora,t1.mes,t1.IdBarraNacional,t1.EnergiaPC
--select * from Demanda_Dx_PtoCompra
--*/

--Demanda_Dx. Demanda de cada distribuidora por mes
/*
IF OBJECT_ID('Demanda_Dx', 'U') IS NOT NULL DROP TABLE Demanda_Dx

select VersionDemanda,IdDistribuidora,Mes,sum(EnergiaPC) EnergiaPC
into Demanda_Dx
from Demanda_Dx_PtoCompra
group by VersionDemanda,IdDistribuidora,Mes
--select * from Demanda_Dx
--*/

--Participación de Energía para cada distribuidora por Modalidad y año
/*
IF OBJECT_ID('EModalidad', 'U') IS NOT NULL DROP TABLE EModalidad

select Modalidad,Ano,IdDistribuidora,EnergiaAnual,EnergiaAnual/sum(EnergiaAnual) over (partition by Ano,IdDistribuidora) Factor
into EModalidad
from (
select t3.Modalidad,t1.Ano,t2.IdDistribuidora,sum(EnergiaAnual) EnergiaAnual
				from EAdjAnual t1
				inner join codigocontrato t2 on t1.IdCodigoContrato=t2.IdCodigoContrato
				inner join licitaciongx t3 on t2.IdGeneradora=t3.IdGeneradora and t2.IdLicitacion=t3.IdLicitacion
				where t1.Ano=@Ano-- and Modalidad='DS 4'
				group by t3.Modalidad,t1.Ano,t2.IdDistribuidora
) t1
group by Modalidad,Ano,IdDistribuidora,EnergiaAnual
--select * from EModalidad
--*/
--Energía AdjudicadaMensual por distribuidora
/*
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
/*
IF OBJECT_ID('DespMod', 'U') IS NOT NULL DROP TABLE DespMod

select t1.versiondemanda,t1.IdDistribuidora,t1.mes,t2.modalidad,Concat('Re 704',t2.TipoBloque) Asignacion,t1.EnergiaPC
		,t3.Factor FactorMod
		,t1.EnergiaPC*t3.Factor EnergiaPCMod,EadjMensual
		,case when t1.EnergiaPC*t3.Factor <=EadjMensual then 1 else EadjMensual/(t1.EnergiaPC*t3.Factor) end [Desp%]
		,case when t1.EnergiaPC*t3.Factor <=EadjMensual then t1.EnergiaPC*t3.Factor else EadjMensual  end EDespachada		
into DespMod
from Demanda_Dx t1
inner join EAdjMensDxTB t2 on t1.iddistribuidora=t2.iddistribuidora and t1.mes=t2.fecha and t2.TipoBloque='BB' 
left join EModalidad t3 on t1.IdDistribuidora=t3.IdDistribuidora and year(t1.mes)=t3.ano and t3.Modalidad=t2.Modalidad
--select * from DespMod
--*/
--Determinacion de participación de Re 704BV en despacho a nivel Dx
/*
insert into DespMod
select t1.versiondemanda,t1.iddistribuidora,t1.mes,t2.modalidad,concat('Re 704',t2.TipoBloque) Asignacion,t1.EnergiaPC
		,t3.Factor,t1.EnergiaPC*t3.Factor EnergiaPCRe704,t2.EadjMensual
		,case	when t1.EnergiaPC*t3.Factor-t4.EDespachada=0 then 0
				when t1.EnergiaPC*t3.Factor-t4.EDespachada<=t2.EadjMensual then 1 
				else t2.EadjMensual/(t1.EnergiaPC*t3.Factor) end [Desp%]
		,case	when t1.EnergiaPC*t3.Factor-t4.EDespachada<=t2.EadjMensual then t1.EnergiaPC*t3.Factor-t4.EDespachada 
				else t2.EadjMensual  end EDespachada				
from Demanda_Dx t1
inner join EAdjMensDxTB t2 on t1.iddistribuidora=t2.iddistribuidora and t1.mes=t2.fecha and t2.TipoBloque='BV'
left join EModalidad t3 on t1.iddistribuidora=t3.iddistribuidora and year(t1.mes)=t3.ano  and t3.Modalidad=t2.Modalidad
left join DespMod t4 on t4.versiondemanda=t1.versiondemanda and t4.iddistribuidora=t1.iddistribuidora and t1.mes=t4.mes
--select * from DespMod
--*/

--Energía para despachar por DS4 que viene de Re 704  a nivel Dx
/*
insert into DespMod
select versiondemanda,IdDistribuidora,mes,'DS 4' modalidad,'Re 704' ,EnergiaPC,FactorMod,EnergiaPCMod
 ,(1-sum([Desp%]))*EnergiaPCMod EadjMensual
 ,(1-sum([Desp%])) [Desp%]
 ,(1-sum([Desp%]))*EnergiaPCMod	EDespachada
from DespMod
group by versiondemanda,IdDistribuidora,mes,modalidad,EnergiaPC,FactorMod,EnergiaPCMod
having sum([Desp%])<1
--select * from DespMod
--*/
--Energía para ser despachada por DS4 a nivel Dx
/*
insert into DespMod
select t1.versiondemanda,t1.IdDistribuidora,t1.mes, Modalidad,Modalidad Asignacion,t1.EnergiaPC
		,t3.Factor FactorMod
		,t1.EnergiaPC*t3.Factor EnergiaPCMod
		,t1.EnergiaPC*t3.Factor EadjMensual
		,1 [Desp%]
		,t1.EnergiaPC*t3.Factor  EDespachada
from Demanda_Dx t1
inner join EModalidad t3 on t1.iddistribuidora=t3.IdDistribuidora and year(t1.mes)=t3.ano
where Modalidad='DS 4'
--select * from DespMod
--*/
--Asignación Energía Adjudicada Mensual por modalidad Re 704 y tipo de bloque para cada CodigoContrato 
/*
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
/*
IF OBJECT_ID('DespachoTemp', 'U') IS NOT NULL DROP TABLE DespachoTemp

select	t2.versiondemanda,t2.IdDistribuidora,t2.mes,t2.IdBarraNacional,t1.modalidad,Asignacion,t3.idcodigocontrato,t2.EnergiaPC
		,t1.FactorMod,t1.[Desp%],t3.FactEAdjMensual,t1.FactorMod*t1.[Desp%]*t2.EnergiaPC*t3.FactEAdjMensual EnergiaPCDesp,1 IdTipoDespacho
into DespachoTemp
from DespMod t1
inner join Demanda_Dx_PtoCompra t2 on t1.IdDistribuidora=t2.IdDistribuidora and t1.mes=t2.mes
left join EAdjMensDxTB_CC t3 on t3.IdDistribuidora=t1.IdDistribuidora and t3.fecha=t1.mes
where t1.modalidad='Re 704' and t1.Asignacion='Re 704BB' and t3.TipoBloque='BB'
union all
select	t2.versiondemanda,t2.IdDistribuidora,t2.mes,t2.IdBarraNacional,t1.modalidad,Asignacion,t3.idcodigocontrato,t2.EnergiaPC
		,t1.FactorMod,t1.[Desp%],t3.FactEAdjMensual,t1.FactorMod*t1.[Desp%]*t2.EnergiaPC*t3.FactEAdjMensual EnergiaPCDesp,1 IdTipoDespacho
from DespMod t1
inner join Demanda_Dx_PtoCompra t2 on t1.IdDistribuidora=t2.IdDistribuidora and t1.mes=t2.mes
left join EAdjMensDxTB_CC t3 on t3.IdDistribuidora=t1.IdDistribuidora and t3.fecha=t1.mes
where t1.modalidad='Re 704' and t1.Asignacion='Re 704BV' and t3.TipoBloque='BV'
--select * from DespachoTemp

--*/
--Participación de contratos DS 4 En energía a despachar
/*
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
/*
insert into DespachoTemp
select	t2.versiondemanda,t2.IdDistribuidora,t2.mes,t2.IdBarraNacional,t1.modalidad,Asignacion,t3.idcodigocontrato,t2.EnergiaPC
		,t1.FactorMod,t1.[Desp%],t3.FactEAdjAnual,t1.FactorMod*t1.[Desp%]*t2.EnergiaPC*t3.FactEAdjAnual EnergiaPCDesp,1 IdTipoDespacho
from DespMod t1
inner join Demanda_Dx_PtoCompra t2 on t1.IdDistribuidora=t2.IdDistribuidora and t1.mes=t2.mes
left join EAdjCCAnual t3 on t3.IdDistribuidora=t1.IdDistribuidora and year(t1.mes)=Ano
where t1.modalidad='DS 4'
select * from DespachoTemp
--*/

--llevar despacho a Punto de Retiro
/*
IF OBJECT_ID('DespachoPtoRetiro', 'U') IS NOT NULL DROP TABLE DespachoPtoRetiro

select 0 iddespacho,t1.VersionDemanda,t1.Mes Fecha,t1.IdDistribuidora,t1.IdCodigoContrato,t2.IdPuntoRetiro,t1.IdTipoDespacho,sum(t1.EnergiaPCDesp*t2.Factor/t2.FactorPZ) Energia, '' Potencia,'' Observacion
--IdEfact	IdVersion	Fecha	IdDistribuidora	IdGeneradora	IdCodigoContrato	IdPuntoRetiro	Distribuidora	Generadora	CodigoContrato	PuntoRetiro	IdTipoDespacho	Energia	Potencia	Observacion
from DespachoTemp t1
left join Demanda_PtoRetiro_PtoCompra t2 on t1.IdDistribuidora=t2.IdDistribuidora and t1.Mes=t2.Mes and t1.IdBarraNacional=t2.IdBarraNacional
group by t1.VersionDemanda,t1.Mes,t1.IdDistribuidora,t1.IdCodigoContrato,t2.IdPuntoRetiro,t1.IdTipoDespacho
union all
select 0 iddespacho,t1.Version,t1.Mes Fecha,t1.IdDistribuidora,0 IdCodigoContrato,t1.IdPuntoRetiro,t1.IdTipoDespacho,t1.Demanda Energia, '' Potencia,'' Observacion
from TempDemanda t1 where IdTipoDespacho=2

--select IdTipoDespacho,sum(Demanda)*1000 DEmandaPR from TempDemanda group by IdTipoDespacho--14736294,2021577
--select * from DespachoTemp t1			where t1.IdDistribuidora=10 and t1.Mes='2020-10-01' and IdBarraNacional=8 order by IdCodigoContrato
--select * from Demanda_Dx_PtoCompra t1	where t1.IdDistribuidora=10 and t1.Mes='2020-10-01' and IdBarraNacional=8 
--select * from DespachoTemp t1			where t1.IdDistribuidora=10 and t1.Mes='2020-10-01' and IdBarraNacional=8 and IdCodigoContrato=86 order by IdCodigoContrato
--select * from  ,mmmmmmmmmmmmmDespMod t1				where t1.IdDistribuidora=10 and t1.Mes='2020-10-01'
--*/

--select sum(EnergiaPC) EnergiaPC from Demanda_Dx_PtoCompra
--select sum(EDespachada) from DespMod
--select sum(EnergiaPCDesp) EnergiaPCDesp from DespachoTemp
--select sum(Demanda)*1000 from TempDemanda where IdTipoDespacho=1



--select * from TempDemanda where IdTipoDespacho=5
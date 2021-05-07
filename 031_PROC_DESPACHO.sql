use pnp_3

--PROTOTIPO DE DESPACHO DE CONTRATOS

--pendiente de trabajar despacho de mataquito "Traspaso Excedentes".
--Pendiente trabajar con tipodespacho=Dx con contratos Holding. Cachar si se debe agregar a demanda de empresa Holding no más. puntos de retiro compartidos

--DEFINIFICÓN DATOS DE CÁLCULO
--/*
DECLARE @VersionD VARCHAR(45)='2007ProyV1' --segundo semestre 2020
DECLARE @VersionPZ VARCHAR(45)='Estimado' -- utiliza pérdida estimada
DECLARE @PeriodoFR VARCHAR(45)='Segundo Semestre 2020'-- indica cuáles factores de referenciación utiliza
DECLARE @Ano int=2020-- año de análisis.
DECLARE @DemandaDespacho VARCHAR(45)='Despacho2007ProyV1' -- utiliza pérdida estimada
--*/

--Definición Vector de precios PNP
--/*
IF OBJECT_ID('TempPNP', 'U') IS NOT NULL DROP TABLE TempPNP--Precios del ITD deben ser
select * 
into TempPNP
from pnp
where version='ITD' and MesIndexacion='2020-07-01' and VersionIndex='2101V3'
--*/

--Definición de demanda Se debe indicar forma de despacho para cada distribuidora y casos puntuales de puntos de retiro.
	--Comentar para crear procedimiento
--/*
--IF OBJECT_ID('DemandaDespacho', 'U') IS NOT NULL DROP TABLE DemandaDespacho
delete from DespachoDemanda where VersionDemandaDespacho=@DemandaDespacho
insert into DespachoDemanda
SELECT	@DemandaDespacho VersionDemandaDespacho, IdDemanda,Version VersionDemanda,IdDistribuidora,Distribuidora,Mes,t2.IdSistemaZonal,t2.Ano,t1.IdPuntoRetiro,PuntoRetiro,Demanda
		,case when t1.IdSistemaZonal<>t2.IdSistemaZonal then t1.Observacion+' Sistema zonal informado no coincide con relacionde Pto retiro en DB' else t1.Observacion end Observacion
		,TipoDemanda
		,case	when IdDistribuidora in(45) then 34--45	Mataquito--Se asocia a Coelcha
				when IdDistribuidora in(12,13,15) then 10--12	EEC--13	TIL TIL--15	LUZ ANDES--Se asocia a Enel
				else IdDistribuidora end  IdDistribuidoraDespacho
		,case	when IdDistribuidora in(45) then 4--45	Mataquito
				when IdDistribuidora in(12,13,15) then 5--12	EEC--13	TIL TIL--15	LUZ ANDES
				when IdDistribuidora in (20) then 2--20	COOPERSOL
				when IdDistribuidora in (34) and t1.IdPuntoRetiro in (8) then 2--Coelcha-Pangue 066
				when IdDistribuidora in (34) and t1.IdPuntoRetiro not in (8) then 1--Coelcha
				when IdDistribuidora in (22) and t1.IdPuntoRetiro in (8) then 2--FRontel-Pangue 066
				when IdDistribuidora in (22) and t1.IdPuntoRetiro not in (8) then 1--FRontel
				when IdDistribuidora in (1,2,3,4,6,7,8,9,10,14,18,21,23,24,25,26,28,29,31,32,33,35,36,39,40,44) then 1 end IdTipoDespacho--Licitacion	
--into DespachoDemanda
FROM DEMANDA T1
inner join ptoretirosistema t2 on t1.IdPuntoRetiro=t2.IdPuntoRetiro and t2.Ano=@Ano
WHERE	T1.Version=@VERSIOND
--*/

--EJECUTAR PROCEDIMIENTO DE DESPACHO
EXEC [dbo].[015_PROC_DESPACHO]
					@VersionD,
					@VersionPZ,
					@PeriodoFR,
					@Ano,
					@DemandaDespacho

select 'S' D,iddistribuidora,idpuntoretiro,idtipodespacho,sum(energia) Energia from DespachoPtoRetiro where Fecha='2020-09-01'
group by iddistribuidora,idpuntoretiro,idtipodespacho
union all
select 'I' D,iddistribuidora,idpuntoretiro,idtipodespacho,sum(Demanda)*1000 from DespachoDemanda where mes='2020-09-01'
group by iddistribuidora,idpuntoretiro,idtipodespacho


select sum(demanda) from DespachoDemanda-- where idpuntoretiro=225 and mes='2020-09-01'
select sum(energia) from DespachoPtoretiro-- where idpuntoretiro=225 and fecha='2020-09-01'

select sum(EnergiaPC) from Demanda_PtoRetiro_PtoCompra
select sum(energiapcdesp) from Despacho
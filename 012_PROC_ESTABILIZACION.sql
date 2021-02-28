USE [PNP_3]
GO

/****** Object:  StoredProcedure [dbo].[012_PROC_ESTABILIZACION]    Script Date: 12-02-2021 17:00:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--	CÁLCULO DE DIFERENCIAS E INDEXACIONES
--CONSIDERA QUE SI NO HAY CRUCE ENTRE CONTRATOS,PUNTO RETIRO Y BARRA NACIONAL, SE CARGA 0
--/*
alter procedure [dbo].[012_PROC_ESTABILIZACION]
					@IdVersionEstabilizacion VARCHAR(10)
as
--*/
/*
USE PNP_2
DECLARE @IdVersionEstabilizacion VARCHAR(255)='140-141'
--*/

--CREAR TABLA TEMPORAL DE VERSION PreciosPNP
IF OBJECT_ID('Temp_Efact_PreciosPNP', 'U') IS NOT NULL DROP TABLE Temp_Efact_PreciosPNP

SELECT	T1.idversion IdVersionPreciosPNP,t1.IdEfact,t1.fechaefact,t1.IdVersionEFact,t1.PNP_VersionIndex,t1.PNP_MesIndexacion,t1.PNP_Version,T1.IdDistribuidora,T1.IdGeneradora,t1.IdCodigoContrato,t1.IdPuntoRetiro,t1.IdSistemaZonal,t1.idtipodespacho,
	SUM(T1.ENERGIA*T1.FactorFR) ENERGIA,SUM(T1.POTENCIA*T1.FactorFR) POTENCIA,
	sum(t1.EPC) EPC,sum(t1.PPC) PPC,sum(ERec_Peso) ERec_Peso,sum(PRec_Peso) PRec_Peso
into Temp_Efact_PreciosPNP
FROM RecaudacionDetalle T1
where t1.idversion in (select IdVersionContratosPNP from VersionEstabilizacion WHERE IdVersionEstabilizacion=@IdVersionEstabilizacion)
group by T1.idversion,t1.IdEfact,t1.fechaefact,t1.IdVersionEFact,t1.PNP_VersionIndex,t1.PNP_MesIndexacion,t1.PNP_Version,T1.IdDistribuidora,T1.IdGeneradora,t1.IdCodigoContrato,t1.IdPuntoRetiro,t1.IdSistemaZonal,t1.idtipodespacho

--CREAR TABLA TEMPORAL DE VERSION PreciosDef
IF OBJECT_ID('Temp_Efact_PreciosDef', 'U') IS NOT NULL DROP TABLE Temp_Efact_PreciosDef

SELECT	T1.idversion IdVersionPreciosDef,t1.IdEfact,t1.fechaefact,t1.IdVersionEFact,t1.PNP_VersionIndex,t1.PNP_MesIndexacion,t1.PNP_Version,T1.IdDistribuidora,T1.IdGeneradora,t1.IdCodigoContrato,t1.IdPuntoRetiro,t1.IdSistemaZonal,t1.idtipodespacho,
	SUM(T1.ENERGIA*T1.FactorFR) ENERGIA,SUM(T1.POTENCIA*T1.FactorFR) POTENCIA,
	sum(t1.EPC) EPC,sum(t1.PPC) PPC,sum(ERec_Peso) ERec_Peso,sum(PRec_Peso) PRec_Peso
into Temp_Efact_PreciosDef
FROM RecaudacionDetalle T1
where t1.idversion in (select IdVersionContratosDefinitiva from VersionEstabilizacion WHERE IdVersionEstabilizacion=@IdVersionEstabilizacion)
group by T1.idversion,t1.IdEfact,t1.fechaefact,t1.IdVersionEFact,t1.PNP_VersionIndex,t1.PNP_MesIndexacion,t1.PNP_Version,T1.IdDistribuidora,T1.IdGeneradora,t1.IdCodigoContrato,t1.IdPuntoRetiro,t1.IdSistemaZonal,t1.idtipodespacho

--COMPARAR RESULTADOS
delete from EstabilizacionDetalle WHERE IdVersionEstabilizacion=@IdVersionEstabilizacion
insert into EstabilizacionDetalle
SELECT	@IdVersionEstabilizacion IdVersionEstabilizacion,
		t1.IdEfact,t1.IdVersionPreciosDef,t2.IdVersionPreciosPNP,t1.IdDistribuidora,t1.IdGeneradora,t1.IdCodigoContrato,t1.IdPuntoRetiro,t1.idtipodespacho,t1.Energia,t1.Potencia,
		t1.fechaefact fechaefact_PrecioDef,t1.IdVersionEFact IdVersionEFact_PrecioDef,t1.PNP_MesIndexacion PNP_MesIndexacion_PrecioDef,t1.PNP_VersionIndex PNP_VersionIndex_PrecioDef,t1.PNP_Version PNP_Version_PrecioDef,t1.EPC EPC_PrecioDef,t1.PPC PPC_PrecioDef,T1.ERec_Peso ERec_Peso_PrecioDef,T1.PRec_Peso PRec_Peso_PrecioDef,
		t2.fechaefact fechaefact_PrecioPNP,t2.IdVersionEFact IdVersionEFact_PrecioPNP,t2.PNP_MesIndexacion PNP_MesIndexacion_PrecioPNP,t1.PNP_VersionIndex PNP_VersionIndex_PrecioPNP,t2.PNP_Version PNP_Version_PrecioPNP,t2.EPC EPC_PrecioPNP,t2.PPC PPC_PRecioPNP,T2.ERec_Peso ERec_Peso_PrecioPNP,T2.PRec_Peso PRec_Peso_PrecioPNP,
		t3.VariacionIPC,t3.Intereses,t3.FactorAjusteE,t3.FactorAjusteP,t3.DolarEstabilizacion, 
		(isnull(T2.ERec_Peso,0)*t3.FactorAjusteE-T1.ERec_Peso) DifEnergiaRecPeso,
		(isnull(T2.PRec_Peso,0)*t3.FactorAjusteP-T1.PRec_Peso) DifPotenciaRecPeso,
		(isnull(T2.ERec_Peso,0)*t3.FactorAjusteE-T1.ERec_Peso)*t3.VariacionIPC*t3.Intereses DifEnergiaRecPesoEst,
		(isnull(T2.PRec_Peso,0)*t3.FactorAjusteP-T1.PRec_Peso)*t3.VariacionIPC*t3.Intereses DifPotenciaRecPesoEst,
		(isnull(T2.ERec_Peso,0)*t3.FactorAjusteE-T1.ERec_Peso)*t3.VariacionIPC*t3.Intereses/t3.DolarEstabilizacion DifEnergiaRecDolarEst,
		(isnull(T2.PRec_Peso,0)*t3.FactorAjusteP-T1.PRec_Peso)*t3.VariacionIPC*t3.Intereses/t3.DolarEstabilizacion DifPotenciaRecDolarEst
FROM Temp_Efact_PreciosDef T1
left join Temp_Efact_PreciosPNP t2 on t1.idefact=t2.idefact and t1.fechaefact=t2.fechaefact
left join Estabilizacion t3 on t1.FechaEfact=t3.fecha


--BORRADO DE TABLAS TEMPORALES
IF OBJECT_ID('Temp_Efact_PreciosDef', 'U') IS NOT NULL DROP TABLE Temp_Efact_PreciosDef
IF OBJECT_ID('Temp_Efact_PreciosPNP', 'U') IS NOT NULL DROP TABLE Temp_Efact_PreciosPNP

--RESULTADOS DE ESTABILIZACION
select	IdVersionEstabilizacion,Fechaefact_PrecioDef,sum(Energia) Energia,sum(Potencia) Potencia,
		sum(DifERec_Peso) DifERec_Peso,sum(DifPRec_Peso) DifPRec_Peso,
		sum(DifERec_Peso_Estabilizado) DifERec_Peso_Estabilizado,sum(DifPRec_Peso_Estabilizado) DifPRec_Peso_Estabilizado,
		sum(DifERec_Dolar_Estabilizado) DifERec_Dolar_Estabilizado,sum(DifPRec_Dolar_Estabilizado) DifPRec_Dolar_Estabilizado
from EstabilizacionDetalle
where IdVersionEstabilizacion=@IdVersionEstabilizacion
group by Fechaefact_PrecioDef,IdVersionEstabilizacion
order by IdVersionEstabilizacion

GO
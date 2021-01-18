/*
create procedure [011_PROC_RECAUDACION]
					@idversion int
as
*/
--DECLARACION VARIABLES, SOLAMENTE PARA REALIZACIÓN DE PRUEBAS ANTES DE PROCEDIMIENTO.
use pnp_2
declare @idVersionRef varchar(15)	set @idVersionRef=118;--Para crear versión y extraer antecedentes Efact
declare @idVersion varchar(15)	set @idVersion=(select max(IdVersion)+1 from versionrec)
select @idVersionRef,@idVersion NuevoID
delete from versionrecdetalle where IdVersion=@idVersion
delete from versionrec where IdVersion=@idVersion

--DECLARACIÓN DE VARIABLES PARA UTILIZAR DENTRO DEL PROCEDIMIENTO
	--crear version de prueba
insert into versionrec select  @idVersion,Descripcion from versionrec where IdVersion=@idVersionRef
insert into versionrecdetalle select @idVersion,Registro,ValorTexto,ValorFecha,ValorInt,ValorFloat,Descripcion from versionrecdetalle where IdVersion=@idVersionRef
--select * from versionrecdetalle where IdVersion=@idVersion

declare @VersionEFACT int	select @VersionEFACT=idversion from versionefact where Descripcion in (
													select ValorTexto from versionrecdetalle where idversion=@idVersion and registro='VersionEfact');--Para crear versión y extraer antecedentes Efact
DECLARE @FECHAEFACT DATE 				select @FECHAEFACT=valorfecha from versionrecdetalle where idversion=@idVersion and Registro='FECHAEFACT';--MES PARA REALIZAR VALIDACIÓN, DEBE EXISTIR EN CEN_Efact

declare @VersionPNCP varchar(255)	select @VersionPNCP=valortexto from versionrecdetalle where idversion=@idVersion and Registro='VersionPNCP';--Para crear versión y extraer antecedentes Efact
DECLARE @FECHAPNCP DATE 			select @FECHAPNCP=valorfecha from versionrecdetalle where idversion=@idVersion and Registro='Mes_PNCP';--MES PARA REALIZAR VALIDACIÓN, DEBE EXISTIR EN CEN_Efact
declare @DolarPNCP float			select @DolarPNCP=valorfloat from versionrecdetalle where idversion=@idVersion and Registro='DolarPNCP';--

declare @DolarVersion float			select @DolarVersion=valorfloat from versionrecdetalle where idversion=@idVersion and Registro='DolarVersion';--Para crear versión y extraer antecedentes Efact
declare @DolarFecha date			select @DolarFecha=valorfecha from versionrecdetalle where idversion=@idVersion and Registro='DolarVersion';--Para crear versión y extraer antecedentes Efact

declare @VersionPNP varchar(15)		select @VersionPNP=valortexto from versionrecdetalle where idversion=@idVersion and Registro='VersionPNP';;--Para crear versión y extraer antecedentes PNP
declare @TipoPNP varchar(15)		select @TipoPNP=valortexto from versionrecdetalle where idversion=@idVersion and Registro='TipoPNP';--Para Separar PNP del mes correspondiente o ITD
DECLARE @FECHAPNP DATE 				select @FECHAPNP=valorfecha from versionrecdetalle where idversion=@idVersion and Registro='FECHAPNP';--MES PARA REALIZAR VALIDACIÓN, DEBE EXISTIR EN CEN_Efact

declare @VersionPerdida varchar(15)	select @VersionPerdida=valortexto from versionrecdetalle where idversion=@idVersion and Registro='VersionPerdida';--Para crear versión y extraer antecedentes Efact
DECLARE @FECHAPerdida DATE 			select @FECHAPerdida=valorfecha from versionrecdetalle where idversion=@idVersion and Registro='FECHAPerdida';--MES PARA REALIZAR VALIDACIÓN, DEBE EXISTIR EN CEN_Efact

DECLARE @PtoRetiroSistemaAno int	select @PtoRetiroSistemaAno=ValorInt from versionrecdetalle where idversion=@idVersion and Registro='PtoRetiroSistemaAno';--MES PARA REALIZAR VALIDACIÓN, DEBE EXISTIR EN CEN_Efact

--crear tabla EfactPNP Temporal
IF OBJECT_ID('tempefact', 'U') IS NOT NULL DROP TABLE tempefact
select t1.[IdEfact],t1.[IdVersion] IdversionEfact,t1.[Fecha] FechaEfact,t1.[IdDistribuidora],[IdGeneradora],[IdCodigoContrato]
      ,t1.[IdPuntoRetiro],t1.[IdTipoDespacho],t1.[Energia],t1.[Potencia]
      ,[Observacion]
into tempefact
from efact t1
where t1.IdVersion=@versionefact and t1.Fecha=@FECHAEFACT

IF OBJECT_ID('temppnp', 'U') IS NOT NULL DROP TABLE temppnp
select * 
into temppnp
from pnp 
where VersionIndex=@VersionPNP and MesIndexacion=@FECHAPNP and Version=@TipoPNP

--CÁLCULO DE ENERGÍA Y POTENCIA RECAUDADA, MISMOS REGISTROS DE EFACTPNP
--/*
--BORRADO VERSION DE TRABAJO
delete from RecaudacionDetalle where idversion=@idversion

--RECAUDACION PARA ENERGÍAS DE LICITACION IdTipoDespacho=1 --"Licitacion"
insert into RecaudacionDetalle 
SELECT	@idVersion idVersion,t1.IdEfact,t1.IdversionEfact,t1.FechaEfact,t1.IdDistribuidora,t1.IdGeneradora,t1.IdCodigoContrato,t1.IdPuntoRetiro,t1.IdTipoDespacho,t1.Energia,t1.Potencia
		,t2.IdSistemaZonal,t3.Fecha FechaPZ,t3.Version VersionPZ,t3.Factor FEPE, t4.Factor FEPP
		,t5.IdBarraNacional,t5.Periodo,t5.Factor FactorR
		,t6.VersionIndex,t6.MesIndexacion,t6.[Version],t6.PNELP,t6.PNPLP
		,'2000-01-01' PNCP_Mes,'',0,0,0,0
		,Energia*t5.Factor*t3.Factor EnergiaPC,Potencia*t5.Factor*t4.Factor PotenciaPC
		,Energia*t5.Factor*t3.Factor*t6.PNELP/1000 EnergiaRecDolar
		,Potencia*t5.Factor*t4.Factor*t6.PNPLP PotenciaRecDolar
		,@DolarVersion Dolar
		,Energia*t5.Factor*t3.Factor*t6.PNELP*@DolarVersion/1000 EnergiaRecPeso
		,Potencia*t5.Factor*t4.Factor*t6.PNPLP*@DolarVersion PotenciaRecPeso		
FROM tempefact t1
left join PtoRetiroSistema t2 on t2.idpuntoRetiro=t1.IdpuntoRetiro and t2.ano=@PtoRetiroSistemaAno
left join perdidazonal t3 on t3.IdSistemaZonal=t2.IdSistemaZonal and t3.Version=@VersionPerdida and t3.Fecha=@FECHAPerdida and t3.TipoFactor='FEPE'
left join perdidazonal t4 on t4.IdSistemaZonal=t2.IdSistemaZonal and t4.Version=@VersionPerdida and t4.Fecha=@FECHAPerdida and t4.TipoFactor='FEPP'
left join factorreferenciacion t5 on t1.IdPuntoRetiro=t5.IdPuntoRetiro and @FECHAPNP>=t5.FechaInicio and  @FECHAPNP<=t5.FechaFin
left join temppnp t6 on t1.IdCodigoContrato=t6.IdCodigoContrato and t5.IdBarraNacional=t6.IdBarraNacional and t6.VersionIndex=@VersionPNP and t6.Version=@TipoPNP and t6.MesIndexacion=@FECHAPNP
WHERE IdTipoDespacho=1

--RECAUDACION PARA ENERGÍAS DE LICITACION IdTipoDespacho=2 --"Corto Plazo"

	--DESPACHO DE CONTRATOS CORTO PLAZO
--CREAR PNCP CON CET
--	/*
delete from PNCPconCET where Idversion=@IdVersion
--insert into PNCPconCET
SELECT	t1.idversion,T1.VersionEfact,t1.FechaEfact,t1.BarraNacional,t1.CodigoContrato,
		T2.Mes_PNCP,t2.VERSIONPNCP,PrecioNudoEnergiaPeso,
		t3.versionpnp,t3.fechaPNP,t3.tipoPNP,isnull(T3.CET,0) CETDolar,
		@DolarPNCP DolarVersion,
		PrecioNudoEnergiaPeso/@DolarPNCP*1000 PrecioNudoEnergiaDolar,
		PrecioNudoPotenciaPeso/@DolarPNCP PrecioNudoPotenciaDolar
FROM tempefact T1--CONTRATOS QUE SON DE CORTO PLAZO
LEFT JOIN PNCP T2 on T2.Mes_PNCP=@FECHAPNCP and t2.VersionPNCP=@VersionPNCP and t1.BarraNAcional=t2.Nudo
left join CETPNCP T3 on T3.codigocontrato=T1.codigocontrato and T3.FechaPNP=@FECHAPNP and t3.versionpnp=@versionpnp and t3.tipopnp=@tipopnp
where IdTipoDespacho=2
--*/

	--ASIGNA PRECIOS A CONTRATOS DE CORTO PLAZO
/*
drop table if exists EfactPNP_PNCP;
select * 
into EfactPNP_PNCP
from (
select t1.*,t2.Mes_PNCP,t2.CETDolar,t2.PrecioNudoEnergiaDolar,t2.PrecioNudoPotenciaDolar
from EfactPNP t1
left join PNCPconCET t2 on t1.idversion=t2.idversion and t1.FechaEfact=t2.fechaefact and t2.BarraNacional=t1.BarraNAcional and t1.CodigoContrato=t2.CodigoContrato
where	FlagCtr=0 and t1.idversion=@idVersion
union all
select EfactPNP.*,Null Mes_PNCP,null CETDolar, Null PrecioNudoEnergiaDolar,Null PrecioNudoPotenciaDolar 
from EfactPNP
where FlagCtr=1 and Idversion=@idVersion
)T
--*/


--insert into RecaudacionDetalle 
SELECT	@idVersion idVersion,t1.IdEfact,t1.IdversionEfact,t1.FechaEfact,t1.IdDistribuidora,t1.IdGeneradora,t1.IdCodigoContrato,t1.IdPuntoRetiro,t1.IdTipoDespacho,t1.Energia,t1.Potencia
		,t2.IdSistemaZonal,t3.Fecha FechaPZ,t3.Version VersionPZ,t3.Factor FEPE, t4.Factor FEPP
		,t5.IdBarraNacional,t5.Periodo,t5.Factor FactorR
		,'','2000-01-01' MesIndexacion,'',0,0
		,'2000-01-01' PNCP_Mes,'',0,0,0,0
		,Energia*t5.Factor*t3.Factor EnergiaPC,Potencia*t5.Factor*t4.Factor PotenciaPC
		,Energia*t5.Factor*t3.Factor*t6.PNELP/1000 EnergiaRecDolar
		,Potencia*t5.Factor*t4.Factor*t6.PNPLP PotenciaRecDolar
		,@DolarVersion Dolar
		,Energia*t5.Factor*t3.Factor*t6.PNELP*@DolarVersion/1000 EnergiaRecPeso
		,Potencia*t5.Factor*t4.Factor*t6.PNPLP*@DolarVersion PotenciaRecPeso		
FROM tempefact t1
left join PtoRetiroSistema t2 on t2.idpuntoRetiro=t1.IdpuntoRetiro and t2.ano=@PtoRetiroSistemaAno
left join perdidazonal t3 on t3.IdSistemaZonal=t2.IdSistemaZonal and t3.Version=@VersionPerdida and t3.Fecha=@FECHAPerdida and t3.TipoFactor='FEPE'
left join perdidazonal t4 on t4.IdSistemaZonal=t2.IdSistemaZonal and t4.Version=@VersionPerdida and t4.Fecha=@FECHAPerdida and t4.TipoFactor='FEPP'
left join factorreferenciacion t5 on t1.IdPuntoRetiro=t5.IdPuntoRetiro and @FECHAPNP>=t5.FechaInicio and  @FECHAPNP<=t5.FechaFin
WHERE IdTipoDespacho=2

SELECT * FROM tipodespacho
--BORRADO TABLAS TEMPORALES
/*
drop table tempefact
drop table temppnp
drop table if exists EfactPNP_PNCP;
drop table if exists ContratoCPTemp

--RESULTADOS
select idversion,FechaEfact,VersionEfact,sum(EnergiaPC) EnergiaPC,sum(PotenciaPC)PotenciaPC,sum(EnergiaRecPeso) EnergiaRecPeso,sum(PotenciaRecPeso) PotenciaRecPeso
from Recaudaciondetalle
where idversion=@idversion
group by FechaEfact,VersionEfact,idversion
order by idversion,versionefact,FechaEfact
--*/
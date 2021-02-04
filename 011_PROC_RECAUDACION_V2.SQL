/*
create procedure [011_PROC_RECAUDACION]
					@idversion int
as
*/
--DECLARACION VARIABLES, SOLAMENTE PARA REALIZACIÓN DE PRUEBAS ANTES DE PROCEDIMIENTO.
use pnp_2
declare @idVersionRef varchar(15)	set @idVersionRef=118;--Para crear versión y extraer antecedentes Efact
declare @idVersion varchar(15)	set @idVersion=135
select @idVersionRef,@idVersion NuevoID

delete from PNCPconCET where Idversion=@IdVersion
delete from RecaudacionDetalle where idversion=@idversion
delete from versionrecdetalle where IdVersion=@idVersion
delete from versionrec where IdVersion=@idVersion

--DECLARACIÓN DE VARIABLES PARA UTILIZAR DENTRO DEL PROCEDIMIENTO
	--crear version de prueba
insert into versionrec select  @idVersion,Descripcion from versionrec where IdVersion=@idVersionRef
insert into versionrecdetalle select @idVersion,Registro,ValorTexto,ValorFecha,ValorInt,ValorFloat,Descripcion from versionrecdetalle where IdVersion=@idVersionRef
--select * from versionrecdetalle where IdVersion=@idVersion
--*/
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

--crear tabla Efact y PNP Temporal
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

--BORRADO VERSION DE TRABAJO
delete from RecaudacionDetalle where idversion=@idversion

--RECAUDACION PARA ENERGÍAS DE CORTO PLAZO IdTipoDespacho=4 --"Déficit"
	--PENDIENTE

--RECAUDACION PARA ENERGÍAS DE LICITACION IdTipoDespacho IN(1,5) --"Licitacion" Y "Dx con contratos Holding"
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
WHERE IdTipoDespacho in(1,5)

--RECAUDACION PARA ENERGÍAS DE CORTO PLAZO IdTipoDespacho=2 --"Corto Plazo"
	--CREAR PNCP CON CET
delete from PNCPconCET where Idversion=@IdVersion
insert into PNCPconCET
select	@idversion idversion,idVersionEfact,FechaEfact
		,T2.mes Mes_PNCP,t2.version VERSIONPNCP,idBarraNacional,PrecioNudoE_Peso
		,case when t3.MesIndexacion is null then '2000-01-01' else t3.MesIndexacion end MesIndexacion
		,case when t3.VersionIndex is null then '0' else t3.VersionIndex end VersionIndex
		,case when t3.Version is null then '0' else t3.Version end [Version]
		,t1.IdGeneradora,t1.IdDistribuidora,isnull(T3.CET,0) CETDolar
		,@DolarPNCP DolarVersion
		,PrecioNudoE_Peso/@DolarPNCP*1000 PrecioNudoEnergiaDolar
		,PrecioNudoP_Peso/@DolarPNCP PrecioNudoPotenciaDolar
from tempefact t1
left join factorreferenciacion t5 on t1.IdPuntoRetiro=t5.IdPuntoRetiro and @FECHAPNP>=t5.FechaInicio and  @FECHAPNP<=t5.FechaFin
LEFT JOIN PNCP T2 on T2.MES=@FECHAPNCP and t2.Version=@VersionPNCP and t5.IdBarraNacional=t2.IdNudo
left join cetcp T3 on	T3.IdDistribuidora=T1.IdDistribuidora and t3.IdGeneradora=t1.IdGeneradora and T3.MesIndexacion=@FECHAPNP 
						and t3.VersionIndex=@versionpnp and t3.Version=@tipopnp
where IdTipoDespacho=2
	--CALCULAR RECAUDACION
insert into RecaudacionDetalle 
SELECT	@idVersion idVersion,t1.IdEfact,t1.IdversionEfact,t1.FechaEfact,t1.IdDistribuidora,t1.IdGeneradora,t1.IdCodigoContrato,t1.IdPuntoRetiro,t1.IdTipoDespacho,t1.Energia,t1.Potencia
		,t2.IdSistemaZonal,t3.Fecha FechaPZ,t3.Version VersionPZ,t3.Factor FEPE, t4.Factor FEPP
		,t5.IdBarraNacional,t5.Periodo,t5.Factor FactorR
		,'','2000-01-01' MesIndexacion,'',0,0
		,t6.MES_PNCP,t6.VersionPNCP,t6.IdNudo,t6.CETDolar,t6.PrecioNudoEnergiaDolar,t6.PrecioNudoPotenciaDolar
		,Energia*t5.Factor*t3.Factor EnergiaPC,Potencia*t5.Factor*t4.Factor PotenciaPC
		,Energia*t5.Factor*t3.Factor*(t6.PrecioNudoEnergiaDolar-t6.CETDolar)/1000 EnergiaRecDolar
		,Potencia*t5.Factor*t4.Factor*t6.PrecioNudoPotenciaDolar PotenciaRecDolar
		,@DolarVersion Dolar
		,Energia*t5.Factor*t3.Factor*(t6.PrecioNudoEnergiaDolar-t6.CETDolar)*@DolarVersion/1000 EnergiaRecPeso
		,Potencia*t5.Factor*t4.Factor*t6.PrecioNudoPotenciaDolar*@DolarVersion PotenciaRecPeso			
FROM tempefact t1
left join PtoRetiroSistema t2 on t2.idpuntoRetiro=t1.IdpuntoRetiro and t2.ano=@PtoRetiroSistemaAno
left join perdidazonal t3 on t3.IdSistemaZonal=t2.IdSistemaZonal and t3.Version=@VersionPerdida and t3.Fecha=@FECHAPerdida and t3.TipoFactor='FEPE'
left join perdidazonal t4 on t4.IdSistemaZonal=t2.IdSistemaZonal and t4.Version=@VersionPerdida and t4.Fecha=@FECHAPerdida and t4.TipoFactor='FEPP'
left join factorreferenciacion t5 on t1.IdPuntoRetiro=t5.IdPuntoRetiro and @FECHAPNP>=t5.FechaInicio and  @FECHAPNP<=t5.FechaFin
left join pncpconcet t6 on t6.FechaEfact=t1.FechaEfact and t6.IdVersion=@idversion and t6.FechaEfact=t1.FechaEfact and t6.IdDistribuidora=t1.IdDistribuidora and t6.IdGeneradora=t1.IdGeneradora and t6.IdNudo=t5.IdBarraNacional
WHERE IdTipoDespacho=2

--RECAUDACION PARA ENERGÍAS DE TRASPASO DE EXCEDENTES IdTipoDespacho=4 --"Traspaso Excedentes"

	--CARGAR PRECIOS A PNPTraspExc
declare @VersionCMG varchar(255)='2101V3'
delete from PNPTraspExc where versionPNP=@VersionCMG and VersionPNP=@VersionPNP and Fecha=@FECHAPNP and version=@TipoPNP

insert into PNPTraspExc
select	t2.versionindex,t2.mesindexacion,t2.version,t1.IdCodigoContrato,t2.idptooferta,t5.idBarraNacional PtoCompra,t2.cet_USD,t2.PrecioEnergia,t2.PrecioPotencia,t2.Observacion
		,t6.Valor DolarMes,t3.VersionCMg,t3.Fecha FechaCMG
		,t3.CMG_Peso/t6.Valor*1000 CMGPtoSuministro
		,t4.CMG_Peso/t6.Valor*1000 CMGPtoOferta
		,(t2.PrecioEnergia-t2.cet_USD)+(t3.CMG_Peso-t4.CMG_Peso)/t6.Valor*1000 PeTraspExc
FROM tempefact t1
left join pnpindex t2 on t1.IdCodigoContrato=t2.idcodigocontrato and Versionindex=@VersionPNP and t2.mesindexacion=@FECHAPNP and t2.version=@TipoPNP
left join factorreferenciacion t5 on t1.IdPuntoRetiro=t5.IdPuntoRetiro and @FECHAPNP>=t5.FechaInicio and  @FECHAPNP<=t5.FechaFin
inner join IndexacionDolar t6 on t6.Fecha=t2.mesindexacion
left join CMGPromedio t3 on t5.IdBarraNacional=t3.IdBarraNacional and t2.mesindexacion=t3.fecha and t3.VersionCMg=@VersionCMG
left join CMGPromedio t4 on t2.idPtoOferta=t4.IdBarraNacional and t2.mesindexacion=t4.fecha and t4.VersionCMg=@VersionCMG
where idtipodespacho=4

	--CARGAR RECAUDACIÓN
insert into RecaudacionDetalle 
SELECT	@idVersion idVersion,t1.IdEfact,t1.IdversionEfact,t1.FechaEfact,t1.IdDistribuidora,t1.IdGeneradora,t1.IdCodigoContrato,t1.IdPuntoRetiro,t1.IdTipoDespacho,t1.Energia,t1.Potencia
		,t2.IdSistemaZonal,t3.Fecha FechaPZ,t3.Version VersionPZ,t3.Factor FEPE, t4.Factor FEPP
		,t5.IdBarraNacional,t5.Periodo,t5.Factor FactorR
		,t6.VersionPNP,t6.FEcha,t6.[Version],t6.PeTRaspExc,t7.PNPLP
		,'2000-01-01' PNCP_Mes,'',0,0,0,0
		,Energia*t5.Factor*t3.Factor EnergiaPC,Potencia*t5.Factor*t4.Factor PotenciaPC
		,Energia*t5.Factor*t3.Factor*t6.PeTRaspExc/1000 EnergiaRecDolar
		,Potencia*t5.Factor*t4.Factor*t7.PNPLP PotenciaRecDolar
		,@DolarVersion Dolar
		,Energia*t5.Factor*t3.Factor*t6.PeTRaspExc*@DolarVersion/1000 EnergiaRecPeso
		,Potencia*t5.Factor*t4.Factor*t7.PNPLP*@DolarVersion PotenciaRecPeso		
FROM tempefact t1
left join PtoRetiroSistema t2 on t2.idpuntoRetiro=t1.IdpuntoRetiro and t2.ano=@PtoRetiroSistemaAno
left join perdidazonal t3 on t3.IdSistemaZonal=t2.IdSistemaZonal and t3.Version=@VersionPerdida and t3.Fecha=@FECHAPerdida and t3.TipoFactor='FEPE'
left join perdidazonal t4 on t4.IdSistemaZonal=t2.IdSistemaZonal and t4.Version=@VersionPerdida and t4.Fecha=@FECHAPerdida and t4.TipoFactor='FEPP'
left join factorreferenciacion t5 on t1.IdPuntoRetiro=t5.IdPuntoRetiro and @FECHAPNP>=t5.FechaInicio and  @FECHAPNP<=t5.FechaFin
left join PNPTraspExc t6 on t1.IdCodigoContrato=t6.IdCodigoContrato and t5.IdBarraNacional=t6.IDPTOCOMPRA and t6.VersionPNP=@VersionPNP and t6.Version=@TipoPNP and t6.FECHA=@FECHAPNP
left join temppnp t7 on t1.IdCodigoContrato=t7.IdCodigoContrato and t5.IdBarraNacional=t7.IdBarraNacional and t7.VersionIndex=@VersionPNP and t6.Version=@TipoPNP and t7.MesIndexacion=@FECHAPNP
WHERE IdTipoDespacho in(4)

--TENER PRESENTE QUE PRECIOS DE MATAQUITO PARA "Versión Contratos PNP" HASTA 2101 NO CONTIENE CÁLCULO DE PRECIOS CON CMG.

--BORRADO TABLAS TEMPORALES
IF OBJECT_ID('tempefact', 'U') IS NOT NULL DROP TABLE tempefact
IF OBJECT_ID('temppnp', 'U') IS NOT NULL DROP TABLE temppnp
IF OBJECT_ID('ContratoCPTemp', 'U') IS NOT NULL DROP TABLE ContratoCPTempemptrasp

--RESULTADOS

select idversion,FechaEfact,idVersionEfact,sum(EPC) EPC,sum(PPC) PPC,sum(ERec_Peso) ERec_Peso,sum(PRec_Peso) PRec_Peso
from Recaudaciondetalle
where idversion in (@idversion,@idVersionRef)
group by FechaEfact,idVersionEfact,idversion
order by idversion,idversionefact,FechaEfact
--*/

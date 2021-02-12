use pnp_2
/* 19:04
--ejecutar solamente 1 vez
--exec sp_addlinkedserver @server='GTD-NOT019\SQLEXPRESS'
GO

insert into barranacional select * from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.barranacional
	insert into BarraNacional values(73,'CHUQUICAMATA 220','Aparece en PNCP')
	insert into BarraNacional values(74,'EL COBRE 220','Aparece en PNCP')
	insert into BarraNacional values(75,'EL LLANO 220','Aparece en PNCP')
	insert into BarraNacional values(76,'NUEVA VICTORIA 220','Aparece en PNCP')
	insert into BarraNacional values(77,'O''HIGGINS 220','Aparece en PNCP')
insert into distribuidora select * from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.distribuidora
insert into generadora select * from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.suministrador
insert into puntoretiro select * from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.PuntoRetiro
insert into sistemazonal select * from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.SistemaZonal

	insert into TipoDespacho values(1,'Licitacion')
	insert into TipoDespacho values(2,'Corto Plazo')
	insert into TipoDespacho values(3,'Déficit')
	insert into TipoDespacho values(4,'Traspaso Excedentes')
	insert into TipoDespacho values(5,'Dx con contratos Holding')

	insert into decreto values(1,'283/2005','','','','','')
	insert into decreto values(2,'147/2006','','','','','')
	insert into decreto values(3,'130/2008','','','','','')
	insert into decreto values(4,'82/2010','','','','','')
	insert into decreto values(5,'85/2011','','','','','')
	insert into decreto values(6,'42/2012','','','','','')
	insert into decreto values(7,'107/2012','','','','','')
	insert into decreto values(8,'4T/2013','','','','','')
	insert into decreto values(9,'10T/2014','','','','','')

	insert into Licitacion values(1,'CGED 2006/01','')
	insert into Licitacion values(2,'CHL 2006/01','')
	insert into Licitacion values(3,'CHL 2006/02','')
	insert into Licitacion values(4,'CHL 2006/02-2','')
	insert into Licitacion values(5,'CHQ 2006/01','')
	insert into Licitacion values(6,'EMEL-SIC 2006/01','')
	insert into Licitacion values(7,'EMEL-SIC 2006/01 (Emelectric)','')
	insert into Licitacion values(8,'EMEL-SIC 2006/01 (Emetal)','')
	insert into Licitacion values(9,'EMEL-SIC 2006/01-2','')
	insert into Licitacion values(10,'EMEL-SIC 2006/01-2 (Emelectric)','')
	insert into Licitacion values(11,'EMEL-SIC 2006/01-2 (Emetal)','')
	insert into Licitacion values(12,'SAE 2006/01','')
	insert into Licitacion values(13,'SAE 2006/01 (Enelsa)','')
	insert into Licitacion values(14,'CGED 2008/01','')
	insert into Licitacion values(15,'CGED 2008/01-2','')
	insert into Licitacion values(16,'CHQ 2008/01','')
	insert into Licitacion values(17,'EMEL-SING 2008/01','')
	insert into Licitacion values(18,'EMEL-SING 2008/01 (Elecda)','')
	insert into Licitacion values(19,'CHL 2010/01','')
	insert into Licitacion values(20,'CHQ 2010/01','')
	insert into Licitacion values(21,'SIC 2013/01','')
	insert into Licitacion values(22,'SIC 2013/01 (Emelectric)','')
	insert into Licitacion values(23,'SIC 2013/01 (Emetal)','')
	insert into Licitacion values(24,'SIC 2013/01 (Enelsa)','')
	insert into Licitacion values(25,'SIC 2013/03','')
	insert into Licitacion values(26,'SIC 2013/03 (Emelectric)','')
	insert into Licitacion values(27,'SIC 2013/03 (Emetal)','')
	insert into Licitacion values(28,'SIC 2013/03 (Enelsa)','')
	insert into Licitacion values(29,'SIC 2013/03_2','')
	insert into Licitacion values(30,'SIC 2013/03_2 (Emelectric)','')
	insert into Licitacion values(31,'SIC 2013/03_2 (emetal)','')
	insert into Licitacion values(32,'SIC 2013/03_2 (Enelsa)','')
	insert into Licitacion values(33,'2015/01','')
	insert into Licitacion values(34,'2015/02','')
	insert into Licitacion values(35,'2015/02 (Elecda)','')
	insert into Licitacion values(0,'Sin Licitacion','')

insert into licitaciondx
select t1.id, L.IdLicitacion,t1.Licitacion,case	when t1.Distribuidora in('CGE Distribución','CGED','CGE DISTRIBUCION') then 18 
							when t1.Distribuidora in('Enel Distribución','CHILECTRA') then 10 
							when t1.Distribuidora in('ELECDA SING','ELECDA SIC') then 3
							when t1.Distribuidora in('TIL-TIL') then 13
							when t1.Distribuidora in('LUZANDES') then 15
							else D.IdDistribuidora end IdDistribuidora 
,t1.Distribuidora,t1.Observacion
from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.licitacion t1
left join licitacion L on L.Licitacion=t1.Licitacion
left join distribuidora D on D.NombreDistribuidora=t1.Distribuidora

insert into licitaciongx
select	t1.id, L.IdLicitacion,t1.Licitacion,LPNP.RExBases,Decr.IdDecreto,LPNP.DecPNudo,LGP.TipoDecreto,LPNP.Modalidad,LGI.MesReferencia
		,G.IdGeneradora,t1.Generadora,BN.IdBarraNacional,t1.PtoOferta,t1.TipoBloque,t1.BLOQUE,t1.PrecioEnergia
		,VC.VigenciaInicio,VC.VigenciaFin,concat(VC.Observacion,t1.Observacion) Observacion
from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.licitaciongx t1
left join licitacion L on L.Licitacion=t1.Licitacion
left join (select distinct licitacion,RExBases,DecPNudo,Modalidad from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.licitacion) LPNP on LPNP.Licitacion=t1.Licitacion
left join decreto Decr on Decr.Nombre=LPNP.DecPNudo
left join (select distinct licitacion,generadora,MesReferencia from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.LicitacionGxIndexacion) LGI on LGI.Licitacion=t1.Licitacion and LGI.Generadora=t1.Generadora
left join generadora G on G.NombreGeneradora=t1.Generadora
left join barranacional BN on t1.PtoOferta=BN.BarraNAcional
left join [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.VigenciaContrato VC on VC.Licitacion=t1.Licitacion and VC.gx=t1.Generadora and VC.Bloque=t1.BLOQUE
left join [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.LicitacionGxPotencia LGP on LGP.licitacion=t1.licitacion and LGP.Generadora=t1.Generadora

--Actualización de error de contratos de Pelumpen
update licitaciongx 
set VigenciaInicio='2019-01-01',Observacion='Se cambia vigenciaInicio, porque reemplaza IdLicitacionGx =129'
where IdLicitacionGx in (133,134)

update licitaciongx 
set VigenciaFin='2018-12-31',Observacion='Se cambia VigenciaFin, porque es reemplazado por IdLicitacionGx in (133,134)'
where IdLicitacionGx in (129)

GO
insert into codigocontrato
select	IDCodigoContrato,concat(t1.Licitacion,'_',Bloque,'_',TipoBloque,'_',t1.distribuidora,'_',t1.generadora) CodigoContrato
		,case when t1.Licitacion='0' then 0 else L.IdLicitacion end IdLicitacion
		,case	when t1.Distribuidora='CGE Distribucion' then 18 
				when t1.Distribuidora in('Enel Distribución') then 10 
				when t1.Distribuidora in('0') then 0
				else D.IdDistribuidora end IdDistribuidora 
		,case when t1.Generadora='0' then 0 else G.IdGeneradora end IdGeneradora
		,t1.Licitacion
		,TipoBloque,Bloque,t1.Distribuidora,t1.Generadora
		, case when IDCodigoContrato in (6,7,39,40,56,57,73,74,109,112,113,136,137,141,142,145,146,149,150,183,184,198,199,216,
											217,234,235,252,253,270,271,308,309,345,346,364,383,384,402,403,420,421,443,444,445,
											449,450,453,454,457,458,475,476,497,498,519,520,537,538,555,556)
		 then '20201127 Creado porque existe en Hoja Contratos' else '' end Observacion
from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.CodigoContrato t1
left join distribuidora D on t1.Distribuidora=D.NombreDistribuidora
left join generadora G on G.NombreGeneradora=t1.Generadora
left join licitacion L on L.Licitacion=t1.Licitacion

insert into demanda
select IdDemanda,Version,case	when t1.NombreDistribuidora in('CGE Distribución','CGED','CGE DISTRIBUCION') then 18 
							when t1.NombreDistribuidora in('Enel Distribución','CHILECTRA') then 10 
							when t1.NombreDistribuidora in('ELECDA SING','ELECDA SIC') then 3
							when t1.NombreDistribuidora in('TIL-TIL') then 13
							when t1.NombreDistribuidora in('LUZANDES') then 15
							else D.IdDistribuidora end IdDistribuidora 
		,t1.NombreDistribuidora,Mes,SZ.IdSistemaZonal,t1.SistemaZonal
		,case	when t1.PuntoRetiro='Central Tarapacá 13.8' then 243 
				when t1.PuntoRetiro='Casas Viejas 13.2' then 207 
				else PR.IdPuntoRetiro end IdPuntoRetiro
		,t1.PuntoRetiro,t1.Demanda_MWh,t1.Observación,'Proyeccion' TipoDemanda
from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.DEMANDA t1
left join distribuidora D on t1.NombreDistribuidora=d.NombreDistribuidora
left join sistemazonal SZ on SZ.SistemaZonal=t1.SistemaZonal
left join puntoretiro PR on PR.PuntoRetiro=t1.PuntoRetiro

insert into difxcompras
select IdData IdDifxCompras,Fecha,Version,case	when t1.Dx in('CGE Distribución','CGED','CGE DISTRIBUCION') then 18 
							when t1.Dx in('Enel Distribución','CHILECTRA') then 10 
							when t1.Dx in('ELECDA SING','ELECDA SIC') then 3
							when t1.Dx in('TIL-TIL') then 13
							when t1.Dx in('LUZANDES') then 15
							else D.IdDistribuidora end IdDistribuidora 
		,t1.dx Distribuidora,G.IdGeneradora,t1.Gx Generadora,SZ.IdSistemaZonal,t1.SistemaZonal
		,CC.IdCodigoContrato,t1.CodigoContrato,t1.Fisico_Pto_Retiro,t1.Valorizado_Pto_Retiro
		,t1.Fisico_Pto_Compra,t1.Valorizado_Pto_Compra,t1.Diferencia_Mensual,t1.Observacion
from (	select max(IdData) IdData,Fecha,Version,Dx,Gx,SistemaZonal,CodigoContrato,sum(Fisico_Pto_Retiro) Fisico_Pto_Retiro
		,sum(Valorizado_Pto_Retiro) Valorizado_Pto_Retiro,sum(Fisico_Pto_Compra) Fisico_Pto_Compra
		,sum(Valorizado_Pto_Compra) Valorizado_Pto_Compra,sum(Diferencia_Mensual) Diferencia_Mensual,'' Observacion
		,REPLACE(CodigoContrato,'CGE Distribución','CGE Distribucion') CodigoContrato2
		from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.CEN_DifCompras
		group by Fecha,Version,Dx,Gx,SistemaZonal,CodigoContrato) t1
left join distribuidora D on t1.Dx=d.NombreDistribuidora
left join generadora G on G.NombreGeneradora=t1.Gx
left join sistemazonal SZ on SZ.SistemaZonal=t1.SistemaZonal
left join codigocontrato CC on CC.CodigoContrato=t1.CodigoContrato2

insert into [dbo].[eadjanual]
select	id,IdCodigoContrato
		,case when t1.PtoCompra='Ciruelos 220' then 1
		when t1.PtoCompra=' Valdivia 220 ' then 17
		when t1.PtoCompra=' Quillota 220 ' then 11
		when t1.PtoCompra=' Alto Jahuel 220 ' then 8
		when t1.PtoCompra=' Cerro Navia 220 ' then 18
		when t1.PtoCompra=' Chena 220 ' then 32
		when t1.PtoCompra=' Polpaico 220 ' then 28
		when t1.PtoCompra in('Barro Blanco 220 / Rahue 220',' Barro Blanco 220 / Rahue 220 ') then 15
		when t1.PtoCompra=' Puerto Montt 220 ' then 36
		when t1.PtoCompra=' Charrua 220 ' then 34
		when t1.PtoCompra='0' then 0
		when t1.PtoCompra=' Itahue 220 ' then 23
		else BN.IdBarraNacional end IdPtoCompra
		,t1.PtoCompra,t1.Ano,EnergiaAnual,t1.Observacion
from [GTD-NOT019\SQLEXPRESS].pnp_1.[dbo].[eadjanual] t1
left join barranacional BN on t1.PtoCompra=BN.BarraNAcional

insert into [dbo].[eadjanualdistrmensual]
select	id,IdCodigoContrato
		,BN.IdBarraNacional 
		,t1.PtoCompra,t1.fecha,EnergiaMensual,t1.Observacion
from [GTD-NOT019\SQLEXPRESS].pnp_1.[dbo].[eadjanualdistrmensual] t1
left join barranacional BN on t1.PtoCompra=BN.BarraNAcional

insert into VersionEfact(descripcion)
select distinct version from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.CEN_Efact

IF OBJECT_ID('tempefact', 'U') IS NOT NULL DROP TABLE tempefact
IF OBJECT_ID('tempefactV0', 'U') IS NOT NULL DROP TABLE tempefactV0
GO

select  t1.idcen,VE.IdVersion,t1.fecha
		,case	when t1.Dx in('CGE Distribución','CGED') then 18 
				when t1.Dx in('Enel Distribución','CHILECTRA') then 10 
				when t1.Dx in('ELECDA SING','ELECDA SIC') then 3
				when t1.Dx in('LUZANDES') then 15
				else D.IdDistribuidora end IdDistribuidora 
		,case when t1.Gx in ('(en blanco)','0') then 0 else G.IdGeneradora end IdGeneradora
		,case	when t1.CodigoContrato IN ('Contrato Corto Plazo_Coelcha_ENDESA','Contrato Corto Plazo_Frontel_ENDESA','Contrato Corto Plazo_COOPERSOL_E-CL') then 0 
				when t1.CodigoContrato IN ('DÉFICIT_Coopelan') then 0 
				ELSE CC.IdCodigoContrato END IdCodigoContrato
		,PR.IdPuntoRetiro
		,t1.Dx
		,t1.Gx
		,t1.CodigoContrato,t1.PuntoRetiro,0 TipoDespacho,t1.Energia,t1.Potencia
		,'' Observacion
into tempefactV0
from (select *,REPLACE(CodigoContrato,'CGE Distribución','CGE Distribucion') CodigoContrato2 from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.CEN_Efact ) t1
left join distribuidora D on t1.Dx=D.NombreDistribuidora
left join generadora G on G.NombreGeneradora=t1.Gx
left join codigocontrato CC on CC.CodigoContrato=t1.CodigoContrato2
left join puntoretiro PR on PR.PuntoRetiro=t1.PuntoRetiro
left join versionefact VE on VE.Descripcion=t1.[Version]
where t1.dx!='(en blanco)' and Ve.Descripcion !='V4'
	--se separa la V4 porque está muy sucia
IF OBJECT_ID('tempefactV4', 'U') IS NOT NULL DROP TABLE tempefactV4
select t1.idcen+(month(t1.fecha)*year(t1.fecha))*10000 IdCen
,VE.IdVersion,t1.fecha
		,case	when t1.Dx in('CGE Distribución','CGED') then 18 
				when t1.Dx in('Enel Distribución','CHILECTRA') then 10 
				when t1.Dx in('ELECDA SING','ELECDA SIC') then 3
				when t1.Dx in('LUZANDES') then 15
				else D.IdDistribuidora end IdDistribuidora 
		,case when t1.Gx in ('(en blanco)','0') then 0 else G.IdGeneradora end IdGeneradora
		,case	when t1.CodigoContrato IN ('Contrato Corto Plazo_Coelcha_ENDESA','Contrato Corto Plazo_Frontel_ENDESA','Contrato Corto Plazo_COOPERSOL_E-CL') then 0 
				when t1.CodigoContrato IN ('DÉFICIT_Coopelan') then 0 
				ELSE CC.IdCodigoContrato END IdCodigoContrato
		,PR.IdPuntoRetiro
		,t1.Dx
		,t1.Gx
		,t1.CodigoContrato,t1.PuntoRetiro,0 TipoDespacho,t1.Energia,t1.Potencia
		,'' Observacion
into tempefactV4
from (select *,REPLACE(CodigoContrato,'CGE Distribución','CGE Distribucion') CodigoContrato2 from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.CEN_Efact ) t1
left join distribuidora D on t1.Dx=D.NombreDistribuidora
left join generadora G on G.NombreGeneradora=t1.Gx
left join codigocontrato CC on CC.CodigoContrato=t1.CodigoContrato2
left join puntoretiro PR on PR.PuntoRetiro=t1.PuntoRetiro
left join versionefact VE on VE.Descripcion=t1.[Version]
where t1.dx!='(en blanco)' and Ve.Descripcion='V4'

select max(IdCen) IdCen,IdVersion,fecha,IdDistribuidora,IdGeneradora,IdCodigoContrato,IdPuntoRetiro,Dx,Gx,CodigoContrato,PuntoRetiro,TipoDespacho,sum(Energia) Energia,sum(Potencia) Potencia,Observacion
into tempefact
from tempefactV0
group by IdVersion,fecha,IdDistribuidora,IdGeneradora,IdCodigoContrato,IdPuntoRetiro,Dx,Gx,CodigoContrato,PuntoRetiro,TipoDespacho,Observacion

insert into tempefact
select max(IdCen),IdVersion,fecha,IdDistribuidora,IdGeneradora,IdCodigoContrato,IdPuntoRetiro,Dx,Gx,CodigoContrato,PuntoRetiro,TipoDespacho,sum(Energia),sum(Potencia), Observacion
from tempefactV4
group by IdVersion,fecha,IdDistribuidora,IdGeneradora,IdCodigoContrato,IdPuntoRetiro,Dx,Gx,CodigoContrato,PuntoRetiro,TipoDespacho,Observacion

update tempefact set TipoDespacho=2 where CodigoContrato IN ('Contrato Corto Plazo_Coelcha_ENDESA','Contrato Corto Plazo_Frontel_ENDESA','Contrato Corto Plazo_COOPERSOL_E-CL') 
update tempefact set TipoDespacho=3 where CodigoContrato IN ('DÉFICIT_Coopelan')
update tempefact set TipoDespacho=4 where IdDistribuidora=45--para Mataquito se asocia Despacho mediante traspaso de excedentes
update tempefact set TipoDespacho=5 where IdDistribuidora in (12,13,15) --para filiales Enel se utilizan contratos del holding
update tempefact set TipoDespacho=1 where idCodigoContrato <>0 and IdDistribuidora not in (45,12,13,15)
GO

UPDATE tempefact SET IdPuntoRetiro=381 where codigocontrato='SIC 2013/03_2_BS2B_BB_Copelec_Pelumpén S.A.' and fecha='2020-10-01' and idversion=10 AND puntoretiro='(en blanco)'

insert into efact select * from tempefact
drop table tempefact
drop table tempefactV4
drop table tempefactV0
GO

insert into [dbo].[factormodulacion]
select	D.iddecreto,Tipo
		,case when t1.BarraNacional='CONCEPCION 220'  then 39
		when t1.BarraNacional='Colbún 220'  then 10
		else BN.IdBarraNacional end IdBarraNacional 
		,t1.BarraNacional,t1.Valor,t1.Observacion
from [GTD-NOT019\SQLEXPRESS].pnp_1.[dbo].[factormodulacion] t1
left join decreto D on t1.DecPNudo=D.Nombre
left join barranacional BN on BN.BarraNAcional=t1.BarraNacional

insert into [dbo].[factorreferenciacion]
select	t1.FechaInicio,t1.FechaFin,PR.IdPuntoRetiro,t1.PuntoRetiro,BN.IdBarraNacional,t1.BarraNacional,t1.Periodo,t1.Factor,'' Observacion
from [GTD-NOT019\SQLEXPRESS].pnp_1.[dbo].FactoresFR t1
left join puntoretiro PR on PR.PuntoRetiro=t1.PuntoRetiro
left join barranacional BN on BN.BarraNAcional=t1.BarraNacional

insert into perdidazonal
select	t1.fecha,t1.Version
		,case when t1.Sistema='STX A' then 1
		when t1.Sistema='STX B' then 2
		when t1.Sistema='STX C' then 3
		when t1.Sistema='STX D' then 4
		when t1.Sistema='STX E' then 5
		when t1.Sistema='STX F' then 6
		else SZ.IdSistemaZonal end IdSistemaZonal
		,t1.Sistema,t1.TipoFactor,t1.Factor,'' Observacion
from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.perdidazonal t1
left join sistemazonal SZ on SZ.SistemaZonal=t1.Sistema

insert into tipocombustible
select *,'' from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.tipocombustible

insert into [dbo].[indexacioncombustible]
select * from [GTD-NOT019\SQLEXPRESS].pnp_1.[dbo].[indexacioncombustible]

insert into [dbo].[indexacioncpi]
select * from [GTD-NOT019\SQLEXPRESS].pnp_1.[dbo].[indexacioncpi]

insert into [dbo].[indexaciondolar]
select * from [GTD-NOT019\SQLEXPRESS].pnp_1.[dbo].[indexaciondolar]

insert into [dbo].[indexacionipc]
select * from [GTD-NOT019\SQLEXPRESS].pnp_1.[dbo].[indexacionipc]

insert into [dbo].[indexadorescontratos]
select * from [GTD-NOT019\SQLEXPRESS].pnp_1.[dbo].[indexadorescontratos]

insert into cet
select LD.idlicitacionDx,t.Licitacion,t.Distribuidora,t.IdGeneradora,t.Generadora,t.cet,t.ValorCET0,t.[Index],t.MesReferencia,t.Rezago,t.Observacion
from (
select	L.idlicitacion,t1.Licitacion,case	when t1.Distribuidora='CGE Distribución' then 18 
							when t1.Distribuidora in('Enel Distribución','CHILECTRA') then 10 
							when t1.Distribuidora in('ELECDA SING','ELECDA SIC') then 3
							else D.IdDistribuidora end IdDistribuidora 
		,t1.Distribuidora
		,case when t1.Generadora='AELA GENERACIÓN' then 3 else G.IdGeneradora end IdGeneradora 
		,t1.Generadora,t1.CET,t1.ValorCET0,t1.[Index],t1.MesReferencia,t1.Rezago,'' Observacion
from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.cet t1
left join distribuidora D on t1.Distribuidora=D.NombreDistribuidora
left join generadora G on t1.Generadora=G.NombreGeneradora
left join licitacion L on L.Licitacion=t1.Licitacion
where t1.Licitacion !='Contrato Corto Plazo'
)t
left join licitaciondx LD on LD.idlicitacion=t.IdLicitacion and LD.iddistribuidora=t.IdDistribuidora

insert into [dbo].[licitaciongxindexacion]
select t1.IdLicitacionGx,t2.TipoIndex,t2.[Index],t2.Rezago,t2.ValorPondera,t2.Observacion
from licitaciongx t1
left join [GTD-NOT019\SQLEXPRESS].pnp_1.[dbo].[licitaciongxindexacion] t2 on t2.Generadora=t1.Generadora and t2.Licitacion=t1.Licitacion 

insert into [dbo].[licitaciongxindexesp]
select * from [GTD-NOT019\SQLEXPRESS].pnp_1.[dbo].[licitaciongxindexesp]

IF OBJECT_ID('LGDC', 'U') IS NOT NULL DROP TABLE t
--drop table if exists LGDC
select	t1.*,case	when t1.Distribuidora='CGE Distribución' then 18 
					when t1.Distribuidora in('Enel Distribución','CHILECTRA') then 10 
					when t1.Distribuidora in('ELECDA SING','ELECDA SIC') then 3
					else D.IdDistribuidora end IdDistribuidora 
		,G.IdGeneradora,L.IdLicitacion
		,BN.IdBarraNacional
into LGDC
from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.LicitacionGxPtoCompraDx t1
left join distribuidora D on t1.Distribuidora=D.NombreDistribuidora
left join generadora G on t1.Generadora=G.NombreGeneradora
left join licitacion L on L.Licitacion=t1.Licitacion
left join barranacional BN on BN.BarraNAcional=t1.PtoCompra

insert into [dbo].[LicitacionGxDxPtoCompra]
select LD.idlicitacionDx,LG.IdLicitacionGx,IdBarraNacional,PtoCompra,t1.Observacion from LGDC t1
left join licitaciondx LD on LD.idlicitacion=t1.IdLicitacion and LD.iddistribuidora=t1.IdDistribuidora
left join licitaciongx LG on LG.IdLicitacion=t1.IdLicitacion and LG.IdGeneradora=t1.IdGeneradora and LG.Bloque=t1.Bloque and LG.TipoBloque=t1.TipoBloque

drop table LGDC

insert into [dbo].[precionudolicitacion]
select D.IdDecreto,t1.DecPNudo,t1.Tipo,t1.Unidad,t1.TipoDecreto,t1.Precio,t1.Observacion
from [GTD-NOT019\SQLEXPRESS].pnp_1.[dbo].[precionudolicitacion] t1
left join decreto D on t1.DecPNudo=D.Nombre

insert into pncp
select	Mes_PNCP,VersionPNCP,
		case when t1.Nudo='CAUTÍN' then 14
		when t1.Nudo='CHILOÉ' then 24
		when t1.Nudo='ESPERANZA SING 220' then 58
		when t1.Nudo='LOS MAQUIS' then 31
		when t1.Nudo='MAIPO' then 9
		when t1.Nudo='MELIPULLI' then 6
		when t1.Nudo='PUNTA COLORADA   220' then 65
		when t1.Nudo='CHUQUICAMATA 220' then 73
		when t1.Nudo='EL COBRE 220' then 74
		when t1.Nudo in ('EL LLANO', 'EL LLANO 220') then 75
		when t1.Nudo='NUEVA VICTORIA 220' then 76
		when t1.Nudo in ('OHIGGINS 220','O''HIGGINS 220') then 77		
		else t2.IdBarraNacional end IdNudo
		,t1.nudo,PrecioNudoEnergiaPeso,PrecioNudoPotenciaPeso,t1.FME,t1.FMP,t1.Observacion
from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.PNCP t1
left join barranacional t2 on t1.nudo=t2.BarraNAcional

insert into pncp values('2000-01-01','',0,'',0,0,0,0,'Registro para datos nulo')

IF OBJECT_ID('temppnp', 'U') IS NOT NULL DROP TABLE temppnp
GO
select	idpnp,versionpnp,fecha,[version]
		,case	when distribuidora in ('CGE Distribución','CGE DISTRIBUCIÓN') then concat(Licitacion,'_',bloque,'_',tipobloque,'_','CGE Distribucion','_', generadora)
				when distribuidora in ('MATAQUITO') then concat(Licitacion,'_',bloque,'_',tipobloque,'_','COELCHA','_', generadora)
				else concat(Licitacion,'_',bloque,'_',tipobloque,'_',distribuidora,'_', generadora) end CodigoContrato
		,Licitacion,tipobloque,bloque,distribuidora,generadora,t2.IdBarraNacional,ptocompra
		,pe,pp		
		,t1.observacion
into temppnp
from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.pnp t1
left join barranacional t2 on t1.ptocompra=t2.BarraNAcional

insert into PNP
select	idpnp,versionpnp,fecha,version,t2.idcodigocontrato,t1.Licitacion,t1.tipobloque,t1.bloque,t1.distribuidora
		,t1.generadora,t1.IdBarraNacional,t1.ptocompra,t1.pe,t1.pp,t1.observacion
from temppnp t1
left join codigocontrato t2 on t1.CodigoContrato=t2.CodigoContrato
where t1.CodigoContrato not in ('EMEL-SIC 2006/01_BB1_BB_CGE Distribucion_ENDESA','EMEL-SIC 2006/01-2_BB_Sur_BB_CGE Distribucion_AES GENER','SIC 2013/03_2 (Enelsa)_BS4_BB_CGE Distribucion_Abengoa','SIC 2013/03_2 (Enelsa)_BS4_BB_CGE Distribucion_Norvind','SIC 2013/03_2 (Enelsa)_BS4_BB_CGE Distribucion_El Campesino')
and t1.distribuidora !='MATAQUITO'
and not (versionPNP='2001V1' and fecha in('2018-07-01','2018-09-01','2018-10-01','2018-11-01','2018-12-01') and version in('ITD','Mes') and IdCodigoContrato in(708,734,760))

insert into PNP
select	max(idpnp) idpnp,versionpnp,fecha,version,t2.idcodigocontrato,t1.Licitacion,t1.tipobloque,t1.bloque,t1.distribuidora
		,t1.generadora,t1.IdBarraNacional,t1.ptocompra,t1.pe,t1.pp,t1.observacion
from temppnp t1
left join codigocontrato t2 on t1.CodigoContrato=t2.CodigoContrato
where (versionPNP='2001V1' and fecha in('2018-07-01','2018-09-01','2018-10-01','2018-11-01','2018-12-01') and version in('ITD','Mes') and IdCodigoContrato in(708,734,760))
group by versionpnp,fecha,version,t2.idcodigocontrato,t1.Licitacion,t1.tipobloque,t1.bloque,t1.distribuidora
		,t1.generadora,t1.IdBarraNacional,t1.ptocompra,t1.pe,t1.pp,t1.observacion

INSERT INTO pnp VALUES (0,'','2000-01-01','',0,'','','',0,0,0,'',0,0,'')

drop table temppnp
insert into versionrec
select distinct idversion,concat(valorfecha,' ',descripcion)
from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.version where registro='FECHAEFACT'


insert into [dbo].[versionrecdetalle]
select * from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.version

--Se agregan estos registros para identificación única de antecedentes de CMg utilizados para iddespacho=4
insert into versionrecdetalle
select  IdVersion,'VersionCMG', ValorTexto,ValorFecha,ValorInt,ValorFloat,Descripcion
from versionrecdetalle where Registro='VersionPNP' and
IdVersion in (
select IdVersion from versionrecdetalle where registro='tipopnp' and valortexto='Mes'
and IdVersion in (select IdVersion from versionrecdetalle where registro='FECHAEFACT' and ValorFecha>='2020-04-01')
)  
and ValorTexto in ('2007ProyV1','2101V3','FPEC_2010V1')

IF OBJECT_ID('tempRecD', 'U') IS NOT NULL DROP TABLE tempRecD
GO
select t1.idversion,t1.idcen,VE.idversion IdVersionEfact,t1.fechaEfact
		,case	when t1.Dx in('CGE Distribución','CGED') then 18 
				when t1.Dx in('Enel Distribución','CHILECTRA') then 10 
				when t1.Dx in('ELECDA SING','ELECDA SIC') then 3
				when t1.Dx in('LUZANDES') then 15
				else D.IdDistribuidora end IdDistribuidora 
		,case when G.idgeneradora is null then 0 else G.idgeneradora end idgeneradora
		,case	when t1.CodigoContrato IN ('Contrato Corto Plazo_Coelcha_ENDESA','Contrato Corto Plazo_Frontel_ENDESA','Contrato Corto Plazo_COOPERSOL_E-CL') then 0 
				when t1.CodigoContrato IN ('DÉFICIT_Coopelan') then 0 
				ELSE CC.IdCodigoContrato END IdCodigoContrato
		,t1.CodigoContrato2 CodigoContrato
		,PR.IdPuntoRetiro,t1.energia,t1.potencia
		,0 IdTipoDespacho
		,t1.FechaFP FechaPZ,t1.VersionFP VersionPZ
		,case	when t1.SistemaZonal='STX A' then 1
				when t1.SistemaZonal='STX B' then 2
				when t1.SistemaZonal='STX C' then 3
				when t1.SistemaZonal='STX D' then 4
				when t1.SistemaZonal='STX E' then 5
				when t1.SistemaZonal='STX F' then 6
				else pz.IdSistemaZonal end IdSistemaZonal
		,t1.FEPE,t1.FEPP
		,fr.IdBarraNacional IdBarraNacionalFR,fr.Periodo PeriodoFR,t1.FactorFR
		,t1.versionPNP PNP_VersionIndex,t1.FechaPNP PNP_MesIndexacion,t1.TipoPNP PNP_Version,Pe PNELP,PP PNPLP
		,t1.mes_pncp PNCP_Mes,PNCP.Version PNCP_Version,case when t1.mes_pncp is null then 0 else fr.IdBarraNacional end PNCP_IdNudo
		,t1.CETDolar CETCP,t1.PrecioNudoEnergiaDolar PNECP_USD,t1.PrecioNudoPotenciaDolar PNPCP_USD
		,t1.EnergiaPC EPC,t1.PotenciaPC PPC,t1.EnergiaRecDolar ERec_USD,t1.PotenciaRecDolar PRec_USD,t1.Dolar,t1.EnergiaRecPeso ERec_Peso,t1.PotenciaRecPeso PRec_Peso
into tempRecD
from (	select *,REPLACE(CodigoContrato,'CGE Distribución','CGE Distribucion') CodigoContrato2 from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.recaudaciondetalle) t1
left join versionEfact VE on VE.Descripcion=t1.VersionEfact
left join distribuidora D on D.NombreDistribuidora=t1.DX
left join generadora G on G.NombreGeneradora=t1.Gx
left join codigocontrato CC on CC.CodigoContrato=t1.CodigoContrato2
left join puntoretiro PR on PR.PuntoRetiro=t1.PuntoRetiro
left join perdidazonal PZ on PZ.fecha=t1.FechaFP and PZ.SistemaZonal=t1.sistemazonal and pz.Version=t1.VersionFP and PZ.TipoFactor='FEPE'
left join factorreferenciacion FR on FR.Periodo=t1.PeriodoFR and fr.BarraNacional=t1.BarraNacional and FR.PuntoRetiro=t1.puntoretiro
left join (select distinct mes,version from PNCP) PNCP on PNCP.mes=t1.mes_pncp

update tempRecD set IdTipoDespacho=2 where CodigoContrato IN ('Contrato Corto Plazo_Coelcha_ENDESA','Contrato Corto Plazo_Frontel_ENDESA','Contrato Corto Plazo_COOPERSOL_E-CL') 
update tempRecD set IdTipoDespacho=3 where CodigoContrato IN ('DÉFICIT_Coopelan')
update tempRecD set IdTipoDespacho=4 where IdDistribuidora=45--para Mataquito se asocia Despacho mediante traspaso de excedentes
update tempRecD set IdTipoDespacho=5 where IdDistribuidora in (12,13,15) --para filiales Enel se utilizan contratos del holding
update tempRecD set IdTipoDespacho=1 where idCodigoContrato <>0 and IdDistribuidora not in (45,12,13,15)

update tempRecD set PNP_VersionIndex='',PNP_MesIndexacion='2000-01-01',PNP_Version='' WHERE PNP_VersionIndex IS NULL
update tempRecD set PNCP_Mes='2000-01-01',PNCP_Version='',PNP_Version='' WHERE PNCP_Mes IS NULL

DELETE FROM tempRecD WHERE IDPUNTORETIRO IS NULL AND IDVERSION IN (119,120)

insert into recaudaciondetalle
select	idversion,max(idcen),IdVersionEfact,fechaEfact,IdDistribuidora,idgeneradora,IdCodigoContrato,IdPuntoRetiro,IdTipoDespacho,sum(energia),sum(potencia)
		,IdSistemaZonal,FechaPZ,VersionPZ,FEPE,FEPP,IdBarraNacionalFR,PeriodoFR,FactorFR,PNP_VersionIndex
		,PNP_MesIndexacion,PNP_Version,PNELP,PNPLP,PNCP_Mes,PNCP_Version,PNCP_IdNudo,CETCP,PNECP_USD,PNPCP_USD
		,sum(EPC),sum(PPC),sum(ERec_USD),sum(PRec_USD),Dolar,sum(ERec_Peso),sum(PRec_Peso)
from tempRecD
where idversion!=0
group by idversion,IdVersionEfact,fechaEfact,IdDistribuidora,idgeneradora,IdCodigoContrato,IdPuntoRetiro
		,IdTipoDespacho,FechaPZ,VersionPZ,IdSistemaZonal,FEPE,FEPP,IdBarraNacionalFR,PeriodoFR,FactorFR,PNP_VersionIndex
		,PNP_MesIndexacion,PNP_Version,PNELP,PNPLP,PNCP_Mes,PNCP_Version,PNCP_IdNudo,CETCP,PNECP_USD,PNPCP_USD
		,Dolar

drop table tempRecD

insert into [dbo].[versionestabilizacion]
select * from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.[versionestabilizacion] where idversionest is not null

select	IdVersionEstabilizacion,idcen IdEfact,IdVersionNoEst IdVersionConstratosDefinitiva,idversionEst IdVersionContratosPNP
		,case	when t1.Dx in('CGE Distribución','CGED') then 18 
				when t1.Dx in('Enel Distribución','CHILECTRA') then 10 
				when t1.Dx in('ELECDA SING','ELECDA SIC') then 3
				when t1.Dx in('LUZANDES') then 15
				else D.IdDistribuidora end IdDistribuidora
		,case when G.idgeneradora is null then 0 else G.idgeneradora end idgeneradora
		,case	when t1.CodigoContrato IN ('Contrato Corto Plazo_Coelcha_ENDESA','Contrato Corto Plazo_Frontel_ENDESA','Contrato Corto Plazo_COOPERSOL_E-CL') then 0 
				when t1.CodigoContrato IN ('DÉFICIT_Coopelan') then 0 
				ELSE CC.IdCodigoContrato END IdCodigoContrato
		,t1.CodigoContrato2 CodigoContrato
		,PR.IdPuntoRetiro,t1.energia,t1.potencia,0 IdTipoDespacho
		,fechaefact		Fechaefact_ContrDef		,VersionEfact VersionEfact_ContrDef		,FechaPNP FechaPNP_ContrDef		,VersionPNP VersionPNP_ContrDef,EnergiaPC EPC_ContrDef	,PotenciaPC PPC_ContrDef		,EnergiaRecPeso ERec_Peso_ContrDef	,PotenciaRecPeso PRec_Peso_ContrDef
		,fechaefactEst	Fechaefact_ContrPNP		,VersionEfactEst VersionEfact_ContrPNP	,FechaPNPEst FechaPNP_ContrPNP	,VersionPNP VersionPNP_ContrPNP,EnergiaPCEst EPC_ContrPNP	,PotenciaPCEst PPC_ContrPNP	,EnergiaRecPesoEst ERec_Peso_ContrPNP,PotenciaRecPesoEst PRec_Peso_ContrPNP
		,VariacionIPC,Interes,FactorAjusteE,FactorAjusteP,DolarEstabilizacion DolarDefinitivoPromedioMes
		,DifEnergiaRecPeso DifERec_Peso				,DifPotenciaRecPeso DifPRec_Peso
		,DifEnergiaRecPesoEst DifERec_Peso_Estabilizado	,DifPotenciaRecPesoEst DifPRec_Peso_Estabilizado
		,DifEnergiaRecDolarEst DifERec_Dolar_Estabilizado,DifPotenciaRecDolarEst DifPRec_Dolar_Estabilizado
into EstDTemp
from (select *,REPLACE(CodigoContrato,'CGE Distribución','CGE Distribucion') CodigoContrato2 from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.Resultado_Estabilizacion) t1
left join distribuidora D on D.NombreDistribuidora=t1.DX
left join generadora G on G.NombreGeneradora=t1.Gx
left join codigocontrato CC on CC.CodigoContrato=t1.CodigoContrato2
left join puntoretiro PR on PR.PuntoRetiro=t1.PuntoRetiro

update EstDTemp set IdTipoDespacho=2 where CodigoContrato IN ('Contrato Corto Plazo_Coelcha_ENDESA','Contrato Corto Plazo_Frontel_ENDESA','Contrato Corto Plazo_COOPERSOL_E-CL') 
update EstDTemp set IdTipoDespacho=3 where CodigoContrato IN ('DÉFICIT_Coopelan')
update EstDTemp set IdTipoDespacho=4 where IdDistribuidora=45--para Mataquito se asocia Despacho mediante traspaso de excedentes
update EstDTemp set IdTipoDespacho=5 where IdDistribuidora in (12,13,15) --para filiales Enel se utilizan contratos del holding
update EstDTemp set IdTipoDespacho=1 where idCodigoContrato <>0 and IdDistribuidora not in (45,12,13,15)

insert into EstabilizacionDetalle
select	IdVersionEstabilizacion,IdEfact,IdVersionConstratosDefinitiva,IdVersionContratosPNP,IdDistribuidora,idgeneradora	
		IdCodigoContrato,IdPuntoRetiro,energia,potencia,IdTipoDespacho,Fechaefact_ContrDef,VersionEfact_ContrDef
		,FechaPNP_ContrDef,VersionPNP_ContrDef,EPC_ContrDef,PPC_ContrDef,ERec_Peso_ContrDef,PRec_Peso_ContrDef,Fechaefact_ContrPNP
		,VersionEfact_ContrPNP,FechaPNP_ContrPNP,VersionPNP_ContrPNP,EPC_ContrPNP,PPC_ContrPNP,ERec_Peso_ContrPNP,PRec_Peso_ContrPNP
		,VariacionIPC,Interes,FactorAjusteE,FactorAjusteP,DolarDefinitivoPromedioMes,DifERec_Peso,DifPRec_Peso
		,DifERec_Peso_Estabilizado,DifPRec_Peso_Estabilizado,DifERec_Dolar_Estabilizado,DifPRec_Dolar_Estabilizado
from EstDTemp

drop table EstDTemp

insert into PtoRetiroSistema
select distinct * from (
select case	when t1.PuntoRetiro='Abanico 13.8' then 30
				when t1.PuntoRetiro='Casas Viejas 13.2' then 207
				when t1.PuntoRetiro='Castilla 13.8' then 304
				when t1.PuntoRetiro='Centro 13.8' then 228
				when t1.PuntoRetiro='Deuco 13.2' then 41
				when t1.PuntoRetiro='Dolores 13.8' then 246
				when t1.PuntoRetiro='El Avellano 015' then 29
				when t1.PuntoRetiro='El Espino 023' then 209
				when t1.PuntoRetiro='El Peñon 023' then 210
				when t1.PuntoRetiro='Isla De Maipo 023' then 135
				when t1.PuntoRetiro='La Palma 015' then 88
				when t1.PuntoRetiro='Malloco 023' then 137
				when t1.PuntoRetiro='Mariscal 023' then 138
				when t1.PuntoRetiro='Panguipulli 024' then 360
				when t1.PuntoRetiro='Paso Hondo 012' then 338
				--when t1.PuntoRetiro='Pirque 015' then 110 Se comenta porque genera error de duplicidad de llave
				when t1.PuntoRetiro='Polpaico ENEL DISTRIBUCIÓN 023' then 290
				when t1.PuntoRetiro='Pozo Almonte 023' then 248
				when t1.PuntoRetiro='Puerto Varas 024' then 10
				when t1.PuntoRetiro='Tocopilla 023' then 235
				when t1.PuntoRetiro='Tome 015' then 128
				else t2.IdPuntoRetiro end IdPuntoRetiro
		,case	when t1.sistemazonal='STX A' then 1
				when t1.sistemazonal='STX B' then 2
				when t1.sistemazonal='STX c' then 3
				when t1.sistemazonal='STX D' then 4
				when t1.sistemazonal='STX E' then 5
				when t1.sistemazonal='STX F' then 6
				else IdSistemaZonal end IdSistemaZonal	
		,ano		
from [GTD-NOT019\SQLEXPRESS].pnp_1.[dbo].[PtoRetiroSistema] t1
left join puntoretiro  t2 on t1.puntoretiro=t2.PuntoRetiro
left join sistemazonal t3 on t1.sistemazonal=t3.SistemaZonal
where t1.puntoretiro not in ('Los Molles 13.2','Maitenes 012','Paposo 13.2','Salado 023')
) t

insert into CETCP
select	fechapnp,versionpnp,tipopnp
		,case	when codigocontrato='Contrato Corto Plazo_Coelcha_ENDESA' then 34
				when codigocontrato='Contrato Corto Plazo_Frontel_ENDESA' then 22
				end IdDistribuidora
		,case	when codigocontrato='Contrato Corto Plazo_Coelcha_ENDESA' then 14
				when codigocontrato='Contrato Corto Plazo_Frontel_ENDESA' then 14
				end IdGeneradora
		,cet
from [GTD-NOT019\SQLEXPRESS].pnp_1.[dbo].CETPNCP

insert into cetcp values ('2000-01-01',0,0,20,10,0)
insert into cetcp values ('2000-01-01',0,0,22,14,0)
insert into cetcp values ('2000-01-01',0,0,34,14,0)

insert into cetcp values ('2018-09-01','2001V1','Mes',	34,	14,	0)
insert into cetcp values ('2018-09-01','2001V1','Mes',	22,	14,	0)
insert into cetcp values ('2018-10-01','2001V1','Mes',	34,	14,	0)
insert into cetcp values ('2018-10-01','2001V1','Mes',	22,	14,	0)
insert into cetcp values ('2018-11-01','2001V1','Mes',	34,	14,	0)
insert into cetcp values ('2018-11-01','2001V1','Mes',	22,	14,	0)
insert into cetcp values ('2018-12-01','2001V1','Mes',	34,	14,	0)
insert into cetcp values ('2018-12-01','2001V1','Mes',	22,	14,	0)
insert into cetcp values ('2018-11-01','2001V1','Mes',	20,	10,	0)
insert into cetcp values ('2018-12-01','2001V1','Mes',	20,	10,	0)
insert into cetcp values ('2019-01-01','2001V1','Mes',	20,	10,	0)
insert into cetcp values ('2019-02-01','2001V1','Mes',	20,	10,	0)
insert into cetcp values ('2019-03-01','2001V1','Mes',	20,	10,	0)
insert into cetcp values ('2019-04-01','2001V1','Mes',	20,	10,	0)
insert into cetcp values ('2019-05-01','2001V1','Mes',	20,	10,	0)
insert into cetcp values ('2019-06-01','2001V1','Mes',	20,	10,	0)
insert into cetcp values ('2019-07-01','2001V1','Mes',	20,	10,	0)
insert into cetcp values ('2019-08-01','2001V1','Mes',	20,	10,	0)
insert into cetcp values ('2019-09-01','2001V1','Mes',	20,	10,	0)
insert into cetcp values ('2019-10-01','2001V1','Mes',	20,	10,	0)
insert into cetcp values ('2019-11-01','2001V1','Mes',	20,	10,	0)
insert into cetcp values ('2019-12-01','2001V1','Mes',	20,	10,	0)
insert into cetcp values ('2018-09-01','2001V1','Mes',	20,	10,	0)
insert into cetcp values ('2018-10-01','2001V1','Mes',	20,	10,	0)
insert into cetcp values ('2020-01-01','2007V1','Mes',	20,	10,	0)
insert into cetcp values ('2020-02-01','2007V1','Mes',	20,	10,	0)
insert into cetcp values ('2020-03-01','2007V1','Mes',	20,	10,	0)
insert into cetcp values ('2020-04-01','2007V1','Mes',	20,	10,	0)
insert into cetcp values ('2020-05-01','2007V1','Mes',	20,	10,	0)
insert into cetcp values ('2020-06-01','2007V1','Mes',	20,	10,	0)

insert into PNCPconCET
select	t1.idversion,t3.idversion idversionefact,fechaEfact,Mes_PNCP,VersionPNCP,t2.IdBarraNacional,precionudoenergiapeso
		,case when fechaPNP is null then '2000-01-01' else fechaPNP end fechaPNP
		,case when VersionPNP is null then '0' else VersionPNP end VersionPNP
		,case when TipoPNP is null then '0' else TipoPNP end TipoPNP
		,case	when codigocontrato='Contrato Corto Plazo_Coelcha_ENDESA' then 14
				when codigocontrato='Contrato Corto Plazo_Frontel_ENDESA' then 14
				when codigocontrato='Contrato Corto Plazo_COOPERSOL_E-CL' then 10
				end IdGeneradora
		,case	when codigocontrato='Contrato Corto Plazo_Coelcha_ENDESA' then 34
				when codigocontrato='Contrato Corto Plazo_Frontel_ENDESA' then 22
				when codigocontrato='Contrato Corto Plazo_COOPERSOL_E-CL' then 20
				end IdDistribuidora
		,CETDolar,ValorDolar,PrecioNudoEnergiaDolar,PrecioNudoPotenciaDolar		
from [GTD-NOT019\SQLEXPRESS].pnp_1.[dbo].PNCPconCET t1
left join barranacional t2 on t1.barranacional=t2.BarraNAcional
left join versionefact t3 on t3.Descripcion=t1.VersionEfact
where codigocontrato not in ('DÉFICIT_Coopelan') and t1.IdVersion !=0

insert into CMGPromedio
select t1.Version VersionCMG,t1.fecha,t2.IdBarraNacional,t1.CMG_Peso,t1.observacion
from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.CMGPromedio t1
left join barranacional t2 on t1.barranacional=t2.BarraNAcional

insert into CMGPromedio-- para version que se calculó sin CMG
select '2007ProyV1',fecha,idbarranacional,0,'' from CMGPromedio where fecha in ('2020-09-01','2020-10-01')

--pnpIndex
IF OBJECT_ID('temppnp', 'U') IS NOT NULL DROP TABLE temppnp
GO
select	distinct versionpnp,fecha,[version]
		,case	when distribuidora in ('CGE Distribución','CGE DISTRIBUCIÓN') then concat(Licitacion,'_',bloque,'_',tipobloque,'_','CGE Distribucion','_', generadora)
				when distribuidora in ('MATAQUITO') then concat(Licitacion,'_',bloque,'_',tipobloque,'_','COELCHA','_', generadora)
				else concat(Licitacion,'_',bloque,'_',tipobloque,'_',distribuidora,'_', generadora) end CodigoContrato
		,t2.IdBarraNacional,PtoOferta
		,t1.CET_USD,t1.PE_Index_USD,t1.PP_Index_USD,t1.observacion
into temppnp
from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.pnp t1
left join barranacional t2 on t1.ptooferta=t2.BarraNAcional
where pe_index_usd is not null

insert into pnpIndex
select	versionpnp VersionIndex,fecha MesIndexacion,version,t2.idcodigocontrato,t1.IdBarraNacional IdPtoOferta,t1.CET_USD,t1.PE_Index_USD,t1.PP_Index_USD,t1.observacion
from temppnp t1
left join codigocontrato t2 on t1.CodigoContrato=t2.CodigoContrato
where t1.CodigoContrato not in ('EMEL-SIC 2006/01_BB1_BB_CGE Distribucion_ENDESA','EMEL-SIC 2006/01-2_BB_Sur_BB_CGE Distribucion_AES GENER','SIC 2013/03_2 (Enelsa)_BS4_BB_CGE Distribucion_Abengoa','SIC 2013/03_2 (Enelsa)_BS4_BB_CGE Distribucion_Norvind','SIC 2013/03_2 (Enelsa)_BS4_BB_CGE Distribucion_El Campesino')
and t1.distribuidora !='MATAQUITO'

IF OBJECT_ID('temppnp', 'U') IS NOT NULL DROP TABLE temppnp

	--cargar registro de contrato faltante
insert into pnpindex
select VersionIndex,MesIndexacion,Version, 186 IdCodigoContrato,IdPtoOferta,Cet_USD,PrecioEnergia,PrecioPotencia,CONCAT(Observacion,'. Se agrega 20210211 porque no existen') Observacion
from pnpindex where MesIndexacion='2020-10-01' and VersionIndex='FPEC_2010V1'
and IdCodigoContrato=185


--PNPTraspExc
IF OBJECT_ID('temptrasp', 'U') IS NOT NULL DROP TABLE temptrasp
select	VersionPNP,fecha,Version
		,case	when distribuidora in ('CGE Distribución','CGE DISTRIBUCIÓN') then concat(Licitacion,'_',bloque,'_',tipobloque,'_','CGE Distribucion','_', generadora)
				when distribuidora in ('MATAQUITO') then concat(Licitacion,'_',bloque,'_',tipobloque,'_','COELCHA','_', generadora)
				else concat(Licitacion,'_',bloque,'_',tipobloque,'_',distribuidora,'_', generadora) end CodigoContrato
		,t2.IdBarraNacional IdPtoOferta,PtoOferta
		,t3.IdBarraNacional IdPtoCompra,PtoCompra
		,t1.CET_USD,t1.PE_Index_USD PrecioEnergia,t1.PP_Index_USD PrecioPotencia,t1.observacion
		,DolarMes,CMGPtoSuministro,CMGPtoOferta,PeTraspExc
into temptrasp
from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.PNPTraspExc t1
left join barranacional t2 on t1.ptooferta=t2.BarraNAcional
left join barranacional t3 on t1.PtoCompra=t3.BarraNAcional

insert into PNPTraspExc
select	t1.VersionPNP,t1.fecha,t1.version,idCodigoContrato,IdPtoOferta,IdPtoCompra,CET_USD,PrecioEnergia,PrecioPotencia,t1.observacion,DolarMes
		,t1.VersionPNP VersionCMG,t1.fecha FechaCMG,CMGPtoSuministro,CMGPtoOferta,PeTraspExc
from temptrasp t1
left join codigocontrato t2 on t1.CodigoContrato=t2.CodigoContrato

IF OBJECT_ID('temptrasp', 'U') IS NOT NULL DROP TABLE temptrasp

insert into DolarFijacion
select iD= ROW_NUMBER() OVER(ORDER BY(SELECT NULL)),* from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.dolarFijacion

insert into Estabilizacion
select iD= ROW_NUMBER() OVER(ORDER BY(SELECT NULL)),*,'' from [GTD-NOT019\SQLEXPRESS].pnp_1.dbo.Estabilizacion
--*/
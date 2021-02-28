use PNP_3

DECLARE @FECHAIndex DATE='2020-10-01'--mes para crear factores de indexación 
declare @versionIndex1 varchar(150)='V1'--para las versiones reales se ocupa 'V1'

--insert into IndexadoresContratos 
--select 'V5' Version,Fecha,Tipo,Valor*1.3 Valor 
--from IndexadoresContratos where Version='V1' and fecha>'2019-10-01'
--insert into IndexadoresContratos 
--select 'V5' Version,Fecha,Tipo,Valor
--from IndexadoresContratos where Version='V1' and fecha<='2019-10-01'


--select * from IndexadoresContratos where Fecha='2020-10-01' order by Tipo

--PROCEDIMIENTO PARA IR CREANDO NUEVOS ÍNDICES DE INDEXACIÓN
	--Entrega como resultado los nuevos índices, si aparece vacía alguna de las tablas, significa que faltan antecedentes para construirlas

/*
EXEC [013_PROC_INDEXACION] @FECHAIndex,@versionIndex1
select * from IndexadoresContratos where fecha=@FECHAIndex--deben ser 14 resultados.
--*/

--PROCEDIMIENTO PARA CREAR CONTRATOS INDEXADOS
	--VALIDAR QUE NO SE CUMPLA LÍMITE PARA ACTUALIZAR PRECIO INDEXACIÓN (10%)
	--FLAG CON ERRORES POSIBLES
	--REALIZAR AJUSTES DE FACTORES DE INDEXACIÓN (CON TEMAS PARA RECUPERAR INFORMACIÓN HISTÓRICA)
	--TEMA DE VIGENCIA DE CONTRATOS.
	--CARGAR EN TABLA DE PRECIOS DE CONTRATOS OFICIALES
--/*
declare @VersionIndex		varchar(255)='Carla5'--version del mes que toma la referencia de los factores de indexación, es equivalente al mes sobre el cual se están indexando los contratos.
declare @MesIndexacion		date='2020-10-01'--mes que toma la referencia de los factores de indexación, es equivalente al mes sobre el cual se están indexando los contratos.
declare @Version			varchar(255)='Mes'--indica si son precios del contratos PNP o contratos definitiva. Cuando es ITD, se fuerzan precios de contratos futuros que estén activos hasta 6 meses depsués de mes indexación
--Cuando se realiza la indexación para el mes a ser utilizado para el modelo PNP, se debe indicar el mes de indexación (para el caso de enero 2021, sería octubre 2020 y tipo pnp=ITD, entonces cuando se transfiere  a la tabla "PNP" se le coloca el mes de referencia.
declare @TipoIndexacion			varchar(255)='V5'--indica elementos de IndexadoresContratos para indexar los contratos. se utiliza en caso de simulaciones de indexadores.
declare @VersionFijacion	varchar(255)='ITPV1'--version del mes de fijación, para comparación de límite del 10%.
declare @MesFijacion		date='2020-10-01'--mes de fijación, para comparación de límite del 10%.
declare @FECHAPNCP			date='2020-10-01'--Fecha del PNCP utilizado.

exec [014_PROC_INDEXACONTRATO]
					@VersionIndex,
					@MesIndexacion,
					@Version,
					@TipoIndexacion,
					@VersionFijacion,
					@MesFijacion,
					@FECHAPNCP

--select VersionIndex,MesIndexacion,Version,count(version) Cantidad from [dbo].[indexacioncontratofm] group by VersionIndex,MesIndexacion,Version
select VersionIndex,sum(PNELP) 
from [dbo].[indexacioncontratofm]
group by VersionIndex
--*/

select * from [dbo].[indexacioncontratofm]

select * from pnp

select * from efact

select * from versionrecdetalle where IdVersion=140
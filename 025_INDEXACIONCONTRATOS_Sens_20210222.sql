use PNP_3

DECLARE @FECHAIndex DATE='2020-10-01'--mes para crear factores de indexaci�n 
declare @versionIndex1 varchar(150)='V1'--para las versiones reales se ocupa 'V1'

--insert into IndexadoresContratos 
--select 'V5' Version,Fecha,Tipo,Valor*1.3 Valor 
--from IndexadoresContratos where Version='V1' and fecha>'2019-10-01'
--insert into IndexadoresContratos 
--select 'V5' Version,Fecha,Tipo,Valor
--from IndexadoresContratos where Version='V1' and fecha<='2019-10-01'


--select * from IndexadoresContratos where Fecha='2020-10-01' order by Tipo

--PROCEDIMIENTO PARA IR CREANDO NUEVOS �NDICES DE INDEXACI�N
	--Entrega como resultado los nuevos �ndices, si aparece vac�a alguna de las tablas, significa que faltan antecedentes para construirlas

/*
EXEC [013_PROC_INDEXACION] @FECHAIndex,@versionIndex1
select * from IndexadoresContratos where fecha=@FECHAIndex--deben ser 14 resultados.
--*/

--PROCEDIMIENTO PARA CREAR CONTRATOS INDEXADOS
	--VALIDAR QUE NO SE CUMPLA L�MITE PARA ACTUALIZAR PRECIO INDEXACI�N (10%)
	--FLAG CON ERRORES POSIBLES
	--REALIZAR AJUSTES DE FACTORES DE INDEXACI�N (CON TEMAS PARA RECUPERAR INFORMACI�N HIST�RICA)
	--TEMA DE VIGENCIA DE CONTRATOS.
	--CARGAR EN TABLA DE PRECIOS DE CONTRATOS OFICIALES
--/*
declare @VersionIndex		varchar(255)='Carla5'--version del mes que toma la referencia de los factores de indexaci�n, es equivalente al mes sobre el cual se est�n indexando los contratos.
declare @MesIndexacion		date='2020-10-01'--mes que toma la referencia de los factores de indexaci�n, es equivalente al mes sobre el cual se est�n indexando los contratos.
declare @Version			varchar(255)='Mes'--indica si son precios del contratos PNP o contratos definitiva. Cuando es ITD, se fuerzan precios de contratos futuros que est�n activos hasta 6 meses depsu�s de mes indexaci�n
--Cuando se realiza la indexaci�n para el mes a ser utilizado para el modelo PNP, se debe indicar el mes de indexaci�n (para el caso de enero 2021, ser�a octubre 2020 y tipo pnp=ITD, entonces cuando se transfiere  a la tabla "PNP" se le coloca el mes de referencia.
declare @TipoIndexacion			varchar(255)='V5'--indica elementos de IndexadoresContratos para indexar los contratos. se utiliza en caso de simulaciones de indexadores.
declare @VersionFijacion	varchar(255)='ITPV1'--version del mes de fijaci�n, para comparaci�n de l�mite del 10%.
declare @MesFijacion		date='2020-10-01'--mes de fijaci�n, para comparaci�n de l�mite del 10%.
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
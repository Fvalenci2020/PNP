
USE pnp_3
GO
 IF NOT EXISTS(SELECT * FROM sys.schemas WHERE [name] = N'db_accessadmin')      
     EXEC (N'CREATE SCHEMA db_accessadmin')                                   
 GO                                                               

USE pnp_3
GO
 IF NOT EXISTS(SELECT * FROM sys.schemas WHERE [name] = N'db_backupoperator')      
     EXEC (N'CREATE SCHEMA db_backupoperator')                                   
 GO                                                               

USE pnp_3
GO
 IF NOT EXISTS(SELECT * FROM sys.schemas WHERE [name] = N'db_datareader')      
     EXEC (N'CREATE SCHEMA db_datareader')                                   
 GO                                                               

USE pnp_3
GO
 IF NOT EXISTS(SELECT * FROM sys.schemas WHERE [name] = N'db_datawriter')      
     EXEC (N'CREATE SCHEMA db_datawriter')                                   
 GO                                                               

USE pnp_3
GO
 IF NOT EXISTS(SELECT * FROM sys.schemas WHERE [name] = N'db_ddladmin')      
     EXEC (N'CREATE SCHEMA db_ddladmin')                                   
 GO                                                               

USE pnp_3
GO
 IF NOT EXISTS(SELECT * FROM sys.schemas WHERE [name] = N'db_denydatareader')      
     EXEC (N'CREATE SCHEMA db_denydatareader')                                   
 GO                                                               

USE pnp_3
GO
 IF NOT EXISTS(SELECT * FROM sys.schemas WHERE [name] = N'db_denydatawriter')      
     EXEC (N'CREATE SCHEMA db_denydatawriter')                                   
 GO                                                               

USE pnp_3
GO
 IF NOT EXISTS(SELECT * FROM sys.schemas WHERE [name] = N'db_owner')      
     EXEC (N'CREATE SCHEMA db_owner')                                   
 GO                                                               

USE pnp_3
GO
 IF NOT EXISTS(SELECT * FROM sys.schemas WHERE [name] = N'db_securityadmin')      
     EXEC (N'CREATE SCHEMA db_securityadmin')                                   
 GO                                                               

USE pnp_3
GO
 IF NOT EXISTS(SELECT * FROM sys.schemas WHERE [name] = N'dbo')      
     EXEC (N'CREATE SCHEMA dbo')                                   
 GO                                                               

USE pnp_3
GO
 IF NOT EXISTS(SELECT * FROM sys.schemas WHERE [name] = N'guest')      
     EXEC (N'CREATE SCHEMA guest')                                   
 GO                                                               

USE pnp_3
GO
 IF NOT EXISTS(SELECT * FROM sys.schemas WHERE [name] = N'INFORMATION_SCHEMA')      
     EXEC (N'CREATE SCHEMA INFORMATION_SCHEMA')                                   
 GO                                                               

USE pnp_3
GO
 IF NOT EXISTS(SELECT * FROM sys.schemas WHERE [name] = N'sys')      
     EXEC (N'CREATE SCHEMA sys')                                   
 GO                                                               

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'barranacional'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'barranacional'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[barranacional]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[barranacional]
(
   [IdBarraNacional] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [BarraNAcional] varchar(255)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.barranacional',
        N'SCHEMA', N'dbo',
        N'TABLE', N'barranacional'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'cet'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'cet'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[cet]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[cet]
(
   [IdLicitacionDx] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Licitacion] varchar(45)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Distribuidora] varchar(45)  NULL,
   [IdGeneradora] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Generadora] varchar(255)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [TieneCET] varchar(3)  NULL,
   [CET0] float  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Index] varchar(45)  NULL,
   [MesReferencia] date  NULL,
   [Rezago] int  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(45)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.cet',
        N'SCHEMA', N'dbo',
        N'TABLE', N'cet'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'cetcp'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'cetcp'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[cetcp]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[cetcp]
(
   [MesIndexacion] date  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [VersionIndex] varchar(45)  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Version] varchar(45)  NOT NULL,
   [IdDistribuidora] int  NOT NULL,
   [IdGeneradora] int  NOT NULL,
   [CET] float  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.cetcp',
        N'SCHEMA', N'dbo',
        N'TABLE', N'cetcp'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'cmgpromedio'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'cmgpromedio'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[cmgpromedio]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[cmgpromedio]
(

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [VersionCMg] varchar(45)  NOT NULL,
   [Fecha] date  NOT NULL,
   [IdBarraNacional] int  NOT NULL,
   [CMG_Peso] float  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.cmgpromedio',
        N'SCHEMA', N'dbo',
        N'TABLE', N'cmgpromedio'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'codigocontrato'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'codigocontrato'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[codigocontrato]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[codigocontrato]
(
   [IdCodigoContrato] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [CodigoContrato] varchar(255)  NOT NULL,
   [IdLicitacion] int  NOT NULL,
   [IdDistribuidora] int  NOT NULL,
   [IdGeneradora] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Licitacion] varchar(255)  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [TipoBloque] varchar(45)  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Bloque] varchar(45)  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Distribuidora] varchar(255)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Generadora] varchar(255)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.codigocontrato',
        N'SCHEMA', N'dbo',
        N'TABLE', N'codigocontrato'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'decreto'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'decreto'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[decreto]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[decreto]
(
   [IdDecreto] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Nombre] varchar(45)  NULL,
   [FechaPromulgacion] date  NULL,
   [FechaPublicacion] date  NULL,
   [FechaEntradaVigencia] date  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Descripcion] varchar(255)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(45)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.decreto',
        N'SCHEMA', N'dbo',
        N'TABLE', N'decreto'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'demanda'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'demanda'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[demanda]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[demanda]
(
   [IdDemanda] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Version] varchar(45)  NOT NULL,
   [IdDistribuidora] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Distribuidora] varchar(255)  NULL,
   [Mes] date  NULL,
   [IdSistemaZonal] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [SistemaZonal] varchar(45)  NULL,
   [IdPuntoRetiro] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [PuntoRetiro] varchar(45)  NULL,
   [Demanda] float  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(255)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   *   M2SS0003: The following SQL clause was ignored during conversion: COMMENT 'Si es demanda real, proyectada, simulada.'.
   */

   [TipoDemanda] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.demanda',
        N'SCHEMA', N'dbo',
        N'TABLE', N'demanda'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'difxcompras'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'difxcompras'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[difxcompras]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[difxcompras]
(
   [IdDifxCompras] int  NOT NULL,
   [Fecha] date  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Version] varchar(45)  NOT NULL,
   [IdDistribuidora] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Distribuidora] varchar(45)  NULL,
   [IdGeneradora] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Generadora] varchar(255)  NULL,
   [IdSistemaZonal] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [SistemaZonal] varchar(45)  NULL,
   [IdCodigoContrato] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [CodigoContrato] varchar(255)  NULL,
   [FisicoPtoRetiro] float  NULL,
   [ValorizadoPtoRetiro] float  NULL,
   [FisicoPtoCompra] float  NULL,
   [ValorizadoPtoCompra] float  NULL,
   [DiferenciaMensual] float  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.difxcompras',
        N'SCHEMA', N'dbo',
        N'TABLE', N'difxcompras'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'distribuidora'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'distribuidora'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[distribuidora]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[distribuidora]
(
   [IdDistribuidora] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [NombreDistribuidora] varchar(255)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.distribuidora',
        N'SCHEMA', N'dbo',
        N'TABLE', N'distribuidora'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'dolarfijacion'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'dolarfijacion'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[dolarfijacion]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[dolarfijacion]
(
   [IdDolarFijacion] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [VersionDolarFijacion] varchar(255)  NULL,
   [Mes_PNP] date  NULL,
   [Valor] int  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Descripcion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.dolarfijacion',
        N'SCHEMA', N'dbo',
        N'TABLE', N'dolarfijacion'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'eadjanual'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'eadjanual'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[eadjanual]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[eadjanual]
(

   /*
   *   SSMA informational messages:
   *   M2SS0003: The following SQL clause was ignored during conversion: COMMENT 'Se asocia a la final de modelo PNP'.
   */

   [IdEAdjAnual] int  NOT NULL,
   [IdCodigoContrato] int  NOT NULL,
   [IdPtoCompra] int  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [PtoCompra] varchar(45)  NULL,
   [Ano] int  NOT NULL,
   [EnergiaAnual] float  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.eadjanual',
        N'SCHEMA', N'dbo',
        N'TABLE', N'eadjanual'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'eadjanualdistrmensual'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'eadjanualdistrmensual'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[eadjanualdistrmensual]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[eadjanualdistrmensual]
(
   [IdEAdjAnualDistrMensual] int  NOT NULL,
   [IdCodigoContrato] int  NOT NULL,
   [IdPtoCompra] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [PtoCompra] varchar(255)  NULL,
   [Fecha] date  NOT NULL,
   [EnergiaMensual] float  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.eadjanualdistrmensual',
        N'SCHEMA', N'dbo',
        N'TABLE', N'eadjanualdistrmensual'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'efact'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'efact'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[efact]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[efact]
(
   [IdEfact] int  NOT NULL,
   [IdVersion] int  NOT NULL,
   [Fecha] date  NULL,
   [IdDistribuidora] int  NOT NULL,
   [IdGeneradora] int  NOT NULL,
   [IdCodigoContrato] int  NOT NULL,
   [IdPuntoRetiro] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Distribuidora] varchar(255)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Generadora] varchar(255)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [CodigoContrato] varchar(255)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [PuntoRetiro] varchar(255)  NULL,
   [IdTipoDespacho] int  NOT NULL,
   [Energia] float  NULL,
   [Potencia] float  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.efact',
        N'SCHEMA', N'dbo',
        N'TABLE', N'efact'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'estabilizacion'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'estabilizacion'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[estabilizacion]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[estabilizacion]
(
   [IdEstabilizacion] int  NOT NULL,
   [Ano] int  NULL,
   [Fecha] date  NULL,
   [IPC] float  NULL,
   [VariacionIPC] float  NULL,
   [Intereses] float  NULL,
   [DolarEstabilizacion] float  NULL,
   [FactorAjusteE] float  NULL,
   [FactorAjusteP] float  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.estabilizacion',
        N'SCHEMA', N'dbo',
        N'TABLE', N'estabilizacion'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'estabilizaciondetalle'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'estabilizaciondetalle'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[estabilizaciondetalle]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[estabilizaciondetalle]
(

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [IdVersionEstabilizacion] varchar(45)  NOT NULL,
   [IdEfact] int  NULL,
   [IdVersionPreciosDef] int  NULL,
   [IdVersionPreciosPNP] int  NULL,
   [IdDistribuidora] int  NULL,
   [IdGeneradora] int  NULL,
   [IdCodigoContrato] int  NULL,
   [IdPuntoRetiro] int  NULL,
   [IdTipoDEspacho] int  NOT NULL,
   [Energia] float  NULL,
   [Potencia] float  NULL,
   [Fechaefact_PrecioDef] date  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [VersionEfact_PrecioDef] varchar(45)  NULL,
   [FechaPNP_PrecioDef] date  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [VersionPNP_PrecioDef] varchar(45)  NULL,
   [EPC_PrecioDef] float  NULL,
   [PPC_PrecioDef] float  NULL,
   [ERec_Peso_PrecioDef] float  NULL,
   [PRec_Peso_PrecioDef] float  NULL,
   [Fechaefact_PrecioPNP] date  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [VersionEfact_PrecioPNP] varchar(45)  NULL,
   [FechaPNP_PrecioPNP] date  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [VersionPNP_PrecioPNP] varchar(45)  NULL,
   [EPC_PrecioPNP] float  NULL,
   [PPC_PrecioPNP] float  NULL,
   [ERec_Peso_PrecioPNP] float  NULL,
   [PRec_Peso_PrecioPNP] float  NULL,
   [VariacionIPC] float  NULL,
   [Interes] float  NULL,
   [FactorAjusteE] float  NULL,
   [FactorAjusteP] float  NULL,
   [DolarDefinitivoPromedioMes] float  NULL,
   [DifERec_Peso] float  NULL,
   [DifPRec_Peso] float  NULL,
   [DifERec_Peso_Estabilizado] float  NULL,
   [DifPRec_Peso_Estabilizado] float  NULL,
   [DifERec_Dolar_Estabilizado] float  NULL,
   [DifPRec_Dolar_Estabilizado] float  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.estabilizaciondetalle',
        N'SCHEMA', N'dbo',
        N'TABLE', N'estabilizaciondetalle'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'factormodulacion'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'factormodulacion'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[factormodulacion]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[factormodulacion]
(
   [IdDecreto] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Tipo] varchar(45)  NOT NULL,
   [IdBarraNacional] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [BarraNacional] varchar(255)  NULL,
   [Valor] float  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.factormodulacion',
        N'SCHEMA', N'dbo',
        N'TABLE', N'factormodulacion'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'factorreferenciacion'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'factorreferenciacion'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[factorreferenciacion]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[factorreferenciacion]
(
   [FechaInicio] date  NOT NULL,
   [FechaFin] date  NOT NULL,
   [IdPuntoRetiro] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [PuntoRetiro] varchar(255)  NULL,
   [IdBarraNacional] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [BarraNacional] varchar(255)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Periodo] varchar(255)  NOT NULL,
   [Factor] float  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.factorreferenciacion',
        N'SCHEMA', N'dbo',
        N'TABLE', N'factorreferenciacion'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'generadora'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'generadora'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[generadora]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[generadora]
(
   [IdGeneradora] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [NombreGeneradora] varchar(255)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.generadora',
        N'SCHEMA', N'dbo',
        N'TABLE', N'generadora'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'indexacioncet'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'indexacioncet'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[indexacioncet]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[indexacioncet]
(

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [VersionIndex] varchar(45)  NOT NULL,
   [MesIndexacion] date  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Version] varchar(45)  NOT NULL,
   [IdLicitacionDx] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Licitacion] varchar(45)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Distribuidora] varchar(45)  NULL,
   [IdGeneradora] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Generadora] varchar(255)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [TieneCET] varchar(3)  NULL,
   [CET0] float  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Index] varchar(45)  NULL,
   [MesReferencia] date  NULL,
   [Rezago] int  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Obsevacion] varchar(45)  NULL,
   [FechaBase] date  NULL,
   [ValorBase] float  NULL,
   [FEchaActual] date  NULL,
   [ValorActual] float  NULL,
   [FactorIndexacion] float  NULL,
   [ValorCET] float  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.indexacioncet',
        N'SCHEMA', N'dbo',
        N'TABLE', N'indexacioncet'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'indexacioncombustible'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'indexacioncombustible'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[indexacioncombustible]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[indexacioncombustible]
(
   [IdIndexC] int  NOT NULL,
   [Fecha] date  NULL,
   [IdTipoCombustible] int  NOT NULL,
   [Valor] float  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.indexacioncombustible',
        N'SCHEMA', N'dbo',
        N'TABLE', N'indexacioncombustible'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'indexacioncontrato'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'indexacioncontrato'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[indexacioncontrato]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[indexacioncontrato]
(

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [VersionIndex] varchar(45)  NOT NULL,
   [MesIndexacion] date  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Version] varchar(45)  NULL,
   [IdLicitacionGx] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Licitacion] varchar(45)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Generadora] varchar(255)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [TipoBloque] varchar(45)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Bloque] varchar(45)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [PtoOferta] varchar(45)  NULL,
   [PrecioEnergiaBase] float  NULL,
   [IdDecrPNudo] int  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [DecPNudo] varchar(45)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [TipoDecreto] varchar(45)  NULL,
   [PrecioPotenciaBase] float  NULL,
   [FactorIndexacionPotencia] float  NULL,
   [FactorIndexacionEnergia] float  NULL,
   [PrecioEnergiaIndexado] float  NULL,
   [PrecioPotenciaIndexado] float  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [FlagIndx] varchar(45)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [FlagFij] varchar(45)  NULL,
   [MesFijacion] date  NULL,
   [PrecioEnergiaFijacion] float  NULL,
   [PrecioPotenciaFijacion] float  NULL,
   [VariacionE] float  NULL,
   [VariacionP] float  NULL,
   [IndexE] float  NULL,
   [IndexP] float  NULL,
   [PrecioEnergia] float  NULL,
   [PrecioPotencia] float  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.indexacioncontrato',
        N'SCHEMA', N'dbo',
        N'TABLE', N'indexacioncontrato'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'indexacioncontratodetalle'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'indexacioncontratodetalle'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[indexacioncontratodetalle]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[indexacioncontratodetalle]
(

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [VersionIndex] varchar(45)  NOT NULL,
   [MesIndexacion] date  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Version] varchar(45)  NULL,
   [IdLicitacionGx] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Licitacion] varchar(45)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Generadora] varchar(255)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [TipoBloque] varchar(45)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Bloque] varchar(45)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [PtoOferta] varchar(45)  NULL,
   [PrecioEnergiaBase] float  NULL,
   [IdDecrPNudo] int  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [DecPNudo] varchar(45)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [TipoDecreto] varchar(45)  NULL,
   [PrecioPotenciaBase] float  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [TipoIndex] varchar(45)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Index] varchar(45)  NULL,
   [MesReferencia] date  NULL,
   [Rezago] int  NULL,
   [Ponderador] float  NULL,
   [FechaBase] date  NULL,
   [ValorBase] float  NULL,
   [FechaActual] date  NULL,
   [ValorActual] float  NULL,
   [FactorIndexacion] float  NULL,
   [PrecioIndexadoPonderado] float  NULL,
   [FlagInd] int  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.indexacioncontratodetalle',
        N'SCHEMA', N'dbo',
        N'TABLE', N'indexacioncontratodetalle'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'indexacioncontratofm'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'indexacioncontratofm'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[indexacioncontratofm]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[indexacioncontratofm]
(

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [VersionIndex] varchar(45)  NOT NULL,
   [MesIndexacion] date  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Version] varchar(45)  NOT NULL,
   [IdCodigoContrato] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [CodigoContrato] varchar(255)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Licitacion] varchar(45)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [TipoBloque] varchar(45)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Bloque] varchar(45)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Distribuidora] varchar(255)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Generadora] varchar(255)  NULL,
   [IdPtoOferta] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [PtoOferta] varchar(45)  NULL,
   [IdBarraNacional] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [BarraNacional] varchar(25)  NULL,
   [PrecioEnergia] float  NULL,
   [PrecioPotencia] float  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [ValorCET] varchar(45)  NULL,
   [RExBasesAno] int  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [OrigenFMO] varchar(255)  NULL,
   [FMEOferta] float  NULL,
   [FMPOferta] float  NULL,
   [FMESuministro] float  NULL,
   [FMPSuministro] float  NULL,
   [PNELP] float  NULL,
   [PNPLP] float  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.indexacioncontratofm',
        N'SCHEMA', N'dbo',
        N'TABLE', N'indexacioncontratofm'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'indexacioncpi'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'indexacioncpi'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[indexacioncpi]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[indexacioncpi]
(
   [IdCPI] int  NOT NULL,
   [Fecha] date  NULL,
   [Valor] float  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.indexacioncpi',
        N'SCHEMA', N'dbo',
        N'TABLE', N'indexacioncpi'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'indexaciondolar'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'indexaciondolar'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[indexaciondolar]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[indexaciondolar]
(
   [IdDolar] int  NOT NULL,
   [Fecha] date  NULL,
   [Valor] float  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.indexaciondolar',
        N'SCHEMA', N'dbo',
        N'TABLE', N'indexaciondolar'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'indexacionipc'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'indexacionipc'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[indexacionipc]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[indexacionipc]
(
   [IdIPC] int  NOT NULL,
   [Fecha] date  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Valor] varchar(45)  NULL,
   [AnoBase] int  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.indexacionipc',
        N'SCHEMA', N'dbo',
        N'TABLE', N'indexacionipc'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'indexadorescontratos'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'indexadorescontratos'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[indexadorescontratos]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[indexadorescontratos]
(

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Version] varchar(45)  NOT NULL,
   [Fecha] date  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Tipo] varchar(45)  NOT NULL,
   [Valor] float  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.indexadorescontratos',
        N'SCHEMA', N'dbo',
        N'TABLE', N'indexadorescontratos'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'licitacion'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'licitacion'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[licitacion]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[licitacion]
(
   [IdLicitacion] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Licitacion] varchar(255)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.licitacion',
        N'SCHEMA', N'dbo',
        N'TABLE', N'licitacion'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'licitaciondx'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'licitaciondx'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[licitaciondx]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[licitaciondx]
(
   [IdLicitacionDx] int  NOT NULL,
   [IdLicitacion] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   *   M2SS0003: The following SQL clause was ignored during conversion: COMMENT 'Resolución exenta o Decreto que define licitación
   *   '.
   */

   [Licitacion] varchar(255)  NULL,
   [IdDistribuidora] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   *   M2SS0003: The following SQL clause was ignored during conversion: COMMENT 'Nombre Distribuidora que aparece en Archivo Excel Modelo PNP, No tiene pq coincidir con descripción que aparece en tabla Distribuidora'.
   */

   [Distribuidora] varchar(45)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.licitaciondx',
        N'SCHEMA', N'dbo',
        N'TABLE', N'licitaciondx'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'licitaciongx'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'licitaciongx'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[licitaciongx]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[licitaciongx]
(
   [IdLicitacionGx] int  NOT NULL,
   [IdLicitacion] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Licitacion] varchar(45)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [RExBases] varchar(255)  NULL,
   [IdDecrPNudo] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [DecPNudo] varchar(45)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [TipoDecreto] varchar(45)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Modalidad] varchar(255)  NULL,
   [MesReferencia] date  NULL,
   [IdGeneradora] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Generadora] varchar(255)  NULL,
   [IdPtoOferta] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [PtoOferta] varchar(255)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [TipoBloque] varchar(45)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Bloque] varchar(45)  NULL,
   [PrecioEnergia] float  NULL,
   [VigenciaInicio] date  NULL,
   [VigenciaFin] date  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.licitaciongx',
        N'SCHEMA', N'dbo',
        N'TABLE', N'licitaciongx'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'licitaciongxdxptocompra'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'licitaciongxdxptocompra'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[licitaciongxdxptocompra]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[licitaciongxdxptocompra]
(
   [IdLicitacionDx] int  NOT NULL,
   [IdLicitacionGx] int  NOT NULL,
   [IdPtoCompra] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [PtoCompra] varchar(255)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.licitaciongxdxptocompra',
        N'SCHEMA', N'dbo',
        N'TABLE', N'licitaciongxdxptocompra'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'licitaciongxindexacion'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'licitaciongxindexacion'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[licitaciongxindexacion]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[licitaciongxindexacion]
(
   [IdLicitacionGx] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [TipoIndex] varchar(45)  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Index] varchar(45)  NOT NULL,
   [Rezago] int  NULL,
   [Ponderador] float  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.licitaciongxindexacion',
        N'SCHEMA', N'dbo',
        N'TABLE', N'licitaciongxindexacion'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'licitaciongxindexesp'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'licitaciongxindexesp'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[licitaciongxindexesp]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[licitaciongxindexesp]
(
   [IdLicitacionGx] int  NOT NULL,
   [Fecha] date  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Tipo] varchar(45)  NOT NULL,
   [Valor] float  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.licitaciongxindexesp',
        N'SCHEMA', N'dbo',
        N'TABLE', N'licitaciongxindexesp'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'perdidazonal'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'perdidazonal'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[perdidazonal]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[perdidazonal]
(
   [Fecha] date  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Version] varchar(45)  NOT NULL,
   [IdSistemaZonal] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [SistemaZonal] varchar(45)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [TipoFactor] varchar(45)  NOT NULL,
   [Factor] float  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.perdidazonal',
        N'SCHEMA', N'dbo',
        N'TABLE', N'perdidazonal'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'pncp'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'pncp'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[pncp]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[pncp]
(
   [MES] date  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Version] varchar(255)  NOT NULL,
   [IdNudo] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Nudo] varchar(45)  NOT NULL,
   [PrecioNudoE_Peso] float  NOT NULL,
   [PrecioNudoP_Peso] float  NOT NULL,
   [FME] float  NOT NULL,
   [FMP] float  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.pncp',
        N'SCHEMA', N'dbo',
        N'TABLE', N'pncp'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'pncpconcet'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'pncpconcet'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[pncpconcet]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[pncpconcet]
(
   [IdVersion] int  NOT NULL,
   [IdVersionEfact] int  NOT NULL,
   [FechaEfact] date  NULL,
   [MES_PNCP] date  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [VersionPNCP] varchar(255)  NOT NULL,
   [IdNudo] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [PrecioNudoEnergiaPeso] varchar(45)  NULL,
   [MesIndexacion] date  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [VersionIndex] varchar(45)  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [VersionPNP] varchar(45)  NOT NULL,
   [IdGeneradora] int  NOT NULL,
   [IdDistribuidora] int  NOT NULL,
   [CETDolar] float  NULL,
   [ValorDolar] float  NULL,
   [PrecioNudoEnergiaDolar] float  NULL,
   [PrecioNudoPotenciaDolar] float  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.pncpconcet',
        N'SCHEMA', N'dbo',
        N'TABLE', N'pncpconcet'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'pnp'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'pnp'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[pnp]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[pnp]
(
   [IdPNP] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [VersionIndex] varchar(45)  NOT NULL,
   [MesIndexacion] date  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Version] varchar(45)  NOT NULL,
   [IdCodigoContrato] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Licitacion] varchar(45)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [TipoBloque] varchar(45)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Bloque] varchar(45)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Distribuidora] varchar(255)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Generadora] varchar(255)  NULL,
   [IdBarraNacional] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [BarraNacional] varchar(25)  NULL,
   [PNELP] float  NULL,
   [PNPLP] float  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.pnp',
        N'SCHEMA', N'dbo',
        N'TABLE', N'pnp'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'pnpindex'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'pnpindex'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[pnpindex]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[pnpindex]
(

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [VersionIndex] varchar(45)  NOT NULL,
   [MesIndexacion] date  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Version] varchar(45)  NOT NULL,
   [IdCodigoContrato] int  NOT NULL,
   [IdPtoOferta] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Cet_USD] varchar(45)  NULL,
   [PrecioEnergia] float  NULL,
   [PrecioPotencia] float  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.pnpindex',
        N'SCHEMA', N'dbo',
        N'TABLE', N'pnpindex'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'pnptraspexc'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'pnptraspexc'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[pnptraspexc]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[pnptraspexc]
(

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [VersionPNP] varchar(45)  NOT NULL,
   [Fecha] date  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Version] varchar(45)  NOT NULL,
   [IdCodigoContrato] int  NOT NULL,
   [IdPtoOferta] int  NOT NULL,
   [IdPtoCompra] int  NOT NULL,
   [CET_USD] float  NULL,
   [PrecioEnergia] float  NULL,
   [PrecioPotencia] float  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(255)  NULL,
   [DolarMes] float  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [VersionCMg] varchar(45)  NOT NULL,
   [FechaCMG] date  NOT NULL,
   [CMGPtoSuministro] float  NULL,
   [CMGPtoOferta] float  NULL,
   [PeTraspExc] float  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.pnptraspexc',
        N'SCHEMA', N'dbo',
        N'TABLE', N'pnptraspexc'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'precionudolicitacion'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'precionudolicitacion'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[precionudolicitacion]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[precionudolicitacion]
(
   [IdDecPNudo] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [DecPNudo] varchar(45)  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Tipo] varchar(45)  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Unidad] varchar(45)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [TipoDecreto] varchar(45)  NOT NULL,
   [Precio] float  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observación] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.precionudolicitacion',
        N'SCHEMA', N'dbo',
        N'TABLE', N'precionudolicitacion'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'ptoretirosistema'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'ptoretirosistema'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[ptoretirosistema]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[ptoretirosistema]
(
   [IdPuntoRetiro] int  NOT NULL,
   [IdSistemaZonal] int  NOT NULL,
   [Ano] int  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.ptoretirosistema',
        N'SCHEMA', N'dbo',
        N'TABLE', N'ptoretirosistema'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'puntoretiro'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'puntoretiro'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[puntoretiro]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[puntoretiro]
(
   [IdPuntoRetiro] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [PuntoRetiro] varchar(255)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.puntoretiro',
        N'SCHEMA', N'dbo',
        N'TABLE', N'puntoretiro'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'recaudaciondetalle'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'recaudaciondetalle'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[recaudaciondetalle]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[recaudaciondetalle]
(
   [IdVersion] int  NOT NULL,
   [IdEfact] int  NOT NULL,
   [IdVersionEFact] int  NOT NULL,
   [FechaEFact] date  NULL,
   [IdDistribuidora] int  NOT NULL,
   [IdGeneradora] int  NOT NULL,
   [IdCodigoContrato] int  NOT NULL,
   [IdPuntoRetiro] int  NOT NULL,
   [IdTipoDespacho] int  NOT NULL,
   [Energia] float  NULL,
   [Potencia] float  NULL,
   [IdSistemaZonal] int  NOT NULL,
   [FechaPZ] date  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [VersionPZ] varchar(45)  NOT NULL,
   [FEPE] float  NULL,
   [FEPP] float  NULL,
   [IdBarraNacionalFR] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [PeriodoFR] varchar(255)  NOT NULL,
   [FactorFR] float  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [PNP_VersionIndex] varchar(45)  NOT NULL,
   [PNP_MesIndexacion] date  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [PNP_Version] varchar(45)  NOT NULL,
   [PNELP] float  NULL,
   [PNPLP] float  NULL,
   [PNCP_Mes] date  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [PNCP_Version] varchar(255)  NOT NULL,
   [PNCP_IdNudo] int  NOT NULL,
   [CETCP] float  NULL,
   [PNECP_USD] float  NULL,
   [PNPCP_USD] float  NULL,
   [EPC] float  NULL,
   [PPC] float  NULL,
   [ERec_USD] float  NULL,
   [PRec_USD] float  NULL,
   [Dolar] float  NULL,
   [ERec_Peso] float  NULL,
   [PRec_Peso] float  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.recaudaciondetalle',
        N'SCHEMA', N'dbo',
        N'TABLE', N'recaudaciondetalle'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'sistemazonal'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'sistemazonal'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[sistemazonal]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[sistemazonal]
(
   [IdSistemaZonal] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [SistemaZonal] varchar(45)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [OBservacion] varchar(45)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.sistemazonal',
        N'SCHEMA', N'dbo',
        N'TABLE', N'sistemazonal'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'tipocombustible'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'tipocombustible'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[tipocombustible]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[tipocombustible]
(
   [IdTipoCombustible] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [TipoCombustible] varchar(255)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Unidad] varchar(45)  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Observacion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.tipocombustible',
        N'SCHEMA', N'dbo',
        N'TABLE', N'tipocombustible'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'tipodespacho'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'tipodespacho'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[tipodespacho]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[tipodespacho]
(
   [IdTipoDEspacho] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Descripcion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.tipodespacho',
        N'SCHEMA', N'dbo',
        N'TABLE', N'tipodespacho'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'versionefact'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'versionefact'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[versionefact]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[versionefact]
(
   [IdVersion] int IDENTITY(1, 1)  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Descripcion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.versionefact',
        N'SCHEMA', N'dbo',
        N'TABLE', N'versionefact'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'versionestabilizacion'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'versionestabilizacion'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[versionestabilizacion]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[versionestabilizacion]
(

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [IdVersionEstabilizacion] varchar(45)  NOT NULL,
   [Fecha] date  NULL,
   [IdVersionContratosDefinitiva] int  NOT NULL,
   [IdVersionContratosPNP] int  NOT NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.versionestabilizacion',
        N'SCHEMA', N'dbo',
        N'TABLE', N'versionestabilizacion'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'versionrec'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'versionrec'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[versionrec]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[versionrec]
(
   [IdVersion] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Descripcion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.versionrec',
        N'SCHEMA', N'dbo',
        N'TABLE', N'versionrec'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'versionrecdetalle'  AND sc.name = N'dbo'  AND type in (N'U'))
BEGIN

  DECLARE @drop_statement nvarchar(500)

  DECLARE drop_cursor CURSOR FOR
      SELECT 'alter table '+quotename(schema_name(ob.schema_id))+
      '.'+quotename(object_name(ob.object_id))+ ' drop constraint ' + quotename(fk.name) 
      FROM sys.objects ob INNER JOIN sys.foreign_keys fk ON fk.parent_object_id = ob.object_id
      WHERE fk.referenced_object_id = 
          (
             SELECT so.object_id 
             FROM sys.objects so JOIN sys.schemas sc
             ON so.schema_id = sc.schema_id
             WHERE so.name = N'versionrecdetalle'  AND sc.name = N'dbo'  AND type in (N'U')
           )

  OPEN drop_cursor

  FETCH NEXT FROM drop_cursor
  INTO @drop_statement

  WHILE @@FETCH_STATUS = 0
  BEGIN
     EXEC (@drop_statement)

     FETCH NEXT FROM drop_cursor
     INTO @drop_statement
  END

  CLOSE drop_cursor
  DEALLOCATE drop_cursor

  DROP TABLE [dbo].[versionrecdetalle]
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE 
[dbo].[versionrecdetalle]
(
   [IdVersion] int  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Registro] varchar(255)  NOT NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [ValorTexto] varchar(255)  NULL,
   [ValorFecha] date  NULL,
   [ValorInt] int  NULL,
   [ValorFloat] float  NULL,

   /*
   *   SSMA warning messages:
   *   M2SS0183: The following SQL clause was ignored during conversion: COLLATE latin1_bin.

   *   SSMA informational messages:
   *   M2SS0055: Data type was converted to VARCHAR according to character set mapping for latin1 character set
   */

   [Descripcion] varchar(255)  NULL
)
WITH (DATA_COMPRESSION = NONE)
GO
BEGIN TRY
    EXEC sp_addextendedproperty
        N'MS_SSMA_SOURCE', N'pnp_3.versionrecdetalle',
        N'SCHEMA', N'dbo',
        N'TABLE', N'versionrecdetalle'
END TRY
BEGIN CATCH
    IF (@@TRANCOUNT > 0) ROLLBACK
    PRINT ERROR_MESSAGE()
END CATCH
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_barranacional_IdBarraNacional'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[barranacional] DROP CONSTRAINT [PK_barranacional_IdBarraNacional]
 GO



ALTER TABLE [dbo].[barranacional]
 ADD CONSTRAINT [PK_barranacional_IdBarraNacional]
   PRIMARY KEY
   CLUSTERED ([IdBarraNacional] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_cet_IdLicitacionDx'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[cet] DROP CONSTRAINT [PK_cet_IdLicitacionDx]
 GO



ALTER TABLE [dbo].[cet]
 ADD CONSTRAINT [PK_cet_IdLicitacionDx]
   PRIMARY KEY
   CLUSTERED ([IdLicitacionDx] ASC, [IdGeneradora] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_cetcp_MesIndexacion'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[cetcp] DROP CONSTRAINT [PK_cetcp_MesIndexacion]
 GO



ALTER TABLE [dbo].[cetcp]
 ADD CONSTRAINT [PK_cetcp_MesIndexacion]
   PRIMARY KEY
   CLUSTERED ([MesIndexacion] ASC, [VersionIndex] ASC, [Version] ASC, [IdGeneradora] ASC, [IdDistribuidora] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_cmgpromedio_VersionCMg'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[cmgpromedio] DROP CONSTRAINT [PK_cmgpromedio_VersionCMg]
 GO



ALTER TABLE [dbo].[cmgpromedio]
 ADD CONSTRAINT [PK_cmgpromedio_VersionCMg]
   PRIMARY KEY
   CLUSTERED ([VersionCMg] ASC, [Fecha] ASC, [IdBarraNacional] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_codigocontrato_IdCodigoContrato'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[codigocontrato] DROP CONSTRAINT [PK_codigocontrato_IdCodigoContrato]
 GO



ALTER TABLE [dbo].[codigocontrato]
 ADD CONSTRAINT [PK_codigocontrato_IdCodigoContrato]
   PRIMARY KEY
   CLUSTERED ([IdCodigoContrato] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_decreto_IdDecreto'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[decreto] DROP CONSTRAINT [PK_decreto_IdDecreto]
 GO



ALTER TABLE [dbo].[decreto]
 ADD CONSTRAINT [PK_decreto_IdDecreto]
   PRIMARY KEY
   CLUSTERED ([IdDecreto] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_demanda_IdDemanda'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[demanda] DROP CONSTRAINT [PK_demanda_IdDemanda]
 GO



ALTER TABLE [dbo].[demanda]
 ADD CONSTRAINT [PK_demanda_IdDemanda]
   PRIMARY KEY
   CLUSTERED ([IdDemanda] ASC, [Version] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_difxcompras_IdDifxCompras'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[difxcompras] DROP CONSTRAINT [PK_difxcompras_IdDifxCompras]
 GO



ALTER TABLE [dbo].[difxcompras]
 ADD CONSTRAINT [PK_difxcompras_IdDifxCompras]
   PRIMARY KEY
   CLUSTERED ([IdDifxCompras] ASC, [Version] ASC, [Fecha] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_distribuidora_IdDistribuidora'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[distribuidora] DROP CONSTRAINT [PK_distribuidora_IdDistribuidora]
 GO



ALTER TABLE [dbo].[distribuidora]
 ADD CONSTRAINT [PK_distribuidora_IdDistribuidora]
   PRIMARY KEY
   CLUSTERED ([IdDistribuidora] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_dolarfijacion_IdDolarFijacion'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[dolarfijacion] DROP CONSTRAINT [PK_dolarfijacion_IdDolarFijacion]
 GO



ALTER TABLE [dbo].[dolarfijacion]
 ADD CONSTRAINT [PK_dolarfijacion_IdDolarFijacion]
   PRIMARY KEY
   CLUSTERED ([IdDolarFijacion] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_eadjanualdistrmensual_IdCodigoContrato'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[eadjanualdistrmensual] DROP CONSTRAINT [PK_eadjanualdistrmensual_IdCodigoContrato]
 GO



ALTER TABLE [dbo].[eadjanualdistrmensual]
 ADD CONSTRAINT [PK_eadjanualdistrmensual_IdCodigoContrato]
   PRIMARY KEY
   CLUSTERED ([IdCodigoContrato] ASC, [IdPtoCompra] ASC, [Fecha] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_efact_IdEfact'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[efact] DROP CONSTRAINT [PK_efact_IdEfact]
 GO



ALTER TABLE [dbo].[efact]
 ADD CONSTRAINT [PK_efact_IdEfact]
   PRIMARY KEY
   CLUSTERED ([IdEfact] ASC, [IdVersion] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_estabilizacion_IdEstabilizacion'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[estabilizacion] DROP CONSTRAINT [PK_estabilizacion_IdEstabilizacion]
 GO



ALTER TABLE [dbo].[estabilizacion]
 ADD CONSTRAINT [PK_estabilizacion_IdEstabilizacion]
   PRIMARY KEY
   CLUSTERED ([IdEstabilizacion] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_factormodulacion_IdDecreto'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[factormodulacion] DROP CONSTRAINT [PK_factormodulacion_IdDecreto]
 GO



ALTER TABLE [dbo].[factormodulacion]
 ADD CONSTRAINT [PK_factormodulacion_IdDecreto]
   PRIMARY KEY
   CLUSTERED ([IdDecreto] ASC, [IdBarraNacional] ASC, [Tipo] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_factorreferenciacion_IdPuntoRetiro'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[factorreferenciacion] DROP CONSTRAINT [PK_factorreferenciacion_IdPuntoRetiro]
 GO



ALTER TABLE [dbo].[factorreferenciacion]
 ADD CONSTRAINT [PK_factorreferenciacion_IdPuntoRetiro]
   PRIMARY KEY
   CLUSTERED ([IdPuntoRetiro] ASC, [IdBarraNacional] ASC, [Periodo] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_generadora_IdGeneradora'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[generadora] DROP CONSTRAINT [PK_generadora_IdGeneradora]
 GO



ALTER TABLE [dbo].[generadora]
 ADD CONSTRAINT [PK_generadora_IdGeneradora]
   PRIMARY KEY
   CLUSTERED ([IdGeneradora] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_indexacioncet_IdLicitacionDx'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[indexacioncet] DROP CONSTRAINT [PK_indexacioncet_IdLicitacionDx]
 GO



ALTER TABLE [dbo].[indexacioncet]
 ADD CONSTRAINT [PK_indexacioncet_IdLicitacionDx]
   PRIMARY KEY
   CLUSTERED ([IdLicitacionDx] ASC, [IdGeneradora] ASC, [VersionIndex] ASC, [Version] ASC, [MesIndexacion] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_indexacioncombustible_IdIndexC'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[indexacioncombustible] DROP CONSTRAINT [PK_indexacioncombustible_IdIndexC]
 GO



ALTER TABLE [dbo].[indexacioncombustible]
 ADD CONSTRAINT [PK_indexacioncombustible_IdIndexC]
   PRIMARY KEY
   CLUSTERED ([IdIndexC] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_indexacioncontratofm_VersionIndex'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[indexacioncontratofm] DROP CONSTRAINT [PK_indexacioncontratofm_VersionIndex]
 GO



ALTER TABLE [dbo].[indexacioncontratofm]
 ADD CONSTRAINT [PK_indexacioncontratofm_VersionIndex]
   PRIMARY KEY
   CLUSTERED ([VersionIndex] ASC, [MesIndexacion] ASC, [Version] ASC, [IdCodigoContrato] ASC, [IdBarraNacional] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_indexacioncpi_IdCPI'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[indexacioncpi] DROP CONSTRAINT [PK_indexacioncpi_IdCPI]
 GO



ALTER TABLE [dbo].[indexacioncpi]
 ADD CONSTRAINT [PK_indexacioncpi_IdCPI]
   PRIMARY KEY
   CLUSTERED ([IdCPI] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_indexaciondolar_IdDolar'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[indexaciondolar] DROP CONSTRAINT [PK_indexaciondolar_IdDolar]
 GO



ALTER TABLE [dbo].[indexaciondolar]
 ADD CONSTRAINT [PK_indexaciondolar_IdDolar]
   PRIMARY KEY
   CLUSTERED ([IdDolar] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_indexacionipc_IdIPC'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[indexacionipc] DROP CONSTRAINT [PK_indexacionipc_IdIPC]
 GO



ALTER TABLE [dbo].[indexacionipc]
 ADD CONSTRAINT [PK_indexacionipc_IdIPC]
   PRIMARY KEY
   CLUSTERED ([IdIPC] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_indexadorescontratos_Version'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[indexadorescontratos] DROP CONSTRAINT [PK_indexadorescontratos_Version]
 GO



ALTER TABLE [dbo].[indexadorescontratos]
 ADD CONSTRAINT [PK_indexadorescontratos_Version]
   PRIMARY KEY
   CLUSTERED ([Version] ASC, [Fecha] ASC, [Tipo] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_licitacion_IdLicitacion'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[licitacion] DROP CONSTRAINT [PK_licitacion_IdLicitacion]
 GO



ALTER TABLE [dbo].[licitacion]
 ADD CONSTRAINT [PK_licitacion_IdLicitacion]
   PRIMARY KEY
   CLUSTERED ([IdLicitacion] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_licitaciondx_IdLicitacionDx'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[licitaciondx] DROP CONSTRAINT [PK_licitaciondx_IdLicitacionDx]
 GO



ALTER TABLE [dbo].[licitaciondx]
 ADD CONSTRAINT [PK_licitaciondx_IdLicitacionDx]
   PRIMARY KEY
   CLUSTERED ([IdLicitacionDx] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_licitaciongx_IdLicitacionGx'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[licitaciongx] DROP CONSTRAINT [PK_licitaciongx_IdLicitacionGx]
 GO



ALTER TABLE [dbo].[licitaciongx]
 ADD CONSTRAINT [PK_licitaciongx_IdLicitacionGx]
   PRIMARY KEY
   CLUSTERED ([IdLicitacionGx] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_licitaciongxdxptocompra_IdPtoCompra'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[licitaciongxdxptocompra] DROP CONSTRAINT [PK_licitaciongxdxptocompra_IdPtoCompra]
 GO



ALTER TABLE [dbo].[licitaciongxdxptocompra]
 ADD CONSTRAINT [PK_licitaciongxdxptocompra_IdPtoCompra]
   PRIMARY KEY
   CLUSTERED ([IdPtoCompra] ASC, [IdLicitacionGx] ASC, [IdLicitacionDx] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_licitaciongxindexacion_IdLicitacionGx'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[licitaciongxindexacion] DROP CONSTRAINT [PK_licitaciongxindexacion_IdLicitacionGx]
 GO



ALTER TABLE [dbo].[licitaciongxindexacion]
 ADD CONSTRAINT [PK_licitaciongxindexacion_IdLicitacionGx]
   PRIMARY KEY
   CLUSTERED ([IdLicitacionGx] ASC, [TipoIndex] ASC, [Index] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_licitaciongxindexesp_IdLicitacionGx'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[licitaciongxindexesp] DROP CONSTRAINT [PK_licitaciongxindexesp_IdLicitacionGx]
 GO



ALTER TABLE [dbo].[licitaciongxindexesp]
 ADD CONSTRAINT [PK_licitaciongxindexesp_IdLicitacionGx]
   PRIMARY KEY
   CLUSTERED ([IdLicitacionGx] ASC, [Tipo] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_perdidazonal_Fecha'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[perdidazonal] DROP CONSTRAINT [PK_perdidazonal_Fecha]
 GO



ALTER TABLE [dbo].[perdidazonal]
 ADD CONSTRAINT [PK_perdidazonal_Fecha]
   PRIMARY KEY
   CLUSTERED ([Fecha] ASC, [Version] ASC, [IdSistemaZonal] ASC, [TipoFactor] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_pncp_MES'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[pncp] DROP CONSTRAINT [PK_pncp_MES]
 GO



ALTER TABLE [dbo].[pncp]
 ADD CONSTRAINT [PK_pncp_MES]
   PRIMARY KEY
   CLUSTERED ([MES] ASC, [Version] ASC, [IdNudo] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_pnp_IdPNP'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[pnp] DROP CONSTRAINT [PK_pnp_IdPNP]
 GO



ALTER TABLE [dbo].[pnp]
 ADD CONSTRAINT [PK_pnp_IdPNP]
   PRIMARY KEY
   CLUSTERED ([IdPNP] ASC, [VersionIndex] ASC, [MesIndexacion] ASC, [Version] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_pnpindex_VersionIndex'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[pnpindex] DROP CONSTRAINT [PK_pnpindex_VersionIndex]
 GO



ALTER TABLE [dbo].[pnpindex]
 ADD CONSTRAINT [PK_pnpindex_VersionIndex]
   PRIMARY KEY
   CLUSTERED ([VersionIndex] ASC, [MesIndexacion] ASC, [Version] ASC, [IdCodigoContrato] ASC, [IdPtoOferta] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_pnptraspexc_VersionPNP'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[pnptraspexc] DROP CONSTRAINT [PK_pnptraspexc_VersionPNP]
 GO



ALTER TABLE [dbo].[pnptraspexc]
 ADD CONSTRAINT [PK_pnptraspexc_VersionPNP]
   PRIMARY KEY
   CLUSTERED ([VersionPNP] ASC, [Fecha] ASC, [Version] ASC, [IdCodigoContrato] ASC, [IdPtoOferta] ASC, [IdPtoCompra] ASC, [FechaCMG] ASC, [VersionCMg] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_precionudolicitacion_IdDecPNudo'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[precionudolicitacion] DROP CONSTRAINT [PK_precionudolicitacion_IdDecPNudo]
 GO



ALTER TABLE [dbo].[precionudolicitacion]
 ADD CONSTRAINT [PK_precionudolicitacion_IdDecPNudo]
   PRIMARY KEY
   CLUSTERED ([IdDecPNudo] ASC, [Tipo] ASC, [TipoDecreto] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_ptoretirosistema_IdPuntoRetiro'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[ptoretirosistema] DROP CONSTRAINT [PK_ptoretirosistema_IdPuntoRetiro]
 GO



ALTER TABLE [dbo].[ptoretirosistema]
 ADD CONSTRAINT [PK_ptoretirosistema_IdPuntoRetiro]
   PRIMARY KEY
   CLUSTERED ([IdPuntoRetiro] ASC, [IdSistemaZonal] ASC, [Ano] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_puntoretiro_IdPuntoRetiro'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[puntoretiro] DROP CONSTRAINT [PK_puntoretiro_IdPuntoRetiro]
 GO



ALTER TABLE [dbo].[puntoretiro]
 ADD CONSTRAINT [PK_puntoretiro_IdPuntoRetiro]
   PRIMARY KEY
   CLUSTERED ([IdPuntoRetiro] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_recaudaciondetalle_IdVersion'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[recaudaciondetalle] DROP CONSTRAINT [PK_recaudaciondetalle_IdVersion]
 GO



ALTER TABLE [dbo].[recaudaciondetalle]
 ADD CONSTRAINT [PK_recaudaciondetalle_IdVersion]
   PRIMARY KEY
   CLUSTERED ([IdVersion] ASC, [IdEfact] ASC, [IdPuntoRetiro] ASC, [IdBarraNacionalFR] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_sistemazonal_IdSistemaZonal'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[sistemazonal] DROP CONSTRAINT [PK_sistemazonal_IdSistemaZonal]
 GO



ALTER TABLE [dbo].[sistemazonal]
 ADD CONSTRAINT [PK_sistemazonal_IdSistemaZonal]
   PRIMARY KEY
   CLUSTERED ([IdSistemaZonal] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_tipocombustible_IdTipoCombustible'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[tipocombustible] DROP CONSTRAINT [PK_tipocombustible_IdTipoCombustible]
 GO



ALTER TABLE [dbo].[tipocombustible]
 ADD CONSTRAINT [PK_tipocombustible_IdTipoCombustible]
   PRIMARY KEY
   CLUSTERED ([IdTipoCombustible] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_tipodespacho_IdTipoDEspacho'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[tipodespacho] DROP CONSTRAINT [PK_tipodespacho_IdTipoDEspacho]
 GO



ALTER TABLE [dbo].[tipodespacho]
 ADD CONSTRAINT [PK_tipodespacho_IdTipoDEspacho]
   PRIMARY KEY
   CLUSTERED ([IdTipoDEspacho] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_versionefact_IdVersion'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[versionefact] DROP CONSTRAINT [PK_versionefact_IdVersion]
 GO



ALTER TABLE [dbo].[versionefact]
 ADD CONSTRAINT [PK_versionefact_IdVersion]
   PRIMARY KEY
   CLUSTERED ([IdVersion] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_versionestabilizacion_IdVersionEstabilizacion'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[versionestabilizacion] DROP CONSTRAINT [PK_versionestabilizacion_IdVersionEstabilizacion]
 GO



ALTER TABLE [dbo].[versionestabilizacion]
 ADD CONSTRAINT [PK_versionestabilizacion_IdVersionEstabilizacion]
   PRIMARY KEY
   CLUSTERED ([IdVersionEstabilizacion] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_versionrec_IdVersion'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[versionrec] DROP CONSTRAINT [PK_versionrec_IdVersion]
 GO



ALTER TABLE [dbo].[versionrec]
 ADD CONSTRAINT [PK_versionrec_IdVersion]
   PRIMARY KEY
   CLUSTERED ([IdVersion] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'PK_versionrecdetalle_IdVersion'  AND sc.name = N'dbo'  AND type in (N'PK'))
ALTER TABLE [dbo].[versionrecdetalle] DROP CONSTRAINT [PK_versionrecdetalle_IdVersion]
 GO



ALTER TABLE [dbo].[versionrecdetalle]
 ADD CONSTRAINT [PK_versionrecdetalle_IdVersion]
   PRIMARY KEY
   CLUSTERED ([IdVersion] ASC, [Registro] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'cet$IdLicitacionDx_UNIQUE'  AND sc.name = N'dbo'  AND type in (N'UQ'))
ALTER TABLE [dbo].[cet] DROP CONSTRAINT [cet$IdLicitacionDx_UNIQUE]
 GO



ALTER TABLE [dbo].[cet]
 ADD CONSTRAINT [cet$IdLicitacionDx_UNIQUE]
 UNIQUE 
   NONCLUSTERED ([IdLicitacionDx] ASC, [IdGeneradora] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'codigocontrato$Licitacion_UNIQUE'  AND sc.name = N'dbo'  AND type in (N'UQ'))
ALTER TABLE [dbo].[codigocontrato] DROP CONSTRAINT [codigocontrato$Licitacion_UNIQUE]
 GO



ALTER TABLE [dbo].[codigocontrato]
 ADD CONSTRAINT [codigocontrato$Licitacion_UNIQUE]
 UNIQUE 
   NONCLUSTERED ([Licitacion] ASC, [TipoBloque] ASC, [Bloque] ASC, [IdDistribuidora] ASC, [IdGeneradora] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'decreto$Nombre_UNIQUE'  AND sc.name = N'dbo'  AND type in (N'UQ'))
ALTER TABLE [dbo].[decreto] DROP CONSTRAINT [decreto$Nombre_UNIQUE]
 GO



ALTER TABLE [dbo].[decreto]
 ADD CONSTRAINT [decreto$Nombre_UNIQUE]
 UNIQUE 
   NONCLUSTERED ([Nombre] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'demanda$Version_UNIQUE'  AND sc.name = N'dbo'  AND type in (N'UQ'))
ALTER TABLE [dbo].[demanda] DROP CONSTRAINT [demanda$Version_UNIQUE]
 GO



ALTER TABLE [dbo].[demanda]
 ADD CONSTRAINT [demanda$Version_UNIQUE]
 UNIQUE 
   NONCLUSTERED ([Version] ASC, [IdDistribuidora] ASC, [Mes] ASC, [IdSistemaZonal] ASC, [IdPuntoRetiro] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'difxcompras$IdCodigoContrato_UNIQUE'  AND sc.name = N'dbo'  AND type in (N'UQ'))
ALTER TABLE [dbo].[difxcompras] DROP CONSTRAINT [difxcompras$IdCodigoContrato_UNIQUE]
 GO



ALTER TABLE [dbo].[difxcompras]
 ADD CONSTRAINT [difxcompras$IdCodigoContrato_UNIQUE]
 UNIQUE 
   NONCLUSTERED ([IdCodigoContrato] ASC, [IdSistemaZonal] ASC, [IdGeneradora] ASC, [IdDistribuidora] ASC, [Version] ASC, [Fecha] ASC)

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'difxcompras$Fecha_UNIQUE'  AND sc.name = N'dbo'  AND type in (N'UQ'))
ALTER TABLE [dbo].[difxcompras] DROP CONSTRAINT [difxcompras$Fecha_UNIQUE]
 GO



ALTER TABLE [dbo].[difxcompras]
 ADD CONSTRAINT [difxcompras$Fecha_UNIQUE]
 UNIQUE 
   NONCLUSTERED ([Fecha] ASC, [Version] ASC, [IdDistribuidora] ASC, [IdGeneradora] ASC, [IdSistemaZonal] ASC, [IdCodigoContrato] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'eadjanual$IdCodigoContrato_UNIQUE'  AND sc.name = N'dbo'  AND type in (N'UQ'))
ALTER TABLE [dbo].[eadjanual] DROP CONSTRAINT [eadjanual$IdCodigoContrato_UNIQUE]
 GO



ALTER TABLE [dbo].[eadjanual]
 ADD CONSTRAINT [eadjanual$IdCodigoContrato_UNIQUE]
 UNIQUE 
   NONCLUSTERED ([IdCodigoContrato] ASC, [IdPtoCompra] ASC, [Ano] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'eadjanualdistrmensual$IdCodigoContrato_UNIQUE'  AND sc.name = N'dbo'  AND type in (N'UQ'))
ALTER TABLE [dbo].[eadjanualdistrmensual] DROP CONSTRAINT [eadjanualdistrmensual$IdCodigoContrato_UNIQUE]
 GO



ALTER TABLE [dbo].[eadjanualdistrmensual]
 ADD CONSTRAINT [eadjanualdistrmensual$IdCodigoContrato_UNIQUE]
 UNIQUE 
   NONCLUSTERED ([IdCodigoContrato] ASC, [IdPtoCompra] ASC, [Fecha] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'efact$IdVersion_UNIQUE'  AND sc.name = N'dbo'  AND type in (N'UQ'))
ALTER TABLE [dbo].[efact] DROP CONSTRAINT [efact$IdVersion_UNIQUE]
 GO



ALTER TABLE [dbo].[efact]
 ADD CONSTRAINT [efact$IdVersion_UNIQUE]
 UNIQUE 
   NONCLUSTERED ([IdVersion] ASC, [Fecha] ASC, [IdGeneradora] ASC, [IdDistribuidora] ASC, [IdCodigoContrato] ASC, [IdPuntoRetiro] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'factormodulacion$IdDecreto_UNIQUE'  AND sc.name = N'dbo'  AND type in (N'UQ'))
ALTER TABLE [dbo].[factormodulacion] DROP CONSTRAINT [factormodulacion$IdDecreto_UNIQUE]
 GO



ALTER TABLE [dbo].[factormodulacion]
 ADD CONSTRAINT [factormodulacion$IdDecreto_UNIQUE]
 UNIQUE 
   NONCLUSTERED ([IdDecreto] ASC, [Tipo] ASC, [IdBarraNacional] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'factorreferenciacion$IdPuntoRetiro_UNIQUE'  AND sc.name = N'dbo'  AND type in (N'UQ'))
ALTER TABLE [dbo].[factorreferenciacion] DROP CONSTRAINT [factorreferenciacion$IdPuntoRetiro_UNIQUE]
 GO



ALTER TABLE [dbo].[factorreferenciacion]
 ADD CONSTRAINT [factorreferenciacion$IdPuntoRetiro_UNIQUE]
 UNIQUE 
   NONCLUSTERED ([IdPuntoRetiro] ASC, [IdBarraNacional] ASC, [Periodo] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'indexacioncet$IdLicitacionDx_UNIQUE'  AND sc.name = N'dbo'  AND type in (N'UQ'))
ALTER TABLE [dbo].[indexacioncet] DROP CONSTRAINT [indexacioncet$IdLicitacionDx_UNIQUE]
 GO



ALTER TABLE [dbo].[indexacioncet]
 ADD CONSTRAINT [indexacioncet$IdLicitacionDx_UNIQUE]
 UNIQUE 
   NONCLUSTERED ([IdLicitacionDx] ASC, [IdGeneradora] ASC, [VersionIndex] ASC, [MesIndexacion] ASC, [Version] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'indexacioncombustible$Fecha_UNIQUE'  AND sc.name = N'dbo'  AND type in (N'UQ'))
ALTER TABLE [dbo].[indexacioncombustible] DROP CONSTRAINT [indexacioncombustible$Fecha_UNIQUE]
 GO



ALTER TABLE [dbo].[indexacioncombustible]
 ADD CONSTRAINT [indexacioncombustible$Fecha_UNIQUE]
 UNIQUE 
   NONCLUSTERED ([Fecha] ASC, [IdTipoCombustible] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'indexacioncpi$Fecha_UNIQUE'  AND sc.name = N'dbo'  AND type in (N'UQ'))
ALTER TABLE [dbo].[indexacioncpi] DROP CONSTRAINT [indexacioncpi$Fecha_UNIQUE]
 GO



ALTER TABLE [dbo].[indexacioncpi]
 ADD CONSTRAINT [indexacioncpi$Fecha_UNIQUE]
 UNIQUE 
   NONCLUSTERED ([Fecha] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'indexaciondolar$Fecha_UNIQUE'  AND sc.name = N'dbo'  AND type in (N'UQ'))
ALTER TABLE [dbo].[indexaciondolar] DROP CONSTRAINT [indexaciondolar$Fecha_UNIQUE]
 GO



ALTER TABLE [dbo].[indexaciondolar]
 ADD CONSTRAINT [indexaciondolar$Fecha_UNIQUE]
 UNIQUE 
   NONCLUSTERED ([Fecha] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'indexacionipc$Fecha_UNIQUE'  AND sc.name = N'dbo'  AND type in (N'UQ'))
ALTER TABLE [dbo].[indexacionipc] DROP CONSTRAINT [indexacionipc$Fecha_UNIQUE]
 GO



ALTER TABLE [dbo].[indexacionipc]
 ADD CONSTRAINT [indexacionipc$Fecha_UNIQUE]
 UNIQUE 
   NONCLUSTERED ([Fecha] ASC, [AnoBase] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'licitaciondx$IdLicitacion_UNIQUE'  AND sc.name = N'dbo'  AND type in (N'UQ'))
ALTER TABLE [dbo].[licitaciondx] DROP CONSTRAINT [licitaciondx$IdLicitacion_UNIQUE]
 GO



ALTER TABLE [dbo].[licitaciondx]
 ADD CONSTRAINT [licitaciondx$IdLicitacion_UNIQUE]
 UNIQUE 
   NONCLUSTERED ([IdLicitacion] ASC, [IdDistribuidora] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'licitaciongx$IdLicitacion_UNIQUE'  AND sc.name = N'dbo'  AND type in (N'UQ'))
ALTER TABLE [dbo].[licitaciongx] DROP CONSTRAINT [licitaciongx$IdLicitacion_UNIQUE]
 GO



ALTER TABLE [dbo].[licitaciongx]
 ADD CONSTRAINT [licitaciongx$IdLicitacion_UNIQUE]
 UNIQUE 
   NONCLUSTERED ([IdLicitacion] ASC, [IdGeneradora] ASC, [TipoBloque] ASC, [Bloque] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'licitaciongxdxptocompra$IdLicitacionDx_UNIQUE'  AND sc.name = N'dbo'  AND type in (N'UQ'))
ALTER TABLE [dbo].[licitaciongxdxptocompra] DROP CONSTRAINT [licitaciongxdxptocompra$IdLicitacionDx_UNIQUE]
 GO



ALTER TABLE [dbo].[licitaciongxdxptocompra]
 ADD CONSTRAINT [licitaciongxdxptocompra$IdLicitacionDx_UNIQUE]
 UNIQUE 
   NONCLUSTERED ([IdLicitacionDx] ASC, [IdLicitacionGx] ASC, [IdPtoCompra] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'licitaciongxindexacion$IdGeneradora_UNIQUE'  AND sc.name = N'dbo'  AND type in (N'UQ'))
ALTER TABLE [dbo].[licitaciongxindexacion] DROP CONSTRAINT [licitaciongxindexacion$IdGeneradora_UNIQUE]
 GO



ALTER TABLE [dbo].[licitaciongxindexacion]
 ADD CONSTRAINT [licitaciongxindexacion$IdGeneradora_UNIQUE]
 UNIQUE 
   NONCLUSTERED ([IdLicitacionGx] ASC, [TipoIndex] ASC, [Index] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'perdidazonal$Fecha_UNIQUE'  AND sc.name = N'dbo'  AND type in (N'UQ'))
ALTER TABLE [dbo].[perdidazonal] DROP CONSTRAINT [perdidazonal$Fecha_UNIQUE]
 GO



ALTER TABLE [dbo].[perdidazonal]
 ADD CONSTRAINT [perdidazonal$Fecha_UNIQUE]
 UNIQUE 
   NONCLUSTERED ([Fecha] ASC, [Version] ASC, [IdSistemaZonal] ASC, [TipoFactor] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'pnp$VersionIndex_UNIQUE'  AND sc.name = N'dbo'  AND type in (N'UQ'))
ALTER TABLE [dbo].[pnp] DROP CONSTRAINT [pnp$VersionIndex_UNIQUE]
 GO



ALTER TABLE [dbo].[pnp]
 ADD CONSTRAINT [pnp$VersionIndex_UNIQUE]
 UNIQUE 
   NONCLUSTERED ([VersionIndex] ASC, [MesIndexacion] ASC, [Version] ASC, [IdCodigoContrato] ASC, [IdBarraNacional] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'pnpindex$VersionIndex_UNIQUE'  AND sc.name = N'dbo'  AND type in (N'UQ'))
ALTER TABLE [dbo].[pnpindex] DROP CONSTRAINT [pnpindex$VersionIndex_UNIQUE]
 GO



ALTER TABLE [dbo].[pnpindex]
 ADD CONSTRAINT [pnpindex$VersionIndex_UNIQUE]
 UNIQUE 
   NONCLUSTERED ([VersionIndex] ASC, [MesIndexacion] ASC, [Version] ASC, [IdCodigoContrato] ASC, [IdPtoOferta] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'precionudolicitacion$IdDecPNudo_UNIQUE'  AND sc.name = N'dbo'  AND type in (N'UQ'))
ALTER TABLE [dbo].[precionudolicitacion] DROP CONSTRAINT [precionudolicitacion$IdDecPNudo_UNIQUE]
 GO



ALTER TABLE [dbo].[precionudolicitacion]
 ADD CONSTRAINT [precionudolicitacion$IdDecPNudo_UNIQUE]
 UNIQUE 
   NONCLUSTERED ([IdDecPNudo] ASC, [Tipo] ASC, [TipoDecreto] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'ptoretirosistema$IdPuntoRetiro_UNIQUE'  AND sc.name = N'dbo'  AND type in (N'UQ'))
ALTER TABLE [dbo].[ptoretirosistema] DROP CONSTRAINT [ptoretirosistema$IdPuntoRetiro_UNIQUE]
 GO



ALTER TABLE [dbo].[ptoretirosistema]
 ADD CONSTRAINT [ptoretirosistema$IdPuntoRetiro_UNIQUE]
 UNIQUE 
   NONCLUSTERED ([IdPuntoRetiro] ASC)

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'ptoretirosistema$Ano_UNIQUE'  AND sc.name = N'dbo'  AND type in (N'UQ'))
ALTER TABLE [dbo].[ptoretirosistema] DROP CONSTRAINT [ptoretirosistema$Ano_UNIQUE]
 GO



ALTER TABLE [dbo].[ptoretirosistema]
 ADD CONSTRAINT [ptoretirosistema$Ano_UNIQUE]
 UNIQUE 
   NONCLUSTERED ([Ano] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'recaudaciondetalle$IdVersionEFact_UNIQUE'  AND sc.name = N'dbo'  AND type in (N'UQ'))
ALTER TABLE [dbo].[recaudaciondetalle] DROP CONSTRAINT [recaudaciondetalle$IdVersionEFact_UNIQUE]
 GO



ALTER TABLE [dbo].[recaudaciondetalle]
 ADD CONSTRAINT [recaudaciondetalle$IdVersionEFact_UNIQUE]
 UNIQUE 
   NONCLUSTERED ([IdVersionEFact] ASC, [IdVersion] ASC, [FechaEFact] ASC, [IdDistribuidora] ASC, [IdGeneradora] ASC, [IdCodigoContrato] ASC, [IdSistemaZonal] ASC, [PNP_VersionIndex] ASC, [PNP_MesIndexacion] ASC, [PNP_Version] ASC, [PNCP_Mes] ASC, [PNCP_Version] ASC, [IdBarraNacionalFR] ASC, [IdPuntoRetiro] ASC)

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'versionrecdetalle$Registro_UNIQUE'  AND sc.name = N'dbo'  AND type in (N'UQ'))
ALTER TABLE [dbo].[versionrecdetalle] DROP CONSTRAINT [versionrecdetalle$Registro_UNIQUE]
 GO



ALTER TABLE [dbo].[versionrecdetalle]
 ADD CONSTRAINT [versionrecdetalle$Registro_UNIQUE]
 UNIQUE 
   NONCLUSTERED ([IdVersion] ASC, [Registro] ASC)

GO


USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'cet'  AND sc.name = N'dbo'  AND si.name = N'fk_CET_Generadora1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_CET_Generadora1_idx] ON [dbo].[cet] 
GO
CREATE NONCLUSTERED INDEX [fk_CET_Generadora1_idx] ON [dbo].[cet]
(
   [IdGeneradora] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'cetcp'  AND sc.name = N'dbo'  AND si.name = N'fk_CETCP_Distribuidora2_idx' AND so.type in (N'U'))
   DROP INDEX [fk_CETCP_Distribuidora2_idx] ON [dbo].[cetcp] 
GO
CREATE NONCLUSTERED INDEX [fk_CETCP_Distribuidora2_idx] ON [dbo].[cetcp]
(
   [IdDistribuidora] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'cetcp'  AND sc.name = N'dbo'  AND si.name = N'fk_CETCP_Generadora2_idx' AND so.type in (N'U'))
   DROP INDEX [fk_CETCP_Generadora2_idx] ON [dbo].[cetcp] 
GO
CREATE NONCLUSTERED INDEX [fk_CETCP_Generadora2_idx] ON [dbo].[cetcp]
(
   [IdGeneradora] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'cmgpromedio'  AND sc.name = N'dbo'  AND si.name = N'fk_CMGPromedio_BarraNacional1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_CMGPromedio_BarraNacional1_idx] ON [dbo].[cmgpromedio] 
GO
CREATE NONCLUSTERED INDEX [fk_CMGPromedio_BarraNacional1_idx] ON [dbo].[cmgpromedio]
(
   [IdBarraNacional] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'codigocontrato'  AND sc.name = N'dbo'  AND si.name = N'fk_CodigoContrato_Distribuidora1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_CodigoContrato_Distribuidora1_idx] ON [dbo].[codigocontrato] 
GO
CREATE NONCLUSTERED INDEX [fk_CodigoContrato_Distribuidora1_idx] ON [dbo].[codigocontrato]
(
   [IdDistribuidora] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'codigocontrato'  AND sc.name = N'dbo'  AND si.name = N'fk_CodigoContrato_Generadora_idx' AND so.type in (N'U'))
   DROP INDEX [fk_CodigoContrato_Generadora_idx] ON [dbo].[codigocontrato] 
GO
CREATE NONCLUSTERED INDEX [fk_CodigoContrato_Generadora_idx] ON [dbo].[codigocontrato]
(
   [IdGeneradora] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'codigocontrato'  AND sc.name = N'dbo'  AND si.name = N'fk_CodigoContrato_Licitacion1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_CodigoContrato_Licitacion1_idx] ON [dbo].[codigocontrato] 
GO
CREATE NONCLUSTERED INDEX [fk_CodigoContrato_Licitacion1_idx] ON [dbo].[codigocontrato]
(
   [IdLicitacion] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'demanda'  AND sc.name = N'dbo'  AND si.name = N'fk_Demanda_Distribuidora1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_Demanda_Distribuidora1_idx] ON [dbo].[demanda] 
GO
CREATE NONCLUSTERED INDEX [fk_Demanda_Distribuidora1_idx] ON [dbo].[demanda]
(
   [IdDistribuidora] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'demanda'  AND sc.name = N'dbo'  AND si.name = N'fk_Demanda_PuntoRetiro1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_Demanda_PuntoRetiro1_idx] ON [dbo].[demanda] 
GO
CREATE NONCLUSTERED INDEX [fk_Demanda_PuntoRetiro1_idx] ON [dbo].[demanda]
(
   [IdPuntoRetiro] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'demanda'  AND sc.name = N'dbo'  AND si.name = N'fk_Demanda_SistemaZonal1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_Demanda_SistemaZonal1_idx] ON [dbo].[demanda] 
GO
CREATE NONCLUSTERED INDEX [fk_Demanda_SistemaZonal1_idx] ON [dbo].[demanda]
(
   [IdSistemaZonal] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'difxcompras'  AND sc.name = N'dbo'  AND si.name = N'fk_DifxCompras_CodigoContrato1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_DifxCompras_CodigoContrato1_idx] ON [dbo].[difxcompras] 
GO
CREATE NONCLUSTERED INDEX [fk_DifxCompras_CodigoContrato1_idx] ON [dbo].[difxcompras]
(
   [IdCodigoContrato] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'difxcompras'  AND sc.name = N'dbo'  AND si.name = N'fk_DifxCompras_Distribuidora1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_DifxCompras_Distribuidora1_idx] ON [dbo].[difxcompras] 
GO
CREATE NONCLUSTERED INDEX [fk_DifxCompras_Distribuidora1_idx] ON [dbo].[difxcompras]
(
   [IdDistribuidora] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'difxcompras'  AND sc.name = N'dbo'  AND si.name = N'fk_DifxCompras_Generadora1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_DifxCompras_Generadora1_idx] ON [dbo].[difxcompras] 
GO
CREATE NONCLUSTERED INDEX [fk_DifxCompras_Generadora1_idx] ON [dbo].[difxcompras]
(
   [IdGeneradora] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'difxcompras'  AND sc.name = N'dbo'  AND si.name = N'fk_DifxCompras_SistemaZonal1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_DifxCompras_SistemaZonal1_idx] ON [dbo].[difxcompras] 
GO
CREATE NONCLUSTERED INDEX [fk_DifxCompras_SistemaZonal1_idx] ON [dbo].[difxcompras]
(
   [IdSistemaZonal] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'eadjanual'  AND sc.name = N'dbo'  AND si.name = N'fk_EAdjAnual_BarraNacional1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_EAdjAnual_BarraNacional1_idx] ON [dbo].[eadjanual] 
GO
CREATE NONCLUSTERED INDEX [fk_EAdjAnual_BarraNacional1_idx] ON [dbo].[eadjanual]
(
   [IdPtoCompra] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'eadjanual'  AND sc.name = N'dbo'  AND si.name = N'fk_EAdjAnual_CodigoContrato1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_EAdjAnual_CodigoContrato1_idx] ON [dbo].[eadjanual] 
GO
CREATE NONCLUSTERED INDEX [fk_EAdjAnual_CodigoContrato1_idx] ON [dbo].[eadjanual]
(
   [IdCodigoContrato] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'eadjanualdistrmensual'  AND sc.name = N'dbo'  AND si.name = N'fk_EAdjAnualDistrMensual_BarraNacional1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_EAdjAnualDistrMensual_BarraNacional1_idx] ON [dbo].[eadjanualdistrmensual] 
GO
CREATE NONCLUSTERED INDEX [fk_EAdjAnualDistrMensual_BarraNacional1_idx] ON [dbo].[eadjanualdistrmensual]
(
   [IdPtoCompra] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'eadjanualdistrmensual'  AND sc.name = N'dbo'  AND si.name = N'fk_EAdjAnualDistrMensual_CodigoContrato1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_EAdjAnualDistrMensual_CodigoContrato1_idx] ON [dbo].[eadjanualdistrmensual] 
GO
CREATE NONCLUSTERED INDEX [fk_EAdjAnualDistrMensual_CodigoContrato1_idx] ON [dbo].[eadjanualdistrmensual]
(
   [IdCodigoContrato] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'efact'  AND sc.name = N'dbo'  AND si.name = N'fk_EFACT_CodigoContrato1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_EFACT_CodigoContrato1_idx] ON [dbo].[efact] 
GO
CREATE NONCLUSTERED INDEX [fk_EFACT_CodigoContrato1_idx] ON [dbo].[efact]
(
   [IdCodigoContrato] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'efact'  AND sc.name = N'dbo'  AND si.name = N'fk_EFACT_Distribuidora1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_EFACT_Distribuidora1_idx] ON [dbo].[efact] 
GO
CREATE NONCLUSTERED INDEX [fk_EFACT_Distribuidora1_idx] ON [dbo].[efact]
(
   [IdDistribuidora] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'efact'  AND sc.name = N'dbo'  AND si.name = N'fk_EFACT_Generadora1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_EFACT_Generadora1_idx] ON [dbo].[efact] 
GO
CREATE NONCLUSTERED INDEX [fk_EFACT_Generadora1_idx] ON [dbo].[efact]
(
   [IdGeneradora] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'efact'  AND sc.name = N'dbo'  AND si.name = N'fk_EFACT_PuntoRetiro1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_EFACT_PuntoRetiro1_idx] ON [dbo].[efact] 
GO
CREATE NONCLUSTERED INDEX [fk_EFACT_PuntoRetiro1_idx] ON [dbo].[efact]
(
   [IdPuntoRetiro] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'efact'  AND sc.name = N'dbo'  AND si.name = N'fk_EFACT_TipoDespacho1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_EFACT_TipoDespacho1_idx] ON [dbo].[efact] 
GO
CREATE NONCLUSTERED INDEX [fk_EFACT_TipoDespacho1_idx] ON [dbo].[efact]
(
   [IdTipoDespacho] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'recaudaciondetalle'  AND sc.name = N'dbo'  AND si.name = N'fk_EfactPNP_CodigoContrato1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_EfactPNP_CodigoContrato1_idx] ON [dbo].[recaudaciondetalle] 
GO
CREATE NONCLUSTERED INDEX [fk_EfactPNP_CodigoContrato1_idx] ON [dbo].[recaudaciondetalle]
(
   [IdCodigoContrato] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'recaudaciondetalle'  AND sc.name = N'dbo'  AND si.name = N'fk_EfactPNP_Distribuidora1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_EfactPNP_Distribuidora1_idx] ON [dbo].[recaudaciondetalle] 
GO
CREATE NONCLUSTERED INDEX [fk_EfactPNP_Distribuidora1_idx] ON [dbo].[recaudaciondetalle]
(
   [IdDistribuidora] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'recaudaciondetalle'  AND sc.name = N'dbo'  AND si.name = N'fk_EfactPNP_Generadora1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_EfactPNP_Generadora1_idx] ON [dbo].[recaudaciondetalle] 
GO
CREATE NONCLUSTERED INDEX [fk_EfactPNP_Generadora1_idx] ON [dbo].[recaudaciondetalle]
(
   [IdGeneradora] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'recaudaciondetalle'  AND sc.name = N'dbo'  AND si.name = N'fk_EfactPNP_PerdidaZonal1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_EfactPNP_PerdidaZonal1_idx] ON [dbo].[recaudaciondetalle] 
GO
CREATE NONCLUSTERED INDEX [fk_EfactPNP_PerdidaZonal1_idx] ON [dbo].[recaudaciondetalle]
(
   [FechaPZ] ASC,
   [VersionPZ] ASC,
   [IdSistemaZonal] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'recaudaciondetalle'  AND sc.name = N'dbo'  AND si.name = N'fk_EfactPNP_TipoDespacho1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_EfactPNP_TipoDespacho1_idx] ON [dbo].[recaudaciondetalle] 
GO
CREATE NONCLUSTERED INDEX [fk_EfactPNP_TipoDespacho1_idx] ON [dbo].[recaudaciondetalle]
(
   [IdTipoDespacho] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'recaudaciondetalle'  AND sc.name = N'dbo'  AND si.name = N'fk_EfactPNP_VersionERec1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_EfactPNP_VersionERec1_idx] ON [dbo].[recaudaciondetalle] 
GO
CREATE NONCLUSTERED INDEX [fk_EfactPNP_VersionERec1_idx] ON [dbo].[recaudaciondetalle]
(
   [IdVersion] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'estabilizaciondetalle'  AND sc.name = N'dbo'  AND si.name = N'fk_EstabilizacionDetalle_TipoDespacho1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_EstabilizacionDetalle_TipoDespacho1_idx] ON [dbo].[estabilizaciondetalle] 
GO
CREATE NONCLUSTERED INDEX [fk_EstabilizacionDetalle_TipoDespacho1_idx] ON [dbo].[estabilizaciondetalle]
(
   [IdTipoDEspacho] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'estabilizaciondetalle'  AND sc.name = N'dbo'  AND si.name = N'fk_EstabilizacionDetalle_VersionEstabilizacion1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_EstabilizacionDetalle_VersionEstabilizacion1_idx] ON [dbo].[estabilizaciondetalle] 
GO
CREATE NONCLUSTERED INDEX [fk_EstabilizacionDetalle_VersionEstabilizacion1_idx] ON [dbo].[estabilizaciondetalle]
(
   [IdVersionEstabilizacion] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'factormodulacion'  AND sc.name = N'dbo'  AND si.name = N'fk_FactorModulacion_BarraNacional1' AND so.type in (N'U'))
   DROP INDEX [fk_FactorModulacion_BarraNacional1] ON [dbo].[factormodulacion] 
GO
CREATE NONCLUSTERED INDEX [fk_FactorModulacion_BarraNacional1] ON [dbo].[factormodulacion]
(
   [IdBarraNacional] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'factormodulacion'  AND sc.name = N'dbo'  AND si.name = N'fk_FactorModulacion_Decreto1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_FactorModulacion_Decreto1_idx] ON [dbo].[factormodulacion] 
GO
CREATE NONCLUSTERED INDEX [fk_FactorModulacion_Decreto1_idx] ON [dbo].[factormodulacion]
(
   [IdDecreto] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'factorreferenciacion'  AND sc.name = N'dbo'  AND si.name = N'fk_FactorReferenciacion_BarraNacional1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_FactorReferenciacion_BarraNacional1_idx] ON [dbo].[factorreferenciacion] 
GO
CREATE NONCLUSTERED INDEX [fk_FactorReferenciacion_BarraNacional1_idx] ON [dbo].[factorreferenciacion]
(
   [IdBarraNacional] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'factorreferenciacion'  AND sc.name = N'dbo'  AND si.name = N'fk_FactorReferenciacion_PuntoRetiro1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_FactorReferenciacion_PuntoRetiro1_idx] ON [dbo].[factorreferenciacion] 
GO
CREATE NONCLUSTERED INDEX [fk_FactorReferenciacion_PuntoRetiro1_idx] ON [dbo].[factorreferenciacion]
(
   [IdPuntoRetiro] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'indexacioncombustible'  AND sc.name = N'dbo'  AND si.name = N'fk_IndexacionCombustible_TipoCombustible1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_IndexacionCombustible_TipoCombustible1_idx] ON [dbo].[indexacioncombustible] 
GO
CREATE NONCLUSTERED INDEX [fk_IndexacionCombustible_TipoCombustible1_idx] ON [dbo].[indexacioncombustible]
(
   [IdTipoCombustible] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'indexacioncontrato'  AND sc.name = N'dbo'  AND si.name = N'fk_IndexacionContratoDetalle_LicitacionGx1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_IndexacionContratoDetalle_LicitacionGx1_idx] ON [dbo].[indexacioncontrato] 
GO
CREATE NONCLUSTERED INDEX [fk_IndexacionContratoDetalle_LicitacionGx1_idx] ON [dbo].[indexacioncontrato]
(
   [IdLicitacionGx] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'indexacioncontratodetalle'  AND sc.name = N'dbo'  AND si.name = N'fk_IndexacionContratoDetalle_LicitacionGx1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_IndexacionContratoDetalle_LicitacionGx1_idx] ON [dbo].[indexacioncontratodetalle] 
GO
CREATE NONCLUSTERED INDEX [fk_IndexacionContratoDetalle_LicitacionGx1_idx] ON [dbo].[indexacioncontratodetalle]
(
   [IdLicitacionGx] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'indexacioncontratofm'  AND sc.name = N'dbo'  AND si.name = N'fk_IndexacionContratoFM_BarraNacional1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_IndexacionContratoFM_BarraNacional1_idx] ON [dbo].[indexacioncontratofm] 
GO
CREATE NONCLUSTERED INDEX [fk_IndexacionContratoFM_BarraNacional1_idx] ON [dbo].[indexacioncontratofm]
(
   [IdPtoOferta] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'pnpindex'  AND sc.name = N'dbo'  AND si.name = N'fk_IndexacionContratoFM_BarraNacional2_idx' AND so.type in (N'U'))
   DROP INDEX [fk_IndexacionContratoFM_BarraNacional2_idx] ON [dbo].[pnpindex] 
GO
CREATE NONCLUSTERED INDEX [fk_IndexacionContratoFM_BarraNacional2_idx] ON [dbo].[pnpindex]
(
   [IdPtoOferta] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'pnp'  AND sc.name = N'dbo'  AND si.name = N'fk_IndexacionContratoFM_BarraNacional2_idx' AND so.type in (N'U'))
   DROP INDEX [fk_IndexacionContratoFM_BarraNacional2_idx] ON [dbo].[pnp] 
GO
CREATE NONCLUSTERED INDEX [fk_IndexacionContratoFM_BarraNacional2_idx] ON [dbo].[pnp]
(
   [IdBarraNacional] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'indexacioncontratofm'  AND sc.name = N'dbo'  AND si.name = N'fk_IndexacionContratoFM_BarraNacional2_idx' AND so.type in (N'U'))
   DROP INDEX [fk_IndexacionContratoFM_BarraNacional2_idx] ON [dbo].[indexacioncontratofm] 
GO
CREATE NONCLUSTERED INDEX [fk_IndexacionContratoFM_BarraNacional2_idx] ON [dbo].[indexacioncontratofm]
(
   [IdBarraNacional] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'pnpindex'  AND sc.name = N'dbo'  AND si.name = N'fk_IndexacionContratoFM_CodigoContrato1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_IndexacionContratoFM_CodigoContrato1_idx] ON [dbo].[pnpindex] 
GO
CREATE NONCLUSTERED INDEX [fk_IndexacionContratoFM_CodigoContrato1_idx] ON [dbo].[pnpindex]
(
   [IdCodigoContrato] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'pnp'  AND sc.name = N'dbo'  AND si.name = N'fk_IndexacionContratoFM_CodigoContrato1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_IndexacionContratoFM_CodigoContrato1_idx] ON [dbo].[pnp] 
GO
CREATE NONCLUSTERED INDEX [fk_IndexacionContratoFM_CodigoContrato1_idx] ON [dbo].[pnp]
(
   [IdCodigoContrato] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'indexacioncontratofm'  AND sc.name = N'dbo'  AND si.name = N'fk_IndexacionContratoFM_CodigoContrato1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_IndexacionContratoFM_CodigoContrato1_idx] ON [dbo].[indexacioncontratofm] 
GO
CREATE NONCLUSTERED INDEX [fk_IndexacionContratoFM_CodigoContrato1_idx] ON [dbo].[indexacioncontratofm]
(
   [IdCodigoContrato] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'licitaciondx'  AND sc.name = N'dbo'  AND si.name = N'fk_Licitacion_Distribuidora1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_Licitacion_Distribuidora1_idx] ON [dbo].[licitaciondx] 
GO
CREATE NONCLUSTERED INDEX [fk_Licitacion_Distribuidora1_idx] ON [dbo].[licitaciondx]
(
   [IdDistribuidora] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'licitaciondx'  AND sc.name = N'dbo'  AND si.name = N'fk_LicitacionDx_Licitacion1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_LicitacionDx_Licitacion1_idx] ON [dbo].[licitaciondx] 
GO
CREATE NONCLUSTERED INDEX [fk_LicitacionDx_Licitacion1_idx] ON [dbo].[licitaciondx]
(
   [IdLicitacion] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'licitaciongxdxptocompra'  AND sc.name = N'dbo'  AND si.name = N'fk_LicitacionDxGxPtoCompra_LicitacionDx1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_LicitacionDxGxPtoCompra_LicitacionDx1_idx] ON [dbo].[licitaciongxdxptocompra] 
GO
CREATE NONCLUSTERED INDEX [fk_LicitacionDxGxPtoCompra_LicitacionDx1_idx] ON [dbo].[licitaciongxdxptocompra]
(
   [IdLicitacionDx] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'licitaciongxdxptocompra'  AND sc.name = N'dbo'  AND si.name = N'fk_LicitacionDxGxPtoCompra_LicitacionGx1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_LicitacionDxGxPtoCompra_LicitacionGx1_idx] ON [dbo].[licitaciongxdxptocompra] 
GO
CREATE NONCLUSTERED INDEX [fk_LicitacionDxGxPtoCompra_LicitacionGx1_idx] ON [dbo].[licitaciongxdxptocompra]
(
   [IdLicitacionGx] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'licitaciongx'  AND sc.name = N'dbo'  AND si.name = N'fk_LicitacionGx_BarraNacional1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_LicitacionGx_BarraNacional1_idx] ON [dbo].[licitaciongx] 
GO
CREATE NONCLUSTERED INDEX [fk_LicitacionGx_BarraNacional1_idx] ON [dbo].[licitaciongx]
(
   [IdPtoOferta] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'licitaciongx'  AND sc.name = N'dbo'  AND si.name = N'fk_LicitacionGx_Decreto1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_LicitacionGx_Decreto1_idx] ON [dbo].[licitaciongx] 
GO
CREATE NONCLUSTERED INDEX [fk_LicitacionGx_Decreto1_idx] ON [dbo].[licitaciongx]
(
   [IdDecrPNudo] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'licitaciongx'  AND sc.name = N'dbo'  AND si.name = N'fk_LicitacionGx_Generadora1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_LicitacionGx_Generadora1_idx] ON [dbo].[licitaciongx] 
GO
CREATE NONCLUSTERED INDEX [fk_LicitacionGx_Generadora1_idx] ON [dbo].[licitaciongx]
(
   [IdGeneradora] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'licitaciongx'  AND sc.name = N'dbo'  AND si.name = N'fk_LicitacionGx_Licitacion1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_LicitacionGx_Licitacion1_idx] ON [dbo].[licitaciongx] 
GO
CREATE NONCLUSTERED INDEX [fk_LicitacionGx_Licitacion1_idx] ON [dbo].[licitaciongx]
(
   [IdLicitacion] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'licitaciongxindexacion'  AND sc.name = N'dbo'  AND si.name = N'fk_LicitacionGxIndexacion_LicitacionGx1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_LicitacionGxIndexacion_LicitacionGx1_idx] ON [dbo].[licitaciongxindexacion] 
GO
CREATE NONCLUSTERED INDEX [fk_LicitacionGxIndexacion_LicitacionGx1_idx] ON [dbo].[licitaciongxindexacion]
(
   [IdLicitacionGx] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'licitaciongxdxptocompra'  AND sc.name = N'dbo'  AND si.name = N'fk_LicitacionGxPtoCompraDx_BarraNacional1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_LicitacionGxPtoCompraDx_BarraNacional1_idx] ON [dbo].[licitaciongxdxptocompra] 
GO
CREATE NONCLUSTERED INDEX [fk_LicitacionGxPtoCompraDx_BarraNacional1_idx] ON [dbo].[licitaciongxdxptocompra]
(
   [IdPtoCompra] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'perdidazonal'  AND sc.name = N'dbo'  AND si.name = N'fk_PerdidaZonal_SistemaZonal1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_PerdidaZonal_SistemaZonal1_idx] ON [dbo].[perdidazonal] 
GO
CREATE NONCLUSTERED INDEX [fk_PerdidaZonal_SistemaZonal1_idx] ON [dbo].[perdidazonal]
(
   [IdSistemaZonal] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'pncp'  AND sc.name = N'dbo'  AND si.name = N'fk_PNCP_BarraNacional1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_PNCP_BarraNacional1_idx] ON [dbo].[pncp] 
GO
CREATE NONCLUSTERED INDEX [fk_PNCP_BarraNacional1_idx] ON [dbo].[pncp]
(
   [IdNudo] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'pncpconcet'  AND sc.name = N'dbo'  AND si.name = N'fk_PNCPconCET_CETCP1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_PNCPconCET_CETCP1_idx] ON [dbo].[pncpconcet] 
GO
CREATE NONCLUSTERED INDEX [fk_PNCPconCET_CETCP1_idx] ON [dbo].[pncpconcet]
(
   [MesIndexacion] ASC,
   [VersionIndex] ASC,
   [VersionPNP] ASC,
   [IdGeneradora] ASC,
   [IdDistribuidora] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'pncpconcet'  AND sc.name = N'dbo'  AND si.name = N'fk_PNCPconCET_PNCP1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_PNCPconCET_PNCP1_idx] ON [dbo].[pncpconcet] 
GO
CREATE NONCLUSTERED INDEX [fk_PNCPconCET_PNCP1_idx] ON [dbo].[pncpconcet]
(
   [MES_PNCP] ASC,
   [VersionPNCP] ASC,
   [IdNudo] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'pncpconcet'  AND sc.name = N'dbo'  AND si.name = N'fk_PNCPconCET_VersionEfact1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_PNCPconCET_VersionEfact1_idx] ON [dbo].[pncpconcet] 
GO
CREATE NONCLUSTERED INDEX [fk_PNCPconCET_VersionEfact1_idx] ON [dbo].[pncpconcet]
(
   [IdVersionEfact] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'pncpconcet'  AND sc.name = N'dbo'  AND si.name = N'fk_PNCPconCET_VersionRec1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_PNCPconCET_VersionRec1_idx] ON [dbo].[pncpconcet] 
GO
CREATE NONCLUSTERED INDEX [fk_PNCPconCET_VersionRec1_idx] ON [dbo].[pncpconcet]
(
   [IdVersion] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'pnptraspexc'  AND sc.name = N'dbo'  AND si.name = N'fk_PNPTraspExc_CMGPromedio1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_PNPTraspExc_CMGPromedio1_idx] ON [dbo].[pnptraspexc] 
GO
CREATE NONCLUSTERED INDEX [fk_PNPTraspExc_CMGPromedio1_idx] ON [dbo].[pnptraspexc]
(
   [VersionCMg] ASC,
   [FechaCMG] ASC,
   [IdPtoCompra] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'pnptraspexc'  AND sc.name = N'dbo'  AND si.name = N'fk_PNPTraspExc_PNPIndex1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_PNPTraspExc_PNPIndex1_idx] ON [dbo].[pnptraspexc] 
GO
CREATE NONCLUSTERED INDEX [fk_PNPTraspExc_PNPIndex1_idx] ON [dbo].[pnptraspexc]
(
   [VersionPNP] ASC,
   [Fecha] ASC,
   [Version] ASC,
   [IdCodigoContrato] ASC,
   [IdPtoOferta] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'precionudolicitacion'  AND sc.name = N'dbo'  AND si.name = N'fk_PrecioNudoLicitacion_Decreto1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_PrecioNudoLicitacion_Decreto1_idx] ON [dbo].[precionudolicitacion] 
GO
CREATE NONCLUSTERED INDEX [fk_PrecioNudoLicitacion_Decreto1_idx] ON [dbo].[precionudolicitacion]
(
   [IdDecPNudo] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'ptoretirosistema'  AND sc.name = N'dbo'  AND si.name = N'fk_PtoRetiroSistema_PuntoRetiro1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_PtoRetiroSistema_PuntoRetiro1_idx] ON [dbo].[ptoretirosistema] 
GO
CREATE NONCLUSTERED INDEX [fk_PtoRetiroSistema_PuntoRetiro1_idx] ON [dbo].[ptoretirosistema]
(
   [IdPuntoRetiro] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'ptoretirosistema'  AND sc.name = N'dbo'  AND si.name = N'fk_PtoRetiroSistema_SistemaZonal1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_PtoRetiroSistema_SistemaZonal1_idx] ON [dbo].[ptoretirosistema] 
GO
CREATE NONCLUSTERED INDEX [fk_PtoRetiroSistema_SistemaZonal1_idx] ON [dbo].[ptoretirosistema]
(
   [IdSistemaZonal] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'recaudaciondetalle'  AND sc.name = N'dbo'  AND si.name = N'fk_RecaudacionDetalle_FactorReferenciacion1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_RecaudacionDetalle_FactorReferenciacion1_idx] ON [dbo].[recaudaciondetalle] 
GO
CREATE NONCLUSTERED INDEX [fk_RecaudacionDetalle_FactorReferenciacion1_idx] ON [dbo].[recaudaciondetalle]
(
   [IdPuntoRetiro] ASC,
   [IdBarraNacionalFR] ASC,
   [PeriodoFR] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'recaudaciondetalle'  AND sc.name = N'dbo'  AND si.name = N'fk_RecaudacionDetalle_PNCP1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_RecaudacionDetalle_PNCP1_idx] ON [dbo].[recaudaciondetalle] 
GO
CREATE NONCLUSTERED INDEX [fk_RecaudacionDetalle_PNCP1_idx] ON [dbo].[recaudaciondetalle]
(
   [PNCP_Mes] ASC,
   [PNCP_Version] ASC,
   [PNCP_IdNudo] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'versionestabilizacion'  AND sc.name = N'dbo'  AND si.name = N'fk_VersionEstabilizacion_VersionRec1_idx' AND so.type in (N'U'))
   DROP INDEX [fk_VersionEstabilizacion_VersionRec1_idx] ON [dbo].[versionestabilizacion] 
GO
CREATE NONCLUSTERED INDEX [fk_VersionEstabilizacion_VersionRec1_idx] ON [dbo].[versionestabilizacion]
(
   [IdVersionContratosDefinitiva] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (
       SELECT * FROM sys.objects  so JOIN sys.indexes si
       ON so.object_id = si.object_id
       JOIN sys.schemas sc
       ON so.schema_id = sc.schema_id
       WHERE so.name = N'versionestabilizacion'  AND sc.name = N'dbo'  AND si.name = N'fk_VersionEstabilizacion_VersionRec2_idx' AND so.type in (N'U'))
   DROP INDEX [fk_VersionEstabilizacion_VersionRec2_idx] ON [dbo].[versionestabilizacion] 
GO
CREATE NONCLUSTERED INDEX [fk_VersionEstabilizacion_VersionRec2_idx] ON [dbo].[versionestabilizacion]
(
   [IdVersionContratosPNP] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] 
GO
GO

USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'cet$fk_CET_Generadora1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[cet] DROP CONSTRAINT [cet$fk_CET_Generadora1]
 GO



ALTER TABLE [dbo].[cet]
 ADD CONSTRAINT [cet$fk_CET_Generadora1]
 FOREIGN KEY 
   ([IdGeneradora])
 REFERENCES 
   [pnp_3].[dbo].[generadora]     ([IdGeneradora])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'cet$fk_CET_LicitacionDx1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[cet] DROP CONSTRAINT [cet$fk_CET_LicitacionDx1]
 GO



ALTER TABLE [dbo].[cet]
 ADD CONSTRAINT [cet$fk_CET_LicitacionDx1]
 FOREIGN KEY 
   ([IdLicitacionDx])
 REFERENCES 
   [pnp_3].[dbo].[licitaciondx]     ([IdLicitacionDx])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'cetcp$fk_CETCP_Distribuidora2'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[cetcp] DROP CONSTRAINT [cetcp$fk_CETCP_Distribuidora2]
 GO



ALTER TABLE [dbo].[cetcp]
 ADD CONSTRAINT [cetcp$fk_CETCP_Distribuidora2]
 FOREIGN KEY 
   ([IdDistribuidora])
 REFERENCES 
   [pnp_3].[dbo].[distribuidora]     ([IdDistribuidora])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'cetcp$fk_CETCP_Generadora2'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[cetcp] DROP CONSTRAINT [cetcp$fk_CETCP_Generadora2]
 GO



ALTER TABLE [dbo].[cetcp]
 ADD CONSTRAINT [cetcp$fk_CETCP_Generadora2]
 FOREIGN KEY 
   ([IdGeneradora])
 REFERENCES 
   [pnp_3].[dbo].[generadora]     ([IdGeneradora])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'cmgpromedio$fk_CMGPromedio_BarraNacional1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[cmgpromedio] DROP CONSTRAINT [cmgpromedio$fk_CMGPromedio_BarraNacional1]
 GO



ALTER TABLE [dbo].[cmgpromedio]
 ADD CONSTRAINT [cmgpromedio$fk_CMGPromedio_BarraNacional1]
 FOREIGN KEY 
   ([IdBarraNacional])
 REFERENCES 
   [pnp_3].[dbo].[barranacional]     ([IdBarraNacional])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'codigocontrato$fk_CodigoContrato_Distribuidora1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[codigocontrato] DROP CONSTRAINT [codigocontrato$fk_CodigoContrato_Distribuidora1]
 GO



ALTER TABLE [dbo].[codigocontrato]
 ADD CONSTRAINT [codigocontrato$fk_CodigoContrato_Distribuidora1]
 FOREIGN KEY 
   ([IdDistribuidora])
 REFERENCES 
   [pnp_3].[dbo].[distribuidora]     ([IdDistribuidora])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'codigocontrato$fk_CodigoContrato_Generadora'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[codigocontrato] DROP CONSTRAINT [codigocontrato$fk_CodigoContrato_Generadora]
 GO



ALTER TABLE [dbo].[codigocontrato]
 ADD CONSTRAINT [codigocontrato$fk_CodigoContrato_Generadora]
 FOREIGN KEY 
   ([IdGeneradora])
 REFERENCES 
   [pnp_3].[dbo].[generadora]     ([IdGeneradora])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'codigocontrato$fk_CodigoContrato_Licitacion1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[codigocontrato] DROP CONSTRAINT [codigocontrato$fk_CodigoContrato_Licitacion1]
 GO



ALTER TABLE [dbo].[codigocontrato]
 ADD CONSTRAINT [codigocontrato$fk_CodigoContrato_Licitacion1]
 FOREIGN KEY 
   ([IdLicitacion])
 REFERENCES 
   [pnp_3].[dbo].[licitacion]     ([IdLicitacion])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'demanda$fk_Demanda_Distribuidora1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[demanda] DROP CONSTRAINT [demanda$fk_Demanda_Distribuidora1]
 GO



ALTER TABLE [dbo].[demanda]
 ADD CONSTRAINT [demanda$fk_Demanda_Distribuidora1]
 FOREIGN KEY 
   ([IdDistribuidora])
 REFERENCES 
   [pnp_3].[dbo].[distribuidora]     ([IdDistribuidora])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'demanda$fk_Demanda_PuntoRetiro1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[demanda] DROP CONSTRAINT [demanda$fk_Demanda_PuntoRetiro1]
 GO



ALTER TABLE [dbo].[demanda]
 ADD CONSTRAINT [demanda$fk_Demanda_PuntoRetiro1]
 FOREIGN KEY 
   ([IdPuntoRetiro])
 REFERENCES 
   [pnp_3].[dbo].[puntoretiro]     ([IdPuntoRetiro])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'demanda$fk_Demanda_SistemaZonal1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[demanda] DROP CONSTRAINT [demanda$fk_Demanda_SistemaZonal1]
 GO



ALTER TABLE [dbo].[demanda]
 ADD CONSTRAINT [demanda$fk_Demanda_SistemaZonal1]
 FOREIGN KEY 
   ([IdSistemaZonal])
 REFERENCES 
   [pnp_3].[dbo].[sistemazonal]     ([IdSistemaZonal])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'difxcompras$fk_DifxCompras_CodigoContrato1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[difxcompras] DROP CONSTRAINT [difxcompras$fk_DifxCompras_CodigoContrato1]
 GO



ALTER TABLE [dbo].[difxcompras]
 ADD CONSTRAINT [difxcompras$fk_DifxCompras_CodigoContrato1]
 FOREIGN KEY 
   ([IdCodigoContrato])
 REFERENCES 
   [pnp_3].[dbo].[codigocontrato]     ([IdCodigoContrato])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'difxcompras$fk_DifxCompras_Distribuidora1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[difxcompras] DROP CONSTRAINT [difxcompras$fk_DifxCompras_Distribuidora1]
 GO



ALTER TABLE [dbo].[difxcompras]
 ADD CONSTRAINT [difxcompras$fk_DifxCompras_Distribuidora1]
 FOREIGN KEY 
   ([IdDistribuidora])
 REFERENCES 
   [pnp_3].[dbo].[distribuidora]     ([IdDistribuidora])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'difxcompras$fk_DifxCompras_Generadora1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[difxcompras] DROP CONSTRAINT [difxcompras$fk_DifxCompras_Generadora1]
 GO



ALTER TABLE [dbo].[difxcompras]
 ADD CONSTRAINT [difxcompras$fk_DifxCompras_Generadora1]
 FOREIGN KEY 
   ([IdGeneradora])
 REFERENCES 
   [pnp_3].[dbo].[generadora]     ([IdGeneradora])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'difxcompras$fk_DifxCompras_SistemaZonal1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[difxcompras] DROP CONSTRAINT [difxcompras$fk_DifxCompras_SistemaZonal1]
 GO



ALTER TABLE [dbo].[difxcompras]
 ADD CONSTRAINT [difxcompras$fk_DifxCompras_SistemaZonal1]
 FOREIGN KEY 
   ([IdSistemaZonal])
 REFERENCES 
   [pnp_3].[dbo].[sistemazonal]     ([IdSistemaZonal])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'eadjanual$fk_EAdjAnual_BarraNacional1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[eadjanual] DROP CONSTRAINT [eadjanual$fk_EAdjAnual_BarraNacional1]
 GO



ALTER TABLE [dbo].[eadjanual]
 ADD CONSTRAINT [eadjanual$fk_EAdjAnual_BarraNacional1]
 FOREIGN KEY 
   ([IdPtoCompra])
 REFERENCES 
   [pnp_3].[dbo].[barranacional]     ([IdBarraNacional])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'eadjanual$fk_EAdjAnual_CodigoContrato1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[eadjanual] DROP CONSTRAINT [eadjanual$fk_EAdjAnual_CodigoContrato1]
 GO



ALTER TABLE [dbo].[eadjanual]
 ADD CONSTRAINT [eadjanual$fk_EAdjAnual_CodigoContrato1]
 FOREIGN KEY 
   ([IdCodigoContrato])
 REFERENCES 
   [pnp_3].[dbo].[codigocontrato]     ([IdCodigoContrato])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'eadjanualdistrmensual$fk_EAdjAnualDistrMensual_BarraNacional1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[eadjanualdistrmensual] DROP CONSTRAINT [eadjanualdistrmensual$fk_EAdjAnualDistrMensual_BarraNacional1]
 GO



ALTER TABLE [dbo].[eadjanualdistrmensual]
 ADD CONSTRAINT [eadjanualdistrmensual$fk_EAdjAnualDistrMensual_BarraNacional1]
 FOREIGN KEY 
   ([IdPtoCompra])
 REFERENCES 
   [pnp_3].[dbo].[barranacional]     ([IdBarraNacional])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'eadjanualdistrmensual$fk_EAdjAnualDistrMensual_CodigoContrato1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[eadjanualdistrmensual] DROP CONSTRAINT [eadjanualdistrmensual$fk_EAdjAnualDistrMensual_CodigoContrato1]
 GO



ALTER TABLE [dbo].[eadjanualdistrmensual]
 ADD CONSTRAINT [eadjanualdistrmensual$fk_EAdjAnualDistrMensual_CodigoContrato1]
 FOREIGN KEY 
   ([IdCodigoContrato])
 REFERENCES 
   [pnp_3].[dbo].[codigocontrato]     ([IdCodigoContrato])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'efact$fk_EFACT_CodigoContrato1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[efact] DROP CONSTRAINT [efact$fk_EFACT_CodigoContrato1]
 GO



ALTER TABLE [dbo].[efact]
 ADD CONSTRAINT [efact$fk_EFACT_CodigoContrato1]
 FOREIGN KEY 
   ([IdCodigoContrato])
 REFERENCES 
   [pnp_3].[dbo].[codigocontrato]     ([IdCodigoContrato])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'efact$fk_EFACT_Distribuidora1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[efact] DROP CONSTRAINT [efact$fk_EFACT_Distribuidora1]
 GO



ALTER TABLE [dbo].[efact]
 ADD CONSTRAINT [efact$fk_EFACT_Distribuidora1]
 FOREIGN KEY 
   ([IdDistribuidora])
 REFERENCES 
   [pnp_3].[dbo].[distribuidora]     ([IdDistribuidora])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'efact$fk_EFACT_Generadora1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[efact] DROP CONSTRAINT [efact$fk_EFACT_Generadora1]
 GO



ALTER TABLE [dbo].[efact]
 ADD CONSTRAINT [efact$fk_EFACT_Generadora1]
 FOREIGN KEY 
   ([IdGeneradora])
 REFERENCES 
   [pnp_3].[dbo].[generadora]     ([IdGeneradora])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'efact$fk_EFACT_PuntoRetiro1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[efact] DROP CONSTRAINT [efact$fk_EFACT_PuntoRetiro1]
 GO



ALTER TABLE [dbo].[efact]
 ADD CONSTRAINT [efact$fk_EFACT_PuntoRetiro1]
 FOREIGN KEY 
   ([IdPuntoRetiro])
 REFERENCES 
   [pnp_3].[dbo].[puntoretiro]     ([IdPuntoRetiro])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'efact$fk_EFACT_TipoDespacho1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[efact] DROP CONSTRAINT [efact$fk_EFACT_TipoDespacho1]
 GO



ALTER TABLE [dbo].[efact]
 ADD CONSTRAINT [efact$fk_EFACT_TipoDespacho1]
 FOREIGN KEY 
   ([IdTipoDespacho])
 REFERENCES 
   [pnp_3].[dbo].[tipodespacho]     ([IdTipoDEspacho])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'efact$fk_EFACT_Version1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[efact] DROP CONSTRAINT [efact$fk_EFACT_Version1]
 GO



ALTER TABLE [dbo].[efact]
 ADD CONSTRAINT [efact$fk_EFACT_Version1]
 FOREIGN KEY 
   ([IdVersion])
 REFERENCES 
   [pnp_3].[dbo].[versionefact]     ([IdVersion])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'estabilizaciondetalle$fk_EstabilizacionDetalle_TipoDespacho1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[estabilizaciondetalle] DROP CONSTRAINT [estabilizaciondetalle$fk_EstabilizacionDetalle_TipoDespacho1]
 GO



ALTER TABLE [dbo].[estabilizaciondetalle]
 ADD CONSTRAINT [estabilizaciondetalle$fk_EstabilizacionDetalle_TipoDespacho1]
 FOREIGN KEY 
   ([IdTipoDEspacho])
 REFERENCES 
   [pnp_3].[dbo].[tipodespacho]     ([IdTipoDEspacho])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'estabilizaciondetalle$fk_EstabilizacionDetalle_VersionEstabilizacion1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[estabilizaciondetalle] DROP CONSTRAINT [estabilizaciondetalle$fk_EstabilizacionDetalle_VersionEstabilizacion1]
 GO



ALTER TABLE [dbo].[estabilizaciondetalle]
 ADD CONSTRAINT [estabilizaciondetalle$fk_EstabilizacionDetalle_VersionEstabilizacion1]
 FOREIGN KEY 
   ([IdVersionEstabilizacion])
 REFERENCES 
   [pnp_3].[dbo].[versionestabilizacion]     ([IdVersionEstabilizacion])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'factormodulacion$fk_FactorModulacion_BarraNacional1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[factormodulacion] DROP CONSTRAINT [factormodulacion$fk_FactorModulacion_BarraNacional1]
 GO



ALTER TABLE [dbo].[factormodulacion]
 ADD CONSTRAINT [factormodulacion$fk_FactorModulacion_BarraNacional1]
 FOREIGN KEY 
   ([IdBarraNacional])
 REFERENCES 
   [pnp_3].[dbo].[barranacional]     ([IdBarraNacional])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'factormodulacion$fk_FactorModulacion_Decreto1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[factormodulacion] DROP CONSTRAINT [factormodulacion$fk_FactorModulacion_Decreto1]
 GO



ALTER TABLE [dbo].[factormodulacion]
 ADD CONSTRAINT [factormodulacion$fk_FactorModulacion_Decreto1]
 FOREIGN KEY 
   ([IdDecreto])
 REFERENCES 
   [pnp_3].[dbo].[decreto]     ([IdDecreto])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'factorreferenciacion$fk_FactorReferenciacion_BarraNacional1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[factorreferenciacion] DROP CONSTRAINT [factorreferenciacion$fk_FactorReferenciacion_BarraNacional1]
 GO



ALTER TABLE [dbo].[factorreferenciacion]
 ADD CONSTRAINT [factorreferenciacion$fk_FactorReferenciacion_BarraNacional1]
 FOREIGN KEY 
   ([IdBarraNacional])
 REFERENCES 
   [pnp_3].[dbo].[barranacional]     ([IdBarraNacional])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'factorreferenciacion$fk_FactorReferenciacion_PuntoRetiro1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[factorreferenciacion] DROP CONSTRAINT [factorreferenciacion$fk_FactorReferenciacion_PuntoRetiro1]
 GO



ALTER TABLE [dbo].[factorreferenciacion]
 ADD CONSTRAINT [factorreferenciacion$fk_FactorReferenciacion_PuntoRetiro1]
 FOREIGN KEY 
   ([IdPuntoRetiro])
 REFERENCES 
   [pnp_3].[dbo].[puntoretiro]     ([IdPuntoRetiro])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'indexacioncet$fk_CETIndexacion_CET1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[indexacioncet] DROP CONSTRAINT [indexacioncet$fk_CETIndexacion_CET1]
 GO



ALTER TABLE [dbo].[indexacioncet]
 ADD CONSTRAINT [indexacioncet$fk_CETIndexacion_CET1]
 FOREIGN KEY 
   ([IdLicitacionDx], [IdGeneradora])
 REFERENCES 
   [pnp_3].[dbo].[cet]     ([IdLicitacionDx], [IdGeneradora])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'indexacioncombustible$fk_IndexacionCombustible_TipoCombustible1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[indexacioncombustible] DROP CONSTRAINT [indexacioncombustible$fk_IndexacionCombustible_TipoCombustible1]
 GO



ALTER TABLE [dbo].[indexacioncombustible]
 ADD CONSTRAINT [indexacioncombustible$fk_IndexacionCombustible_TipoCombustible1]
 FOREIGN KEY 
   ([IdTipoCombustible])
 REFERENCES 
   [pnp_3].[dbo].[tipocombustible]     ([IdTipoCombustible])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'indexacioncontrato$fk_IndexacionContratoDetalle_LicitacionGx10'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[indexacioncontrato] DROP CONSTRAINT [indexacioncontrato$fk_IndexacionContratoDetalle_LicitacionGx10]
 GO



ALTER TABLE [dbo].[indexacioncontrato]
 ADD CONSTRAINT [indexacioncontrato$fk_IndexacionContratoDetalle_LicitacionGx10]
 FOREIGN KEY 
   ([IdLicitacionGx])
 REFERENCES 
   [pnp_3].[dbo].[licitaciongx]     ([IdLicitacionGx])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'indexacioncontratodetalle$fk_IndexacionContratoDetalle_LicitacionGx1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[indexacioncontratodetalle] DROP CONSTRAINT [indexacioncontratodetalle$fk_IndexacionContratoDetalle_LicitacionGx1]
 GO



ALTER TABLE [dbo].[indexacioncontratodetalle]
 ADD CONSTRAINT [indexacioncontratodetalle$fk_IndexacionContratoDetalle_LicitacionGx1]
 FOREIGN KEY 
   ([IdLicitacionGx])
 REFERENCES 
   [pnp_3].[dbo].[licitaciongx]     ([IdLicitacionGx])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'indexacioncontratofm$fk_IndexacionContratoFM_BarraNacional1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[indexacioncontratofm] DROP CONSTRAINT [indexacioncontratofm$fk_IndexacionContratoFM_BarraNacional1]
 GO



ALTER TABLE [dbo].[indexacioncontratofm]
 ADD CONSTRAINT [indexacioncontratofm$fk_IndexacionContratoFM_BarraNacional1]
 FOREIGN KEY 
   ([IdPtoOferta])
 REFERENCES 
   [pnp_3].[dbo].[barranacional]     ([IdBarraNacional])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'indexacioncontratofm$fk_IndexacionContratoFM_BarraNacional2'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[indexacioncontratofm] DROP CONSTRAINT [indexacioncontratofm$fk_IndexacionContratoFM_BarraNacional2]
 GO



ALTER TABLE [dbo].[indexacioncontratofm]
 ADD CONSTRAINT [indexacioncontratofm$fk_IndexacionContratoFM_BarraNacional2]
 FOREIGN KEY 
   ([IdBarraNacional])
 REFERENCES 
   [pnp_3].[dbo].[barranacional]     ([IdBarraNacional])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'indexacioncontratofm$fk_IndexacionContratoFM_CodigoContrato1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[indexacioncontratofm] DROP CONSTRAINT [indexacioncontratofm$fk_IndexacionContratoFM_CodigoContrato1]
 GO



ALTER TABLE [dbo].[indexacioncontratofm]
 ADD CONSTRAINT [indexacioncontratofm$fk_IndexacionContratoFM_CodigoContrato1]
 FOREIGN KEY 
   ([IdCodigoContrato])
 REFERENCES 
   [pnp_3].[dbo].[codigocontrato]     ([IdCodigoContrato])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'licitaciondx$fk_LicitacionDx_Licitacion1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[licitaciondx] DROP CONSTRAINT [licitaciondx$fk_LicitacionDx_Licitacion1]
 GO



ALTER TABLE [dbo].[licitaciondx]
 ADD CONSTRAINT [licitaciondx$fk_LicitacionDx_Licitacion1]
 FOREIGN KEY 
   ([IdLicitacion])
 REFERENCES 
   [pnp_3].[dbo].[licitacion]     ([IdLicitacion])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'licitaciondx$fk_Licitacion_Distribuidora1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[licitaciondx] DROP CONSTRAINT [licitaciondx$fk_Licitacion_Distribuidora1]
 GO



ALTER TABLE [dbo].[licitaciondx]
 ADD CONSTRAINT [licitaciondx$fk_Licitacion_Distribuidora1]
 FOREIGN KEY 
   ([IdDistribuidora])
 REFERENCES 
   [pnp_3].[dbo].[distribuidora]     ([IdDistribuidora])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'licitaciongx$fk_LicitacionGx_BarraNacional1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[licitaciongx] DROP CONSTRAINT [licitaciongx$fk_LicitacionGx_BarraNacional1]
 GO



ALTER TABLE [dbo].[licitaciongx]
 ADD CONSTRAINT [licitaciongx$fk_LicitacionGx_BarraNacional1]
 FOREIGN KEY 
   ([IdPtoOferta])
 REFERENCES 
   [pnp_3].[dbo].[barranacional]     ([IdBarraNacional])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'licitaciongx$fk_LicitacionGx_Decreto1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[licitaciongx] DROP CONSTRAINT [licitaciongx$fk_LicitacionGx_Decreto1]
 GO



ALTER TABLE [dbo].[licitaciongx]
 ADD CONSTRAINT [licitaciongx$fk_LicitacionGx_Decreto1]
 FOREIGN KEY 
   ([IdDecrPNudo])
 REFERENCES 
   [pnp_3].[dbo].[decreto]     ([IdDecreto])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'licitaciongx$fk_LicitacionGx_Generadora1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[licitaciongx] DROP CONSTRAINT [licitaciongx$fk_LicitacionGx_Generadora1]
 GO



ALTER TABLE [dbo].[licitaciongx]
 ADD CONSTRAINT [licitaciongx$fk_LicitacionGx_Generadora1]
 FOREIGN KEY 
   ([IdGeneradora])
 REFERENCES 
   [pnp_3].[dbo].[generadora]     ([IdGeneradora])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'licitaciongx$fk_LicitacionGx_Licitacion1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[licitaciongx] DROP CONSTRAINT [licitaciongx$fk_LicitacionGx_Licitacion1]
 GO



ALTER TABLE [dbo].[licitaciongx]
 ADD CONSTRAINT [licitaciongx$fk_LicitacionGx_Licitacion1]
 FOREIGN KEY 
   ([IdLicitacion])
 REFERENCES 
   [pnp_3].[dbo].[licitacion]     ([IdLicitacion])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'licitaciongxdxptocompra$fk_LicitacionDxGxPtoCompra_LicitacionDx1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[licitaciongxdxptocompra] DROP CONSTRAINT [licitaciongxdxptocompra$fk_LicitacionDxGxPtoCompra_LicitacionDx1]
 GO



ALTER TABLE [dbo].[licitaciongxdxptocompra]
 ADD CONSTRAINT [licitaciongxdxptocompra$fk_LicitacionDxGxPtoCompra_LicitacionDx1]
 FOREIGN KEY 
   ([IdLicitacionDx])
 REFERENCES 
   [pnp_3].[dbo].[licitaciondx]     ([IdLicitacionDx])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'licitaciongxdxptocompra$fk_LicitacionDxGxPtoCompra_LicitacionGx1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[licitaciongxdxptocompra] DROP CONSTRAINT [licitaciongxdxptocompra$fk_LicitacionDxGxPtoCompra_LicitacionGx1]
 GO



ALTER TABLE [dbo].[licitaciongxdxptocompra]
 ADD CONSTRAINT [licitaciongxdxptocompra$fk_LicitacionDxGxPtoCompra_LicitacionGx1]
 FOREIGN KEY 
   ([IdLicitacionGx])
 REFERENCES 
   [pnp_3].[dbo].[licitaciongx]     ([IdLicitacionGx])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'licitaciongxdxptocompra$fk_LicitacionGxPtoCompraDx_BarraNacional1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[licitaciongxdxptocompra] DROP CONSTRAINT [licitaciongxdxptocompra$fk_LicitacionGxPtoCompraDx_BarraNacional1]
 GO



ALTER TABLE [dbo].[licitaciongxdxptocompra]
 ADD CONSTRAINT [licitaciongxdxptocompra$fk_LicitacionGxPtoCompraDx_BarraNacional1]
 FOREIGN KEY 
   ([IdPtoCompra])
 REFERENCES 
   [pnp_3].[dbo].[barranacional]     ([IdBarraNacional])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'licitaciongxindexacion$fk_LicitacionGxIndexacion_LicitacionGx1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[licitaciongxindexacion] DROP CONSTRAINT [licitaciongxindexacion$fk_LicitacionGxIndexacion_LicitacionGx1]
 GO



ALTER TABLE [dbo].[licitaciongxindexacion]
 ADD CONSTRAINT [licitaciongxindexacion$fk_LicitacionGxIndexacion_LicitacionGx1]
 FOREIGN KEY 
   ([IdLicitacionGx])
 REFERENCES 
   [pnp_3].[dbo].[licitaciongx]     ([IdLicitacionGx])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'licitaciongxindexesp$fk_LicitacionGxIndexEsp_LicitacionGx1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[licitaciongxindexesp] DROP CONSTRAINT [licitaciongxindexesp$fk_LicitacionGxIndexEsp_LicitacionGx1]
 GO



ALTER TABLE [dbo].[licitaciongxindexesp]
 ADD CONSTRAINT [licitaciongxindexesp$fk_LicitacionGxIndexEsp_LicitacionGx1]
 FOREIGN KEY 
   ([IdLicitacionGx])
 REFERENCES 
   [pnp_3].[dbo].[licitaciongx]     ([IdLicitacionGx])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'perdidazonal$fk_PerdidaZonal_SistemaZonal1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[perdidazonal] DROP CONSTRAINT [perdidazonal$fk_PerdidaZonal_SistemaZonal1]
 GO



ALTER TABLE [dbo].[perdidazonal]
 ADD CONSTRAINT [perdidazonal$fk_PerdidaZonal_SistemaZonal1]
 FOREIGN KEY 
   ([IdSistemaZonal])
 REFERENCES 
   [pnp_3].[dbo].[sistemazonal]     ([IdSistemaZonal])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'pncp$fk_PNCP_BarraNacional1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[pncp] DROP CONSTRAINT [pncp$fk_PNCP_BarraNacional1]
 GO



ALTER TABLE [dbo].[pncp]
 ADD CONSTRAINT [pncp$fk_PNCP_BarraNacional1]
 FOREIGN KEY 
   ([IdNudo])
 REFERENCES 
   [pnp_3].[dbo].[barranacional]     ([IdBarraNacional])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'pncpconcet$fk_PNCPconCET_CETCP1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[pncpconcet] DROP CONSTRAINT [pncpconcet$fk_PNCPconCET_CETCP1]
 GO



ALTER TABLE [dbo].[pncpconcet]
 ADD CONSTRAINT [pncpconcet$fk_PNCPconCET_CETCP1]
 FOREIGN KEY 
   ([MesIndexacion], [VersionIndex], [VersionPNP], [IdGeneradora], [IdDistribuidora])
 REFERENCES 
   [pnp_3].[dbo].[cetcp]     ([MesIndexacion], [VersionIndex], [Version], [IdGeneradora], [IdDistribuidora])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'pncpconcet$fk_PNCPconCET_PNCP1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[pncpconcet] DROP CONSTRAINT [pncpconcet$fk_PNCPconCET_PNCP1]
 GO



ALTER TABLE [dbo].[pncpconcet]
 ADD CONSTRAINT [pncpconcet$fk_PNCPconCET_PNCP1]
 FOREIGN KEY 
   ([MES_PNCP], [VersionPNCP], [IdNudo])
 REFERENCES 
   [pnp_3].[dbo].[pncp]     ([MES], [Version], [IdNudo])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'pncpconcet$fk_PNCPconCET_VersionEfact1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[pncpconcet] DROP CONSTRAINT [pncpconcet$fk_PNCPconCET_VersionEfact1]
 GO



ALTER TABLE [dbo].[pncpconcet]
 ADD CONSTRAINT [pncpconcet$fk_PNCPconCET_VersionEfact1]
 FOREIGN KEY 
   ([IdVersionEfact])
 REFERENCES 
   [pnp_3].[dbo].[versionefact]     ([IdVersion])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'pncpconcet$fk_PNCPconCET_VersionRec1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[pncpconcet] DROP CONSTRAINT [pncpconcet$fk_PNCPconCET_VersionRec1]
 GO



ALTER TABLE [dbo].[pncpconcet]
 ADD CONSTRAINT [pncpconcet$fk_PNCPconCET_VersionRec1]
 FOREIGN KEY 
   ([IdVersion])
 REFERENCES 
   [pnp_3].[dbo].[versionrec]     ([IdVersion])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'pnp$fk_IndexacionContratoFM_BarraNacional20'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[pnp] DROP CONSTRAINT [pnp$fk_IndexacionContratoFM_BarraNacional20]
 GO



ALTER TABLE [dbo].[pnp]
 ADD CONSTRAINT [pnp$fk_IndexacionContratoFM_BarraNacional20]
 FOREIGN KEY 
   ([IdBarraNacional])
 REFERENCES 
   [pnp_3].[dbo].[barranacional]     ([IdBarraNacional])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'pnp$fk_IndexacionContratoFM_CodigoContrato10'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[pnp] DROP CONSTRAINT [pnp$fk_IndexacionContratoFM_CodigoContrato10]
 GO



ALTER TABLE [dbo].[pnp]
 ADD CONSTRAINT [pnp$fk_IndexacionContratoFM_CodigoContrato10]
 FOREIGN KEY 
   ([IdCodigoContrato])
 REFERENCES 
   [pnp_3].[dbo].[codigocontrato]     ([IdCodigoContrato])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'pnpindex$fk_IndexacionContratoFM_BarraNacional200'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[pnpindex] DROP CONSTRAINT [pnpindex$fk_IndexacionContratoFM_BarraNacional200]
 GO



ALTER TABLE [dbo].[pnpindex]
 ADD CONSTRAINT [pnpindex$fk_IndexacionContratoFM_BarraNacional200]
 FOREIGN KEY 
   ([IdPtoOferta])
 REFERENCES 
   [pnp_3].[dbo].[barranacional]     ([IdBarraNacional])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'pnpindex$fk_IndexacionContratoFM_CodigoContrato100'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[pnpindex] DROP CONSTRAINT [pnpindex$fk_IndexacionContratoFM_CodigoContrato100]
 GO



ALTER TABLE [dbo].[pnpindex]
 ADD CONSTRAINT [pnpindex$fk_IndexacionContratoFM_CodigoContrato100]
 FOREIGN KEY 
   ([IdCodigoContrato])
 REFERENCES 
   [pnp_3].[dbo].[codigocontrato]     ([IdCodigoContrato])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'pnptraspexc$fk_PNPTraspExc_CMGPromedio1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[pnptraspexc] DROP CONSTRAINT [pnptraspexc$fk_PNPTraspExc_CMGPromedio1]
 GO



ALTER TABLE [dbo].[pnptraspexc]
 ADD CONSTRAINT [pnptraspexc$fk_PNPTraspExc_CMGPromedio1]
 FOREIGN KEY 
   ([VersionCMg], [FechaCMG], [IdPtoCompra])
 REFERENCES 
   [pnp_3].[dbo].[cmgpromedio]     ([VersionCMg], [Fecha], [IdBarraNacional])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'pnptraspexc$fk_PNPTraspExc_PNPIndex1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[pnptraspexc] DROP CONSTRAINT [pnptraspexc$fk_PNPTraspExc_PNPIndex1]
 GO



ALTER TABLE [dbo].[pnptraspexc]
 ADD CONSTRAINT [pnptraspexc$fk_PNPTraspExc_PNPIndex1]
 FOREIGN KEY 
   ([VersionPNP], [Fecha], [Version], [IdCodigoContrato], [IdPtoOferta])
 REFERENCES 
   [pnp_3].[dbo].[pnpindex]     ([VersionIndex], [MesIndexacion], [Version], [IdCodigoContrato], [IdPtoOferta])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'precionudolicitacion$fk_PrecioNudoLicitacion_Decreto1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[precionudolicitacion] DROP CONSTRAINT [precionudolicitacion$fk_PrecioNudoLicitacion_Decreto1]
 GO



ALTER TABLE [dbo].[precionudolicitacion]
 ADD CONSTRAINT [precionudolicitacion$fk_PrecioNudoLicitacion_Decreto1]
 FOREIGN KEY 
   ([IdDecPNudo])
 REFERENCES 
   [pnp_3].[dbo].[decreto]     ([IdDecreto])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'ptoretirosistema$fk_PtoRetiroSistema_PuntoRetiro1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[ptoretirosistema] DROP CONSTRAINT [ptoretirosistema$fk_PtoRetiroSistema_PuntoRetiro1]
 GO



ALTER TABLE [dbo].[ptoretirosistema]
 ADD CONSTRAINT [ptoretirosistema$fk_PtoRetiroSistema_PuntoRetiro1]
 FOREIGN KEY 
   ([IdPuntoRetiro])
 REFERENCES 
   [pnp_3].[dbo].[puntoretiro]     ([IdPuntoRetiro])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'ptoretirosistema$fk_PtoRetiroSistema_SistemaZonal1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[ptoretirosistema] DROP CONSTRAINT [ptoretirosistema$fk_PtoRetiroSistema_SistemaZonal1]
 GO



ALTER TABLE [dbo].[ptoretirosistema]
 ADD CONSTRAINT [ptoretirosistema$fk_PtoRetiroSistema_SistemaZonal1]
 FOREIGN KEY 
   ([IdSistemaZonal])
 REFERENCES 
   [pnp_3].[dbo].[sistemazonal]     ([IdSistemaZonal])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'recaudaciondetalle$fk_EfactPNP_CodigoContrato1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[recaudaciondetalle] DROP CONSTRAINT [recaudaciondetalle$fk_EfactPNP_CodigoContrato1]
 GO



ALTER TABLE [dbo].[recaudaciondetalle]
 ADD CONSTRAINT [recaudaciondetalle$fk_EfactPNP_CodigoContrato1]
 FOREIGN KEY 
   ([IdCodigoContrato])
 REFERENCES 
   [pnp_3].[dbo].[codigocontrato]     ([IdCodigoContrato])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'recaudaciondetalle$fk_EfactPNP_Distribuidora1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[recaudaciondetalle] DROP CONSTRAINT [recaudaciondetalle$fk_EfactPNP_Distribuidora1]
 GO



ALTER TABLE [dbo].[recaudaciondetalle]
 ADD CONSTRAINT [recaudaciondetalle$fk_EfactPNP_Distribuidora1]
 FOREIGN KEY 
   ([IdDistribuidora])
 REFERENCES 
   [pnp_3].[dbo].[distribuidora]     ([IdDistribuidora])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'recaudaciondetalle$fk_EfactPNP_Generadora1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[recaudaciondetalle] DROP CONSTRAINT [recaudaciondetalle$fk_EfactPNP_Generadora1]
 GO



ALTER TABLE [dbo].[recaudaciondetalle]
 ADD CONSTRAINT [recaudaciondetalle$fk_EfactPNP_Generadora1]
 FOREIGN KEY 
   ([IdGeneradora])
 REFERENCES 
   [pnp_3].[dbo].[generadora]     ([IdGeneradora])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'recaudaciondetalle$fk_EfactPNP_PerdidaZonal1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[recaudaciondetalle] DROP CONSTRAINT [recaudaciondetalle$fk_EfactPNP_PerdidaZonal1]
 GO


/* 
*   SSMA error messages:
*   M2SS0048: Foreign Key does not contains all the columns of Primary/Unique Key


ALTER TABLE [dbo].[recaudaciondetalle]
 ADD CONSTRAINT [recaudaciondetalle$fk_EfactPNP_PerdidaZonal1]
 FOREIGN KEY 
   ([FechaPZ], [VersionPZ], [IdSistemaZonal])
 REFERENCES 
   [pnp_3].[dbo].[perdidazonal]     ([Fecha], [Version], [IdSistemaZonal])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

*/

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'recaudaciondetalle$fk_EfactPNP_TipoDespacho1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[recaudaciondetalle] DROP CONSTRAINT [recaudaciondetalle$fk_EfactPNP_TipoDespacho1]
 GO



ALTER TABLE [dbo].[recaudaciondetalle]
 ADD CONSTRAINT [recaudaciondetalle$fk_EfactPNP_TipoDespacho1]
 FOREIGN KEY 
   ([IdTipoDespacho])
 REFERENCES 
   [pnp_3].[dbo].[tipodespacho]     ([IdTipoDEspacho])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'recaudaciondetalle$fk_EfactPNP_VersionERec1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[recaudaciondetalle] DROP CONSTRAINT [recaudaciondetalle$fk_EfactPNP_VersionERec1]
 GO



ALTER TABLE [dbo].[recaudaciondetalle]
 ADD CONSTRAINT [recaudaciondetalle$fk_EfactPNP_VersionERec1]
 FOREIGN KEY 
   ([IdVersion])
 REFERENCES 
   [pnp_3].[dbo].[versionrec]     ([IdVersion])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'recaudaciondetalle$fk_RecaudacionDetalle_FactorReferenciacion1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[recaudaciondetalle] DROP CONSTRAINT [recaudaciondetalle$fk_RecaudacionDetalle_FactorReferenciacion1]
 GO



ALTER TABLE [dbo].[recaudaciondetalle]
 ADD CONSTRAINT [recaudaciondetalle$fk_RecaudacionDetalle_FactorReferenciacion1]
 FOREIGN KEY 
   ([IdPuntoRetiro], [IdBarraNacionalFR], [PeriodoFR])
 REFERENCES 
   [pnp_3].[dbo].[factorreferenciacion]     ([IdPuntoRetiro], [IdBarraNacional], [Periodo])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'recaudaciondetalle$fk_RecaudacionDetalle_PNCP1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[recaudaciondetalle] DROP CONSTRAINT [recaudaciondetalle$fk_RecaudacionDetalle_PNCP1]
 GO



ALTER TABLE [dbo].[recaudaciondetalle]
 ADD CONSTRAINT [recaudaciondetalle$fk_RecaudacionDetalle_PNCP1]
 FOREIGN KEY 
   ([PNCP_Mes], [PNCP_Version], [PNCP_IdNudo])
 REFERENCES 
   [pnp_3].[dbo].[pncp]     ([MES], [Version], [IdNudo])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'versionestabilizacion$fk_VersionEstabilizacion_VersionRec1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[versionestabilizacion] DROP CONSTRAINT [versionestabilizacion$fk_VersionEstabilizacion_VersionRec1]
 GO



ALTER TABLE [dbo].[versionestabilizacion]
 ADD CONSTRAINT [versionestabilizacion$fk_VersionEstabilizacion_VersionRec1]
 FOREIGN KEY 
   ([IdVersionContratosDefinitiva])
 REFERENCES 
   [pnp_3].[dbo].[versionrec]     ([IdVersion])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO

IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'versionestabilizacion$fk_VersionEstabilizacion_VersionRec2'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[versionestabilizacion] DROP CONSTRAINT [versionestabilizacion$fk_VersionEstabilizacion_VersionRec2]
 GO



ALTER TABLE [dbo].[versionestabilizacion]
 ADD CONSTRAINT [versionestabilizacion$fk_VersionEstabilizacion_VersionRec2]
 FOREIGN KEY 
   ([IdVersionContratosPNP])
 REFERENCES 
   [pnp_3].[dbo].[versionrec]     ([IdVersion])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
IF EXISTS (SELECT * FROM sys.objects so JOIN sys.schemas sc ON so.schema_id = sc.schema_id WHERE so.name = N'versionrecdetalle$fk_VersionErecDetalle_VersionERec1'  AND sc.name = N'dbo'  AND type in (N'F'))
ALTER TABLE [dbo].[versionrecdetalle] DROP CONSTRAINT [versionrecdetalle$fk_VersionErecDetalle_VersionERec1]
 GO



ALTER TABLE [dbo].[versionrecdetalle]
 ADD CONSTRAINT [versionrecdetalle$fk_VersionErecDetalle_VersionERec1]
 FOREIGN KEY 
   ([IdVersion])
 REFERENCES 
   [pnp_3].[dbo].[versionrec]     ([IdVersion])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

GO


USE pnp_3
GO
ALTER TABLE  [dbo].[barranacional]
 ADD DEFAULT NULL FOR [BarraNAcional]
GO

ALTER TABLE  [dbo].[barranacional]
 ADD DEFAULT NULL FOR [Observacion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[cet]
 ADD DEFAULT NULL FOR [Licitacion]
GO

ALTER TABLE  [dbo].[cet]
 ADD DEFAULT NULL FOR [Distribuidora]
GO

ALTER TABLE  [dbo].[cet]
 ADD DEFAULT NULL FOR [Generadora]
GO

ALTER TABLE  [dbo].[cet]
 ADD DEFAULT NULL FOR [TieneCET]
GO

ALTER TABLE  [dbo].[cet]
 ADD DEFAULT NULL FOR [CET0]
GO

ALTER TABLE  [dbo].[cet]
 ADD DEFAULT NULL FOR [Index]
GO

ALTER TABLE  [dbo].[cet]
 ADD DEFAULT NULL FOR [MesReferencia]
GO

ALTER TABLE  [dbo].[cet]
 ADD DEFAULT NULL FOR [Rezago]
GO

ALTER TABLE  [dbo].[cet]
 ADD DEFAULT NULL FOR [Observacion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[cetcp]
 ADD DEFAULT NULL FOR [CET]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[cmgpromedio]
 ADD DEFAULT NULL FOR [CMG_Peso]
GO

ALTER TABLE  [dbo].[cmgpromedio]
 ADD DEFAULT NULL FOR [Observacion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[codigocontrato]
 ADD DEFAULT NULL FOR [Distribuidora]
GO

ALTER TABLE  [dbo].[codigocontrato]
 ADD DEFAULT NULL FOR [Generadora]
GO

ALTER TABLE  [dbo].[codigocontrato]
 ADD DEFAULT NULL FOR [Observacion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[decreto]
 ADD DEFAULT NULL FOR [Nombre]
GO

ALTER TABLE  [dbo].[decreto]
 ADD DEFAULT NULL FOR [FechaPromulgacion]
GO

ALTER TABLE  [dbo].[decreto]
 ADD DEFAULT NULL FOR [FechaPublicacion]
GO

ALTER TABLE  [dbo].[decreto]
 ADD DEFAULT NULL FOR [FechaEntradaVigencia]
GO

ALTER TABLE  [dbo].[decreto]
 ADD DEFAULT NULL FOR [Descripcion]
GO

ALTER TABLE  [dbo].[decreto]
 ADD DEFAULT NULL FOR [Observacion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[demanda]
 ADD DEFAULT NULL FOR [Distribuidora]
GO

ALTER TABLE  [dbo].[demanda]
 ADD DEFAULT NULL FOR [Mes]
GO

ALTER TABLE  [dbo].[demanda]
 ADD DEFAULT NULL FOR [SistemaZonal]
GO

ALTER TABLE  [dbo].[demanda]
 ADD DEFAULT NULL FOR [PuntoRetiro]
GO

ALTER TABLE  [dbo].[demanda]
 ADD DEFAULT NULL FOR [Demanda]
GO

ALTER TABLE  [dbo].[demanda]
 ADD DEFAULT NULL FOR [Observacion]
GO

ALTER TABLE  [dbo].[demanda]
 ADD DEFAULT NULL FOR [TipoDemanda]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[difxcompras]
 ADD DEFAULT NULL FOR [Distribuidora]
GO

ALTER TABLE  [dbo].[difxcompras]
 ADD DEFAULT NULL FOR [Generadora]
GO

ALTER TABLE  [dbo].[difxcompras]
 ADD DEFAULT NULL FOR [SistemaZonal]
GO

ALTER TABLE  [dbo].[difxcompras]
 ADD DEFAULT NULL FOR [CodigoContrato]
GO

ALTER TABLE  [dbo].[difxcompras]
 ADD DEFAULT NULL FOR [FisicoPtoRetiro]
GO

ALTER TABLE  [dbo].[difxcompras]
 ADD DEFAULT NULL FOR [ValorizadoPtoRetiro]
GO

ALTER TABLE  [dbo].[difxcompras]
 ADD DEFAULT NULL FOR [FisicoPtoCompra]
GO

ALTER TABLE  [dbo].[difxcompras]
 ADD DEFAULT NULL FOR [ValorizadoPtoCompra]
GO

ALTER TABLE  [dbo].[difxcompras]
 ADD DEFAULT NULL FOR [DiferenciaMensual]
GO

ALTER TABLE  [dbo].[difxcompras]
 ADD DEFAULT NULL FOR [Observacion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[distribuidora]
 ADD DEFAULT NULL FOR [NombreDistribuidora]
GO

ALTER TABLE  [dbo].[distribuidora]
 ADD DEFAULT NULL FOR [Observacion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[dolarfijacion]
 ADD DEFAULT NULL FOR [VersionDolarFijacion]
GO

ALTER TABLE  [dbo].[dolarfijacion]
 ADD DEFAULT NULL FOR [Mes_PNP]
GO

ALTER TABLE  [dbo].[dolarfijacion]
 ADD DEFAULT NULL FOR [Valor]
GO

ALTER TABLE  [dbo].[dolarfijacion]
 ADD DEFAULT NULL FOR [Descripcion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[eadjanual]
 ADD DEFAULT NULL FOR [IdPtoCompra]
GO

ALTER TABLE  [dbo].[eadjanual]
 ADD DEFAULT NULL FOR [PtoCompra]
GO

ALTER TABLE  [dbo].[eadjanual]
 ADD DEFAULT NULL FOR [EnergiaAnual]
GO

ALTER TABLE  [dbo].[eadjanual]
 ADD DEFAULT NULL FOR [Observacion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[eadjanualdistrmensual]
 ADD DEFAULT NULL FOR [PtoCompra]
GO

ALTER TABLE  [dbo].[eadjanualdistrmensual]
 ADD DEFAULT NULL FOR [EnergiaMensual]
GO

ALTER TABLE  [dbo].[eadjanualdistrmensual]
 ADD DEFAULT NULL FOR [Observacion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[efact]
 ADD DEFAULT NULL FOR [Fecha]
GO

ALTER TABLE  [dbo].[efact]
 ADD DEFAULT NULL FOR [Distribuidora]
GO

ALTER TABLE  [dbo].[efact]
 ADD DEFAULT NULL FOR [Generadora]
GO

ALTER TABLE  [dbo].[efact]
 ADD DEFAULT NULL FOR [CodigoContrato]
GO

ALTER TABLE  [dbo].[efact]
 ADD DEFAULT NULL FOR [PuntoRetiro]
GO

ALTER TABLE  [dbo].[efact]
 ADD DEFAULT NULL FOR [Energia]
GO

ALTER TABLE  [dbo].[efact]
 ADD DEFAULT NULL FOR [Potencia]
GO

ALTER TABLE  [dbo].[efact]
 ADD DEFAULT NULL FOR [Observacion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[estabilizacion]
 ADD DEFAULT NULL FOR [Ano]
GO

ALTER TABLE  [dbo].[estabilizacion]
 ADD DEFAULT NULL FOR [Fecha]
GO

ALTER TABLE  [dbo].[estabilizacion]
 ADD DEFAULT NULL FOR [IPC]
GO

ALTER TABLE  [dbo].[estabilizacion]
 ADD DEFAULT NULL FOR [VariacionIPC]
GO

ALTER TABLE  [dbo].[estabilizacion]
 ADD DEFAULT NULL FOR [Intereses]
GO

ALTER TABLE  [dbo].[estabilizacion]
 ADD DEFAULT NULL FOR [DolarEstabilizacion]
GO

ALTER TABLE  [dbo].[estabilizacion]
 ADD DEFAULT NULL FOR [FactorAjusteE]
GO

ALTER TABLE  [dbo].[estabilizacion]
 ADD DEFAULT NULL FOR [FactorAjusteP]
GO

ALTER TABLE  [dbo].[estabilizacion]
 ADD DEFAULT NULL FOR [Observacion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [IdEfact]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [IdVersionPreciosDef]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [IdVersionPreciosPNP]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [IdDistribuidora]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [IdGeneradora]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [IdCodigoContrato]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [IdPuntoRetiro]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [Energia]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [Potencia]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [Fechaefact_PrecioDef]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [VersionEfact_PrecioDef]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [FechaPNP_PrecioDef]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [VersionPNP_PrecioDef]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [EPC_PrecioDef]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [PPC_PrecioDef]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [ERec_Peso_PrecioDef]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [PRec_Peso_PrecioDef]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [Fechaefact_PrecioPNP]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [VersionEfact_PrecioPNP]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [FechaPNP_PrecioPNP]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [VersionPNP_PrecioPNP]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [EPC_PrecioPNP]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [PPC_PrecioPNP]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [ERec_Peso_PrecioPNP]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [PRec_Peso_PrecioPNP]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [VariacionIPC]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [Interes]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [FactorAjusteE]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [FactorAjusteP]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [DolarDefinitivoPromedioMes]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [DifERec_Peso]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [DifPRec_Peso]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [DifERec_Peso_Estabilizado]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [DifPRec_Peso_Estabilizado]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [DifERec_Dolar_Estabilizado]
GO

ALTER TABLE  [dbo].[estabilizaciondetalle]
 ADD DEFAULT NULL FOR [DifPRec_Dolar_Estabilizado]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[factormodulacion]
 ADD DEFAULT NULL FOR [BarraNacional]
GO

ALTER TABLE  [dbo].[factormodulacion]
 ADD DEFAULT NULL FOR [Valor]
GO

ALTER TABLE  [dbo].[factormodulacion]
 ADD DEFAULT NULL FOR [Observacion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[factorreferenciacion]
 ADD DEFAULT NULL FOR [PuntoRetiro]
GO

ALTER TABLE  [dbo].[factorreferenciacion]
 ADD DEFAULT NULL FOR [BarraNacional]
GO

ALTER TABLE  [dbo].[factorreferenciacion]
 ADD DEFAULT NULL FOR [Factor]
GO

ALTER TABLE  [dbo].[factorreferenciacion]
 ADD DEFAULT NULL FOR [Observacion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[generadora]
 ADD DEFAULT NULL FOR [NombreGeneradora]
GO

ALTER TABLE  [dbo].[generadora]
 ADD DEFAULT NULL FOR [Observacion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[indexacioncet]
 ADD DEFAULT NULL FOR [Licitacion]
GO

ALTER TABLE  [dbo].[indexacioncet]
 ADD DEFAULT NULL FOR [Distribuidora]
GO

ALTER TABLE  [dbo].[indexacioncet]
 ADD DEFAULT NULL FOR [Generadora]
GO

ALTER TABLE  [dbo].[indexacioncet]
 ADD DEFAULT NULL FOR [TieneCET]
GO

ALTER TABLE  [dbo].[indexacioncet]
 ADD DEFAULT NULL FOR [CET0]
GO

ALTER TABLE  [dbo].[indexacioncet]
 ADD DEFAULT NULL FOR [Index]
GO

ALTER TABLE  [dbo].[indexacioncet]
 ADD DEFAULT NULL FOR [MesReferencia]
GO

ALTER TABLE  [dbo].[indexacioncet]
 ADD DEFAULT NULL FOR [Rezago]
GO

ALTER TABLE  [dbo].[indexacioncet]
 ADD DEFAULT NULL FOR [Obsevacion]
GO

ALTER TABLE  [dbo].[indexacioncet]
 ADD DEFAULT NULL FOR [FechaBase]
GO

ALTER TABLE  [dbo].[indexacioncet]
 ADD DEFAULT NULL FOR [ValorBase]
GO

ALTER TABLE  [dbo].[indexacioncet]
 ADD DEFAULT NULL FOR [FEchaActual]
GO

ALTER TABLE  [dbo].[indexacioncet]
 ADD DEFAULT NULL FOR [ValorActual]
GO

ALTER TABLE  [dbo].[indexacioncet]
 ADD DEFAULT NULL FOR [FactorIndexacion]
GO

ALTER TABLE  [dbo].[indexacioncet]
 ADD DEFAULT NULL FOR [ValorCET]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[indexacioncombustible]
 ADD DEFAULT NULL FOR [Fecha]
GO

ALTER TABLE  [dbo].[indexacioncombustible]
 ADD DEFAULT NULL FOR [Valor]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[indexacioncontrato]
 ADD DEFAULT NULL FOR [MesIndexacion]
GO

ALTER TABLE  [dbo].[indexacioncontrato]
 ADD DEFAULT NULL FOR [Version]
GO

ALTER TABLE  [dbo].[indexacioncontrato]
 ADD DEFAULT NULL FOR [Licitacion]
GO

ALTER TABLE  [dbo].[indexacioncontrato]
 ADD DEFAULT NULL FOR [Generadora]
GO

ALTER TABLE  [dbo].[indexacioncontrato]
 ADD DEFAULT NULL FOR [TipoBloque]
GO

ALTER TABLE  [dbo].[indexacioncontrato]
 ADD DEFAULT NULL FOR [Bloque]
GO

ALTER TABLE  [dbo].[indexacioncontrato]
 ADD DEFAULT NULL FOR [PtoOferta]
GO

ALTER TABLE  [dbo].[indexacioncontrato]
 ADD DEFAULT NULL FOR [PrecioEnergiaBase]
GO

ALTER TABLE  [dbo].[indexacioncontrato]
 ADD DEFAULT NULL FOR [IdDecrPNudo]
GO

ALTER TABLE  [dbo].[indexacioncontrato]
 ADD DEFAULT NULL FOR [DecPNudo]
GO

ALTER TABLE  [dbo].[indexacioncontrato]
 ADD DEFAULT NULL FOR [TipoDecreto]
GO

ALTER TABLE  [dbo].[indexacioncontrato]
 ADD DEFAULT NULL FOR [PrecioPotenciaBase]
GO

ALTER TABLE  [dbo].[indexacioncontrato]
 ADD DEFAULT NULL FOR [FactorIndexacionPotencia]
GO

ALTER TABLE  [dbo].[indexacioncontrato]
 ADD DEFAULT NULL FOR [FactorIndexacionEnergia]
GO

ALTER TABLE  [dbo].[indexacioncontrato]
 ADD DEFAULT NULL FOR [PrecioEnergiaIndexado]
GO

ALTER TABLE  [dbo].[indexacioncontrato]
 ADD DEFAULT NULL FOR [PrecioPotenciaIndexado]
GO

ALTER TABLE  [dbo].[indexacioncontrato]
 ADD DEFAULT NULL FOR [FlagIndx]
GO

ALTER TABLE  [dbo].[indexacioncontrato]
 ADD DEFAULT NULL FOR [FlagFij]
GO

ALTER TABLE  [dbo].[indexacioncontrato]
 ADD DEFAULT NULL FOR [MesFijacion]
GO

ALTER TABLE  [dbo].[indexacioncontrato]
 ADD DEFAULT NULL FOR [PrecioEnergiaFijacion]
GO

ALTER TABLE  [dbo].[indexacioncontrato]
 ADD DEFAULT NULL FOR [PrecioPotenciaFijacion]
GO

ALTER TABLE  [dbo].[indexacioncontrato]
 ADD DEFAULT NULL FOR [VariacionE]
GO

ALTER TABLE  [dbo].[indexacioncontrato]
 ADD DEFAULT NULL FOR [VariacionP]
GO

ALTER TABLE  [dbo].[indexacioncontrato]
 ADD DEFAULT NULL FOR [IndexE]
GO

ALTER TABLE  [dbo].[indexacioncontrato]
 ADD DEFAULT NULL FOR [IndexP]
GO

ALTER TABLE  [dbo].[indexacioncontrato]
 ADD DEFAULT NULL FOR [PrecioEnergia]
GO

ALTER TABLE  [dbo].[indexacioncontrato]
 ADD DEFAULT NULL FOR [PrecioPotencia]
GO

ALTER TABLE  [dbo].[indexacioncontrato]
 ADD DEFAULT NULL FOR [Observacion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[indexacioncontratodetalle]
 ADD DEFAULT NULL FOR [MesIndexacion]
GO

ALTER TABLE  [dbo].[indexacioncontratodetalle]
 ADD DEFAULT NULL FOR [Version]
GO

ALTER TABLE  [dbo].[indexacioncontratodetalle]
 ADD DEFAULT NULL FOR [Licitacion]
GO

ALTER TABLE  [dbo].[indexacioncontratodetalle]
 ADD DEFAULT NULL FOR [Generadora]
GO

ALTER TABLE  [dbo].[indexacioncontratodetalle]
 ADD DEFAULT NULL FOR [TipoBloque]
GO

ALTER TABLE  [dbo].[indexacioncontratodetalle]
 ADD DEFAULT NULL FOR [Bloque]
GO

ALTER TABLE  [dbo].[indexacioncontratodetalle]
 ADD DEFAULT NULL FOR [PtoOferta]
GO

ALTER TABLE  [dbo].[indexacioncontratodetalle]
 ADD DEFAULT NULL FOR [PrecioEnergiaBase]
GO

ALTER TABLE  [dbo].[indexacioncontratodetalle]
 ADD DEFAULT NULL FOR [IdDecrPNudo]
GO

ALTER TABLE  [dbo].[indexacioncontratodetalle]
 ADD DEFAULT NULL FOR [DecPNudo]
GO

ALTER TABLE  [dbo].[indexacioncontratodetalle]
 ADD DEFAULT NULL FOR [TipoDecreto]
GO

ALTER TABLE  [dbo].[indexacioncontratodetalle]
 ADD DEFAULT NULL FOR [PrecioPotenciaBase]
GO

ALTER TABLE  [dbo].[indexacioncontratodetalle]
 ADD DEFAULT NULL FOR [TipoIndex]
GO

ALTER TABLE  [dbo].[indexacioncontratodetalle]
 ADD DEFAULT NULL FOR [Index]
GO

ALTER TABLE  [dbo].[indexacioncontratodetalle]
 ADD DEFAULT NULL FOR [MesReferencia]
GO

ALTER TABLE  [dbo].[indexacioncontratodetalle]
 ADD DEFAULT NULL FOR [Rezago]
GO

ALTER TABLE  [dbo].[indexacioncontratodetalle]
 ADD DEFAULT NULL FOR [Ponderador]
GO

ALTER TABLE  [dbo].[indexacioncontratodetalle]
 ADD DEFAULT NULL FOR [FechaBase]
GO

ALTER TABLE  [dbo].[indexacioncontratodetalle]
 ADD DEFAULT NULL FOR [ValorBase]
GO

ALTER TABLE  [dbo].[indexacioncontratodetalle]
 ADD DEFAULT NULL FOR [FechaActual]
GO

ALTER TABLE  [dbo].[indexacioncontratodetalle]
 ADD DEFAULT NULL FOR [ValorActual]
GO

ALTER TABLE  [dbo].[indexacioncontratodetalle]
 ADD DEFAULT NULL FOR [FactorIndexacion]
GO

ALTER TABLE  [dbo].[indexacioncontratodetalle]
 ADD DEFAULT NULL FOR [PrecioIndexadoPonderado]
GO

ALTER TABLE  [dbo].[indexacioncontratodetalle]
 ADD DEFAULT NULL FOR [FlagInd]
GO

ALTER TABLE  [dbo].[indexacioncontratodetalle]
 ADD DEFAULT NULL FOR [Observacion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[indexacioncontratofm]
 ADD DEFAULT NULL FOR [CodigoContrato]
GO

ALTER TABLE  [dbo].[indexacioncontratofm]
 ADD DEFAULT NULL FOR [Licitacion]
GO

ALTER TABLE  [dbo].[indexacioncontratofm]
 ADD DEFAULT NULL FOR [TipoBloque]
GO

ALTER TABLE  [dbo].[indexacioncontratofm]
 ADD DEFAULT NULL FOR [Bloque]
GO

ALTER TABLE  [dbo].[indexacioncontratofm]
 ADD DEFAULT NULL FOR [Distribuidora]
GO

ALTER TABLE  [dbo].[indexacioncontratofm]
 ADD DEFAULT NULL FOR [Generadora]
GO

ALTER TABLE  [dbo].[indexacioncontratofm]
 ADD DEFAULT NULL FOR [PtoOferta]
GO

ALTER TABLE  [dbo].[indexacioncontratofm]
 ADD DEFAULT NULL FOR [BarraNacional]
GO

ALTER TABLE  [dbo].[indexacioncontratofm]
 ADD DEFAULT NULL FOR [PrecioEnergia]
GO

ALTER TABLE  [dbo].[indexacioncontratofm]
 ADD DEFAULT NULL FOR [PrecioPotencia]
GO

ALTER TABLE  [dbo].[indexacioncontratofm]
 ADD DEFAULT NULL FOR [ValorCET]
GO

ALTER TABLE  [dbo].[indexacioncontratofm]
 ADD DEFAULT NULL FOR [RExBasesAno]
GO

ALTER TABLE  [dbo].[indexacioncontratofm]
 ADD DEFAULT NULL FOR [OrigenFMO]
GO

ALTER TABLE  [dbo].[indexacioncontratofm]
 ADD DEFAULT NULL FOR [FMEOferta]
GO

ALTER TABLE  [dbo].[indexacioncontratofm]
 ADD DEFAULT NULL FOR [FMPOferta]
GO

ALTER TABLE  [dbo].[indexacioncontratofm]
 ADD DEFAULT NULL FOR [FMESuministro]
GO

ALTER TABLE  [dbo].[indexacioncontratofm]
 ADD DEFAULT NULL FOR [FMPSuministro]
GO

ALTER TABLE  [dbo].[indexacioncontratofm]
 ADD DEFAULT NULL FOR [PNELP]
GO

ALTER TABLE  [dbo].[indexacioncontratofm]
 ADD DEFAULT NULL FOR [PNPLP]
GO

ALTER TABLE  [dbo].[indexacioncontratofm]
 ADD DEFAULT NULL FOR [Observacion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[indexacioncpi]
 ADD DEFAULT NULL FOR [Fecha]
GO

ALTER TABLE  [dbo].[indexacioncpi]
 ADD DEFAULT NULL FOR [Valor]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[indexaciondolar]
 ADD DEFAULT NULL FOR [Fecha]
GO

ALTER TABLE  [dbo].[indexaciondolar]
 ADD DEFAULT NULL FOR [Valor]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[indexacionipc]
 ADD DEFAULT NULL FOR [Fecha]
GO

ALTER TABLE  [dbo].[indexacionipc]
 ADD DEFAULT NULL FOR [Valor]
GO

ALTER TABLE  [dbo].[indexacionipc]
 ADD DEFAULT NULL FOR [AnoBase]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[indexadorescontratos]
 ADD DEFAULT NULL FOR [Valor]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[licitacion]
 ADD DEFAULT NULL FOR [Licitacion]
GO

ALTER TABLE  [dbo].[licitacion]
 ADD DEFAULT NULL FOR [Observacion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[licitaciondx]
 ADD DEFAULT NULL FOR [Licitacion]
GO

ALTER TABLE  [dbo].[licitaciondx]
 ADD DEFAULT NULL FOR [Distribuidora]
GO

ALTER TABLE  [dbo].[licitaciondx]
 ADD DEFAULT NULL FOR [Observacion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[licitaciongx]
 ADD DEFAULT NULL FOR [Licitacion]
GO

ALTER TABLE  [dbo].[licitaciongx]
 ADD DEFAULT NULL FOR [RExBases]
GO

ALTER TABLE  [dbo].[licitaciongx]
 ADD DEFAULT NULL FOR [DecPNudo]
GO

ALTER TABLE  [dbo].[licitaciongx]
 ADD DEFAULT NULL FOR [TipoDecreto]
GO

ALTER TABLE  [dbo].[licitaciongx]
 ADD DEFAULT NULL FOR [Modalidad]
GO

ALTER TABLE  [dbo].[licitaciongx]
 ADD DEFAULT NULL FOR [MesReferencia]
GO

ALTER TABLE  [dbo].[licitaciongx]
 ADD DEFAULT NULL FOR [Generadora]
GO

ALTER TABLE  [dbo].[licitaciongx]
 ADD DEFAULT NULL FOR [PtoOferta]
GO

ALTER TABLE  [dbo].[licitaciongx]
 ADD DEFAULT NULL FOR [TipoBloque]
GO

ALTER TABLE  [dbo].[licitaciongx]
 ADD DEFAULT NULL FOR [Bloque]
GO

ALTER TABLE  [dbo].[licitaciongx]
 ADD DEFAULT NULL FOR [PrecioEnergia]
GO

ALTER TABLE  [dbo].[licitaciongx]
 ADD DEFAULT NULL FOR [VigenciaInicio]
GO

ALTER TABLE  [dbo].[licitaciongx]
 ADD DEFAULT NULL FOR [VigenciaFin]
GO

ALTER TABLE  [dbo].[licitaciongx]
 ADD DEFAULT NULL FOR [Observacion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[licitaciongxdxptocompra]
 ADD DEFAULT NULL FOR [PtoCompra]
GO

ALTER TABLE  [dbo].[licitaciongxdxptocompra]
 ADD DEFAULT NULL FOR [Observacion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[licitaciongxindexacion]
 ADD DEFAULT NULL FOR [Rezago]
GO

ALTER TABLE  [dbo].[licitaciongxindexacion]
 ADD DEFAULT NULL FOR [Ponderador]
GO

ALTER TABLE  [dbo].[licitaciongxindexacion]
 ADD DEFAULT NULL FOR [Observacion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[licitaciongxindexesp]
 ADD DEFAULT NULL FOR [Fecha]
GO

ALTER TABLE  [dbo].[licitaciongxindexesp]
 ADD DEFAULT NULL FOR [Valor]
GO

ALTER TABLE  [dbo].[licitaciongxindexesp]
 ADD DEFAULT NULL FOR [Observacion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[perdidazonal]
 ADD DEFAULT NULL FOR [SistemaZonal]
GO

ALTER TABLE  [dbo].[perdidazonal]
 ADD DEFAULT NULL FOR [Factor]
GO

ALTER TABLE  [dbo].[perdidazonal]
 ADD DEFAULT NULL FOR [Observacion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[pncp]
 ADD DEFAULT NULL FOR [Observacion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[pncpconcet]
 ADD DEFAULT NULL FOR [FechaEfact]
GO

ALTER TABLE  [dbo].[pncpconcet]
 ADD DEFAULT NULL FOR [PrecioNudoEnergiaPeso]
GO

ALTER TABLE  [dbo].[pncpconcet]
 ADD DEFAULT NULL FOR [CETDolar]
GO

ALTER TABLE  [dbo].[pncpconcet]
 ADD DEFAULT NULL FOR [ValorDolar]
GO

ALTER TABLE  [dbo].[pncpconcet]
 ADD DEFAULT NULL FOR [PrecioNudoEnergiaDolar]
GO

ALTER TABLE  [dbo].[pncpconcet]
 ADD DEFAULT NULL FOR [PrecioNudoPotenciaDolar]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[pnp]
 ADD DEFAULT NULL FOR [Licitacion]
GO

ALTER TABLE  [dbo].[pnp]
 ADD DEFAULT NULL FOR [TipoBloque]
GO

ALTER TABLE  [dbo].[pnp]
 ADD DEFAULT NULL FOR [Bloque]
GO

ALTER TABLE  [dbo].[pnp]
 ADD DEFAULT NULL FOR [Distribuidora]
GO

ALTER TABLE  [dbo].[pnp]
 ADD DEFAULT NULL FOR [Generadora]
GO

ALTER TABLE  [dbo].[pnp]
 ADD DEFAULT NULL FOR [BarraNacional]
GO

ALTER TABLE  [dbo].[pnp]
 ADD DEFAULT NULL FOR [PNELP]
GO

ALTER TABLE  [dbo].[pnp]
 ADD DEFAULT NULL FOR [PNPLP]
GO

ALTER TABLE  [dbo].[pnp]
 ADD DEFAULT NULL FOR [Observacion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[pnpindex]
 ADD DEFAULT NULL FOR [Cet_USD]
GO

ALTER TABLE  [dbo].[pnpindex]
 ADD DEFAULT NULL FOR [PrecioEnergia]
GO

ALTER TABLE  [dbo].[pnpindex]
 ADD DEFAULT NULL FOR [PrecioPotencia]
GO

ALTER TABLE  [dbo].[pnpindex]
 ADD DEFAULT NULL FOR [Observacion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[pnptraspexc]
 ADD DEFAULT NULL FOR [CET_USD]
GO

ALTER TABLE  [dbo].[pnptraspexc]
 ADD DEFAULT NULL FOR [PrecioEnergia]
GO

ALTER TABLE  [dbo].[pnptraspexc]
 ADD DEFAULT NULL FOR [PrecioPotencia]
GO

ALTER TABLE  [dbo].[pnptraspexc]
 ADD DEFAULT NULL FOR [Observacion]
GO

ALTER TABLE  [dbo].[pnptraspexc]
 ADD DEFAULT NULL FOR [DolarMes]
GO

ALTER TABLE  [dbo].[pnptraspexc]
 ADD DEFAULT NULL FOR [CMGPtoSuministro]
GO

ALTER TABLE  [dbo].[pnptraspexc]
 ADD DEFAULT NULL FOR [CMGPtoOferta]
GO

ALTER TABLE  [dbo].[pnptraspexc]
 ADD DEFAULT NULL FOR [PeTraspExc]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[precionudolicitacion]
 ADD DEFAULT NULL FOR [Unidad]
GO

ALTER TABLE  [dbo].[precionudolicitacion]
 ADD DEFAULT NULL FOR [Precio]
GO

ALTER TABLE  [dbo].[precionudolicitacion]
 ADD DEFAULT NULL FOR [Observación]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[puntoretiro]
 ADD DEFAULT NULL FOR [PuntoRetiro]
GO

ALTER TABLE  [dbo].[puntoretiro]
 ADD DEFAULT NULL FOR [Observacion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[recaudaciondetalle]
 ADD DEFAULT NULL FOR [FechaEFact]
GO

ALTER TABLE  [dbo].[recaudaciondetalle]
 ADD DEFAULT NULL FOR [Energia]
GO

ALTER TABLE  [dbo].[recaudaciondetalle]
 ADD DEFAULT NULL FOR [Potencia]
GO

ALTER TABLE  [dbo].[recaudaciondetalle]
 ADD DEFAULT NULL FOR [FEPE]
GO

ALTER TABLE  [dbo].[recaudaciondetalle]
 ADD DEFAULT NULL FOR [FEPP]
GO

ALTER TABLE  [dbo].[recaudaciondetalle]
 ADD DEFAULT NULL FOR [FactorFR]
GO

ALTER TABLE  [dbo].[recaudaciondetalle]
 ADD DEFAULT NULL FOR [PNELP]
GO

ALTER TABLE  [dbo].[recaudaciondetalle]
 ADD DEFAULT NULL FOR [PNPLP]
GO

ALTER TABLE  [dbo].[recaudaciondetalle]
 ADD DEFAULT NULL FOR [CETCP]
GO

ALTER TABLE  [dbo].[recaudaciondetalle]
 ADD DEFAULT NULL FOR [PNECP_USD]
GO

ALTER TABLE  [dbo].[recaudaciondetalle]
 ADD DEFAULT NULL FOR [PNPCP_USD]
GO

ALTER TABLE  [dbo].[recaudaciondetalle]
 ADD DEFAULT NULL FOR [EPC]
GO

ALTER TABLE  [dbo].[recaudaciondetalle]
 ADD DEFAULT NULL FOR [PPC]
GO

ALTER TABLE  [dbo].[recaudaciondetalle]
 ADD DEFAULT NULL FOR [ERec_USD]
GO

ALTER TABLE  [dbo].[recaudaciondetalle]
 ADD DEFAULT NULL FOR [PRec_USD]
GO

ALTER TABLE  [dbo].[recaudaciondetalle]
 ADD DEFAULT NULL FOR [Dolar]
GO

ALTER TABLE  [dbo].[recaudaciondetalle]
 ADD DEFAULT NULL FOR [ERec_Peso]
GO

ALTER TABLE  [dbo].[recaudaciondetalle]
 ADD DEFAULT NULL FOR [PRec_Peso]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[sistemazonal]
 ADD DEFAULT NULL FOR [SistemaZonal]
GO

ALTER TABLE  [dbo].[sistemazonal]
 ADD DEFAULT NULL FOR [OBservacion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[tipocombustible]
 ADD DEFAULT NULL FOR [TipoCombustible]
GO

ALTER TABLE  [dbo].[tipocombustible]
 ADD DEFAULT NULL FOR [Unidad]
GO

ALTER TABLE  [dbo].[tipocombustible]
 ADD DEFAULT NULL FOR [Observacion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[tipodespacho]
 ADD DEFAULT NULL FOR [Descripcion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[versionefact]
 ADD DEFAULT NULL FOR [Descripcion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[versionestabilizacion]
 ADD DEFAULT NULL FOR [Fecha]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[versionrec]
 ADD DEFAULT NULL FOR [Descripcion]
GO


USE pnp_3
GO
ALTER TABLE  [dbo].[versionrecdetalle]
 ADD DEFAULT NULL FOR [ValorTexto]
GO

ALTER TABLE  [dbo].[versionrecdetalle]
 ADD DEFAULT NULL FOR [ValorFecha]
GO

ALTER TABLE  [dbo].[versionrecdetalle]
 ADD DEFAULT NULL FOR [ValorInt]
GO

ALTER TABLE  [dbo].[versionrecdetalle]
 ADD DEFAULT NULL FOR [ValorFloat]
GO

ALTER TABLE  [dbo].[versionrecdetalle]
 ADD DEFAULT NULL FOR [Descripcion]
GO


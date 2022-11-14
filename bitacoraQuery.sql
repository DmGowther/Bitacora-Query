-- CREACION DE LA BITACORA PARA BASE DE DATOS COMPLETA

IF NOT EXISTS (
    SELECT name
        FROM sys.databases
        WHERE name = N'bitacora'
)
CREATE TABLE dbo.bitacora
(
    [idBitacora] [int] IDENTITY(1,1) NOT NULL,
    [DatabaseName] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [EventTyoe] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [ObjectName] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [ObjectType] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [SqlCommand] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [EventDate] [datetime] NOT NULL CONSTRAINT [DF_bitacora_EventDate]  DEFAULT (getdate()),
    [LoginName] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [HostName] [varchar](70) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [AppName] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
)ON [PRIMARY];
GO

CREATE TRIGGER objBitacora
ON DATABASE

FOR create_procedure, alter_procedure, drop_procedure,
create_table, alter_table, drop_table,
create_function, alter_function, drop_function
AS
SET NOCOUNT ON
DECLARE @data xml
SET @data = EVENTDATA()
INSERT INTO dbo.bitacora
(
    DatabaseName,
    EventTyoe,
    ObjectName,
    ObjectType,
    SqlCommand,
    LoginName,
    HostName,
    AppName
)
VALUES
(
    @data.value('(/EVENT_INSTANCE/DatabaseName)[1]', 'varchar(256)'),
    @data.value('(/EVENT_INSTANCE/EventTyoe)[1]', 'varchar(50)'),
    @data.value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(256)'),
    @data.value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(25)'),
    @data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'varchar(max)'),
    @data.value('(/EVENT_INSTANCE/LoginName)[1]', 'varchar(256)'),
    host_name(), 
    APP_NAME()
)
GO  

-- Creaci�n de un usuario
USE [master]
GO
CREATE LOGIN [new_employee] WITH PASSWORD=N'Password', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

-- Asignaci�n de una DB y rol al usuario nuevo
USE [WideWorldImporters];

CREATE USER [new_employee] FOR LOGIN [new_employee]
GO

USE [WideWorldImporters]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [new_employee]
GO

-- Creaci�n de schemas
CREATE SCHEMA Interno
GO

ALTER SCHEMA Interno TRANSFER Cities
ALTER SCHEMA Interno TRANSFER Countries
ALTER SCHEMA Interno TRANSFER StateProvinces

-- Asignaci�n de Schema al usuario
GRANT SELECT ON SCHEMA::[Interno] TO [Ralph_DBA];
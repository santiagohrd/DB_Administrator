USE master;

-- Revisión de la fecha del primer y último backup de la db. Adicionalmente, relaciona el tipo de backup 
SELECT database_name,
	name,
	backup_start_date,
	backup_finish_date,
	CASE
		WHEN type = 'D' THEN 'Full Backup'
		WHEN type = 'L' THEN 'Log Backup'
		WHEN type = 'I' THEN 'Differential Backup'
	END AS Type
FROM msdb.dbo.backupset;

-- Generando un full Backup
BACKUP DATABASE [WideWorldImporters] TO  DISK = 'C:\LOCATION\WideWorldImportes_dc.bak' 
GO

-- Restableciendo un full Backup reemplazando completamente el db
USE [master]
RESTORE DATABASE [WideWorldImporters] FROM  DISK = 'C:\LOCATION\WideWorldImporters-Full.bak' WITH REPLACE

GO

-- Backup diferencial
BACKUP DATABASE [WideWorldImporters] TO  DISK = 'C:\LOCATION\WideWorldImportes_dc.bak' WITH  DIFFERENTIAL
GO

-- Restaurando un backup diferencial
USE [master]
RESTORE DATABASE [WideWorldImporters] FROM  DISK = 'C:\LOCATION\WideWorldImporters_LogBackup_2023-05-14_06-44-25.bak' WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 5

GO


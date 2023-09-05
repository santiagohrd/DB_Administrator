USE WideWorldImporters;

-- Fechas de creaci�n de tablas y modificaci�n de las mismas
SELECT name,
	create_date,
	modify_date
FROM sys.tables
WHERE type = 'U';

-- Columnas y tablas a las que pertenencen filtrada por sus nombres
SELECT sc.name AS ColumnName,
	st.name AS TableName,
	sc.max_length
FROM sys.columns sc
INNER JOIN sys.tables st
	ON sc.object_id = st.object_id
WHERE sc.name LIKE '%name%';

-- Nombre de los archivos, locaci�n y tama�o de los mismos en MB
SELECT name,
	physical_name,
	size,
	(size * 8) / 1024 as sizeMB
FROM sys.database_files;

-- Consulta a toda la informaci�n de las columnas y tablas de la base de datos
SELECT *
FROM WideWorldImporters.INFORMATION_SCHEMA.COLUMNS;

SELECT *
FROM WideWorldImporters.INFORMATION_SCHEMA.TABLES;

-- Verificaci�n del modo de autorizaci�n
SELECT
	CASE
		SERVERPROPERTY('IsIntegratedSecurityOnly')
		WHEN 1 THEN 'Windows Authentication'
		WHEN 0 THEN 'Windows and SQL Authentication'
	END as [Authentication Mode];




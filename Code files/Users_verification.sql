
-- Revisión y validación de usuarios existentes
USE master;

SELECT name,
	principal_id,
	type_desc,
	is_disabled,
	create_date,
	modify_date
FROM sys.sql_logins;

-- roles y permisos de seguridad en la base de datos
USE WideWorldImporters;

SELECT pr.principal_id,
	pr.name,
	pr.type_desc,
	pr.authentication_type_desc,
	pe.state_desc,
	pe.permission_name

FROM sys.database_principals AS pr
	JOIN sys.database_permissions AS pe
	ON pe.grantee_principal_id = pr.principal_id
WHERE pr.name <> 'Public';

-- Verificación de roles y usuarios asignados a dicho rol dentro de la dB
SELECT pr.name AS DB_Role,
	ISNULL (pr2.name, 'No Members') AS DB_UserName
FROM sys.database_role_members as rm
	RIGHT JOIN sys.database_principals as pr
	ON rm.role_principal_id = pr.principal_id
	LEFT JOIN sys.database_principals as pr2
	ON rm.member_principal_id = pr2.principal_id
ORDER BY pr.name;
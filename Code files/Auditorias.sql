--Auditoria automatizada de usuarios
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'system_users_admin', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'DESKTOP-UPJ12JN\User', @job_id = @jobId OUTPUT
select @jobId
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'system_users_admin', @server_name = N'DESKTOP-UPJ12JN'
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'system_users_admin', @step_name=N'create_table', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'drop table if exists custom_audit.sysadmin_users

create table custom_audit.sysadmin_users
	(
	name varchar(100),
	roleName varchar(50),
	modify_date datetime
	);', 
		@database_name=N'msdb', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'system_users_admin', @step_name=N'insert_data', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'INSERT INTO custom_audit.sysadmin_users
SELECT members.name
	, roles.name
	, members.modify_date
FROM sys.server_role_members AS rm
INNER JOIN sys.server_principals as roles
	ON rm.role_principal_id = roles.principal_id
INNER JOIN sys.server_principals as members
	ON rm.member_principal_id = members.principal_id;', 
		@database_name=N'msdb', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'system_users_admin', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'DESKTOP-UPJ12JN\User', 
		@notify_email_operator_name=N'', 
		@notify_page_operator_name=N''
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'system_users_admin', @name=N'Weekly_audit', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=2, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20230907, 
		@active_end_date=99991231, 
		@active_start_time=120000, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO


-- Auditoria a conexiones fallidas

--Step 1
USE [msdb]
GO
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'failed_logins', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'DESKTOP-UPJ12JN\User', @job_id = @jobId OUTPUT
select @jobId
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'failed_logins', @server_name = N'DESKTOP-UPJ12JN'
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'failed_logins', @step_name=N'create_table', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DROP TABLE IF EXISTS custom_audit.failed_logins_$(ESCAPE_NONE(DATE))

CREATE TABLE custom_audit.failed_logins_$(ESCAPE_NONE(DATE))
	(
	message_date datetime,
	message_type varchar(20) NULL,
	message varchar(150) NULL
	);', 
		@database_name=N'msdb', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'failed_logins', @step_name=N'insert_data', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'INSERT INTO custom_audit.failed_logins
exec sp_readerrorlog 0, 1, ''Login failed'';', 
		@database_name=N'msdb', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'failed_logins', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'DESKTOP-UPJ12JN\User', 
		@notify_email_operator_name=N'', 
		@notify_page_operator_name=N''
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'failed_logins', @name=N'daily', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=42, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20230907, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO

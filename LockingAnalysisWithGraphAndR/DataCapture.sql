/*
Read the section bellow carefully.

1) Make sure you "USE" a database used for you DBA processes.

2) The following should be run only once

--1)Create schema dba if it does not exists

USE [ThisIsTheDBADatabase]
GO
IF (SELECT SCHEMA_ID('dba')) IS NULL
BEGIN
	CREATE SCHEMA dba 
END 

--2) Create Tables

--sessions
CREATE TABLE [dba].[tbl_sessions](
	[run_date] [DATETIME] NOT NULL,
	[session_id] [SMALLINT] NOT NULL
	INDEX ixc clustered (run_date)
) 
AS node


-- Requests Details
CREATE TABLE dba.tbl_request_details(
	[run_date] [DATETIME] NOT NULL,
	[session_id] [INT] NULL,
	[status] [NVARCHAR](300) NULL,
	[blocking_session_id] [INT] NULL,
	[wait_type] [NVARCHAR](600) NULL,
	[wait_resource] [NVARCHAR](2560) NULL,
	[wait_time] [BIGINT] NULL,
	[cpu_time] [BIGINT] NULL,
	[logical_reads] [BIGINT] NULL,
	[reads] [BIGINT] NULL,
	[writes] [BIGINT] NULL,
	[total_elapsed_time] [BIGINT] NULL,
	[statement_text] [NVARCHAR](MAX) NULL,
	[command_text] [NVARCHAR](MAX) NULL,
	[command] [NVARCHAR](MAX) NULL,
	[login_name] [NVARCHAR](200) NULL,
	[host_name] [NVARCHAR](200) NULL,
	[program_name] [NVARCHAR](200) NULL,
	[host_process_id] [BIGINT] NULL,
	[last_request_end_time] [DATETIME] NULL,
	[login_time] [DATETIME] NULL,
	[open_transaction_count] [INT] NULL,
	[command_text] [NVARCHAR](MAX) NULL,

	INDEX ixc CLUSTERED (run_date)
)
AS node

-- Blocked Table
CREATE TABLE dba.tbl_blocked (run_date [DATETIME] NOT NULL, INDEX ixc CLUSTERED (run_date) )
AS edge


*/

-- Bellow is the code to run to save locking activity

DECLARE @run_date AS DATETIME

SET @run_date =(SELECT GETDATE())


INSERT INTO [dba].[tbl_sessions] (   [run_date] ,
                               [session_id] ,
                               [login_time] ,
                               [host_name] ,
                               [program_name] ,
                               [host_process_id] ,
                               [login_name] ,
                               [status] ,
                               [last_request_end_time]
                           )
SELECT @run_date,session_id,login_time,host_name,program_name,host_process_id,login_name,status,last_request_end_time FROM sys.dm_exec_sessions

INSERT INTO dba.tbl_request_details (   run_date ,
                                        session_id ,
                                        status ,
                                        blocking_session_id ,
                                        wait_type ,
                                        wait_resource ,
                                        wait_time ,
                                        cpu_time ,
                                        logical_reads ,
                                        reads ,
                                        writes ,
                                        total_elapsed_time ,
                                        statement_text ,
                                        command_text ,
                                        command ,
                                        login_name ,
                                        host_name ,
                                        program_name ,
                                        host_process_id ,
                                        last_request_end_time ,
                                        login_time ,
                                        open_transaction_count
                                    )

SELECT @run_date ,
	   s.session_id ,
       r.status ,
       r.blocking_session_id ,
       r.wait_type ,
       wait_resource ,
       r.wait_time ,
       r.cpu_time ,
       r.logical_reads ,
       r.reads ,
       r.writes ,
       r.total_elapsed_time ,
       SUBSTRING(
                    st.text ,
                    ( r.statement_start_offset / 2 ) + 1,
                    (( CASE r.statement_end_offset
                            WHEN-1 THEN DATALENGTH(st.text)
                            ELSE r.statement_end_offset
                       END - r.statement_start_offset
                     ) / 2
                    ) + 1
                ) AS statement_text ,
       COALESCE(QUOTENAME(DB_NAME(st.dbid)) + N'.'
                + QUOTENAME(OBJECT_SCHEMA_NAME(st.objectid ,
                                               st.dbid
                                              )
                           ) + N'.'
                + QUOTENAME(OBJECT_NAME(st.objectid ,
                                        st.dbid
                                       )
                           ) ,'') AS command_text ,
       r.command ,
       s.login_name ,
       s.host_name ,
       s.program_name ,
       s.host_process_id ,
       s.last_request_end_time ,
       s.login_time ,
       r.open_transaction_count
FROM   sys.dm_exec_sessions AS s
       JOIN sys.dm_exec_requests AS r ON r.session_id = s.session_id
       CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS st
WHERE  r.session_id != @@SPID;


-- Populate Blocking Edge

INSERT INTO dba.tbl_blocked 
SELECT sessions.$node_id,details.$node_id,sessions.run_date FROM dba.tbl_sessions sessions
RIGHT  OUTER JOIN
dba.tbl_request_details details
ON sessions.session_id=details.session_id
AND sessions.run_date=details.run_date
WHERE details.run_date=@run_date
AND details.blocking_session_id !=0

-- For Reference
SELECT @run_date

SELECT * FROM dba.tbl_blocked
WHERE run_date=@run_date

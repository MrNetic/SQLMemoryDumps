

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

-- Requests
CREATE TABLE [dba].[tbl_sessions](
	[run_date] [DATETIME] NOT NULL,
	[session_id] [SMALLINT] NOT NULL,
	[login_time] [DATETIME] NOT NULL,
	[host_name] [NVARCHAR](128) NULL,
	[program_name] [NVARCHAR](128) NULL,
	[host_process_id] [INT] NULL,
	[login_name] [NVARCHAR](128) NOT NULL,
	[status] [NVARCHAR](30) NOT NULL,
	[last_request_end_time] [DATETIME] NULL,
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
-- 

--- Nota, experimentar uma tabela com os blocking
--- E outra tabela com os processos
--- E depois outra tabela com todos os processos bloqueados
--- 

DECLARE @rscript NVARCHAR(2000)
DECLARE @rinputdata NVARCHAR(2000)
DECLARE @run_date AS DATETIME
-- Output Location, note: include the last \\
DECLARE @igraphoutputlocation NVARCHAR(200) = 'F:\\WorkAux\\DBA\\BlockingGraphs\\'
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



--SELECT * INTO #requests FROM [.\sql2016].gbeodin_poc.dba.tbl_Requests
--WHERE Instance_id =31
--AND run_date='2017-07-17 07:55:01.000'


-- Create Blocking Edge

INSERT INTO dba.tbl_blocked 
SELECT sessions.$node_id,details.$node_id,sessions.run_date FROM dba.tbl_sessions sessions
RIGHT  OUTER JOIN
dba.tbl_request_details details
ON sessions.session_id=details.session_id
AND sessions.run_date=details.run_date
WHERE details.run_date=@run_date


/*
Aux Query
SELECT		sessions.session_id AS SessionID,
			details.host_name AS HostName,
			details.command_text AS CommandText,
			details.wait_type AS WaitType,
			details.wait_resource AS WaitResource,
			details.blocking_session_id AS BlockerSessionID,
			ISNULL((SELECT host_name FROM dba.tbl_request_details WHERE session_id= details.blocking_session_id AND run_date=blocked.run_date),0) as BlockerProcssHostName,
			ISNULL((SELECT command_text FROM dba.tbl_request_details WHERE session_id= details.blocking_session_id AND run_date=blocked.run_date),0) AS BlockerCommandText,
			ISNULL((SELECT wait_type FROM dba.tbl_request_details WHERE session_id= details.blocking_session_id AND run_date=blocked.run_date),0) as BlockerProcessWaitType,
			ISNULL((SELECT wait_resource FROM dba.tbl_request_details WHERE session_id= details.blocking_session_id AND run_date=blocked.run_date),0) as BlockerProcessWaitResource,
			ISNULL((SELECT wait_time FROM dba.tbl_request_details WHERE session_id= details.blocking_session_id AND run_date=blocked.run_date),0) AS BlockerProcessWaitTime
	

FROM dba.tbl_sessions sessions, dba.tbl_blocked blocked, dba.tbl_request_details details
WHERE MATCH(sessions-(blocked)->details)
AND blocked.run_date='2017-07-17 07:55:01.000'	

*/

SET @rscript= N'
require(igraph)

g <- graph.data.frame(graphdf)

V(g)$label.cex <- 2

jpeg(filename = "'+@igraphoutputlocation+
REPLACE(CONVERT (VARCHAR(24), @run_date,126),':','')+'_blockingAnalysis.jpeg", height = 4000, width = 5000, res = 150);
plot(g, vertex.label.family = "sans", vertex.size = 4)
dev.off()
'

SET @rinputdata = N'SELECT sessions.session_id,details.blocking_session_id,details.host_name
FROM dba.tbl_sessions sessions, dba.tbl_blocked blocked, dba.tbl_request_details details
WHERE MATCH(sessions-(blocked)->details)
AND blocked.run_date=''' + '2017-07-17 07:55:01.000'+''''
--AND blocked.run_date=''' + CONVERT (CHAR(24), @run_date,126)+''''



	EXEC sp_execute_external_script @language = N'R',
	@script =@rscript,
	@input_data_1 =@rinputdata,
	@input_data_1_name = N'graphdf'



	-- second example by hostname
	SET @rscript= N'
require(igraph)

g <- graph.data.frame(graphdf)

V(g)$label.cex <- 2

jpeg(filename = "'+@igraphoutputlocation+
REPLACE(CONVERT (VARCHAR(24), @run_date,126),':','')+'_blockingAnalysis_ByHostname.jpeg",height = 4000, width = 5000, res = 100);
plot(g, vertex.label.family = "sans", vertex.size = 4)
dev.off()
'

SET @rinputdata = N'select 
			details.host_name AS HostName,
			ISNULL((SELECT host_name FROM dba.tbl_request_details WHERE session_id= details.blocking_session_id AND run_date=blocked.run_date),''NotBlocked :)'') as BlockerProcssHostName
			
			
FROM dba.tbl_sessions sessions, dba.tbl_blocked blocked, dba.tbl_request_details details
WHERE MATCH(sessions-(blocked)->details)
AND blocked.run_date=''' + '2017-07-17 07:55:01.000'+''''
--AND blocked.run_date=''' + CONVERT (CHAR(24), @run_date,126)+''''



	EXEC sp_execute_external_script @language = N'R',
	@script =@rscript,
	@input_data_1 =@rinputdata,
	@input_data_1_name = N'graphdf'

	-- second example by Command Text
	SET @rscript= N'
require(igraph)

g <- graph.data.frame(graphdf)

V(g)$label.cex <- 2

jpeg(filename = "'+@igraphoutputlocation+
REPLACE(CONVERT (VARCHAR(24), @run_date,126),':','')+'_blockingAnalysis_ByCommandText.jpeg", height = 4000, width = 5000, res = 150);
plot(g, vertex.label.family = "sans", vertex.size = 4)
dev.off()
'

SET @rinputdata = N'SELECT
			details.command_text AS CommandText,
			ISNULL((SELECT command_text FROM dba.tbl_request_details WHERE session_id= details.blocking_session_id AND run_date=blocked.run_date),''NotBlocked :)'') AS BlockerCommandText
	

FROM dba.tbl_sessions sessions, dba.tbl_blocked blocked, dba.tbl_request_details details
WHERE MATCH(sessions-(blocked)->details)
AND blocked.run_date=''' + '2017-07-17 07:55:01.000'+''''


SELECT @rinputdata
--AND blocked.run_date=''' + CONVERT (CHAR(24), @run_date,126)+''''



EXEC sp_execute_external_script @language = N'R',
	@script =@rscript,
	@input_data_1 =@rinputdata,
	@input_data_1_name = N'graphdf'


	



--IF (EXISTS (SELECT TOP 1 run_date FROM dba.tbl_blocked WHERE run_date=@run_date))
--BEGIN
--	EXEC sp_execute_external_script @language = N'R',
--	@script =@rscript,
--	@input_data_1 =@rinputdata,
--	@input_data_1_name = N'graphdf'
--END 




/*




Msg 39023, Level 16, State 1, Procedure sp_execute_external_script, Line 1 [Batch Start Line 0]
'sp_execute_external_script' is disabled on this instance of SQL Server. Use sp_configure 'external scripts enabled' to enable it.


sp_configure 'external scripts enabled', 1

RECONFIGURE

-- service needs to be reconfigured

ADD URL ON installing this STUFF

--



exec sp_execute_external_script @language = N'R',
@script = N'
require(igraph)

g <- graph.data.frame(graphdf)

V(g)$label.cex <- 2

jpeg(filename = "F:\WorkAux\DBA\BlockingGraphs\\blockingAnalysis.jpeg", height = 10000, width = 10000, res = 100);
plot(g, vertex.label.family = "sans", vertex.size = 6)
dev.off()
',
@input_data_1 = N'SELECT requests.session_id,details.blocking_session_id,details.host_name
FROM dba.tbl_requests requests, dba.tbl_blocked blocked, dba.tbl_request_details details
WHERE MATCH(requests-(blocked)->details)
',
@input_data_1_name = N'graphdf'
GO

*/
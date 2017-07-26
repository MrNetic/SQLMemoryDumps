DECLARE @rscript NVARCHAR(2000)
DECLARE @rinputdata NVARCHAR(2000)
DECLARE @run_date AS DATETIME
-- Output Location, note: include the last \\
DECLARE @igraphoutputlocation NVARCHAR(200) = 'F:\\WorkAux\\DBA\\BlockingGraphs\\'

SET @run_date = '2017-06-10 07:55:01.000'
SET @rinputdata = N'SELECT sessions.session_id,details.blocking_session_id,details.host_name
FROM dba.tbl_sessions sessions, dba.tbl_blocked blocked, dba.tbl_request_details details
WHERE MATCH(sessions-(blocked)->details)
AND blocked.run_date=''' + CONVERT (CHAR(19), @run_date,126)+''''


SELECT @rinputdata
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
AND blocked.run_date=''' + CONVERT (CHAR(24), @run_date,126)+''''



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
AND blocked.run_date=''' + CONVERT (CHAR(24), @run_date,126)+''''



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
AND blocked.run_date=''' + CONVERT (CHAR(24), @run_date,126)+''''




EXEC sp_execute_external_script @language = N'R',
	@script =@rscript,
	@input_data_1 =@rinputdata,
	@input_data_1_name = N'graphdf'

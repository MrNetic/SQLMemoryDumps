-- Lets start by details of LogReader
-- save it on a temp table
SELECT ROW_NUMBER() OVER(ORDER BY time ASC) AS RecordID,*
INTO #LogReaderHistory
FROM mslogreader_history WITH (nolock) 
WHERE time >='2016-08-09 19:04:29.823' 
AND time <='2016-08-10 02:20:54.163'
-- get the agent_id from SELECT * FROM dbo.MSlogreader_agents
AND agent_id=36
ORDER BY time ASC

-- Look for pattern change on DeliveredTransactions & DeliveredCommands
SELECT a.RecordID,b.RecordId,b.time,b.delivered_transactions-a.delivered_transactions AS DeliveredTransactions,
b.delivered_commands-a.delivered_commands AS DeliveredCommands
, a.* FROM #LogReaderHistory a
LEFT OUTER JOIN
(SELECT RecordID-1 AS RecordIdToJoin, * FROM #LogReaderHistory) b
ON a.RecordID=b.RecordIdToJoin

ORDER BY a.RecordID

-- Also, start by getting the other part of the coin (distrib.exe)

SELECT ROW_NUMBER() OVER(ORDER BY time ASC) AS RecordID,*
INTO #DistribHistory
FROM MSdistribution_history WITH (nolock) 
WHERE time >='2016-08-09 19:04:29.823' 
AND time <='2016-08-10 02:20:54.163'
-- get the agent_id from SELECT * FROM dbo.MSdistribution_agents
AND agent_id=36
AND delivered_transactions!=0
AND delivered_commands!=0
ORDER BY time asc

SELECT * FROM #DistribHistory

-- Look for pattern change on DeliveredTransactions & DeliveredCommands
SELECT a.RecordID,b.RecordId,b.time,b.delivered_transactions-a.delivered_transactions AS DeliveredTransactions,
b.delivered_commands-a.delivered_commands AS DeliveredCommands
, a.*,b.* FROM #DistribHistory a
LEFT OUTER JOIN
(SELECT RecordID-1 AS RecordIdToJoin, * FROM #DistribHistory) b
ON a.RecordID=b.RecordIdToJoin
ORDER BY a.RecordID

-- Look For all records where deliveredtransactions/DeliveredCommands=0

SELECT ROW_NUMBER() OVER(ORDER BY time ASC) AS RecordID,*
INTO #DistribHistory_WithZero
FROM MSdistribution_history WITH (nolock) 
WHERE time >='2016-08-09 19:04:29.823' 
AND time <='2016-08-10 02:20:54.163'
-- get the agent_id from SELECT * FROM dbo.MSdistribution_agents
AND agent_id=36
AND delivered_transactions=0
OR delivered_commands=0
ORDER BY time ASC

SELECT *,time AS abc,CAST (comments AS XML) FROM #DistribHistory_WithZero
where agent_id=36
ORDER BY abc



SELECT * FROM dbo.MSlogreader_agents
WHERE time >='2016-07-26 07:04:29.823' 
AND time <='2016-07-26 10:30:40.813'
AND agent_id=36

SELECT TOP 100 * FROM mslogreader_history
WHERE time >='2016-07-26 07:04:29.823' 
--AND time <='2016-07-26 10:30:40.813'
AND agent_id=36


SELECT TOP 25
  st.text, qp.query_plan,
    (qs.total_logical_reads/qs.execution_count) as avg_logical_reads,
    (qs.total_logical_writes/qs.execution_count) as avg_logical_writes,
    (qs.total_physical_reads/qs.execution_count) as avg_phys_reads,
  qs.*
FROM sys.dm_exec_query_stats as qs
         CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as st
         CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) as qp
WHERE st.text like 'CREATE PROCEDURE sys.sp_MSget_repl_commands%'
  ORDER BY qs.total_worker_time DESC
Go
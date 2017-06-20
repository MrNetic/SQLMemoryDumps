SELECT 
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
SUBSTRING(st.text,
        ( r.statement_start_offset / 2 ) + 1,
        ( ( CASE r.statement_end_offset
            WHEN -1
            THEN DATALENGTH(st.text)
            ELSE r.statement_end_offset
            END - r.statement_start_offset )
        / 2 ) + 1) AS statement_text ,
COALESCE(QUOTENAME(DB_NAME(st.dbid)) + N'.'
        + QUOTENAME(OBJECT_SCHEMA_NAME(st.objectid,
                            st.dbid)) + N'.'
        + QUOTENAME(OBJECT_NAME(st.objectid,
                            st.dbid)), '') AS command_text ,
r.command ,
s.login_name ,
s.host_name ,
s.program_name ,
s.host_process_id ,
s.last_request_end_time ,
s.login_time ,
r.open_transaction_count,
r.plan_handle,r.query_hash,r.query_plan_hash,
p.query_plan
FROM    sys.dm_exec_sessions AS s
INNER JOIN sys.dm_exec_requests AS r ON r.session_id = s.session_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle)
AS st
CROSS APPLY sys.dm_exec_query_plan(r.plan_handle) p
WHERE   r.session_id != @@SPID
ORDER BY r.wait_time DESC;

SELECT 
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
SUBSTRING(st.text,
        ( r.statement_start_offset / 2 ) + 1,
        ( ( CASE r.statement_end_offset
            WHEN -1
            THEN DATALENGTH(st.text)
            ELSE r.statement_end_offset
            END - r.statement_start_offset )
        / 2 ) + 1) AS statement_text ,
COALESCE(QUOTENAME(DB_NAME(st.dbid)) + N'.'
        + QUOTENAME(OBJECT_SCHEMA_NAME(st.objectid,
                            st.dbid)) + N'.'
        + QUOTENAME(OBJECT_NAME(st.objectid,
                            st.dbid)), '') AS command_text ,
r.command ,
s.login_name ,
s.host_name ,
s.program_name ,
s.host_process_id ,
s.last_request_end_time ,
s.login_time ,
r.open_transaction_count,
r.plan_handle,r.query_hash,r.query_plan_hash--,
--p.query_plan
FROM    sys.dm_exec_sessions AS s
INNER JOIN sys.dm_exec_requests AS r ON r.session_id = s.session_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle)
AS st
--CROSS APPLY sys.dm_exec_query_plan(r.plan_handle) p
WHERE   r.session_id != @@SPID
ORDER BY r.wait_time DESC;


SELECT session_id ,
       request_id ,
       scheduler_id ,
       dop ,
       request_time ,
       requested_memory_kb ,
       granted_memory_kb ,
       required_memory_kb ,
       used_memory_kb ,
       max_used_memory_kb ,
       grant_time ,
	   query_cost ,
       timeout_sec ,
       resource_semaphore_id ,
       queue_id ,
       wait_order ,
       is_next_candidate ,
       wait_time_ms ,
       plan_handle ,
       sql_handle ,
       group_id ,
       pool_id ,
       is_small ,
       ideal_memory_kb FROM sys.dm_exec_query_memory_grants


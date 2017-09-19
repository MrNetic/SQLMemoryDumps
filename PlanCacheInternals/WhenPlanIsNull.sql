--https://blogs.msdn.microsoft.com/psssql/2016/07/13/why-am-i-getting-null-values-for-query_plan-from-sys-dm_exec_query_plan/

--
SELECT s2.dbid,   
    s1.sql_handle,    
    (SELECT TOP 1 SUBSTRING(s2.text,statement_start_offset / 2+1 ,   
      ( (CASE WHEN statement_end_offset = -1   
         THEN (LEN(CONVERT(nvarchar(max),s2.text)) * 2)   
         ELSE statement_end_offset END)  - statement_start_offset) / 2+1))  AS sql_statement,  
         cast(s3.query_plan as xml) query_plan,
    execution_count,   
    plan_generation_num,   
    last_execution_time,     
    total_worker_time,   
    last_worker_time,   
    min_worker_time,   
    max_worker_time,  
    total_physical_reads,   
    last_physical_reads,   
    min_physical_reads,    
    max_physical_reads,    
    total_logical_writes,   
    last_logical_writes,   
    min_logical_writes,   
    max_logical_writes    
                
FROM sys.dm_exec_query_stats AS s1   
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS s2    
cross apply sys.dm_exec_text_query_plan (plan_handle, statement_start_offset, statement_end_offset) s3
where object_name ( s2.objectid, s2.dbid) = 'Proc'
ORDER BY s1.sql_handle, s1.statement_start_offset, s1.statement_end_offset;  
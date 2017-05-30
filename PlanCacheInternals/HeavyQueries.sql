
    SELECT TOP 10
            st.* ,
            qs.* ,
            qp.*
    FROM    sys.dm_exec_query_stats qs
            CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
            CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
    ORDER BY qs.last_worker_time DESC; 
 
    SELECT TOP 50
            [Average CPU used] = total_worker_time / qs.execution_count ,
            [Total CPU used] = total_worker_time ,
            [Execution count] = qs.execution_count ,
            [Individual Query] = SUBSTRING(qt.text, qs.statement_start_offset / 2,
                                           ( CASE WHEN qs.statement_end_offset = -1
                                                  THEN LEN(CONVERT(NVARCHAR(MAX), qt.text))
                                                       * 2
                                                  ELSE qs.statement_end_offset
                                             END - qs.statement_start_offset ) / 2) ,
            [Parent Query] = qt.text ,
            DatabaseName = DB_NAME(qt.dbid)
    FROM    sys.dm_exec_query_stats qs
            CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
    ORDER BY [Average CPU used] DESC;



SELECT TOP 50 qs.max_elapsed_time /1000/1000 AS MaxElapsedTimeMS,
	[Avg. MultiCore/CPU time(MS)] = qs.total_worker_time / 1000000 / qs.execution_count,
	[Total MultiCore/CPU time(MS)] = qs.total_worker_time / 1000000,
	[Avg. Elapsed Time(MS)] = qs.total_elapsed_time / 1000000 / qs.execution_count,
	[Total Elapsed Time(MS)] = qs.total_elapsed_time / 1000000,
	qs.execution_count,
	[Avg. I/O] = (total_logical_reads + total_logical_writes) / qs.execution_count,
	[Total I/O] = total_logical_reads + total_logical_writes,
	Query = SUBSTRING(qt.[text], (qs.statement_start_offset / 2) + 1,
		(
			(
				CASE qs.statement_end_offset
					WHEN -1 THEN DATALENGTH(qt.[text])
					ELSE qs.statement_end_offset
				END - qs.statement_start_offset
			) / 2
		) + 1
	),
	Batch = qt.[text],
	[DB] = DB_NAME(qt.[dbid]),
	qs.last_execution_time,
	qp.query_plan
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.[sql_handle]) AS qt
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) AS qp
--where qs.execution_count > 5	--more than 5 occurences
ORDER BY qs.max_elapsed_time DESC


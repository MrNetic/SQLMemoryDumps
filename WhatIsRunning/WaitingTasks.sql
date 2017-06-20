
-- WITHOUT PLAN
Select SessionID = WT.session_id, 
    WaitDuration_ms = WT.wait_duration_ms,
    WaitType = WT.wait_type,
    WaitResource = WT.resource_description,
    Program = S.program_name,
 --   QueryPlan = CP.query_plan,
    SQLText = SUBSTRING(ST.text, (R.statement_start_offset/2)+1, 
        ((Case R.statement_end_offset
              When -1 Then DATALENGTH(ST.text)
             Else R.statement_end_offset
         End - R.statement_start_offset)/2) + 1),
    DBName = DB_NAME(R.database_id),
    BlockingSessionID = WT.blocking_session_id,
 --   BlockerQueryPlan = CPBlocker.query_plan,
    BlockerSQLText = SUBSTRING(STBlocker.text, (RBlocker.statement_start_offset/2)+1, 
        ((Case RBlocker.statement_end_offset
              When -1 Then DATALENGTH(STBlocker.text)
             Else RBlocker.statement_end_offset
         End - RBlocker.statement_start_offset)/2) + 1)
From sys.dm_os_waiting_tasks WT
Inner Join sys.dm_exec_sessions S on WT.session_id = S.session_id
Inner Join sys.dm_exec_requests R on R.session_id = WT.session_id
Outer Apply sys.dm_exec_query_plan (R.plan_handle) CP
Outer Apply sys.dm_exec_sql_text(R.sql_handle) ST
Left Join sys.dm_exec_requests RBlocker on RBlocker.session_id = WT.blocking_session_id
Outer Apply sys.dm_exec_query_plan (RBlocker.plan_handle) CPBlocker
Outer Apply sys.dm_exec_sql_text(RBlocker.sql_handle) STBlocker
Where R.status = 'suspended' -- Waiting on a resource
And S.is_user_process = 1 -- Is a used process
And R.session_id <> @@spid -- Filter out this session
And WT.wait_type Not Like '%sleep%' -- more waits to ignore
And WT.wait_type Not Like '%queue%' -- more waits to ignore
And WT.wait_type Not Like -- more waits to ignore
    Case When SERVERPROPERTY('IsHadrEnabled') = 0 Then 'HADR%'
        Else 'zzzz' End

Option(Recompile); -- Don't save query plan in plan cache



-- WITH PLANs
Select SessionID = WT.session_id, 
    WaitDuration_ms = WT.wait_duration_ms,
    WaitType = WT.wait_type,
    WaitResource = WT.resource_description,
    Program = S.program_name,
    QueryPlan = CP.query_plan,
    SQLText = SUBSTRING(ST.text, (R.statement_start_offset/2)+1, 
        ((Case R.statement_end_offset
              When -1 Then DATALENGTH(ST.text)
             Else R.statement_end_offset
         End - R.statement_start_offset)/2) + 1),
    DBName = DB_NAME(R.database_id),
    BlocingSessionID = WT.blocking_session_id,
    BlockerQueryPlan = CPBlocker.query_plan,
    BlockerSQLText = SUBSTRING(STBlocker.text, (RBlocker.statement_start_offset/2)+1, 
        ((Case RBlocker.statement_end_offset
              When -1 Then DATALENGTH(STBlocker.text)
             Else RBlocker.statement_end_offset
         End - RBlocker.statement_start_offset)/2) + 1)
From sys.dm_os_waiting_tasks WT
Inner Join sys.dm_exec_sessions S on WT.session_id = S.session_id
Inner Join sys.dm_exec_requests R on R.session_id = WT.session_id
Outer Apply sys.dm_exec_query_plan (R.plan_handle) CP
Outer Apply sys.dm_exec_sql_text(R.sql_handle) ST
Left Join sys.dm_exec_requests RBlocker on RBlocker.session_id = WT.blocking_session_id
Outer Apply sys.dm_exec_query_plan (RBlocker.plan_handle) CPBlocker
Outer Apply sys.dm_exec_sql_text(RBlocker.sql_handle) STBlocker
Where R.status = 'suspended' -- Waiting on a resource
And S.is_user_process = 1 -- Is a used process
And R.session_id <> @@spid -- Filter out this session
And WT.wait_type Not Like '%sleep%' -- more waits to ignore
And WT.wait_type Not Like '%queue%' -- more waits to ignore
And WT.wait_type Not Like -- more waits to ignore
    Case When SERVERPROPERTY('IsHadrEnabled') = 0 Then 'HADR%'
        Else 'zzzz' End

Option(Recompile); -- Don't save query plan in plan cache
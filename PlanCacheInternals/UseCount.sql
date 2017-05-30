SELECT usecounts, cacheobjtype, objtype, [text] 
FROM sys.dm_exec_cached_plans P 
    CROSS APPLY sys.dm_exec_sql_text(plan_handle) 
WHERE cacheobjtype = 'Compiled Plan' 
    AND [text] NOT LIKE '%dm_exec_cached_plans%';

	SELECT TOP 10 * FROM sys.dm_exec_cached_plans
	WHERE usecounts=1
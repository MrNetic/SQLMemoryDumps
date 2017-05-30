SELECT TOP 500 d.object_id, d.database_id,
	db_name(d.database_id),
	OBJECT_NAME(object_id, database_id) 'proc name', 
    d.cached_time, d.last_execution_time, d.total_elapsed_time,
    d.total_elapsed_time/d.execution_count AS [avg_elapsed_time],
    d.last_elapsed_time as LastElapsedTime, d.execution_count as ExecutionCount,d.*
FROM sys.dm_exec_procedure_stats AS d
WHERE OBJECT_NAME(object_id, database_id) LIKE '%Procedure Name%'
ORDER BY d.max_elapsed_time DESC;

   SELECT TOP 10  pvt.bucketid, 
      CONVERT(nvarchar(18), pvt.cacheobjtype) AS cacheobjtype, 
      pvt.objtype, 
      CONVERT(int, pvt.objectid) AS objid, 
      CONVERT(smallint, pvt.dbid) AS dbid, 
      CONVERT(smallint, pvt.dbid_execute) AS dbidexec, 
      CONVERT(smallint, pvt.user_id) AS uid, 
      pvt.refcounts, pvt.usecounts, 
      pvt.size_in_bytes / 8192 AS pagesused, 
      CONVERT(int, pvt.set_options) AS setopts, 
      CONVERT(smallint, pvt.language_id) AS langid, 
      CONVERT(smallint, pvt.date_format) AS dateformat, 
      CONVERT(int, pvt.status) AS status, 
      CONVERT(bigint, 0) as lasttime, 
      CONVERT(bigint, 0) as maxexectime, 
      CONVERT(bigint, 0) as avgexectime, 
      CONVERT(bigint, 0) as lastreads, 
      CONVERT(bigint, 0) as lastwrites, 
      CONVERT(int, LEN(CONVERT(nvarchar(max), fgs.text)) * 2) as sqlbytes, 
      CONVERT(nvarchar(3900), fgs.text) as sql 
FROM (SELECT ecp.*, epa.attribute, epa.value 
  FROM sys.dm_exec_cached_plans ecp 
    OUTER APPLY 
      sys.dm_exec_plan_attributes(ecp.plan_handle) epa) AS ecpa 
PIVOT (MAX(ecpa.value) for ecpa.attribute IN 
    ("set_options", "objectid", "dbid", 
    "dbid_execute", "user_id", "language_id", 
    "date_format", "status")) AS pvt 
OUTER APPLY sys.dm_exec_sql_text(pvt.plan_handle) fgs
WHERE pvt.objectid='123123213'


DBCC FREEPROCCACHE(PlanHandleGoesHere)
DBCC FREEPROCCACHE(0x05000600FC7F6C76503FF5470600000001000000000000000000000000000000000000000000000000000000)
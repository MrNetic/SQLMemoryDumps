SELECT * 
FROM sys.dm_exec_plan_attributes (0x05000600FC7F6C76C05E690A0900000001000000000000000000000000000000000000000000000000000000)

SELECT TOP 1000 OBJECT_NAME(ps.object_id,ps.database_id) AS Obj ,ps.*,cp.*,epa.*
      FROM sys.dm_exec_cached_plans cp
          OUTER APPLY sys.dm_exec_plan_attributes(plan_handle) AS epa 
		  LEFT OUTER JOIN sys.dm_exec_procedure_stats ps
		  ON cp.plan_handle=ps.plan_handle
		  WHERE OBJECT_NAME(ps.object_id,ps.database_id) ='Proc Name'
      --WHERE cacheobjtype = 'Compiled Plan' 
	  --WHERE cp.plan_handle=0x05000600FC7F6C76C05E690A0900000001000000000000000000000000000000000000000000000000000000

 SELECT TOP 1000 object_name(ps.object_id,ps.database_id) AS Obj ,ps.*,cp.*,epa.*
      FROM sys.dm_exec_cached_plans cp
          OUTER APPLY sys.dm_exec_plan_attributes(plan_handle) AS epa 
		  LEFT OUTER JOIN sys.dm_exec_procedure_stats ps
		  ON cp.plan_handle=ps.plan_handle
		  WHERE object_name(ps.object_id,ps.database_id) ='Proc Name'
      --WHERE cacheobjtype = 'Compiled Plan' 
	  --WHERE cp.plan_handle=0x05000600FC7F6C76C05E690A0900000001000000000000000000000000000000000000000000000000000000

    
     SELECT epa.attribute, epa.value,COUNT(*)
      FROM sys.dm_exec_cached_plans cp
          OUTER APPLY sys.dm_exec_plan_attributes(plan_handle) AS epa 
		  LEFT OUTER JOIN sys.dm_exec_procedure_stats ps
		  ON cp.plan_handle=ps.plan_handle
		  WHERE object_name(ps.object_id,ps.database_id) ='Proc Name'
		GROUP BY epa.attribute,epa.value
		ORDER BY epa.attribute
      --WHERE cacheobjtype = 'Compiled Plan' 
	  --WHERE cp.plan_handle=0x05000600FC7F6C76C05E690A0900000001000000000000000000000000000000000000000000000000000000

    SELECT des.program_name,
des.login_name,
des.host_name,
des.database_id,
COUNT(des.session_id) [Connections]
FROM sys.dm_exec_sessions des
INNER JOIN sys.dm_exec_connections DEC
ON des.session_id = DEC.session_id
WHERE des.is_user_process = 1
AND des.status != 'running'
GROUP BY des.program_name,
des.login_name,
des.host_name
,des.database_id
HAVING COUNT(des.session_id) > 2
ORDER BY COUNT(des.session_id) DESC
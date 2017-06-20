SELECT host_name,a.login_name,b.node_affinity,COUNT(*) AS tot  FROM sys.dm_exec_sessions a
LEFT OUTER JOIN sys.dm_exec_connections b
ON a.session_id=b.session_id
WHERE a.host_name IS NOT NULL 
GROUP BY a.host_name,a.login_name,b.node_affinity
ORDER BY a.host_name,a.login_name,b.node_affinity

SELECT * FROM sys.sysprocesses
SELECT b.node_affinity,COUNT(*) AS tot  FROM sys.dm_exec_sessions a
LEFT OUTER JOIN sys.dm_exec_connections b
ON a.session_id=b.session_id
WHERE a.host_name IS NOT NULL 
GROUP BY b.node_affinity
ORDER BY b.node_affinity


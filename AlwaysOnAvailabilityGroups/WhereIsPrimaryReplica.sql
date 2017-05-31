SELECT
AG.name AS Name,
ISNULL(agstates.primary_replica, '') AS PrimaryReplicaServerName
FROM master.sys.availability_groups AS AG
LEFT OUTER JOIN master.sys.dm_hadr_availability_group_states as agstates
ON AG.group_id = agstates.group_id
INNER JOIN master.sys.availability_replicas AS AR
ON AG.group_id = AR.group_id
INNER JOIN master.sys.dm_hadr_availability_replica_states AS arstates
ON AR.replica_id = arstates.replica_id AND arstates.is_local = 1

ORDER BY Name ASC
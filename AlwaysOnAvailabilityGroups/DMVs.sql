-- DMVs http://msdn.microsoft.com/en-us/library/ff878305(SQL.110).aspx

-- List
-- Show Cluster
select * from sys.dm_hadr_cluster

--Show Members with state
select * from sys.dm_hadr_cluster_members

--Show Members Network
select * from sys.dm_hadr_cluster_networks

--Show Availability Groups
select * from sys.availability_groups

--
select * from sys.availability_groups_cluster
select * from sys.dm_hadr_availability_group_states
select * from sys.availability_replicas
select * from sys.dm_hadr_availability_replica_cluster_nodes
select * from sys.dm_hadr_availability_replica_cluster_states
select * from sys.dm_hadr_availability_replica_states
select * from sys.dm_hadr_auto_page_repair
select log_send_queue_size,log_send_rate,* from sys.dm_hadr_database_replica_states
select * from sys.dm_hadr_database_replica_cluster_states
select * from sys.availability_group_listener_ip_addresses
select * from sys.availability_group_listeners
select * from sys.dm_tcp_listener_states
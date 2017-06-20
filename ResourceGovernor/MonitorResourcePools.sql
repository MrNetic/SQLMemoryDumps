-- Notes
-- Performance Counters are good visuals for this:
-- SQLServer : Resource Pool Stats
-- Performance notes

SELECT pool_id, name, min_iops_per_volume, max_iops_per_volume, read_io_queued_total,
read_io_issued_total, read_io_completed_total,read_io_throttled_total, read_bytes_total,
read_io_stall_total_ms, read_io_stall_queued_ms, io_issue_violations_total,io_issue_delay_total_ms
FROM   sys.dm_resource_governor_resource_pools
WHERE  name <> 'internal'; 

SELECT * FROM sys.dm_resource_governor_resource_pool_volumes
SELECT read_io_queued_total,* FROM sys.dm_resource_governor_resource_pools


ALTER RESOURCE POOL ThrottledCheckDB WITH (MIN_IOPS_PER_VOLUME=0, MAX_IOPS_PER_VOLUME=4000);
ALTER RESOURCE GOVERNOR RECONFIGURE;

/* Attention, the default is 10
ALTER RESOURCE GOVERNOR  
WITH (MAX_OUTSTANDING_IO_PER_VOLUME = 50);   
*/

SELECT * FROM sys.sysprocesses
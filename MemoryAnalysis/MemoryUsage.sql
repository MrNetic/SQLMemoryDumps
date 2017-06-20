-- Memory clerks

SELECT   type , name
         memory_node_id ,
         pages_kb ,
         virtual_memory_reserved_kb ,
         virtual_memory_committed_kb ,
         awe_allocated_kb
FROM     sys.dm_os_memory_clerks
ORDER BY pages_kb DESC;

-- Caches
SELECT   [name] ,
         [type] ,
         pages_kb ,
         entries_count
FROM     sys.dm_os_memory_cache_counters
ORDER BY pages_kb DESC;

-- Buffer Pool Per DB
SELECT   COUNT(*) * 8 / 1024 AS 'Cached Size (MB)' ,
         CASE database_id
              WHEN 32767 THEN 'ResourceDb'
              ELSE DB_NAME(database_id)
         END AS 'Database'
FROM     sys.dm_os_buffer_descriptors
GROUP BY DB_NAME(database_id) ,
         database_id
ORDER BY 'Cached Size (MB)' DESC;


SELECT * FROM sys.dm_os_memory_pools
SELECT * FROM sys.dm_os_memory_objects
SELECT * FROM sys.dm_os_sys_memory
SELECT * FROM sys.dm_os_sys_info 
SELECT * FROM sys.dm_os_process_memory

SELECT * FROM sys.dm_os_memory_allocations
SELECT * FROM sys.dm_os_memory_broker_clerks
SELECT * FROM sys.dm_os_memory_cache_clock_hands
SELECT * FROM sys.dm_os_memory_clerks
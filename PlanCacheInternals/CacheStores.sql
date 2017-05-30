SELECT type as 'plan cache store', buckets_count 
FROM sys.dm_os_memory_cache_hash_tables 
WHERE type IN ('CACHESTORE_OBJCP', 'CACHESTORE_SQLCP', 
   'CACHESTORE_PHDR', 'CACHESTORE_XPROC');

   SELECT type AS Store, SUM(pages_in_bytes/1024.) AS KB_used 
FROM sys.dm_os_memory_objects 
WHERE type IN ('MEMOBJ_CACHESTOREOBJCP', 'MEMOBJ_CACHESTORESQLCP', 
  'MEMOBJ_CACHESTOREXPROC', 'MEMOBJ_SQLMGR') 
GROUP BY type;
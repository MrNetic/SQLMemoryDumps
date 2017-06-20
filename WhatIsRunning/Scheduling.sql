-- CPU
SELECT  scheduler_id
        ,cpu_id
        ,status
        ,runnable_tasks_count
        ,active_workers_count
        ,load_factor
        ,yield_count
FROM sys.dm_os_schedulers
WHERE scheduler_id < 255
AND status='visible online'
ORDER BY runnable_tasks_count DESC


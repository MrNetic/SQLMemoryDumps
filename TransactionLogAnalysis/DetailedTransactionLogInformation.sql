
-- Example 01 
SELECT @@SERVERNAME,db.database_id,db.name,delayed_durability_desc,ls.* FROM sys.databases db
CROSS APPLY  sys.dm_db_log_stats(db.database_id) ls


-- Example 02

-- Example 03


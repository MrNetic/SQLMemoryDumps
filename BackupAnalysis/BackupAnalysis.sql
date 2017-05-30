SELECT  
   A.[Server],  
   a.database_name,--type,
   CASE a.type
   WHEN 'D' THEN 'Database'
   WHEN 'I' THEN 'Differential'
   WHEN 'L' THEN 'Log'
   WHEN 'F' THEN 'Filegroup'
   WHEN 'G' THEN 'Differential File'
   END AS Type,
   A.last_db_backup_date,  
   B.backup_start_date,  
   --B.expiration_date, 
   
   cast(B.backup_size / 1024.0/1024.0/1024.0 AS decimal(20,3)) AS BackupSizeGB,  
   --B.logical_device_name,  
   B.physical_device_name,   
   B.backupset_name , 
   B.description
   INTO ##Backups
FROM 
   ( 
   SELECT   
       CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server, 
       msdb.dbo.backupset.database_name,  
       MAX(msdb.dbo.backupset.backup_finish_date) AS last_db_backup_date ,
	   msdb..backupset.type
   FROM    msdb.dbo.backupmediafamily  
       INNER JOIN msdb.dbo.backupset ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id  
  -- WHERE   msdb..backupset.type = 'D' 
   GROUP BY 
       msdb.dbo.backupset.database_name ,type
   ) AS A 
    
   LEFT JOIN  

   ( 
   SELECT   
   CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server, 
   msdb.dbo.backupset.database_name,  
   msdb.dbo.backupset.backup_start_date,  
   msdb.dbo.backupset.backup_finish_date, 
   msdb.dbo.backupset.expiration_date, 
   msdb.dbo.backupset.backup_size,  
   msdb.dbo.backupmediafamily.logical_device_name,  
   msdb.dbo.backupmediafamily.physical_device_name,   
   msdb.dbo.backupset.name AS backupset_name, 
   msdb.dbo.backupset.description 
FROM   msdb.dbo.backupmediafamily  
   INNER JOIN msdb.dbo.backupset ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id  
--WHERE  msdb..backupset.type = 'D' 
   ) AS B 
   ON A.[server] = B.[server] AND A.[database_name] = B.[database_name] AND A.[last_db_backup_date] = B.[backup_finish_date] 
ORDER BY  
   A.database_name 

   SELECT * FROM ##Backups
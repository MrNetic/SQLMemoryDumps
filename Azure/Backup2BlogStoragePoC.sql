
/************************************************************\
*	SQL Server BACKUP 2 BLOG STORAGE Proof of Concept v.1	*
*	Paulo Condeça, Microsoft | September 2014				*
*	Influenced by Mickaël MOTTET							*
\************************************************************/

DECLARE @name VARCHAR(50);
DECLARE @filename VARCHAR(255);
DECLARE @storageAccount VARCHAR(255);
DECLARE @credential VARCHAR(100);

DECLARE @stmt nvarchar(2000)
DECLARE @type varchar(20)

-- Change value bellow to match your environment
SET @storageAccount = 'StorageAccountName';
SET @credential = 'CredentialNameCreateOnSQLServerInstance'
SET @type = 'DATABASE' -- LOG OR DATABASE | This will also define the folder location of the backups


DECLARE db_cursor CURSOR FOR  
	SELECT name 
	FROM sys.databases
	WHERE database_id !=2
	ORDER BY database_id ASC; -- Exclude tempdb
 
 	OPEN db_cursor   
		FETCH NEXT FROM db_cursor INTO @name;   
 
		WHILE @@FETCH_STATUS = 0   
		BEGIN    
			 -- Assuming having a countainer called sqlbackups.
			 SET @filename = 'https://' + @storageAccount + '.blob.core.windows.net/sqlbackups/' + @name + 
			CASE 
				WHEN @type='DATABASE' then  '/Full/'
				WHEN @type='LOG' then  '/Log/'
			END
			+ @name + '_'+ convert(char(8),getdate(),112)+ '.bak';

			SET @stmt = '
			BACKUP '+ @type + ' [' + @name +
			'] TO URL = ''' + @filename +
			''' WITH CREDENTIAL = ''' + @credential +
			''', COMPRESSION,STATS=5'
			PRINT @stmt
		FETCH NEXT FROM db_cursor INTO @name;
		END   
	CLOSE db_cursor;
DEALLOCATE db_cursor;

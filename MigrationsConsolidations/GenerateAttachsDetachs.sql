USE [master];
GO
DECLARE @database NVARCHAR(200) ,
    @cmd NVARCHAR(1000) ,
    @detach_cmd NVARCHAR(4000) ,
    @attach_cmd NVARCHAR(4000) ,
    @file NVARCHAR(1000) ,
    @i INT ,
    @DetachOrAttach BIT;

SET @DetachOrAttach = 0;

-- 1 Detach 0 - Attach
-- 1 Generates Detach Script
-- 0 Generates Attach Script
DECLARE dbname_cur CURSOR STATIC LOCAL FORWARD_ONLY
FOR
    SELECT  RTRIM(LTRIM([name]))
    FROM    sys.databases
    WHERE   database_id > 4
	-- No system databases
	 AND [name] not in (
					
					'QualityCenter_Demo_db'
					)
OPEN dbname_cur

FETCH NEXT FROM dbname_cur INTO @database

WHILE @@FETCH_STATUS = 0 
    BEGIN
        SELECT  @i = 1;

        SET @attach_cmd = '-- ' + QUOTENAME(@database) + CHAR(10)
            + 'EXEC sp_attach_db @dbname = ''' + @database + '''' + CHAR(10);
      -- Change skip checks to false if you want to update statistics before you detach.
        SET @detach_cmd = '-- ' + QUOTENAME(@database) + CHAR(10)
            + 'EXEC sp_detach_db @dbname = ''' + @database
            + ''' , @skipchecks = ''true'';' + CHAR(10);

      -- Get a list of files for the database
        DECLARE dbfiles_cur CURSOR STATIC LOCAL FORWARD_ONLY
        FOR
            SELECT  physical_name
            FROM    sys.master_files
            WHERE   database_id = DB_ID(@database)
            ORDER BY [file_id];

        OPEN dbfiles_cur

        FETCH NEXT FROM dbfiles_cur INTO @file

        WHILE @@FETCH_STATUS = 0 
            BEGIN
                SET @attach_cmd = @attach_cmd + '    ,@filename'
                    + CAST(@i AS NVARCHAR(10)) + ' = ''' + @file + ''''
                    + CHAR(10);
                SET @i = @i + 1;

                FETCH NEXT FROM dbfiles_cur INTO @file
            END

        CLOSE dbfiles_cur;

        DEALLOCATE dbfiles_cur;

        IF ( @DetachOrAttach = 0 ) 
            BEGIN
            -- Output attach script
                PRINT @attach_cmd;
            END
        ELSE -- Output detach script
            PRINT @detach_cmd;

        FETCH NEXT FROM dbname_cur INTO @database
    END

CLOSE dbname_cur;

DEALLOCATE dbname_cur; 

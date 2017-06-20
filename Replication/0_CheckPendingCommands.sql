
-- Check Pending Commands, run at the distributor please.
-- Paulo Condeça, 2016.

--Clean as possible
SET NOCOUNT ON;

DECLARE @command NVARCHAR(2000);
DECLARE @message NVARCHAR(2500);
DECLARE @commandoutput NVARCHAR(200);
DECLARE @progress int

SET @progress =( SELECT CONVERT(VARCHAR(1), ISNULL([is_distributor], 0))
     FROM   [master].[sys].[servers] (NOLOCK)
     WHERE  [name] = 'REPL_DISTRIBUTOR'
            AND [data_source] = CONVERT(sysname, SERVERPROPERTY('ServerName'))
   )
   IF @progress =0 OR @progress IS null
    BEGIN
        RAISERROR ('This instance is not a distributor',10,1) WITH NOWAIT;
        RETURN;
    END;


IF DB_ID() != ( SELECT  database_id
                FROM    sys.databases
                WHERE   is_distributor = 1
              )
    BEGIN
        RAISERROR ('Command must be run under Distribution Database Context.',10,1) WITH NOWAIT;
        RETURN;				
    END;

IF OBJECT_ID('tempdb..#Commands01') IS NOT NULL
    DROP TABLE #Commands01;


SELECT DISTINCT
        'sp_replmonitorsubscriptionpendingcmds 
@publisher=''' + Publisher.srvname + ''',' + '
@publisher_db=''' + publications.publisher_db + ''',' + '
@publication=''' + publications.publication + ''',' + '
@subscriber=''' + Subscriber.srvname + ''',' + '
@subscriber_db=''' + subscriptions.subscriber_db + ''',' + '
@subscription_type=''' + CAST(subscriptions.subscription_type AS CHAR(1))
        + '''' AS command ,
        Publisher.srvname AS PUBLISHER ,
        publications.publisher_db AS PUBLISHER_DB ,
        publications.publication AS PUBLICATION ,
        Subscriber.srvname AS SUBSCRIBER ,
        subscriptions.subscriber_db AS SUBSCRIBER_DB ,
        subscriptions.subscription_type AS SUBSCRIPTION_TYPE
INTO    #Commands01
FROM    MSsubscriptions subscriptions
        LEFT OUTER JOIN MSpublications publications ON subscriptions.publication_id = publications.publication_id
        LEFT OUTER JOIN master..sysservers Publisher ON publications.publisher_id = Publisher.srvid
        LEFT OUTER JOIN master..sysservers Subscriber ON subscriptions.subscriber_id = Subscriber.srvid;

DECLARE CommandCursor CURSOR READ_ONLY FORWARD_ONLY
FOR
    SELECT  command--,PUBLISHER,PUBLISHER_DB,PUBLICATION,SUBSCRIBER,SUBSCRIBER_DB,SUBSCRIPTION_TYPE
    FROM    #Commands01;
OPEN CommandCursor;
FETCH NEXT FROM CommandCursor INTO @command;
WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT  '------------------------------------------';
		--SET @message = ( SELECT 'Command: ' + @command); 
        --RAISERROR (@message, 10, 1) WITH NOWAIT;
		
        SET @message = ( 'Started  @ >>' + CONVERT(VARCHAR(20), GETDATE(), 113) ); 
        RAISERROR (@message, 10, 1) WITH NOWAIT;
        BEGIN TRY
		
            PRINT @command;-- AS PendingsCommands
            PRINT '';
            EXECUTE sp_executesql @command; 
        
        END TRY		
        BEGIN CATCH
            SELECT  ERROR_NUMBER() AS ErrorNumber ,
                    ERROR_SEVERITY() AS ErrorSeverity ,
                    ERROR_STATE() AS ErrorState ,
                    ERROR_PROCEDURE() AS ErrorProcedure ,
                    ERROR_LINE() AS ErrorLine ,
                    ERROR_MESSAGE() AS ErrorMessage;  
        END CATCH;
                
        SET @message = ( SELECT 'Finished @ >>'
                                + CONVERT(VARCHAR(20), GETDATE(), 113)
                       );  
        RAISERROR (@message, 10, 1) WITH NOWAIT;
        SELECT  '------------------------------------------';
        FETCH NEXT FROM CommandCursor INTO @command;
    END;
CLOSE CommandCursor;
DEALLOCATE CommandCursor;	

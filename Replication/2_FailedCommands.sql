
-- Execute on the Distribution Database
EXECUTE dbo.sp_browsereplcmds
                                  @xact_seqno_start = '0x0000002B00000584001D00000000',
                                  @xact_seqno_end = '0x0000002B00000584001D00000000',
                                  @publisher_database_id = 1 
--                                  ,@command_id = 1



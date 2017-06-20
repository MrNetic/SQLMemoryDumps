-- 

-- Transaction Log Analysis From Backup

CREATE TABLE [dbo].[LogAnalysis]
(
	[Current LSN] [NVARCHAR](23) COLLATE Latin1_General_CI_AS NOT NULL,
	[Operation] [NVARCHAR](31) COLLATE Latin1_General_CI_AS NOT NULL,
	[Context] [NVARCHAR](31) COLLATE Latin1_General_CI_AS NOT NULL,
	[Transaction ID] [NVARCHAR](14) COLLATE Latin1_General_CI_AS NOT NULL,
	[LogBlockGeneration] [BIGINT] NOT NULL,
	[Tag Bits] [BINARY](2) NOT NULL,
	[Log Record Fixed Length] [SMALLINT] NOT NULL,
	[Log Record Length] [SMALLINT] NOT NULL,
	[Previous LSN] [NVARCHAR](23) COLLATE Latin1_General_CI_AS NOT NULL,
	[Flag Bits] [BINARY](2) NOT NULL,
	[Log Reserve] [INT] NOT NULL,
	[AllocUnitId] [BIGINT] NULL,
	[AllocUnitName] [NVARCHAR](387) COLLATE Latin1_General_CI_AS NULL,
	[Page ID] [NVARCHAR](14) COLLATE Latin1_General_CI_AS NULL,
	[Slot ID] [INT] NULL,
	[Previous Page LSN] [NVARCHAR](23) COLLATE Latin1_General_CI_AS NULL,
	[PartitionId] [BIGINT] NULL,
	[RowFlags] [SMALLINT] NULL,
	[Num Elements] [SMALLINT] NULL,
	[Offset in Row] [SMALLINT] NULL,
	[Modify Size] [SMALLINT] NULL,
	[Checkpoint Begin] [NVARCHAR](24) COLLATE Latin1_General_CI_AS NULL,
	[CHKPT Begin DB Version] [SMALLINT] NULL,
	[Max XDESID] [NVARCHAR](14) COLLATE Latin1_General_CI_AS NULL,
	[Num Transactions] [SMALLINT] NULL,
	[Checkpoint End] [NVARCHAR](24) COLLATE Latin1_General_CI_AS NULL,
	[CHKPT End DB Version] [SMALLINT] NULL,
	[Minimum LSN] [NVARCHAR](23) COLLATE Latin1_General_CI_AS NULL,
	[Dirty Pages] [INT] NULL,
	[Oldest Replicated Begin LSN] [NVARCHAR](23) COLLATE Latin1_General_CI_AS NULL,
	[Next Replicated End LSN] [NVARCHAR](23) COLLATE Latin1_General_CI_AS NULL,
	[Last Distributed Backup End LSN] [NVARCHAR](23) COLLATE Latin1_General_CI_AS NULL,
	[Last Distributed End LSN] [NVARCHAR](23) COLLATE Latin1_General_CI_AS NULL,
	[Repl Min Hold LSN] [NVARCHAR](23) COLLATE Latin1_General_CI_AS NULL,
	[Server UID] [INT] NULL,
	[SPID] [INT] NULL,
	[Beginlog Status] [BINARY](4) NULL,
	[Xact Type] [INT] NULL,
	[Begin Time] [NVARCHAR](24) COLLATE Latin1_General_CI_AS NULL,
	[Transaction Name] [NVARCHAR](33) COLLATE Latin1_General_CI_AS NULL,
	[Transaction SID] [VARBINARY](85) NULL,
	[Parent Transaction ID] [NVARCHAR](14) COLLATE Latin1_General_CI_AS NULL,
	[Oldest Active Transaction ID] [NVARCHAR](14) COLLATE Latin1_General_CI_AS NULL,
	[Xact ID] [BIGINT] NULL,
	[Xact Node ID] [INT] NULL,
	[Xact Node Local ID] [INT] NULL,
	[End AGE] [BIGINT] NULL,
	[End Time] [NVARCHAR](24) COLLATE Latin1_General_CI_AS NULL,
	[Transaction Begin] [NVARCHAR](23) COLLATE Latin1_General_CI_AS NULL,
	[Replicated Records] [BIGINT] NULL,
	[Oldest Active LSN] [NVARCHAR](23) COLLATE Latin1_General_CI_AS NULL,
	[Server Name] [NVARCHAR](129) COLLATE Latin1_General_CI_AS NULL,
	[Database Name] [NVARCHAR](129) COLLATE Latin1_General_CI_AS NULL,
	[Mark Name] [NVARCHAR](33) COLLATE Latin1_General_CI_AS NULL,
	[Repl Partition ID] [INT] NULL,
	[Repl Epoch] [INT] NULL,
	[Repl CSN] [BIGINT] NULL,
	[Repl Flags] [INT] NULL,
	[Repl Msg] [VARBINARY](8000) NULL,
	[Repl Source Commit Time] [NVARCHAR](24) COLLATE Latin1_General_CI_AS NULL,
	[Master XDESID] [NVARCHAR](14) COLLATE Latin1_General_CI_AS NULL,
	[Master DBID] [INT] NULL,
	[Preplog Begin LSN] [NVARCHAR](23) COLLATE Latin1_General_CI_AS NULL,
	[Prepare Time] [NVARCHAR](24) COLLATE Latin1_General_CI_AS NULL,
	[Virtual Clock] [BIGINT] NULL,
	[Previous Savepoint] [NVARCHAR](23) COLLATE Latin1_General_CI_AS NULL,
	[Savepoint Name] [NVARCHAR](33) COLLATE Latin1_General_CI_AS NULL,
	[Rowbits First Bit] [SMALLINT] NULL,
	[Rowbits Bit Count] [SMALLINT] NULL,
	[Rowbits Bit Value] [BINARY](1) NULL,
	[Number of Locks] [SMALLINT] NULL,
	[Lock Information] [NVARCHAR](256) COLLATE Latin1_General_CI_AS NULL,
	[LSN before writes] [NVARCHAR](23) COLLATE Latin1_General_CI_AS NULL,
	[Pages Written] [SMALLINT] NULL,
	[Command Type] [INT] NULL,
	[Publication ID] [INT] NULL,
	[Article ID] [INT] NULL,
	[Partial Status] [INT] NULL,
	[Command] [NVARCHAR](26) COLLATE Latin1_General_CI_AS NULL,
	[Byte Offset] [SMALLINT] NULL,
	[New Value] [BINARY](1) NULL,
	[Old Value] [BINARY](1) NULL,
	[New Split Page] [NVARCHAR](14) COLLATE Latin1_General_CI_AS NULL,
	[Rows Deleted] [SMALLINT] NULL,
	[Bytes Freed] [SMALLINT] NULL,
	[CI Table Id] [INT] NULL,
	[CI Index Id] [SMALLINT] NULL,
	[NewAllocUnitId] [BIGINT] NULL,
	[FileGroup ID] [SMALLINT] NULL,
	[Meta Status] [BINARY](4) NULL,
	[File Status] [BINARY](4) NULL,
	[File ID] [SMALLINT] NULL,
	[Physical Name] [NVARCHAR](261) COLLATE Latin1_General_CI_AS NULL,
	[Logical Name] [NVARCHAR](129) COLLATE Latin1_General_CI_AS NULL,
	[Format LSN] [NVARCHAR](23) COLLATE Latin1_General_CI_AS NULL,
	[RowsetId] [BIGINT] NULL,
	[TextPtr] [BINARY](16) NULL,
	[Column Offset] [INT] NULL,
	[Flags] [INT] NULL,
	[Text Size] [BIGINT] NULL,
	[Offset] [BIGINT] NULL,
	[Old Size] [BIGINT] NULL,
	[New Size] [BIGINT] NULL,
	[Description] [NVARCHAR](256) COLLATE Latin1_General_CI_AS NOT NULL,
	[Bulk allocated extent count] [INT] NULL,
	[Bulk RowsetId] [BIGINT] NULL,
	[Bulk AllocUnitId] [BIGINT] NULL,
	[Bulk allocation first IAM Page ID] [NVARCHAR](14) COLLATE Latin1_General_CI_AS NULL,
	[Bulk allocated extent ids] [NVARCHAR](961) COLLATE Latin1_General_CI_AS NULL,
	[VLFs added] [NVARCHAR](688) COLLATE Latin1_General_CI_AS NULL,
	[InvalidateCache Id] [INT] NULL,
	[InvalidateCache keys] [NVARCHAR](256) COLLATE Latin1_General_CI_AS NULL,
	[CopyVerionInfo Source Page Id] [NVARCHAR](14) COLLATE Latin1_General_CI_AS NULL,
	[CopyVerionInfo Source Page LSN] [NVARCHAR](23) COLLATE Latin1_General_CI_AS NULL,
	[CopyVerionInfo Source Slot Id] [INT] NULL,
	[CopyVerionInfo Source Slot Count] [INT] NULL,
	[RowLog Contents 0] [VARBINARY](8000) NULL,
	[RowLog Contents 1] [VARBINARY](8000) NULL,
	[RowLog Contents 2] [VARBINARY](8000) NULL,
	[RowLog Contents 3] [VARBINARY](8000) NULL,
	[RowLog Contents 4] [VARBINARY](8000) NULL,
	[RowLog Contents 5] [VARBINARY](8000) NULL,
	[Compression Log Type] [SMALLINT] NULL,
	[Compression Info] [VARBINARY](8000) NULL,
	[PageFormat PageType] [SMALLINT] NULL,
	[PageFormat PageFlags] [SMALLINT] NULL,
	[PageFormat PageLevel] [SMALLINT] NULL,
	[PageFormat PageStat] [SMALLINT] NULL,
	[PageFormat FormatOption] [SMALLINT] NULL,
	[Log Record] [VARBINARY](8000) NOT NULL,

INDEX [ix1] NONCLUSTERED 
(
	[Current LSN] ASC
)
)WITH ( MEMORY_OPTIMIZED = ON , DURABILITY = SCHEMA_ONLY )

INSERT INTO dbo.LogAnalysis
 SELECT
    *
		
FROM
    fn_dump_dblog (
        NULL, NULL, N'DISK', 1, N'TransactionLogFilePagh.trn',
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);

GO
-- 

SELECT TOP 1 * FROM dbo.LogAnalysis
WHERE [Page ID] LIKE '%5104665%'



--------------------


--
--See information about our PAGE
--The PAGE IS 5104665, converting TO hex = 4DE419

SELECT DISTINCT spid FROM dbo.LogAnalysis
WHERE [Transaction ID] IN 
(
SELECT  [Transaction ID] FROM dbo.LogAnalysis
WHERE [Page ID] LIKE '%4DE419%'
OR  [Page ID] LIKE '%5104665%'
OR [Lock Information] LIKE '%4DE419%'
OR [Lock Information] LIKE '%5104665%'
OR Description LIKE '%4DE419%'
OR Description LIKE '%5104665%'
)


SELECT DISTINCT [Transaction ID],spid FROM dbo.LogAnalysis
WHERE [Page ID] LIKE '%4DE419%'
OR  [Page ID] LIKE '%5104665%'
OR [Lock Information] LIKE '%4DE419%'
OR [Lock Information] LIKE '%5104665%'
OR Description LIKE '%4DE419%'
OR Description LIKE '%5104665%'

 SELECT  * FROM dbo.LogAnalysis WHERE Operation LIKE '%CKPT%'
AND Description LIKE '%5104665%'

AND [Transaction ID] NOT IN (SELECT [Transaction ID] FROM dbo.LogAnalysis WHERE spid IN (33,286))

0014:8ebeb4b7
0014:8ebe27f0

SELECT DISTINCT spid FROM dbo.LogAnalysis
WHERE [Transaction ID] IN ('0014:8ebeb4b7','0014:8ebe27f0')
ORDER BY [Current LSN]


SELECT DISTINCT spid FROM dbo.LogAnalysis
WHERE spid<50

SELECT * FROM dbo.LogAnalysis WHERE Operation LIKE '%CKPT%'
WHERE spid IN (39)
ORDER BY [Current LSN]

SELECT * FROM dbo.LogAnalysis
WHERE [Transaction ID] LIKE '0014:8ebded0%'
ORDER BY 1
ORDER BY spid desc




SELECT  * FROM dbo.LogAnalysis
WHERE [Page ID] LIKE '%4DE419%'
OR  [Page ID] LIKE '%5104665%'
OR [Lock Information] LIKE '%4DE419%'
OR [Lock Information] LIKE '%5104665%'
OR Description LIKE '%4DE419%'
OR Description LIKE '%5104665%'
ORDER BY [Current LSN]

SELECT DISTINCT spid FROM dbo.LogAnalysis
WHERE [Transaction ID] IN 
(
SELECT  [Transaction ID] FROM dbo.LogAnalysis
WHERE [Page ID] LIKE '%4DE419%'
OR  [Page ID] LIKE '%5104665%'
OR [Lock Information] LIKE '%4DE419%'
OR [Lock Information] LIKE '%5104665%'
OR Description LIKE '%4DE419%'
OR Description LIKE '%5104665%'
)
AND spid!=39
AND( [Begin Time] IS NOT NULL OR [end time] IS NOT NULL)
ORDER BY [Current LSN]


SELECT TOP 100 * FROM sys.dm_xe_map_values 
WHERE map_value LIKE '%latch%'


--CHECK the TRANSACTION that does the LOP_DELETE_ROWS

SELECT  * FROM dbo.LogAnalysis
WHERE [Transaction ID]='0014:8ebe27f0'
ORDER BY [Current LSN]

Now CHECK Lock Information

SELECT  * FROM dbo.LogAnalysis
WHERE [Lock Information] LIKE '%5104665%'



Vamos para a altura que houve o DUMP
0014:8ebe2fd0

SELECT * FROM dbo.LogAnalysis
WHERE [Transaction ID]='0014:8ebeb3e7'
ORDER BY 1

SELECT * FROM dbo.LogAnalysis
WHERE [Transaction ID] IN(
SELECT [Transaction ID] FROM dbo.LogAnalysis
WHERE spid=33
)
ORDER BY 1

SELECT DISTINCT [Description] FROM dbo.LogAnalysis
WHERE [Transaction ID] IN(
SELECT [Transaction ID] FROM dbo.LogAnalysis
WHERE spid=33
)
AND Description LIKE '%5104665%'
ORDER BY Description


SELECT * FROM dbo.LogAnalysis
WHERE [Lock Information] LIKE '%5104665%'
ORDER BY 1

SELECT * FROM dbo.LogAnalysis
WHERE [Transaction ID] IN ('0014:8ebe27f0',
'0014:8ebeb4b7')
ORDER BY 1

SELECT DISTINCT spid FROM dbo.LogAnalysis
WHERE [Transaction ID] IN (
SELECT [Transaction ID] FROM dbo.LogAnalysis
WHERE Operation ='LOP_FORGET_XACT')

SELECT spid,* FROM dbo.LogAnalysis
WHERE Operation IN ('LOP_BEGIN_CKPT','LOP_END_CKPT')
--AND [Current LSN] <='0030fa39:00017174:0004'
ORDER BY [Current LSN]
AND 
(
[Page ID] LIKE '%4DE419%'
OR  [Page ID] LIKE '%5104665%'
OR [Lock Information] LIKE '%4DE419%'
OR [Lock Information] LIKE '%5104665%'
OR Description LIKE '%4DE419%'
OR Description LIKE '%5104665%'
)

SELECT [current lsn],[checkpoint begin],[checkpoint end],* FROM dbo.LogAnalysis
WHERE Operation IN ('LOP_BEGIN_CKPT','LOP_END_CKPT')
ORDER BY 1

order by 1


ORDER BY [Current LSN]
0000:00000000
0014:8ebe27f0
0014:8ebeb4b7
0014:8ebece01
0014:8ebed133
0014:8ebed134


--

INSERT INTO dbo.LogAnalysis
 SELECT
    *
		
FROM
    fn_dump_dblog (
        NULL, NULL, N'DISK', 1, N'PathTRN\70207_014000.trn',
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);

		;
WITH    Checkpoints ( [current lsn], [checkpoint begin], [checkpoint end], [Minimum LSN] )
          AS ( SELECT   [Current LSN] ,
                        [Checkpoint Begin] ,
                        [Checkpoint End] ,
                        [Minimum LSN]
               FROM     dbo.LogAnalysis
               WHERE    Operation IN ( 'LOP_BEGIN_CKPT', 'LOP_END_CKPT' )
             )
    SELECT  ROW_NUMBER() OVER ( ORDER BY a.[current lsn] ) AS Ranks ,
            a.[checkpoint begin] ,
            b.[checkpoint end],
			datediff(ss,a.[checkpoint begin],b.[checkpoint end]) CheckpointDurationSeconds
    FROM    Checkpoints a
            LEFT OUTER JOIN ( SELECT    ROW_NUMBER() OVER ( ORDER BY [current lsn] ) AS Ranks ,
                                        *
                              FROM      Checkpoints
                              WHERE     [Checkpoint End] IS NOT NULL
                            ) b ON a.[current lsn] = b.[Minimum LSN]
    WHERE   a.[checkpoint begin] IS NOT NULL 



INSERT INTO dbo.LogAnalysis
 SELECT
    *
		
FROM
    fn_dump_dblog (
        NULL, NULL, N'DISK', 1, N'PathFile.trn',
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
;

-- 

SELECT MIN([Checkpoint Begin])  FROM dbo.LogAnalysis
SELECT MAX([Checkpoint Begin])  FROM dbo.LogAnalysis
ORDER BY 1
WHERE [Xact ID] LIKE '%4630503965%'

SELECT * FROM dbo.LogAnalysis 
WHERE [Xact ID] LIKE '%4630503965%'
ORDER BY [Current LSN]

SELECT * FROM dbo.LogAnalysis 
WHERE [Xact ID] LIKE '%4630503934%'
ORDER BY [Current LSN]

DEADLOCK VICTIM = 4630503965 = 0003:4fe02753
OTHER PROCESS= 4630503934 =    0003:4fe02752

NOTES -> TRANSACTION began sequencially AS a coincidence

SELECT * FROM dbo.LogAnalysis WHERE [Transaction ID] = '0003:4fe02752'
--AND PartitionId='72057594073972736'
ORDER BY [Current LSN]

-- From the process that was killed, checking the wait resource
SELECT [Lock Information],* FROM dbo.LogAnalysis
WHERE [Lock Information] LIKE '%93d093466be3%'
ORDER BY [Current LSN]


-- Check the wait resource + the surviving spid
SELECT [Lock Information],* FROM dbo.LogAnalysis
WHERE [Lock Information] LIKE '%93d093466be3%'
AND [Transaction ID] = '0003:4fe02752'
ORDER BY [Current LSN]

SELECT * FROM dbo.LogAnalysis
WHERE [Current LSN] >='001163e8:00034f6f:007b'
AND [Lock Information] LIKE '%75c34a5efe64%'

-- Lock again for transaction that was killed

SELECT * FROM dbo.LogAnalysis WHERE [Transaction ID] = '0003:4fe02753'
ORDER BY [Current LSN]

SELECT * FROM dbo.LogAnalysis
WHERE [Transaction ID] IN (
SELECT [Transaction ID] FROM dbo.LogAnalysis WHERE Operation='LOP_ABORT_XACT'
)
AND Operation IN ('LOP_BEGIN_XACT')
ORDER BY [Current LSN]

-- View allocation unit changes

SELECT [Parent Transaction ID],* FROM dbo.LogAnalysis WHERE [Transaction ID] = '0003:4fe02753'
AND [Lock Information] LIKE '%638625318%'
ORDER BY [Current LSN]

SELECT * FROM dbo.LogAnalysis WHERE [Parent Transaction ID] ='0003:4fe02753'

SELECT * FROM dbo.LogAnalysis WHERE [Transaction ID]='0003:4fe0277d'

SELECT [Oldest Active Transaction ID],[Lock Information],* FROM dbo.LogAnalysis
 WHERE [Transaction ID] = '0003:4fe02752'
 ORDER BY [Current LSN]

 SELECT [Oldest Active Transaction ID],[Lock Information],* FROM dbo.LogAnalysis
 WHERE [Transaction ID] = '0003:4fe02751'
 ORDER BY [Current LSN]


 -- Get Times from Transactons that had locks here (IUD)

 SELECT [Begin Time],[End Time],* FROM dbo.LogAnalysis
 WHERE [Transaction ID] IN (
 SELECT * FROM dbo.LogAnalysis
WHERE [Lock Information] LIKE '%638625318%'
)
AND Operation IN ('LOP_BEGIN_XACT','LOP_COMMIT_XACT')
ORDER BY [Current LSN]

-- 

--GET ALL PROCESSES THAT modified selection

DEADLOCK VICTIM = 4630503965 = 0003:4fe02753
OTHER PROCESS= 4630503934 =    0003:4fe02752

NOTES -> TRANSACTION began sequencially AS a coincidence

SELECT * FROM dbo.LogAnalysis WHERE [Transaction ID] = '0003:4fe02752'
--AND PartitionId='72057594073972736'
ORDER BY [Current LSN]

SELECT DISTINCT [Transaction ID] FROM dbo.LogAnalysis WHERE PartitionId =72057594073579520
AND [Current LSN] <='001163e8:00034eea:0001'

DEADLOCK VICTIM = 4630503965 = 0003:4fe02753
OTHER PROCESS= 4630503934 =    0003:4fe02752

SELECT DISTINCT AllocUnitId FROM dbo.LogAnalysis WHERE [Transaction ID]='0003:4fe02753'
ORDER BY [Current LSN]

SELECT * FROM dbo.LogAnalysis WHERE [Transaction ID]='0003:4fe02753'
ORDER BY [Current LSN]

SELECT * FROM dbo.LogAnalysis WHERE [Lock Information] LIKE '%638625318%'
AND [Current LSN]<=
-- Create DummyDatabase

SET NOCOUNT ON
CREATE DATABASE MyTestDatabase

GO

USE MyTestDatabase

GO

-- Start with a fake full backup to keep all log records
BACKUP DATABASE MyTestDatabase TO DISK='NUL' -- BlackHole

CREATE TABLE [dbo].[DummyTable01](
	[AuditId] [BIGINT] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Id01] [BIGINT] NOT NULL,
	[Column01] [NVARCHAR](500) NOT NULL,
	[ColumnToAllowNullsInFuture01] [NVARCHAR](500) NOT NULL,
	[Column02] [NVARCHAR](500) NOT NULL,
	[ColumnToAllowNullsInFuture02] [NVARCHAR](500) NOT NULL,
	[ColumnToAllowNullsInFuture03] [NVARCHAR](500) NOT NULL
 CONSTRAINT [PK_DummyTable01] PRIMARY KEY CLUSTERED 
(
	[AuditId] ASC
))

GO

DECLARE @var INT=0
WHILE @var<10000000
BEGIN
INSERT INTO dbo.DummyTable01
        ( Id01 ,
          Column01 ,
          ColumnToAllowNullsInFuture01 ,
          Column02 ,
          ColumnToAllowNullsInFuture02 ,
          ColumnToAllowNullsInFuture03
        )
VALUES  ( 1 , -- Id01 - bigint
          N'A' , -- Column01 - nvarchar(500)
          N'B' , -- ColumnToAllowNullsInFuture01 - nvarchar(500)
          N'C' , -- Column02 - nvarchar(500)
          N'D' , -- ColumnToAllowNullsInFuture02 - nvarchar(500)
          N'E'  -- ColumnToAllowNullsInFuture03 - nvarchar(500)
        )
SET @var=@var+1
END

-- This will allow me to know where I am, if needed 
BEGIN TRANSACTION ThisIsMeBeforeAllowNull
INSERT INTO dbo.DummyTable01
        ( Id01 ,
          Column01 ,
          ColumnToAllowNullsInFuture01 ,
          Column02 ,
          ColumnToAllowNullsInFuture02 ,
          ColumnToAllowNullsInFuture03
        )
VALUES  ( 1 , -- Id01 - bigint
          N'A' , -- Column01 - nvarchar(500)
          N'B' , -- ColumnToAllowNullsInFuture01 - nvarchar(500)
          N'C' , -- Column02 - nvarchar(500)
          N'D' , -- ColumnToAllowNullsInFuture02 - nvarchar(500)
          N'E'  -- ColumnToAllowNullsInFuture03 - nvarchar(500)
        )
COMMIT TRANSACTION ThisIsMeBeforeAllowNull


-- Look at the number of records that exist -> and save the number ~308627
SELECT [Xact ID],[Begin Time],Description,*
FROM
    fn_dblog (NULL, NULL)
--	WHERE Description LIKE '%ThisIsMeBeforeAllowNull%'
ORDER BY [Transaction ID]

	SELECT Description,[Xact ID],[Begin Time],* FROM 
    fn_dblog (NULL, NULL)
	WHERE Description LIKE '%ThisIsMeBeforeAllowNull%'

-- Look at the size of the transaction log or this database
DBCC SQLPERF(LOGSPACE)

-- Save the values and see if there is and signifiant increase after change
Database Name	Log Size (MB)	Log Space Used (%)	Status
MyTestDatabase	71,99219	69,58017	0

-- Lets see what happens internally with the modification
ALTER TABLE [dbo].[DummyTable01]
ALTER COLUMN [ColumnToAllowNullsInFuture01] [NVARCHAR](500)  NULL

-- No significant change in transction log size
DBCC SQLPERF (LOGSPACE)
Database Name	Log Size (MB)	Log Space Used (%)	Status
MyTestDatabase	71,99219	69,58424	0

-- Look what happened after the TransactionLog
-- Just a couple of new entries, regarding the alter table
-- ~308644 rows now @ log
	SELECT Description,[Xact ID],[Begin Time],* FROM 
    fn_dblog (NULL, NULL)
		


	-- Now make the change, to original to now allow null, just to see the difference of volume:
ALTER TABLE [dbo].[DummyTable01]
ALTER COLUMN [ColumnToAllowNullsInFuture01] [NVARCHAR](500)    NULL

SELECT OBJECT_ID('[DummyTable01]')
-- Look At log size
DBCC SQLPERF (LOGSPACE)
Database Name	Log Size (MB)	Log Space Used (%)	Status
MyTestDatabase	135,9922	50,74862	0
-- Log significantly increased 

-- Lets see the records inthe transaction log

	SELECT Description,[Xact ID],[Begin Time],* FROM 
    fn_dblog (NULL, NULL)
		-- it increased significantly to 420045

	SELECT COUNT(*) FROM 
    fn_dblog (NULL, NULL)
	WHERE Operation='LOP_MODIFY_ROW'

	-- all rows are modified,  taking more time for the operation to finish

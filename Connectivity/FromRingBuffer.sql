SELECT CAST(record AS XML) FROM sys.dm_os_ring_buffers
WHERE ring_buffer_type = 'RING_BUFFER_CONNECTIVITY'


;WITH RingBufferConnectivity as
(   SELECT
        records.record.value('(/Record/@id)[1]', 'int') AS [RecordID],
        records.record.value('(/Record/ConnectivityTraceRecord/RecordType)[1]', 'varchar(max)') AS [RecordType],
        records.record.value('(/Record/ConnectivityTraceRecord/RecordTime)[1]', 'datetime') AS [RecordTime],
        records.record.value('(/Record/ConnectivityTraceRecord/SniConsumerError)[1]', 'int') AS [Error],
        records.record.value('(/Record/ConnectivityTraceRecord/State)[1]', 'int') AS [State],
        records.record.value('(/Record/ConnectivityTraceRecord/Spid)[1]', 'int') AS [Spid],
        records.record.value('(/Record/ConnectivityTraceRecord/RemoteHost)[1]', 'varchar(max)') AS [RemoteHost],
        records.record.value('(/Record/ConnectivityTraceRecord/RemotePort)[1]', 'varchar(max)') AS [RemotePort],
        records.record.value('(/Record/ConnectivityTraceRecord/LocalHost)[1]', 'varchar(max)') AS [LocalHost]
    FROM
    (   SELECT CAST(record as xml) AS record_data
        FROM sys.dm_os_ring_buffers
        WHERE ring_buffer_type= 'RING_BUFFER_CONNECTIVITY'
    ) TabA
    CROSS APPLY record_data.nodes('//Record') AS records (record)
)
SELECT RBC.*, m.text
FROM RingBufferConnectivity RBC
LEFT JOIN sys.messages M ON
    RBC.Error = M.message_id AND M.language_id = 1033
WHERE RBC.RecordType='Error' --Comment Out to see all RecordTypes
ORDER BY RBC.RecordTime DESC


SELECT 
    CONVERT (varchar(30), GETDATE(), 121) as [RunTime],
    DATEADD (ms, rbf.[timestamp] - tme.ms_ticks, GETDATE()) as [Notification_Time],
    CAST(record as xml).value('(//SPID)[1]', 'bigint') as SPID,
    CAST(record as xml).value('(//ErrorCode)[1]', 'varchar(255)') as Error_Code,
    CAST(record as xml).value('(//CallingAPIName)[1]', 'varchar(255)') as [CallingAPIName],
    CAST(record as xml).value('(//APIName)[1]', 'varchar(255)') as [APIName],
    CAST(record as xml).value('(//Record/@id)[1]', 'bigint') AS [Record Id],
    CAST(record as xml).value('(//Record/@type)[1]', 'varchar(30)') AS [Type],
    CAST(record as xml).value('(//Record/@time)[1]', 'bigint') AS [Record Time],
    tme.ms_ticks as [Current Time]
from sys.dm_os_ring_buffers rbf
cross join sys.dm_os_sys_info tme
where rbf.ring_buffer_type = 'RING_BUFFER_SECURITY_ERROR' --and cast(record as xml).value('(//SPID)[1]', 'int') = XspidNo
ORDER BY rbf.timestamp ASC



    SELECT CONVERT (varchar(30), GETDATE(), 121) as [RunTime],
    dateadd (ms, (rbf.[timestamp] - tme.ms_ticks), GETDATE()) as Time_Stamp,
    cast(record as xml).value('(//Record/ConnectivityTraceRecord/RecordType)[1]', 'varchar(50)') AS [Action], 
    cast(record as xml).value('(//Record/ConnectivityTraceRecord/RecordSource)[1]', 'varchar(50)') AS [Source], 
    cast(record as xml).value('(//Record/ConnectivityTraceRecord/Spid)[1]', 'int') AS [SPID],
    cast(record as xml).value('(//Record/ConnectivityTraceRecord/RemoteHost)[1]', 'varchar(100)') AS [RemoteHost],
    cast(record as xml).value('(//Record/ConnectivityTraceRecord/RemotePort)[1]', 'varchar(25)') AS [RemotePort],
    cast(record as xml).value('(//Record/ConnectivityTraceRecord/LocalPort)[1]', 'varchar(25)') AS [LocalPort],
    cast(record as xml).value('(//Record/ConnectivityTraceRecord/TdsBuffersInformation/TdsInputBufferError)[1]', 'varchar(25)') AS [TdsInputBufferError],
    cast(record as xml).value('(//Record/ConnectivityTraceRecord/TdsBuffersInformation/TdsOutputBufferError)[1]', 'varchar(25)') AS [TdsOutputBufferError],
    cast(record as xml).value('(//Record/ConnectivityTraceRecord/TdsBuffersInformation/TdsInputBufferBytes)[1]', 'varchar(25)') AS [TdsInputBufferBytes],
    cast(record as xml).value('(//Record/ConnectivityTraceRecord/TdsDisconnectFlags/PhysicalConnectionIsKilled)[1]', 'int') AS [isPhysConnKilled], 
    cast(record as xml).value('(//Record/ConnectivityTraceRecord/TdsDisconnectFlags/DisconnectDueToReadError)[1]', 'int') AS [DisconnectDueToReadError],
    cast(record as xml).value('(//Record/ConnectivityTraceRecord/TdsDisconnectFlags/NetworkErrorFoundInInputStream)[1]', 'int') AS [NetworkErrorFound],
    cast(record as xml).value('(//Record/ConnectivityTraceRecord/TdsDisconnectFlags/ErrorFoundBeforeLogin)[1]', 'int') AS [ErrorBeforeLogin],
    cast(record as xml).value('(//Record/ConnectivityTraceRecord/TdsDisconnectFlags/SessionIsKilled)[1]', 'int') AS [isSessionKilled],
    cast(record as xml).value('(//Record/ConnectivityTraceRecord/TdsDisconnectFlags/NormalDisconnect)[1]', 'int') AS [NormalDisconnect],
    cast(record as xml).value('(//Record/ConnectivityTraceRecord/TdsDisconnectFlags/NormalLogout)[1]', 'int') AS [NormalLogout],
    cast(record as xml).value('(//Record/@id)[1]', 'bigint') AS [Record Id], 
    cast(record as xml).value('(//Record/@type)[1]', 'varchar(30)') AS [Type], 
    cast(record as xml).value('(//Record/@time)[1]', 'bigint') AS [Record Time],
    tme.ms_ticks as [Current Time]
FROM sys.dm_os_ring_buffers rbf
cross join sys.dm_os_sys_info tme
where rbf.ring_buffer_type = 'RING_BUFFER_CONNECTIVITY' and cast(record as xml).value('(//Record/ConnectivityTraceRecord/Spid)[1]', 'int') <> 0
ORDER BY rbf.timestamp ASC

SELECT GETDATE()

 ;WITH connectivity_ring_buffer as
(SELECT
record.value('(Record/@id)[1]', 'int') as id,
record.value('(Record/@type)[1]', 'varchar(50)') as type,
record.value('(Record/ConnectivityTraceRecord/RecordType)[1]', 'varchar(50)') as RecordType,
record.value('(Record/ConnectivityTraceRecord/RecordSource)[1]', 'varchar(50)') as RecordSource,
record.value('(Record/ConnectivityTraceRecord/Spid)[1]', 'int') as Spid,
record.value('(Record/ConnectivityTraceRecord/SniConnectionId)[1]', 'uniqueidentifier') as SniConnectionId,
record.value('(Record/ConnectivityTraceRecord/SniProvider)[1]', 'int') as SniProvider,
record.value('(Record/ConnectivityTraceRecord/OSError)[1]', 'int') as OSError,
record.value('(Record/ConnectivityTraceRecord/SniConsumerError)[1]', 'int') as SniConsumerError,
record.value('(Record/ConnectivityTraceRecord/State)[1]', 'int') as State,
record.value('(Record/ConnectivityTraceRecord/RemoteHost)[1]', 'varchar(50)') as RemoteHost,
record.value('(Record/ConnectivityTraceRecord/RemotePort)[1]', 'varchar(50)') as RemotePort,
record.value('(Record/ConnectivityTraceRecord/LocalHost)[1]', 'varchar(50)') as LocalHost,
record.value('(Record/ConnectivityTraceRecord/LocalPort)[1]', 'varchar(50)') as LocalPort,
record.value('(Record/ConnectivityTraceRecord/RecordTime)[1]', 'datetime') as RecordTime,
record.value('(Record/ConnectivityTraceRecord/LoginTimers/TotalLoginTimeInMilliseconds)[1]', 'bigint') as TotalLoginTimeInMilliseconds,
record.value('(Record/ConnectivityTraceRecord/LoginTimers/LoginTaskEnqueuedInMilliseconds)[1]', 'bigint') as LoginTaskEnqueuedInMilliseconds,
record.value('(Record/ConnectivityTraceRecord/LoginTimers/NetworkWritesInMilliseconds)[1]', 'bigint') as NetworkWritesInMilliseconds,
record.value('(Record/ConnectivityTraceRecord/LoginTimers/NetworkReadsInMilliseconds)[1]', 'bigint') as NetworkReadsInMilliseconds,
record.value('(Record/ConnectivityTraceRecord/LoginTimers/SslProcessingInMilliseconds)[1]', 'bigint') as SslProcessingInMilliseconds,
record.value('(Record/ConnectivityTraceRecord/LoginTimers/SspiProcessingInMilliseconds)[1]', 'bigint') as SspiProcessingInMilliseconds,
record.value('(Record/ConnectivityTraceRecord/LoginTimers/LoginTriggerAndResourceGovernorProcessingInMilliseconds)[1]', 'bigint') as LoginTriggerAndResourceGovernorProcessingInMilliseconds,
record.value('(Record/ConnectivityTraceRecord/TdsBuffersInformation/TdsInputBufferError)[1]', 'int') as TdsInputBufferError,
record.value('(Record/ConnectivityTraceRecord/TdsBuffersInformation/TdsOutputBufferError)[1]', 'int') as TdsOutputBufferError,
record.value('(Record/ConnectivityTraceRecord/TdsBuffersInformation/TdsInputBufferBytes)[1]', 'int') as TdsInputBufferBytes,
record.value('(Record/ConnectivityTraceRecord/TdsDisconnectFlags/PhysicalConnectionIsKilled)[1]', 'int') as PhysicalConnectionIsKilled,
record.value('(Record/ConnectivityTraceRecord/TdsDisconnectFlags/DisconnectDueToReadError)[1]', 'int') as DisconnectDueToReadError,
record.value('(Record/ConnectivityTraceRecord/TdsDisconnectFlags/NetworkErrorFoundInInputStream)[1]', 'int') as NetworkErrorFoundInInputStream,
record.value('(Record/ConnectivityTraceRecord/TdsDisconnectFlags/ErrorFoundBeforeLogin)[1]', 'int') as ErrorFoundBeforeLogin,
record.value('(Record/ConnectivityTraceRecord/TdsDisconnectFlags/SessionIsKilled)[1]', 'int') as SessionIsKilled,
record.value('(Record/ConnectivityTraceRecord/TdsDisconnectFlags/NormalDisconnect)[1]', 'int') as NormalDisconnect
--record.value('(Record/ConnectivityTraceRecord/TdsDisconnectFlags/NormalLogout)[1]', 'int') as NormalLogout
FROM
( SELECT CAST(record as xml) as record
FROM sys.dm_os_ring_buffers
WHERE ring_buffer_type = 'RING_BUFFER_CONNECTIVITY') as tab
)
SELECT c.RecordTime,m.[text],*
FROM connectivity_ring_buffer c
LEFT JOIN sys.messages m ON c.SniConsumerError = m.message_id AND m.language_id = 1033
ORDER BY c.RecordTime DESC
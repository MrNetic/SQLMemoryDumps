select object_name,counter_name,instance_name,cntr_value
from sys.dm_os_performance_counters
 where object_name like '%Replica%'
 and object_name not like '%Replication%'
-- Alternative to DBCC IND :) more recent

select top 10 * from sys.dm_db_database_page_allocations(db_id(),object_id('dba.tbl_requests'),null,null,'limited')


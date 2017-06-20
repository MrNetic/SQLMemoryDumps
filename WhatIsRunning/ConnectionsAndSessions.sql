SELECT   
    c.net_transport,    
    c.auth_scheme, s.host_name,c.client_net_address , 
    s.client_interface_name, s.login_name, 
	s.original_login_name,COUNT(*) AS conns  
FROM sys.dm_exec_connections AS c  
JOIN sys.dm_exec_sessions AS s  
    ON c.session_id = s.session_id 
	GROUP BY     c.net_transport,    
    c.auth_scheme, s.host_name, c.client_net_address  ,
    s.client_interface_name, s.login_name, 
	s.original_login_name
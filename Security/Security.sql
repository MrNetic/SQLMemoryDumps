/* SEGURANÇA @ MS SQL SERVER 2005 */
/*
Using Transact-SQL to Verify SQL Server Login Authentication
You can use Transact-SQL to verify login authentication in addition to other security
settings, such as encryption and database permissions. Transact-SQL catalog views
and the LOGINPROPERTY Transact-SQL function provide this functionality.
Transact-SQL Security Catalog Views Security information is exposed in Transact-
SQL security catalog views. You can use the following catalog views to access catalog
metadata:
? Database-Level Views
? sys.database_permissions
? sys.database_role_members
? sys.database_principals
? sys.master_key_passwords
? Server-Level Views
? sys.server_permissions	
? select * from sys.sql_logins
? sys.server_principals
? sys.system_components_surface_area_configuration
? sys.server_role_members
? Encryption Views
? sys.asymmetric_keys
? sys.crypt_properties
? sys.certificates
? sys.key_encryptions
? sys.credentials
? sys.symmetric_keys :)
*/

/*
SQL Server 2005 Security Terminology
The following are some important terms in SQL Server 2005:

Principal Principal
is a generic term that can be used to refer to an 
individual Windows login or a Windows group, a SQL login, a database user, 
an application role, or a database role, which is used for authentication 
and authorization purposes in SQL Server. The sa SQL Server login and 
BUILTIN\Administrators Windows group are examples of principals. 
Each principal has a unique SID. The sys.server_principals and 
sys.database_principals catalog views can be used to view a list of 
server-level and database-level principals, respectively.
*/

-- Ver roles, não tem o public

SELECT c.name AS Sysadmin_Server_Role_Members,a.name

FROM sys.server_principals a 

INNER JOIN sys.server_role_members b

ON a.principal_id = b.role_principal_id AND a.type = 'R'
-- AND a.name ='sysadmin'

INNER JOIN sys.server_principals c

ON b.member_principal_id = c.principal_id

--

select dp.NAME AS principal_name,

           dp.type_desc AS principal_type_desc,

           o.NAME AS object_name,

           p.permission_name,

           p.state_desc AS permission_state_desc 

   from    sys.database_permissions p

   left    OUTER JOIN sys.all_objects o

   on     p.major_id = o.OBJECT_ID

   inner   JOIN sys.database_principals dp

   on     p.grantee_principal_id = dp.principal_id

--






select USER_NAME(p.grantee_principal_id) AS principal_name,

        dp.type_desc AS principal_type_desc,

        p.class_desc,

        OBJECT_NAME(p.major_id) AS object_name,

        p.permission_name,

        p.state_desc AS permission_state_desc 

from    sys.database_permissions p

inner   JOIN sys.database_principals dp

on     p.grantee_principal_id = dp.principal_id







--
-- INFORMAÇÃO POR BASE DE DADOS


WITH    perms_cte as

(

        select USER_NAME(p.grantee_principal_id) AS principal_name,

                dp.principal_id,

                dp.type_desc AS principal_type_desc,

                p.class_desc,

                OBJECT_NAME(p.major_id) AS object_name,

                p.permission_name,

                p.state_desc AS permission_state_desc 

        from    sys.database_permissions p

        inner   JOIN sys.database_principals dp

        on     p.grantee_principal_id = dp.principal_id

)

--users

SELECT p.principal_name,  p.principal_type_desc, p.class_desc, p.[object_name], p.permission_name, p.permission_state_desc, cast(NULL as sysname) as role_name

FROM    perms_cte p

WHERE   principal_type_desc <> 'DATABASE_ROLE'

UNION

--role members

SELECT rm.member_principal_name, rm.principal_type_desc, p.class_desc, p.object_name, p.permission_name, p.permission_state_desc,rm.role_name

FROM    perms_cte p

right outer JOIN (

    select role_principal_id, dp.type_desc as principal_type_desc, member_principal_id,user_name(member_principal_id) as member_principal_name,user_name(role_principal_id) as role_name--,*

    from    sys.database_role_members rm

    INNER   JOIN sys.database_principals dp

    ON     rm.member_principal_id = dp.principal_id

) rm

ON     rm.role_principal_id = p.principal_id

order by 1














--
SELECT a.name AS Login_Name, 

a.type_desc AS LoginType, 

b.permission_name AS Permission


FROM sys.server_principals a

INNER JOIN sys.server_permissions b 

ON a.principal_id = b.grantee_principal_id


WHERE a.type <> 'R' -- Excludes Server Role

AND a.name NOT LIKE '##MS_%' -- Excludes system level certificate mapped logins

--AND a.name <> 'sa' -- Excludes the obvious system administrator

AND b.state = 'G' -- Granted

ORDER BY a.name





--

-- Analisar Principals
select * from sys.server_principals 
select * from sys.database_principals 
SELECT * FROM sys.fn_builtin_permissions(DEFAULT);

-- Analisar Logins

select * from sys.sql_logins

/*
Securable 
Securables are items like endpoints, databases, the Full-Text catalog, 
Service Broker contracts, tables, views, functions, procedures, and so 
on that you can secure at the server level, database level, or schema level.

Grantor
The grantor is the principal that grants a permission.

Grantee
The grantee is the principal to whom the permission is granted.

*/



--You can use the sys.server_permissions and sys.database_permissions 
--catalog views to view server-level and database-level permission details.
select * from sys.server_permissions
select * from sys.database_permissions
select * from sys.sql_modules
/* Segurança SQL SERVER */

/*
Example 7.1.1: Adding a standard SQL Server login account
?? Standard login name: BookUser
?? Password: t0ughPassword$1
?? Default database: BookRepository07
?? Default language: English:
*/
EXEC sp_addlogin
'NomeUtilizador',
'Password',
'NomeBd',
'English'

--Example 7.1.2: Adding an NT user account
EXEC sp_grantlogin
'CURLINGSTONE\BookAdministrator'

--Example 7.1.3: Adding an NT group
EXEC sp_grantlogin
'CURLINGSTONE\Accounting'

-- Validar se conta existe em dominio

sp_validatelogins

-- Alterar Password
-- Se nao se lembrar da password antiga, pode-se alterar o valor de null
--na PasswordAntiga.
sp_password 'PasswordAntiga','PasswordNova','NomeUtilizador'

-- Alterar owner BD

sp_changedbowner

-- Alterar Owner de Objectos
EXEC sp_changeobjectowner 'Owner.Objecto', 'dbo'

-- Revogar acesso BD ( Remove user de BD, mas mantem login @ servidor

sp_revokedbaccess NomeDeUser

--Analisar roles

sp_helprole

-- Ver membros de um determinado role

sp_helprolemember 'db_owner'

-- Ver users de uma determinada BD

sp_helpuser 'dbo'


-- Ver todos os users que pertencem a uma determinada role

sp_helpuser 'NomeDaRole'

-- Mostrar permissoes das contas e permition path

EXEC master..xp_logininfo 'dominio\username'

-- Como negar acesso ao SQL SERVER a um NTUSER OU GRUPO

sp_denylogin 'Dominio\Nome'

-- Retornar Server Roles

sp_helpsrvrole

sp_srvrolepermission

sp_helpsrvrolemember

-- Ver Fixed Database Roles
sp_helpdbfixedrole

-- Ver permissoes das fixes Database Roles
sp_dbfixedrolepermission

-- EXEMPLOS DE GRANTS

--Example 7.21.1: Granting permissions to back up the database 
--and transaction log to a user
GRANT BACKUP DATABASE, BACKUP LOG
TO JaneDoe

--Example 7.21.2: Granting all statement permissions to a user
GRANT ALL TO JaneDoe

--Example 7.21.3: Granting CREATE TABLE permissions to a user-defined 
--database role
GRANT CREATE TABLE TO BookDistributor

--Example 7.21.4: Granting SELECT permissions for a table to one user
GRANT SELECT ON Authors TO JaneDoe

--Example 7.21.5: Granting SELECT permissions for a table to one 
--user using WITH GRANT
--This example allows the user to grant the specified permissions 
--to other security accounts:
GRANT SELECT ON Authors TO JaneDoe
WITH GRANT OPTION

--Example 7.21.6: Granting INSERT, UPDATE, and DELETE permissions
--for a table to one user
GRANT INSERT, UPDATE, DELETE ON Authors
TO JaneDoe

--Example 7.21.7: Granting ALL permissions for a table to one user
GRANT ALL ON Authors
TO JaneDoe

--Example 7.21.8: Granting SELECT permissions for a table to multiple users
GRANT SELECT ON Books
TO JaneDoe, JohnDeer, JackSmith
--Example 7.21.9: Granting REFERENCES to a table for a user-defined role
GRANT REFERENCES ON Books TO BookDistributor

--Example 7.21.10: Denying permissions to back up the database and
--transaction log for a user
DENY BACKUP DATABASE, BACKUP LOG TO JaneDoe

--Example 7.21.11: Denying all statement permissions for a user
DENY ALL TO JaneDoe

--Example 7.21.12: Denying CREATE TABLE permissions to a user-defined 
--database role
DENY CREATE TABLE TO BookDistributor

--Example 7.21.13: Denying SELECT permissions for a table to one user
DENY SELECT ON Authors TO JaneDoe

--Example 7.21.14: Denying INSERT, UPDATE, and DELETE permissions for 
--a table to one user
DENY INSERT, UPDATE, DELETE ON Authors TO JaneDoe

--Example 7.21.15: Denying ALL permissions for a table to one user
DENY ALL ON Authors TO JaneDoe

--Example 7.21.16: Denying SELECT permissions for a table to multiple users
DENY SELECT ON Books TO JaneDoe, JohnDeer, JackSmith

--Example 7.21.17: Denying REFERENCES to a table for a user-defined role
DENY REFERENCES ON Books TO BookDistributor

--Example 7.21.18: Denying SELECT to a table to a user, and any users to 
--whom the original WITH GRANT OPTION user may have granted permissions
--This example denies access to the Authors table for JaneDoe,
--and also anyone to whom JaneDoe may have
--granted Authors SELECT permissions:
DENY SELECT ON Authors TO JaneDoe CASCADE

--Example 7.21.19: Revoking permissions to back up the database and 
--transaction log from a user
REVOKE BACKUP DATABASE, BACKUP LOG FROM JaneDoe

--Example 7.21.20: Revoking all statement permissions from a user
REVOKE ALL FROM JaneDoe

--Example 7.21.21: Revoking CREATE TABLE permissions from a user-defined 
--database role
REVOKE CREATE TABLE FROM BookDistributor

--Example 7.21.22: Revoking SELECT permissions for a table from one user
REVOKE SELECT ON Authors TO JaneDoe

--Example 7.21.23: Revoking SELECT permissions for a table from a user
--that was given WITH GRANT OPTION permissions
REVOKE SELECT ON Authors TO JaneDoe CASCADE

--Example 7.21.24: Revoking INSERT, UPDATE, and DELETE permissions for 
--a table from one user
REVOKE INSERT, UPDATE, DELETE ON Authors TO JaneDoe

--Example 7.21.25: Revoking ALL permissions for a table to one user
REVOKE ALL ON Authors TO JaneDoe

--Example 7.21.26: Revoking SELECT permissions for a table to multiple users
REVOKE SELECT ON Books TO JaneDoe, JohnDeer, JackSmith

--Example 7.21.27: Revoking REFERENCES to a table for a user-defined role
REVOKE REFERENCES ON Books TO BookDistributor

-- Analisar permissoes de utilizador.
sp_helprotect

-- Analisar permissoes individualmente.
sp_helprotect @username ='dbo'

-- Analisar permissoes por objecto
EXEC sp_helprotect @name = 'NomeObjecto'

-- Ver todos os utilizadores que foram granted ou denied a um objecto
-- especifico
sp_helprotect @name = 'CREATE DEFAULT'

--
USE msdb
GO

-----------------------------------------------------------------------------
-- generate code to create the subfolders
-- Copy and paste the first column into a batch file and run it.
-----------------------------------------------------------------------------
WITH ChildFolders AS(
    SELECT PARENT.parentfolderid, PARENT.folderid, PARENT.foldername,
        CAST('' AS SYSNAME) AS RootFolder,
        CAST(PARENT.foldername AS VARCHAR(MAX)) AS FullPath,
        0 AS Lvl\\\\
        CASE ChildFolders.Lvl
            WHEN 0 THEN CHILD.foldername
            ELSE ChildFolders.RootFolder
        END AS RootFolder,
        CAST(ChildFolders.FullPath + '/' + CHILD.foldername AS VARCHAR(MAX))
            AS FullPath,
        ChildFolders.Lvl + 1 AS Lvl
    FROM msdb.dbo.sysssispackagefolders CHILD
        INNER JOIN ChildFolders ON ChildFolders.folderid = CHILD.parentfolderid
)
SELECT DISTINCT
   'mkdir "s:\temp' + REPLACE(f.FullPath, '/', '\') + '"'
   ,F.FullPath
FROM ChildFolders F
    INNER JOIN msdb.dbo.sysssispackages P ON P.folderid = F.folderid
WHERE F.RootFolder <> ''
ORDER BY F.FullPath ASC

go
---------------------------------------------------------------------------
-- generate code to use DTUTIL to export the DTSX files using the same directory 
-- structure as in MSDB
-- Copy and paste the first column into a batch file and run it.
---------------------------------------------------------------------------
WITH ChildFolders AS(
    SELECT PARENT.parentfolderid, PARENT.folderid, PARENT.foldername,
        CAST('' AS SYSNAME) AS RootFolder,
        CAST(PARENT.foldername AS VARCHAR(MAX)) AS FullPath,
        0 AS Lvl
    FROM msdb.dbo.sysssispackagefolders PARENT
    WHERE PARENT.parentfolderid IS NULL
    UNION ALL
    SELECT CHILD.parentfolderid, CHILD.folderid, CHILD.foldername,
        CASE ChildFolders.Lvl
            WHEN 0 THEN CHILD.foldername
            ELSE ChildFolders.RootFolder
        END AS RootFolder,
        CAST(ChildFolders.FullPath + '/' + CHILD.foldername AS VARCHAR(MAX))
            AS FullPath,
        ChildFolders.Lvl + 1 AS Lvl
    FROM msdb.dbo.sysssispackagefolders CHILD
        INNER JOIN ChildFolders ON ChildFolders.folderid = CHILD.parentfolderid
)
SELECT 
   'DTUTIL /SQL "' + REPLACE(f.FullPath, '/', '\') + '\' + P.name 
       + '" /Copy FILE;"s:\temp' 
       + REPLACE(f.FullPath, '/', '\') + '\' + P.name 
       + '.dtsx" /Decrypt PackagePassword'
   ,F.RootFolder, F.FullPath, P.name AS PackageName,
    P.description AS PackageDescription, P.packageformat, P.packagetype,
    P.vermajor, P.verminor, P.verbuild, P.vercomments,
    CAST(CAST(P.packagedata AS VARBINARY(MAX)) AS XML) AS PackageData
FROM ChildFolders F
    INNER JOIN msdb.dbo.sysssispackages P ON P.folderid = F.folderid
ORDER BY F.FullPath ASC, P.name ASC; 

--
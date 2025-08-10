-- Change the column type for PhoneNumber in the Clients table
EXEC ModifyColumnType 'Clients', 'PhoneNumber', 'VARCHAR(50)';
GO

-- Rollback the column type change
EXEC RollbackColumnType 'Clients', 'PhoneNumber', 'VARCHAR(20)';
GO



-- Add a default constraint to the Priority column in the Tasks table
EXEC AddDefaultConstraint 'Tasks', 'Priority', '''Medium''';
GO

-- Rollback the default constraint
EXEC RollbackDefaultConstraint 'Tasks', 'Priority';
GO




-- Create a new table for ArchivedProjects
EXEC CreateNewTable 'ArchivedProjects', 'ArchiveID INT PRIMARY KEY, ProjectName NVARCHAR(255), ArchivedDate DATE';
GO

-- Rollback the created table
EXEC RollbackCreateTable 'ArchivedProjects';
GO



-- Add a new column to the Projects table
EXEC AddColumn 'Projects', 'EstimatedDuration', 'INT';
GO

-- Rollback the added column
EXEC RollbackAddColumn 'Projects', 'EstimatedDuration';
GO



-- Add a foreign key to the Employees table referencing Teams
EXEC AddForeignKey 'Employees', 'TeamID', 'Teams', 'TeamID';
GO

-- Rollback the foreign key
EXEC RollbackForeignKey 'Employees', 'TeamID';
GO


SELECT * FROM VersionHistory;
SELECT * FROM VersionControl;

EXEC UpdateVersion @version = 2;
GO
CREATE OR ALTER PROCEDURE CreateNewTable 
    @table_name NVARCHAR(50),
    @columns NVARCHAR(MAX),
    @new_version INT = 1
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);

    -- Create new table
    SET @sql = 'CREATE TABLE ' + @table_name + ' (' + @columns + ')';
    EXEC sp_executesql @sql;

    -- Log the change
    IF @new_version = 1
    BEGIN
        INSERT INTO VersionHistory (
            ProcedureName, TableName, ColumnsDefinition
        ) VALUES (
            'CreateNewTable', @table_name, @columns
        );
        UPDATE VersionControl SET CurrentVersion = (SELECT MAX(VersionNumber) FROM VersionHistory);
    END
END;
GO

CREATE OR ALTER PROCEDURE AddColumn 
    @table_name NVARCHAR(50), 
    @column_name NVARCHAR(50), 
    @column_type NVARCHAR(50),
    @new_version INT = 1
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);

    -- Add column
    SET @sql = 'ALTER TABLE ' + @table_name + ' ADD ' + @column_name + ' ' + @column_type;
    EXEC sp_executesql @sql;

    -- Log the change
    IF @new_version = 1
    BEGIN
        INSERT INTO VersionHistory (
            ProcedureName, TableName, ColumnName, ColumnAdded, ColumnAddedType
        ) VALUES (
            'AddColumn', @table_name, @column_name, @column_name, @column_type
        );
        UPDATE VersionControl SET CurrentVersion = (SELECT MAX(VersionNumber) FROM VersionHistory);
    END
END;
GO

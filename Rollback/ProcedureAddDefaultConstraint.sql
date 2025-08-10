CREATE OR ALTER PROCEDURE AddDefaultConstraint 
    @table_name NVARCHAR(50), 
    @column_name NVARCHAR(50), 
    @default_value NVARCHAR(50),
    @new_version INT = 1
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);

    -- Add default constraint
    SET @sql = 'ALTER TABLE ' + @table_name + ' ADD CONSTRAINT DF_' + @table_name + '_' + @column_name + 
               ' DEFAULT ' + @default_value + ' FOR ' + @column_name;
    EXEC sp_executesql @sql;

    -- Log the change
    IF @new_version = 1
    BEGIN
        INSERT INTO VersionHistory (
            ProcedureName, TableName, ColumnName, DefaultValue
        ) VALUES (
            'AddDefaultConstraint', @table_name, @column_name, @default_value
        );
        UPDATE VersionControl SET CurrentVersion = (SELECT MAX(VersionNumber) FROM VersionHistory);
    END
END;
GO

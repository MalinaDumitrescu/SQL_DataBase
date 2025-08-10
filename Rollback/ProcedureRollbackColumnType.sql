CREATE OR ALTER PROCEDURE RollbackColumnType
    @table_name NVARCHAR(50),
    @column_name NVARCHAR(50),
    @old_type NVARCHAR(50)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);

    -- Revert column type
    SET @sql = 'ALTER TABLE ' + @table_name + ' ALTER COLUMN ' + @column_name + ' ' + @old_type;
    EXEC sp_executesql @sql;
END;
GO

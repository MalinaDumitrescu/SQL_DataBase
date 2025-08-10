CREATE OR ALTER PROCEDURE RollbackAddColumn
    @table_name NVARCHAR(50),
    @column_name NVARCHAR(50)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);

    -- Remove column
    SET @sql = 'ALTER TABLE ' + @table_name + ' DROP COLUMN ' + @column_name;
    EXEC sp_executesql @sql;
END;
GO

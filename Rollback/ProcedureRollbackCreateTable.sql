CREATE OR ALTER PROCEDURE RollbackCreateTable
    @table_name NVARCHAR(50)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);

    -- Drop the table
    SET @sql = 'DROP TABLE ' + @table_name;
    EXEC sp_executesql @sql;
END;
GO

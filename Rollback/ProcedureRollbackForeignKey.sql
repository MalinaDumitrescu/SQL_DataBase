CREATE OR ALTER PROCEDURE RollbackForeignKey 
    @table_name NVARCHAR(50),
    @column_name NVARCHAR(50)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);

    -- Remove foreign key
    SET @sql = 'ALTER TABLE ' + @table_name + ' DROP CONSTRAINT FK_' + @table_name + '_' + @column_name;
    EXEC sp_executesql @sql;
END;
GO

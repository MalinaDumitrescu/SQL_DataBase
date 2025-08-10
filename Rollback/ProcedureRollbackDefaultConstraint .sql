CREATE OR ALTER PROCEDURE RollbackDefaultConstraint 
    @table_name NVARCHAR(50),
    @column_name NVARCHAR(50)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);

    -- Remove default constraint
    SET @sql = 'ALTER TABLE ' + @table_name + ' DROP CONSTRAINT DF_' + @table_name + '_' + @column_name;
    EXEC sp_executesql @sql;
END;
GO

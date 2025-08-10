CREATE OR ALTER PROCEDURE AddForeignKey 
    @table_name NVARCHAR(50), 
    @column_name NVARCHAR(50), 
    @referenced_table NVARCHAR(50),
    @referenced_column NVARCHAR(50),
    @new_version INT = 1
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);

    -- Add foreign key
    SET @sql = 'ALTER TABLE ' + @table_name + 
               ' ADD CONSTRAINT FK_' + @table_name + '_' + @column_name +
               ' FOREIGN KEY (' + @column_name + ') REFERENCES ' + @referenced_table + '(' + @referenced_column + ')';
    EXEC sp_executesql @sql;

    -- Log the change
    IF @new_version = 1
    BEGIN
        INSERT INTO VersionHistory (
            ProcedureName, TableName, ColumnName, ForeignKeyTable, ForeignKeyColumn
        ) VALUES (
            'AddForeignKey', @table_name, @column_name, @referenced_table, @referenced_column
        );
        UPDATE VersionControl SET CurrentVersion = (SELECT MAX(VersionNumber) FROM VersionHistory);
    END
END;
GO

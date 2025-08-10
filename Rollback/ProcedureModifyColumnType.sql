CREATE OR ALTER PROCEDURE ModifyColumnType 
    @table_name NVARCHAR(50), 
    @column_name NVARCHAR(50), 
    @new_type NVARCHAR(50),
    @new_version INT = 1
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);
    DECLARE @old_type NVARCHAR(50);

    -- Get current column type
    SELECT @old_type = DATA_TYPE 
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = @table_name AND COLUMN_NAME = @column_name;

    DECLARE @length AS VARCHAR(50);
    SET @length = (
        SELECT CHARACTER_MAXIMUM_LENGTH
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @table_name AND COLUMN_NAME = @column_name
    );

    IF @length IS NOT NULL
        SET @old_type = @old_type + '(' + @length + ')';

    -- Alter column type
    SET @sql = 'ALTER TABLE ' + @table_name + ' ALTER COLUMN ' + @column_name + ' ' + @new_type;
    EXEC sp_executesql @sql;

    -- Log the change
    IF @new_version = 1
    BEGIN
        INSERT INTO VersionHistory (
            ProcedureName, TableName, ColumnName, OldColumnType, NewColumnType
        ) VALUES (
            'ModifyColumnType', @table_name, @column_name, @old_type, @new_type
        );
        UPDATE VersionControl SET CurrentVersion = (SELECT MAX(VersionNumber) FROM VersionHistory);
    END
END;
GO

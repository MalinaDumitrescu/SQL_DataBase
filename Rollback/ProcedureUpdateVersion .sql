CREATE OR ALTER PROCEDURE UpdateVersion 
    @version INT
AS
BEGIN
    DECLARE @currentVersion INT;
    SELECT @currentVersion = ISNULL(CurrentVersion, 0) FROM VersionControl;

    -- Handle case when the target version is the same as the current version
    IF @version = @currentVersion
    BEGIN
        PRINT 'Already at specified version';
        RETURN;
    END

    -- Declaration of variables for VersionHistory fields
    DECLARE @verNum INT, @proc NVARCHAR(100), @table NVARCHAR(50), @column NVARCHAR(50),
            @oldType NVARCHAR(50), @newType NVARCHAR(50), @default NVARCHAR(50),
            @colAdded NVARCHAR(50), @colType NVARCHAR(50), @fkTable NVARCHAR(50), @fkCol NVARCHAR(50), @cdef NVARCHAR(MAX);

    -- Logic for going up (applying upgrades)
    IF @version > @currentVersion
    BEGIN
        PRINT 'Upgrading to version ' + CAST(@version AS NVARCHAR);

        DECLARE history_cursor CURSOR FOR
        SELECT VersionNumber, ProcedureName, TableName, ColumnName, OldColumnType, NewColumnType, 
               DefaultValue, ColumnAdded, ColumnAddedType, ForeignKeyTable, ForeignKeyColumn, ColumnsDefinition
        FROM VersionHistory
        WHERE VersionNumber > @currentVersion AND VersionNumber <= @version
        ORDER BY VersionNumber ASC;

        OPEN history_cursor;

        FETCH NEXT FROM history_cursor INTO @verNum, @proc, @table, @column, @oldType, @newType,
                                            @default, @colAdded, @colType, @fkTable, @fkCol, @cdef;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Dynamically execute the appropriate procedure
            IF @proc = 'ModifyColumnType'
                EXEC ModifyColumnType @table, @column, @newType, 0;
            ELSE IF @proc = 'AddDefaultConstraint'
                EXEC AddDefaultConstraint @table, @column, @default, 0;
            ELSE IF @proc = 'CreateNewTable'
                IF @cdef IS NOT NULL
                    EXEC CreateNewTable @table, @cdef, 0;
            ELSE IF @proc = 'AddColumn'
                EXEC AddColumn @table, @colAdded, @colType, 0;
            ELSE IF @proc = 'AddForeignKey'
                EXEC AddForeignKey @table, @column, @fkTable, @fkCol, 0;

            -- Update CurrentVersion
            UPDATE VersionControl SET CurrentVersion = @verNum;

            FETCH NEXT FROM history_cursor INTO @verNum, @proc, @table, @column, @oldType, @newType,
                                                @default, @colAdded, @colType, @fkTable, @fkCol, @cdef;
        END;

        CLOSE history_cursor;
        DEALLOCATE history_cursor;
    END

    -- Logic for going down (rolling back changes)
    ELSE IF @version < @currentVersion
    BEGIN
        PRINT 'Rolling back to version ' + CAST(@version AS NVARCHAR);

        DECLARE rollback_cursor CURSOR FOR
        SELECT VersionNumber, ProcedureName, TableName, ColumnName, OldColumnType, NewColumnType,
               DefaultValue, ColumnAdded, ColumnAddedType, ForeignKeyTable, ForeignKeyColumn, ColumnsDefinition
        FROM VersionHistory
        WHERE VersionNumber <= @currentVersion AND VersionNumber > @version
        ORDER BY VersionNumber DESC;

        OPEN rollback_cursor;

        FETCH NEXT FROM rollback_cursor INTO @verNum, @proc, @table, @column, @oldType, @newType,
                                             @default, @colAdded, @colType, @fkTable, @fkCol, @cdef;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Dynamically execute the appropriate rollback procedure
            IF @proc = 'ModifyColumnType'
                EXEC RollbackColumnType @table, @column, @oldType;
            ELSE IF @proc = 'AddDefaultConstraint'
                EXEC RollbackDefaultConstraint @table, @column;
            ELSE IF @proc = 'CreateNewTable'
                IF @cdef IS NOT NULL
                    EXEC RollbackCreateTable @table;
            ELSE IF @proc = 'AddColumn'
                EXEC RollbackAddColumn @table, @colAdded;
            ELSE IF @proc = 'AddForeignKey'
                EXEC RollbackForeignKey @table, @column;

            -- Update CurrentVersion
            UPDATE VersionControl SET CurrentVersion = @verNum - 1;

            FETCH NEXT FROM rollback_cursor INTO @verNum, @proc, @table, @column, @oldType, @newType,
                                                 @default, @colAdded, @colType, @fkTable, @fkCol, @cdef;
        END;

        CLOSE rollback_cursor;
        DEALLOCATE rollback_cursor;
    END
END;
GO

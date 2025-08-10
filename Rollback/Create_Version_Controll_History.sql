create table VersionControl (
   CurrentVersion int primary key
);

insert into VersionControl (CurrentVersion) values (0);

create table VersionHistory (
   VersionNumber int identity(1, 1) not null primary key,
   ProcedureName nvarchar(100),
   TableName nvarchar(50) null,
   ColumnName nvarchar(50) null,
   OldColumnType nvarchar(50) null,
   NewColumnType nvarchar(50) null,
   DefaultValue nvarchar(50) null,
   ColumnAdded nvarchar(50) null,
   ColumnAddedType nvarchar(50) null,
   ForeignKeyTable nvarchar(50) null,
   ForeignKeyColumn nvarchar(50) null,
   ColumnsDefinition nvarchar(max) null
);

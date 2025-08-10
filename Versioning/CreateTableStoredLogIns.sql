create table StoredLogIns(
LogID int identity primary key, 
EventDateTime datetime default getdate(), -- when was the instruction executed
EventType char(1),  --type of instruction (I/U/D)
TableName nvarchar(255),
AffectedRows int);
go
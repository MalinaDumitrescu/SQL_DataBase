create trigger triggerClientsLogIns
on Clients
after insert, update, delete
as 
begin
   set nocount on;
   declare @RowCount int;
   set @RowCount = @@ROWCOUNT;

   -- INSERT

   if exists (select 1 from inserted)
   and not exists (select 1 from deleted)
   begin
       insert into StoredLogIns (EventType, TableName, AffectedRows)
	   values ('I', 'Clients', @RowCount);
   end 

   -- DELETE
   if exists (select 1 from deleted)
   and not exists (select 1 from inserted)
   begin
       insert into StoredLogIns (EventType, TableName, AffectedRows)
	   values ('D', 'Clients', @RowCount);
   end 

   -- UPDATE

   if exists(select 1 from inserted)
   and exists (select 1 from deleted)
   begin 
      insert into StoredLogIns (EventType, TableName, AffectedRows)
	  values ('U', 'Clients', @RowCount);
	end
end;
go

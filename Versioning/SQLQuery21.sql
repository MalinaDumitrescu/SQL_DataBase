-- 2. allocate a resource to a project
exec AllocateResourceToProject 1, 1;
go

--verify the resource distribution and quantity update
select * from Resource_Distribution where ProjectID = 1 and ResourceID = 1;
select Quantity from Resources where ResourceID = 1;

-- 3.
--insert a new client to trigger logging
insert into Clients (ClientID, Name, Contact, Email, PhoneNumber, Address, Industry)
values (14, 'Trigger Corp', 'Triggered User', 'trigger@corp.com', '999-888-7777', '123 Trigger St', 'Energy');
go

--update the client to trigger logging
update Clients set PhoneNumber = '777-666-5555' where ClientID = 14;
go

--delete the client to trigger logging
delete from Clients where ClientID = 14;
go

--verify the log entries
select * from StoredLogIns where TableName = 'Clients';

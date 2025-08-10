-- 1.
--valid insert
exec InsertClient 11, 'New Corp', 'Alice Blue', 'alice@newcorp.com', '555-444-3333', '456 Ocean St', 'Technology';
go
select * from Clients where ClientID = 11;

--invalid insert
exec InsertClient 12, 'Bad Email Corp', 'Invalid User', 'bademail.com', '111-222-3333', '123 Fake St', 'Technology';
go
--invalid industry
exec InsertClient 13, 'Bad Industry Corp', 'Another User', 'user@industry.com', '222-333-4444', '987 Unknown St', 'UnknownIndustry';
go


-- ERRORS on 2nd ex, because the table is not populates as it should be
-- i didn t check as i should ve done the resource allocation, if it has or has not been successfully done, but code should be good

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

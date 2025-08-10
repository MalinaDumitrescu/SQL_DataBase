--valid insert
exec InsertClient 11, 'New Corp', 'Alice Blue', 'alice@newcorp.com', '555-444-3333', '456 Ocean St', 'Technology';
go
select * from Clients where ClientID = 13;

--invalid insert
exec InsertClient 12, 'Bad Email Corp', 'Invalid User', 'bademail.com', '111-222-3333', '123 Fake St', 'Technology';
go
--invalid industry
exec InsertClient 13, 'Bad Industry Corp', 'Another User', 'user@industry.com', '222-333-4444', '987 Unknown St', 'UnknownIndustry';
go
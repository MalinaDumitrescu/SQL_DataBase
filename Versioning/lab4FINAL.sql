--A1

--Validare 1
create function ValidateEmailFormat (@Email nvarchar(255))
returns bit 
as 
begin 
    if @Email like '%@%.%' 
	     return 1;
    return 0;
end;
go
     
-- valid: user@example.com

-- Validare 2
create function ValidateIndustry (@Industry nvarchar(100))
returns bit 
as
begin
     declare @ValidateIndustry Table (Industry nvarchar(100));
	 insert into @ValidateIndustry (Industry)
	 values ('Technology'), ('Healthcare'), ('Finance'), ('Retail'), ('Manufacturing'), ('Education'), ('Energy'), ('Food'), ('Logistics'), ('Construction'), ('Environment'), ('Tourism');

	 if exists (select 1 from @ValidateIndustry where Industry = @Industry)
	    return 1;
     return 0;
end;
go


create procedure InsertClient @ClientID int,  @Name nvarchar(255), @Contact nvarchar(255), @Email nvarchar(255), @PhoneNumber nvarchar(255), @Address text, @Industry nvarchar(255)
as
begin
    if dbo.ValidateEmailFormat(@Email) = 0
	begin
	   print 'error: invalid email format';
	   return;
	end;

	if dbo.ValidateIndustry(@Industry) = 0
	begin
	    print 'error: invalid industry';
		return;
	end;

	begin try 
	    insert into Clients (ClientID, Name, Contact, Email, PhoneNumber, Address, Industry)
		values (@ClientID, @Name, @Contact, @Email, @PhoneNumber, @Address, @Industry);
        
		print 'Client successfully inserted';
	end try
	begin catch
	     print 'error: unable to insert client' + error_message();
	end catch;
end;
go


-- A2
-- view
-- returns info about emp working on the latest project from their assigned tasks, sepcifically 
-- on the ongoing projects => details about project, employee, and their associated team
create or alter view ActiveEmployeesWithProjects
as
with RankedProjects as(
    select  -- select with all the needed info 
        p.ProjectID,
        p.Name as ProjectName,
        e.EmployeeID,
        e.Name as EmployeeName,
        e.TeamID,
        t.Name as TeamName,
        p.Status as ProjectStatus,
		-- get most recent project an employee is working on, each emp gets their projects ranked independently
        row_number() over (partition by e.EmployeeID order by p.StartDate desc) as Rank
    from Employees e
	-- associate emp with team, tasks and project details only to ONGOING projects
    inner join Teams t on e.TeamID = t.TeamID 
    inner join Tasks ts on e.EmployeeID = ts.EmployeeID
    inner join Projects p on ts.ProjectID = p.ProjectID
    where p.Status = 'Ongoing'
)
select 
    ProjectID,
    ProjectName,
    EmployeeID,
    EmployeeName,
    TeamID,
    TeamName,
    ProjectStatus
from RankedProjects
where Rank = 1; -- only keep the latest project for each employee

go

-- function

create or alter function TotalPaymentsForProject(@ProjectID INT)
returns table -- with project and total payments
as
return(
        select
		      p.ProjectID,
			  sum(pm.amount) as totalPayments
		from Projects p 
	    inner join Contracts_Clients cc on p.ContractID = cc.ContractID -- link projects to contracts
	    inner join Payments pm on cc.ContractID = pm.ContractID -- get all payments related to a contract
		where p.ProjectID = @ProjectID
		group by p.ProjectID );
go      

-- combine---> emplN, teamN, ProjN, projStatus, totalPayments---> in case i want to make a statistic for rasing the salaries

select 
     aep.EmployeeName,
	 aep.TeamName,

     aep.ProjectName,
     aep.ProjectStatus,
     tp.TotalPayments
from ActiveEmployeesWithProjects aep
-- ij subq that calc all proj totalP  with aep
inner join(
     select 
	    p.ProjectID,
		sum(pm.Amount) as TotalPayments -- calc all proj cost
	 from Projects p
	 inner join Contracts_Clients cc on p.ContractID = cc.ContractID
	 inner join Payments pm on cc.ContractID = pm.ContractID
	 group by p.ProjectID
) tp on aep.ProjectID = tp.ProjectID;

go

select * from ActiveEmployeesWithProjects;
select * from TotalPaymentsForProject(3);


-- A3

create table LogTable(
     LogID int Identity(1,1) primary key,
	 EventDateTime datetime not null,
	 OperationType char(1) not null,
	 TableName varchar(50) not null,
	 AffectedRows int not null);

create or alter trigger triggerLogClients
on Clients
--trg activates after any ... in Client table
after insert, update, delete
as
begin
     declare @AffectedRows int;
	 -- update affets both inserted new val and deleted old val
	 if exists (select 1 from inserted) and exists (select 1 from deleted)
     begin 
	      set @AffectedRows = (select count(*) from inserted); -- count affected rows
		  insert into LogTable(EventDateTime, OperationType, TableName, AffectedRows)
		  values(getdate(), 'U', 'Clients', @AffectedRows);
	end -- insert affects only the inserted 
	else if exists(select 1 from inserted)
	begin 
	      set @AffectedRows = (select count(*) from inserted);
		  insert into LogTable(EventDateTime, OperationType, TableName, AffectedRows)
		  values(getdate(), 'I', 'Clients', @AffectedRows);
	end 
	else if exists(select 1 from deleted)
	begin
	      set @AffectedRows = (select count(*) from deleted);
		  insert into LogTable(EventDateTime, OperationType, TableName, AffectedRows)
		  values(getdate(), 'D', 'Clients', @AffectedRows);
	end
end;
go
	      
-- tests
insert into Clients  (ClientID, Name, Contact, Email, PhoneNumber, Address, Industry)
values (11, 'ABCDE Corp', 'Johnny Deep', 'johnny.deep@abcde.com', '0771545730', '123432070 Street', 'Technology');

update Clients
set Name = 'ABCDE Corporation'
where ClientID = 11;

delete from Clients
where ClientID = 11;

Select * from LogTable; 

--	A4
-- PROCEDURA
create or alter procedure AllocateResource
    @DistributionID int,
	@ResourceID int,
    @TeamID int,
    @ProjectID int,
    @DistributionDate date
as
begin
    insert into Resource_Distribution(DistributionID, ResourceID, TeamID, ProjectID, DistributionDate)
	values(@DistributionID, @ResourceID, @TeamID, @ProjectID, @DistributionDate);
end;

-- CURSOR
declare @ProjectID int, @TeamID int, @ResourceID int, @DistributionDate date, @NextID INT;

declare project_cursor cursor for
select p.ProjectID, t.TeamID
from Projects p
inner join Teams t on t.Specialization like '%General%'
where p.Status = 'Ongoing'

open project_cursor;

fetch next from project_cursor into @ProjectID, @TeamID;

while @@FETCH_STATUS = 0
begin 
    select top 1 @ResourceID = r.ResourceID
	from Resources r 
	where r.ProjectID is null -- resource must not already be allocated
	order by r.Cost desc;
	-- check if a resource is available for allocation
    IF @ResourceID IS NOT NULL
    BEGIN
        -- generate the next unique DistributionID
        SELECT @NextID = ISNULL(MAX(DistributionID), 0) + 1 FROM Resource_Distribution;
	
	    set @DistributionDate = GETDATE()
        EXEC AllocateResource @DistributionID = @NextID, @ResourceID = @ResourceID, @TeamID = @TeamID, @ProjectID = @ProjectID, @DistributionDate = @DistributionDate;
    END;
	--fetch the next row from the cursor into the variables
	fetch next from project_cursor into @ProjectID, @TeamID;
end;

close project_cursor;
deallocate project_cursor;

-- TESTS

select * from Resource_Distribution
where ResourceID = 2 AND TeamID = 2 AND ProjectID = 2;

-- Declare @NextID for the test script
DECLARE @NextID INT;

-- Generate the next unique DistributionID
SELECT @NextID = ISNULL(MAX(DistributionID), 0) + 1 FROM Resource_Distribution;

-- Execute the stored procedure
exec AllocateResource @DistributionID = @NextID, @ResourceID = 2, @TeamID = 2, @ProjectID = 2, @DistributionDate = '2024-12-09';

-- 1.1

create or alter function ValidateEmailFormat (@Email nvarchar(255))
returns bit 
as 
begin 
    if @Email like '%@%.%'  -- also allows only one @
	     return 1;
    return 0;
end;
go
     
-- valid: user@example.com 

-- 1.2
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

-- 1.3

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

-- 2.1
create view ProjectBudgetsByContract
as -- calculate the sum of all projects budgets linked to a specific contract
-- and gets total projects- the count of projects associated with each contract.
with BudgetSummary as (
    select c.ContractID, C.ClientID, sum(p.Budget) as TotalBudget, count(p.ProjectID) as TotalProjects
	from Contracts_Clients c
	inner join Projects p on c.ContractID = p.ContractID
	group by c.ContractID, C.ClientID)

select bs.ContractID, bs.ClientID, cl.Name as clientName, bs.TotalBudget, bs.TotalProjects
from BudgetSummary bs
inner join Clients cl on bs.ClientID = cl.ClientID;
go

-- 2.2  -- returns a table with emp, tasks details and a computed column TaskCount
        --that calculates the total number of tasks assigned to each employee using the PARTITION BY clause
create function GetTasksByEmployee ()
returns table
as
return 
with TaskCounts as(
     select e.EmployeeID, e.Name AS EmployeeName, t.TaskID, t.Name as TaskName, t.Status, count(t.TaskID) over (partition by t.EmployeeID) as TaskCount
	 from Employees e
	 inner join Tasks t on e.EmployeeID = t.EmployeeID
)

select EmployeeID, EmployeeName, TaskID, TaskName, Status, TaskCount
from TaskCounts;
go

-- 2.3
    --  combining the view and the TVF in a single query, we can extract a detailed, high-level report that connects projects, contracts, tasks, and employees
select pb.ContractID, pb.ClientName, pb.TotalBudget, t.EmployeeName, t.TaskName, t.Status, t.TaskCount
from ProjectBudgetsByContract pb
inner join Projects p on pb.ContractID = p.ContractID
inner join Tasks tRaw on p.ProjectID = tRaw.ProjectID
inner join dbo.GetTasksByEmployee() t on tRaw.TaskID = t.TaskID
where pb.ContractID = 1;

-- 3.1
create table StoredLogIns(
LogID int identity primary key, 
EventDateTime datetime default getdate(), -- when was the instruction executed
EventType char(1),  --type of instruction (I/U/D)
TableName nvarchar(255),
AffectedRows int);
go

-- 3.2
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

-- 4
create procedure AllocateResourceToProject
  @ProjectID int,
  @ResourceID int
as
begin
    set nocount on;

	if exists (select 1 from Resources where ResourceID = @ResourceID and Quantity > 0)
    begin 
      update Resources
      set Quantity = Quantity - 1
      where ResourceID = @ResourceID;

      insert into Resource_Distribution(DistributionDate, ResourceID, TeamID, ProjectID)
      values (getdate(), @ResourceID, null, @ProjectID);
      print 'Resource allocated successfully';
	end 
	else
	begin
	  print 'Resource not availabe';
	end
end;
go
--4.2
declare @ProjectID int;
declare @ResourceID int = 1;

declare ProjectCursor cursor for
select ProjectID
from Projects
where Status = 'In Progress';

open ProjectCursor;

fetch next from ProjectCursor into @ProjectID;

while @@FETCH_STATUS = 0
begin 
   exec AllocateResourceToProject @ProjectID, @ResourceID;
   fetch next from ProjectCursor into @ProjectID;
end;
close ProjectCursor;
deallocate ProjectCursor;
go
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
     
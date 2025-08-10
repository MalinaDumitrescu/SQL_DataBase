select pb.ContractID, pb.ClientName, pb.TotalBudget, t.EmployeeName, t.TaskName, t.Status, t.TaskCount
from ProjectBudgetsByContract pb
inner join Projects p on pb.ContractID = p.ContractID
inner join Tasks tRaw on p.ProjectID = tRaw.ProjectID
inner join dbo.GetTasksByEmployee() t on tRaw.TaskID = t.TaskID
where pb.ContractID = 1;


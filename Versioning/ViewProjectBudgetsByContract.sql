create view ProjectBudgetsByContract
as
with BudgetSummary as (
    select c.ContractID, C.ClientID, sum(p.Budget) as TotalBudget, count(p.ProjectID) as TotalProjects
	from Contracts_Clients c
	inner join Projects p on c.ContractID = p.ContractID
	group by c.ContractID, C.ClientID)

select bs.ContractID, bs.ClientID, cl.Name as clientName, bs.TotalBudget, bs.TotalProjects
from BudgetSummary bs
inner join Clients cl on bs.ClientID = cl.ClientID;
go
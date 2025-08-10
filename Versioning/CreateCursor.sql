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

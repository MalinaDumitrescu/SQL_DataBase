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
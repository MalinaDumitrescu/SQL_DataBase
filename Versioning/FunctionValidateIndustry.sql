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

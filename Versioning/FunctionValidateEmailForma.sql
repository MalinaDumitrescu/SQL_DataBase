create function ValidateEmailFormat (@Email nvarchar(255))
returns bit 
as 
begin 
    if @Email like '%@%.%' and charindex('@', @Email) = CHARINDEX('@', REVERSE(@Email))  -- also allows only one @
	     return 1;
    return 0;
end;
go
     
-- valid: user@example.com



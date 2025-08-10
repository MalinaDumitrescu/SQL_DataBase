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
	 

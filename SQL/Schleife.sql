use standard
go

-- Schleifen


declare @x int = 1;

while @x <= 20
begin 
	print cast(@x as varchar(5)) + ' . Durchlauf';
	set @x +=1;
end;




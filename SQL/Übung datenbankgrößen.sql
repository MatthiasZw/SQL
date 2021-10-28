
set nocount on;
declare @name varchar(50), @hk char(1) = char(39) ;
declare @sizelog table(dn char(100), sd int,sl int);
declare @sql varchar(max);


declare tab1 cursor for

select sys.databases.name from sys.databases ;  --join sys.databases_files on sys.databases.database_id = sys.database_files.    ;

open tab1;

fetch tab1 into @name;


while @@FETCH_STATUS = 0
	begin
		
		set @sql =  ('select '+ @hk + @name + @hk + ', (select sum(size) from ' + @name + '.sys.database_files where data_space_id = 0) as a , ' + '(select sum(size) from ' + @name + '.sys.database_files where data_space_id = 1) as b ');
		insert into @sizelog exec(@sql);
		fetch tab1 into @name;
		
	end
select * from @sizelog;
deallocate tab1;
set nocount off;
go

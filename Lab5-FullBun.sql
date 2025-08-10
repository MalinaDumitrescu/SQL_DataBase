--teil 1

create table Ta (
    idA int identity(1,1) primary key,
    a2 int unique
);

create table Tb (
    idB int identity(1,1) primary key ,
    b2 int,
    b3 int
);

create table Tc (
    idC int identity(1,1) primary key,
    idA int,
    idB int,
    foreign key (idA) references Ta(idA),
    foreign key (idB) references Tb(idB)
);


create or alter procedure InsertData
as
begin
    declare @counterA int = 1;
    declare @counterB int = 1;

    while @counterA <= 10000
    begin
        insert into Ta (a2) values (@counterA * 2);
        set @counterA = @counterA + 1;
    end;

    while @counterB <= 3000
    begin
        insert into Tb (b2, b3) values (@counterB * 3, @counterB * 5);
        set @counterB = @counterB + 1;
    end;

    declare @idA int, @idB int;

    set @counterA = 1;
    while @counterA <= 400
    begin
        set @idA = @counterA;
        set @counterB = 1;
        while @counterB <= 75
        begin
            set @idB = @counterB;
            insert into Tc (idA, idB) values (@idA, @idB);
            set @counterB = @counterB + 1;
        end;
        set @counterA = @counterA + 1;
    end;
end;
go

exec InsertData;
go


select count(*) from Ta;
select count(*) from Tb;
select count(*) from Tc;

select * from Tc
select * from Ta

--teil 2

-- A
-- index on Ta
sp_helpindex Ta; --> we automatically have an index cluster (by default) on idA because pk and a nonclustered one on a2 to enforce the uniqueness of the column

-- Clustered index scan (operatorion), clustered index is completely parsed b=in order to return the sorted data
--> idA has an index clustered
select * from Ta order by idA;
-- Clustered index seek (operatorion), parse in index s tree for finding idA=5000
--> idA has an index clustered
select * from Ta where idA = 5000;
-- Nonclustered index scan (operatorion), bc a2 has a nonclustered index and % needs values scanning
select a2 from Ta where a2 % 2 = 0;
-- Nonclustered index seek (operatorion), bc a2 has a nonclustered index and condition a2>8000 can be checked directly via index
select * from Ta where a2 > 8000;

-- B
alter table Ta add a3 int;
-- a key lookup occures when a nonc idx is used to find rows that meet the where condition (a2=600)
-- column a3 is not part of the nonc idx --> so we use the key lookup to retirve the value of a3 from the clustered index
select * from Ta
where a2 = 600;
-- basically we use the nonclustered index on a2 (nonclustered index seek)to efficiently locate rows where bla bla
-- retrieve the additional columns like a3 that are not part of the nonclustered index and key lookup navigates back (to nested loop) to fetch the column

-- C

select * from Tb where b2 = 2997;
create nonclustered index Tb_b2 on Tb(b2); -- idx stores the value of b2 in a sorted order + ptr s row loc
select * from Tb where b2 = 2997;

drop index Tb_b2 on Tb;


-- before idx --> tABLE sCAN(operator), performance: reads all rows, high I/O cost (reads every page), slow for big db
-- after idx --> Noncluster Index Scan (operator), performance: navigates directly to the relevant rows in the idx (faster),  reduces the number of pages read on a big scale, faster response time especially for big db s

-- D
-- rows where Tc.idA matches pk Ta.idA + where Ta.idA=20
-- without idx: --> we perform an clustered idx scan on Tc because there is no idx on idA column 
-- it will check all rows in Tc to find matches for the inner join 
select Tc.idC, Ta.a2, Ta.a3 from Tc
inner join Ta on Tc.idA = Ta.idA
where Ta.idA = 20;
-- kinda same like the first query
select Tc.idC, Tb.b2, Tb.b3 from Tc
inner join Tb on Tc.idB = Tb.idB
where Tb.idB = 75;
-- basically without the index we would have to scan all rows--> SLOOOW, with the index we will find rows
-- in Tc wherer idA or idB match the inner hoin condition ---> FAAAST

--BEFORE IDX-> On Tc Clustered Index Scan every row, Ta or Tb Pk Clustered Index Seek
--> High I/O and logical reads on Tc, long exec time 

--AFTER IDX-> reduced logical read on Tc because  the idx aloows direct lookups so  XXX no scanning all table XXX
--Lower estimated subtree cost 
create nonclustered index Tc_idA on Tc(idA);
create nonclustered index Tc_idB on Tc(idB);

drop index TC_idA on Tc;
drop index TC_idB on Tc;
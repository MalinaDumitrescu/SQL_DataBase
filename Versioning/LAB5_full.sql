-- Teil 1

create table Ta(
     idA int identity(1, 1) primary key,
	 a2 int unique,
	 a3 int
);

create table Tb(
     idB int identity(1, 1) primary key,
	 b2 int,
	 b3 int
);

create table Tc(
     idC int identity(1, 1) primary key,
	 idA int,
	 idB int
	 foreign key (idA) references Ta(idA),
	 foreign key (idB) references Tb(idB)
);

create or alter procedure IntroduceData
as 
begin
     declare @counterA INT = 1;
	 declare @counterB INT = 1;
	 declare @idA INT, @idB INT; 

	 -- 10.000 tuples in Ta
    while @counterA <= 10000
    begin
        insert into Ta (a2, a3) 
        values (@counterA * 2, @counterA * 3);
        set @counterA = @counterA + 1;
    end;

    -- 3.000 tuples in Tb
    while @counterB <= 3000
    begin
        insert into Tb (b2, b3) 
        values (@counterB * 3, @counterB * 5);
        set @counterB = @counterB + 1;
    end;

    -- 30.000 tuples in Tc
    set @counterA = 1; -- Resetare variabilă
    while @counterA <= 30000
    begin
        set @idA = @counterA % 10000 + 1;
        set @idB = @counterA % 3000 + 1;
        insert into Tc (idA, idB) VALUES (@idA, @idB);
        set @counterA = @counterA + 1;
    end;
end;
go

exec IntroduceData;
go

select count(*) from Ta;
select count(*) from Tb;
select count(*) from Tc;

-- Teil 2 
-- a.

-- check existence of index in Ta
exec sp_helpindex 'Ta';

-- clustered index scan
select * 
from Ta 
where a3 > 5000;

-- clustered index seek
select * 
from Ta 
where idA = 1000;

-- nonclustered index scan
select a2 
from Ta 
where a2 between 100 and 1000;

-- nonclustered index seek
select a2 
from Ta 
where a2 = 200;

-- b.

-- add index nonclustered pe a2
create nonclustered index idx_Ta_a2 on Ta(a2);

-- Interogare cu WHERE pe a2
select a3 
from Ta 
where a2 = 200;

-- c.

-- Interogare fără index pe Tb
select * 
from Tb 
where b2 = 100;

-- Creare index nonclustered pe b2
create nonclustered index idx_Tb_b2 on Tb(b2);

-- Interogare cu index pe Tb
select * 
from Tb 
where b2 = 100;

-- Eliminare index pentru refolosire
drop index idx_Tb_b2 on Tb;


-- d.

-- INNER JOIN între Tc și Ta
select Tc.idC, Ta.a2, Ta.a3 
from Tc 
inner join Ta on Tc.idA = Ta.idA
where Ta.idA = 500;

-- INNER JOIN între Tc și Tb
select Tc.idC, Tb.b2, Tb.b3 
from Tc 
inner join Tb on Tc.idB = Tb.idB
where Tb.idB = 200;

-- Creare index pe cheile externe din Tc
create nonclustered index idx_Tc_idA on Tc(idA);
create nonclustered index idx_Tc_idB on Tc(idB);

-- Re-executare JOIN pentru analiză
select Tc.idC, Ta.a2, Ta.a3 
from Tc 
inner join Ta on Tc.idA = Ta.idA
where Ta.idA = 500;

select Tc.idC, Tb.b2, Tb.b3 
from Tc 
inner join Tb on Tc.idB = Tb.idB
where Tb.idB = 200;

-- Eliminare index pentru curățare
drop index idx_Tc_idA on Tc;
drop index idx_Tc_idB on Tc;

Use WorldEvents
go

Select * from tblEvent where EventID in (1,2,3,5,12,13)

Select * from tblEvent where CountryID=7


delete from tblEvent where EventID in (58,61,63)
begin tran a
delete from tblEvent where EventID in (1,2,3)

commit tran a;

Alter TRIGGER dbo.Event_Uk
   ON  dbo.tblEvent 
   Instead of Delete
AS 
BEGIN
	SET NOCOUNT ON;
	Declare @CountryID int;
	Declare @EventID int;
	-- if country is not UK (7), allow deletion
	Declare co cursor  for select CountryID,EventID from deleted

	open co
		FETCH next from co into @CountryID,@EventID

		while @@FETCH_STATUS=0
			begin

				IF @CountryID <> 7

					BEGIN

					DELETE FROM tblEvent WHERE EventId = @EventId

					END

				fetch next from co into @CountryID,@EventID

			end

	close co;
	deallocate co;
 

END
GO


use DoctorWho
go

select CHARINDEX(EpisodeType,'a',0) from tblEpisode


Declare @var varchar(500)
select @var=[50th anniversary specia]+','+[Autumn special]+','+[Christmas special]+','+[Easter special]+','+
[Normal episode]  from 
(
	select * from 
		(select distinct EpisodeType, LEFT(EpisodeType,CHARINDEX(' ',EpisodeType,1)-1) firstcolumn from tblEpisode)
		as tbl
) as t pivot (max(firstcolumn) for EpisodeType in ([50th anniversary specia],[Autumn special],[Christmas special],[Easter special],
[Normal episode])--(select distinct EpisodeType from tblEpisode) 
) as a;
print @var



			select STUFF((SELECT distinct ',' + QUOTENAME(c.EpisodeType) 
            FROM tblEpisode c
            FOR XML PATH('')).value('.', 'NVARCHAR(MAX)'),1,1,'') 

SElect STUFF((SELECT distinct ',' + QUOTENAME(c.EpisodeType) 
            FROM tblEpisode c
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')
		,[50th anniversary specia],[Autumn special],[Christmas special],[Easter special],[Normal episode]
		,[50th anniversary specia],[Autumn special],[Christmas special],[Easter special],[Normal episode]

select ep.DoctorId,LEFT(EpisodeType,CHARINDEX(' ',EpisodeType,1)-1) firstcolumn,DoctorName from tblEpisode ep join tblDoctor doc
on ep.DoctorId=doc.DoctorId

use DoctorWho
go
select count(*) total,LEFT(EpisodeType,CHARINDEX(' ',EpisodeType,1)-1) firstcolumn,DoctorName from tblEpisode ep join tblDoctor doc
on ep.DoctorId=doc.DoctorId
group by LEFT(EpisodeType,CHARINDEX(' ',EpisodeType,1)-1),DoctorName


Declare @var varchar(500)
select @var=[50th anniversary specia]+','+[Autumn special]+','+[Christmas special]+','+[Easter special]+','+
[Normal episode]  from 
(
	select * from 
		(select distinct EpisodeType, LEFT(EpisodeType,CHARINDEX(' ',EpisodeType,1)-1) firstcolumn from tblEpisode)
		as tbl
) as t pivot (max(firstcolumn) for EpisodeType in ([50th anniversary specia],[Autumn special],[Christmas special],[Easter special],
[Normal episode])--(select distinct EpisodeType from tblEpisode) 
) as a;
print @var


select * from 
(select ep.DoctorId,LEFT(EpisodeType,CHARINDEX(' ',EpisodeType,1)-1) firstcolumn,DoctorName from tblEpisode ep join tblDoctor doc
on ep.DoctorId=doc.DoctorId) as tbl
pivot(
count(DoctorID) for firstcolumn in ([50th],Autumn,Christmas,Easter,Normal)
)
as final

Declare @Col NVARCHAR(MAX)
Declare @Query NVARCHAR(MAX)
select @Col=STUFF((SELECT distinct ',' + QUOTENAME(c.EpisodeType) 
            FROM tblEpisode c
            FOR XML PATH(''), TYPE
			).value('.','NVARCHAR(MAX)')
			,1,1,'')
print @Col

	  SET @Query='select *  from 
(
	select * from 
		(select distinct EpisodeType, LEFT(EpisodeType,CHARINDEX('''+ ' ' +''',EpisodeType,1)-1) firstcolumn from tblEpisode)
		as tbl
) as t pivot (max(firstcolumn) for EpisodeType in ('+@Col+')
) as a'

print @Query
execute(@Query)




DECLARE @ColumnList varchar(max) = ''

-- accumulate the episode types
SELECT 
	@ColumnList += 
		CASE
			WHEN LEN(@ColumnList) = 0 THEN ''
			ELSE ','
		END + QUOTENAME(LEFT(e.EpisodeType,CHARINDEX(' ',e.EpisodeType,1)-1))
FROM
	tblEpisode AS e
GROUP BY
	e.EpisodeType
ORDER BY
	e.EpisodeType

	Select @ColumnList

Declare @firstCOl NVARCHAR(MAX)
Declare @finalQuery NVARCHAR(MAX)
select @firstCOl=STUFF((select distinct ','+QUOTENAME(LEFT(EpisodeType,CHARINDEX(' ',EpisodeType,1)-1)) firstcolumn from tblEpisode ep join tblDoctor doc
on ep.DoctorId=doc.DoctorId
for XML PATH(''),TYPE).value('.','NVARCHAR(MAX)'),1,1,'')
print @firstCOl
SET @finalQuery='select * from 
(select ep.DoctorId,LEFT(EpisodeType,CHARINDEX('''+' '+ ''',EpisodeType,1)-1) firstcolumn,DoctorName from tblEpisode ep join tblDoctor doc
on ep.DoctorId=doc.DoctorId) as tbl
pivot(
count(DoctorID) for firstcolumn in ('+@firstCOl+')
)
as final'
print @finalQuery
execute(@finalQuery) 


declare @Episode NVARCHAR(MAX)
DECLARE @pivotQuery NVARCHAR(MAX)
DECLARE @pivotQuery1 NVARCHAR(MAX)
declare @blank  NVARCHAR(MAX)
SELECT @Episode=STUFF((select distinct ','+QUOTENAME(EpisodeType) from tblEpisode for XML PATH(''),TYPE).value('.','NVARCHAR(MAX)'),1,1,'')
print @Episode
set @pivotQuery='select * from (
Select distinct EpisodeType,LEFT(EpisodeType,CHARINDEX('''+' ' +''',EpisodeType,1)-1) colm from tblEpisode
) as a 
pivot (max(colm) for EpisodeType In ('+@Episode+')) as pivottable'
--print @pivotQuery
--execute(@pivotQuery)

SET @pivotQuery1='Select '+REPLACE(@Episode,',','+'+''','''+'+') +' from (
Select distinct EpisodeType,LEFT(EpisodeType,CHARINDEX('''+' ' +''',EpisodeType,1)-1) colm from tblEpisode
) as a 
pivot (max(colm) for EpisodeType In ('+@Episode+')) as pivottable'
print @pivotQuery1
execute(@pivotQuery1)

use WorldEvents
go

DECLARE @COlumnlist NVARCHAR(MAX)
set @COlumnlist=''
Select @COlumnlist += CASE WHEN @COlumnlist='' then '' else ',' end + QUOTENAME(EventName,'''') from tblEvent
group by EventName
select @COlumnlist

DECLARE @COlumnlist NVARCHAR(MAX),@COlumnlistF NVARCHAR(MAX)
set @COlumnlist=''
Select @COlumnlist= @COlumnlist+QUOTENAME(EventName,'''')+',' from tblEvent
where Year(EventDate) between 1980 and 1989
group by EventName
select @COlumnlistF=LEFT(@COlumnlist,LEN(@COlumnlist)-1)
print @COlumnlistF

execute('select * from tblEvent where EventName in ('+@COlumnlistF+')')

SELECT value from STRING_SPLIT('OWL','')
select substring(a.col, v.number+1, 1) 
from (select 'Owl' col) a
join master..spt_values v on v.number < len(a.col)
where v.type = 'P'


select SUBSTRING(a.col,v.number+1,1),v.number from 
	(Select 'Owl' as col) a 
		join 
	master..spt_values v on v.number<len(a.col) 
where type = 'P' and number<3
order by number

--create table #temp(ch varchar(10))
IF OBJECT_ID(N'tempdb..#temp') is not null 
begin
Drop table #temp
end
go
select EventName,EventDetails,EventDate,CountryID,CategoryID into #temp from tblEvent where 1=2
declare @length int , @i int,@fil varchar(max)
declare @query nvarchar(max)
select @length=len('OWL')
set @i=1
set @query=''
while (@i<=@length)
begin
--insert into #temp values(SUBSTRING('OWL',@i,1))
SET @query+= 'Upper(EventDetails) not like '+''''+'%'+ SUBSTRING('OWL',@i,1) +'%'+'''' + case when
@i<@length then ' and ' else '' end 
--select SUBSTRING('OWL',@i,1)
SET @i=@i+1;
end
SET @query='insert into #temp SELECT EventName,EventDetails,EventDate,CountryID,CategoryID from tblEvent where '+@query 
execute(@query)
;with cte as(
select * from #temp
),cnEvent as 
(select distinct te.EventName,te.EventDetails,te.EventDate,te.CountryID,te.CategoryID 
from #temp t join tblEvent te on t.CountryID=te.CountryID),
eventList as (
select distinct te.EventName,te.EventDetails,te.EventDate,te.CountryID,te.CategoryID 
from --cnEvent t 
--join 
tblEvent te where te.CategoryID in (Select distinct CategoryID from cnEvent) 
--and te.CountryID in (Select distinct CountryID from cnEvent)
--on t.CategoryID=te.CategoryID
)
select * from eventList

Use Carnival
go

select * from tblMenu


;with cte as (select m.MenuId,m.MenuName,m.ParentMenuId,ISNULL(m2.MenuName,'TOP') as ParentMenu from tblMenu m left join tblMenu m2 on m.ParentMenuId=m2.MenuId 
--where m.MenuId in (1,2,7) 
)
--select * from cte
,cte1 as (select c.MenuId,c.MenuName,
c.ParentMenuId,CAST(c.ParentMenu as VARCHAR(MAX)) as ParentMenu
--CAST(Isnull(m.MenuName,'TOP') as VARCHAR(MAX)) as parentMenu 
from cte c 
--left join tblMenu m 
--on c.ParentMenuId=m.MenuId 
union all
select ct.MenuId,ct.MenuName,
ct2.ParentMenuId,
CAST(ct2.parentMenu+'>'+ct.parentMenu AS VARCHAR(MAX)) as parentMenu from cte1 ct join cte ct2 on ct.ParentMenuId=ct2.MenuId
)
select MenuId,MenuName,ParentMenu from cte1 where ParentMenuId is NULL
order by MenuID

Use WorldEvents
go
with topcn as (Select TOP 3 co.CountryID,co.CountryName,count(ev.EventID) as [No of Events] 
from [dbo].[tblCountry] co join [dbo].[tblEvent] ev on co.CountryID=ev.CountryID
group by co.CountryID,co.CountryName
order by 3 desc),
topct as (
Select TOP 3 co.CategoryID,co.CategoryName,count(ev.EventID) as [No of Events] 
from [dbo].tblCategory co join [dbo].[tblEvent] ev on co.CategoryID=ev.CategoryID
group by co.CategoryID,co.CategoryName
order by 3 desc),
ctco as (
select CountryID,CategoryID,CountryName,CategoryName from topcn cross join topct)
select c.CountryName,c.CategoryName,count(te.EventId) from tblEvent te join ctco c
on te.CategoryID=c.CategoryID and te.CountryID=c.CountryID
group by c.CountryName,c.CategoryName

use DoctorWho
go

select te.*,td.DoctorName from [dbo].[tblEpisode] te join tblDoctor td on te.DoctorId=td.DoctorId
where td.DoctorName='David Tennant'

select te.*,td.DoctorName,ten.EnemyName,ten.EnemyId from [dbo].[tblEpisode] te 
join tblDoctor td on te.DoctorId=td.DoctorId
join  tblEpisodeEnemy tee on tee.EpisodeId=te.EpisodeId
join tblEnemy ten on ten.EnemyId=tee.EnemyId 
where td.DoctorName<>'David Tennant'
order by 1

with nondaviden as (
select distinct ten.EnemyId from [dbo].[tblEpisode] te 
join tblDoctor td on te.DoctorId=td.DoctorId
join  tblEpisodeEnemy tee on tee.EpisodeId=te.EpisodeId
join tblEnemy ten on ten.EnemyId=tee.EnemyId 
where td.DoctorName<>'David Tennant'
--order by 1
)
,davidepisode as (
select te.*,td.DoctorName,ten.EnemyName,ten.EnemyId from [dbo].[tblEpisode] te join tblDoctor td on te.DoctorId=td.DoctorId
join  tblEpisodeEnemy tee on tee.EpisodeId=te.EpisodeId
join tblEnemy ten on ten.EnemyId=tee.EnemyId 
where td.DoctorName='David Tennant'
--order by 1
)
--select distinct * from davidepisode
select distinct EpisodeId,Title from davidepisode where 
episodeid not in (select distinct de.EpisodeId from davidepisode de join nondaviden nde on de.EnemyId=nde.EnemyId)

use WorldEvents
go

;with a as (Select distinct co.CountryName,ct.CategoryName,ct.CategoryID,co.CountryID from [dbo].[tblCountry] co join tblevent ev on
co.CountryID=ev.CountryID
join tblCategory ct on ev.CategoryID=ct.CategoryID
WHere CountryName like 'Space%'),
b as (
select te.*,tc.CountryName from tblevent te join tblCountry tc on te.CountryID=tc.CountryID 
where te.CountryID not in (select distinct CountryID from a)
and CategoryID in (select distinct CategoryID from a)
) select distinct CountryName  from b

Use DoctorWho
go

select * from tblEpisode
select dbo.fnCompanions(1)
select dbo.fnEnemies(1)

sp_helptext 'dbo.fnCompanions'

Alter function dbo.fnSilly (@appearant1 varchar(max),@appearant2 varchar(max))
Returns @table TABLE(SeriesID int , EpisodeID int, Title varchar(max),Doctor varchar(max),Author varchar(max),Appearing varchar(max)) 
as 
BEGIN
--Declare @appearant1 varchar(max),@appearant2 varchar(max)
--set @appearant1='wilf'
--Set @appearant2='Ood'
--Declare @table TABLE(SeriesID int , EpisodeID int, Title varchar(max),Doctor varchar(max),Author varchar(max),Appearing varchar(max)) 

insert into @table
select distinct te.SeriesNumber,te.EpisodeNumber,te.Title,td.DoctorName,ta.AuthorName,dbo.fnCompanions(te.EpisodeId) from tblEpisode te join tblEpisodeCompanion tec on 
tec.EpisodeId=te.EpisodeId 
join tblCompanion tc on tc.CompanionId=tec.CompanionId
join tblDoctor td on td.DoctorId=te.DoctorId
join tblAuthor ta on te.AuthorId=ta.AuthorId
where tc.CompanionName like '%'+@appearant1+'%' -- or tc.CompanionName like '%'+@appearant2+'%'

insert into @table
select distinct te.SeriesNumber,te.EpisodeNumber,te.Title,td.DoctorName,ta.AuthorName,dbo.fnEnemies(te.EpisodeId) 
from tblEpisode te join tblEpisodeEnemy tec on 
tec.EpisodeId=te.EpisodeId 
join tblEnemy tc on tc.EnemyId=tec.EnemyId
join tblDoctor td on td.DoctorId=te.DoctorId
join tblAuthor ta on te.AuthorId=ta.AuthorId
where tc.EnemyName like '%'+@appearant2+'%' --or tc.EnemyName like '%'+@appearant2+'%'

return

end

select * from dbo.fnSilly('wilf','Ood')
--SELECT * FROM dbo.fnSilly('river','great intelligence')

-- show episodes featuring either Wilfred Mott or The Ood
SELECT * FROM dbo.fnSilly('wilf','ood')

Use WorldEvents
go

declare @var int ,@printstatement NVARCHAR(MAX),@commaEvents NVARCHAR(MAX)
set @var=1;
set @printstatement=''
While @var<=12
begin
SELECT @commaEvents=STUFF((select ','+EventNAme from tblEvent te where MONTH(te.EventDate)=@var 
for XML PATH (''),TYPE).value('.','NVARCHAR(MAX)'),1,1,'')
--print cast(@var as varchar(max))+ ' ' + @commaEvents
set @printstatement = @printstatement + 
case when @var=1 then '' else (CHAR(10)) end +
'Events which occured in '+ DATENAME(MM, '2017-' + CAST(@var AS VARCHAR(2)) + '-01')+': '+@commaEvents 
--print DATENAME(MM, '2017-' + CAST(@var AS VARCHAR(2)) + '-01')
print @printstatement
set @printstatement=''
set @var=@var+1;
--print @printstatement +'Shivi'
end


Create procedure contName
(@variable varchar(max) OUTPUT)
as
begin
select top 1 @variable= tcc.ContinentName from tblEvent te join tblCountry tc on te.CountryID=tc.CountryID
join tblContinent tcc on tc.ContinentID=tcc.ContinentID
where te.EventDate=(Select min(EventDate) from tblEvent)
end



create procedure ContEvents(@con varchar(max))
as
begin
select distinct te.EventName,te.EventDate,@con from tblEvent te join tblCountry tc on te.CountryID=tc.CountryID
join tblContinent tcc on tc.ContinentID=tcc.ContinentID
where tcc.ContinentName=@con
end 

DECLARE @Variableo VARCHAR(100) = ''

EXEC contName @variable = @Variableo OUTPUT
print @Variableo
exec ContEvents @variableo

select CountryID from (
select top 30 CountryID  from tblCountry tc
order by ROW_NUMBER() Over(order by CountryName desc) asc
) a

select * from tblEvent te where te.CountryID not in 
(select top 30 CountryID  from tblCountry tc
order by ROW_NUMBER() Over(order by CountryName desc) asc)
and te.CategoryID not in (
select top 15 CategoryID  from tblCategory tc
order by ROW_NUMBER() Over(order by CategoryName desc) asc
)

use DoctorWho
go
create view vwEpisodeCompanion as

select distinct e.EpisodeID,e.Title from tblEpisode e join tblEpisodeCompanion tc on e.EpisodeID=tc.EpisodeID
join tblCompanion c on tc.CompanionID=c.CompanionID
group by e.EpisodeID,e.Title
having count(distinct tc.CompanionID)=1

create view vwEpisodeEnemy as
select distinct e.EpisodeID,e.Title from tblEpisode e join tblEpisodeEnemy tc on e.EpisodeID=tc.EpisodeID
join tblEnemy c on tc.EnemyID=c.EnemyID
group by e.EpisodeID,e.Title
having count(distinct tc.EnemyID)=1

create view vwEpisodeSummary as 

select EpisodeID,Title from tblEpisode where EpisodeID not in (select distinct EpisodeID from vwEpisodeCompanion)
and EpisodeID not in (select distinct EpisodeID from vwEpisodeEnemy)

select * from vwEpisodeCompanion
select * from vwEpisodeEnemy
select * from vwEpisodeSummary order by 2

select * from tblEpisode where Title like '%Dalek%'
select * from tblEnemy where EnemyName like '%Dalesks%'
select * from tblEpisode where Year(EpisodeDAte)=2005

select Year(e.EpisodeDate) [Episode Year],c.EnemyName,count(distinct e.EpisodeID) [No of Episode] 
from tblEpisode e join tblEpisodeEnemy tc on e.EpisodeID=tc.EpisodeID
join tblEnemy c on tc.EnemyID=c.EnemyID
join tblDoctor td on e.DoctorID=td.DoctorID and year(td.BirthDate)<1970
group by Year(e.EpisodeDate),c.EnemyName
having count(distinct e.EpisodeID)>1
order by 1

use WorldEvents
go

select Count(te.EventID) NoOfEvents,Ceiling(Avg(Len(te.EventName))) EventNameLength,Left(tc.CategoryName,1) CategoryInitial 
from tblEvent te join tblCategory tc on te.CategoryID=tc.CategoryID
group by Left(tc.CategoryName,1)

Select Left(year(EventDate),2)+case when CAST(SUBSTRING(CAST(year(EventDate) AS VARCHAR(2)),2,1) AS INT)=1 then 'st'
		when CAST(SUBSTRING(CAST(year(EventDate) AS VARCHAR(2)),2,1) AS INT)=2 then 'nd'
		when CAST(SUBSTRING(CAST(year(EventDate) AS VARCHAR(2)),2,1) AS INT)=3 then 'rd'
		else 'th' end +' Century',count(EventID) from tblEvent te
group by SUBSTRING(CAST(year(EventDate) AS VARCHAR(2)),2,1),Left(year(EventDate),2)

Select COALESCE( CAST(Left(year(EventDate),2)-1 AS VARCHAR(10))
+case when CAST(SUBSTRING(CAST(year(EventDate) AS VARCHAR(2)),2,1) AS INT)-1=1 then 'st'
		when CAST(SUBSTRING(CAST(year(EventDate) AS VARCHAR(2)),2,1) AS INT)-1=2 then 'nd'
		when CAST(SUBSTRING(CAST(year(EventDate) AS VARCHAR(2)),2,1) AS INT)-1=3 then 'rd'
		else 'th' end 
+' Century',null,'..All Centuries') As Century
		,count(EventID) from tblEvent te
group by  CUBE(Left(year(EventDate),2)),SUBSTRING(CAST(year(EventDate) AS VARCHAR(2)),2,1)


select * from tblFamily
;with cte as (
select f1.FamilyName,f1.FamilyID,--f2.familyID as PFamID,
f2.ParentFamilyId,
coalesce(cast(f2.FamilyName+'>'+f1.FamilyName as varchar(max)),null,cast(f1.FamilyName as varchar(max)))as [full family Name] from
tblFamily f1 left join tblFamily f2 on f1.ParentFamilyID=f2.FamilyID
union all 
select c.FamilyName,c.FamilyID,--f.FamilyID,
f.ParentFamilyId,
coalesce(cast(f.FamilyName+'>'+c.[full family Name] as varchar(max)) ,null,
cast(f.FamilyName as varchar(max)))
from cte c join tblFamily f on c.ParentFamilyId=f.FamilyID

)
select FamilyID,FamilyName,[full family Name] from cte 
where ParentFamilyId is null
order by 1
option (maxrecursion 0)



select f1.FamilyName--,f1.FamilyID,--f2.familyID as PFamID,
--f2.ParentFamilyId,
--coalesce(cast(f2.FamilyName+'>'+f1.FamilyName as varchar(max)),null,cast(f1.FamilyName as varchar(max)))as [full family Name] 
,coalesce(cast(f3.FamilyName+'>'+f2.FamilyName+'>'+f1.familyName as varchar(max)),null,cast(f1.FamilyName as varchar(max)))
as [Family Path] 
from
tblFamily f1 left join tblFamily f2 
on f1.ParentFamilyID=f2.FamilyID
left join tblFamily f3
on f2.ParentFamilyID=f3.FamilyID


select EventName,DateName(Weekday,EventDate) +' ' + Cast(DATEPART(d,EventDate) as varchar(2)) 
--,Right(DATEPART(d,EventDate),1)
+case when CAST(DATEPART(d,EventDate) AS INT) in (1,21,31) then 'st'
		when CAST(DATEPART(d,EventDate) AS INT) in (2,22) then 'nd'
		when CAST(DATEPART(d,EventDate) AS INT) in (3,23) then 'rd'
		else 'th' end +' ' + Cast(DateName(MONTH,EventDate) as varchar(50)) +' '+Cast(Year(EventDate) as varchar(4)) as date
from tblEvent


select Country,kmsquared,kmsquared/20761 walesunit ,kmsquared%20761	 ArealeftOver,
Case when kmsquared<20761 then 'Smaller than Wales' else cast(kmsquared/20761 as Varchar(100)) + 'X Wales Unit plus '+
cast(kmsquared%20761 as varchar(100))+' sq. km.' end
as WalesComparison
from CountriesByArea 
--where Country like '%Wales%'
order by ABS(kmsquared-20761) asc


create table Student
( Roll_No int , 
Name varchar(50), 
Gender varchar(30), 
Mob_No bigint );

insert into Student
values (4, 'ankita', 'female', 9876543210 );

insert into Student 
values (3, 'anita', 'female', 9675432890 );

insert into Student 
values (5, 'mahima', 'female', 8976453201 ); 
insert into Student 
values (5, 'mahima', 'female', 8976453202 ); 
insert into Student 
values (5, 'mahima', 'female', 8976453203 ); 
insert into Student 
values (5, 'mahima', 'female', 8976453203 ); 

select * from Student
order by 1
;with cte as (
select *,ROW_NUMBER() Over(Partition by Roll_No,Name,Mob_No order by Roll_No desc) as rownum,
DENSE_RANK() Over(order by Mob_No asc) as dense,RANK() Over(Order by Mob_no asc ) as [rank]  from Student
)
select * from cte where rownum>1

;with cte as (
select *,ROW_NUMBER() Over(Partition by StudentName order by Marks asc) as rownum,
DENSE_RANK() Over(order by Marks asc) as dense,RANK() Over(Order by Marks asc ) as [rank] , NTILE(2) Over (order by Marks) as groupno from ExamResult
)
select * from cte order by Marks,groupno

;with cte as (
Select distinct StudentName,SUm(Marks) Over (Partition by StudentName) totalMarks  from ExamResult
)
Select *,NTILE(3) over(order by totalMarks desc) from cte

;with cte as (
select *,ROW_NUMBER() Over(Partition by StudentName order by Marks asc) as rownum,
DENSE_RANK() Over(order by Marks asc) as dense,RANK() Over(Order by Marks asc ) as [rank]  from ExamResult
)
select * from cte c where Rownum=(select max(rownum) from cte c1 where c1.StudentName= c.StudentName)
order by 3

select * from ExamResult

CREATE TABLE ExamResult
(StudentName VARCHAR(70), 
 Subject     VARCHAR(20), 
 Marks       INT
);
INSERT INTO ExamResult
VALUES
('Shivi', 
 'Maths', 
 30
);
INSERT INTO ExamResult
VALUES
('Shivi', 
 'Science', 
 50
);
INSERT INTO ExamResult
VALUES
('Shivi', 
 'english', 
 80
);
INSERT INTO ExamResult
VALUES
('Samagra', 
 'Maths', 
 100
);
INSERT INTO ExamResult
VALUES
('Samagra', 
 'Science', 
 100
);
INSERT INTO ExamResult
VALUES
('Samagra', 
 'english', 
 100
);
INSERT INTO ExamResult
VALUES
('Anveshi', 
 'Maths', 
 100
);
INSERT INTO ExamResult
VALUES
('Anveshi', 
 'Science', 
 60
);
INSERT INTO ExamResult
VALUES
('Anveshi', 
 'english', 
 90
);


select  * from   [dbo].[SSIS Configurations] LIMIT 1

use SSISHandson
go
Alter table [dbo].[SSIS Configurations] 
Alter column ConfiguredValueType int

Update [dbo].[SSIS Configurations]
set ConfiguredValueType=1

SELECT * FROM sys.fn_helpcollations() 
where name like '%Chi%UTF%' 
collate Chinese_Hong_Kong_Stroke_90_CS_AI_WS_SC_UTF8

SELECT * FROM sys.fn_helpcollations() 
ORDER BY name COLLATE SQL_Latin1_General_CP1_CI_AS; 

create table dbo.#temp1(col1 varchar(50))

create table dbo.#temp2(col1 varchar(50))

insert into dbo.#temp1 values(Null)
insert into dbo.#temp2 values(Null)
insert into dbo.#temp1 values(1)
insert into dbo.#temp2 values(1)

select * from dbo.#temp1 t1 order by 1 desc, NULL FIRST

full outer join dbo.#temp2 t2 on t1.col1=t2.col1

null is treated forst 


create function test_error() returns int as 
begin
declare @i int
set @i=0
begin try
if @i=0 
print 'inside try'
end try
begin catch 
print 'in catch'
end catch

return @i
end


Create view [SSIS Configurations View] as 
select * into testview from [SSIS Configurations]

select * from [SSIS Configurations View] --.0032842

select * from [SSISHandson].dbo.testview

create view [SSIS Configurations MView] with schemabinding as
select ss.ConfigurationFilter,ss.ConfiguredValue from  dbo.testview ss join dbo.testview st
on ss.ConfigurationFilter=st.ConfigurationFilter

select * from [SSIS Configurations MView]

drop view  [SSIS Configurations MView]
Create Unique clustered index index_mv on [SSIS Configurations MView](ConfigurationFilter)


use WorldEvents
go

Alter view view_test as 
select Count(te.EventID) NoOfEvents,Ceiling(Avg(Len(te.EventName))) EventNameLength,Left(tc.CategoryName,1) CategoryInitial 
from tblEvent te join tblCategory tc on te.CategoryID=tc.CategoryID
group by Left(tc.CategoryName,1)

Alter view Mview_test with schemabinding as 
select --tc.CategoryID,sum(len(te.EventName)) leng
Count_big(distinct te.EventID) NoOfEvents,Ceiling(SUM(Len(te.EventName))) EventNameLength,Left(tc.CategoryName,1) CategoryInitial 
from dbo.tblEvent te join dbo.tblCategory tc on te.CategoryID=tc.CategoryID
group by Left(tc.CategoryName,1)

select * from view_test --.0452284
select * from Mview_test --.045228

CReate unique clustered index MV_index on Mview_test(CategoryInitial)

select distinct event from [SSISHandson].[dbo].[sysssislog]

Create Table PrevNull (
SeqID int not null,
ID int null,
Name Char(10)
)

insert into PrevNull values (1,10,'ABC')
insert into PrevNull values (2,NUll,'ABC')
insert into PrevNull values (3,20,'ABC')
insert into PrevNull values (4,NUll,'ABC')
insert into PrevNull values (5,NUll,'ABC')
insert into PrevNull values (6,30,'ABC')
insert into PrevNull values (7,NUll,'ABC')

select * from PrevNull

;With cte as (
Select SeqID,Name,ID,SUM(case when ID is null then 0 else 1 end) Over(order by SeqID) as id1,
SUM(case when ID is null then 0 else 1 end) Over() as id2
--case when ID is null then 0 else 1 end 
from PrevNull
)
Select SeqID,Name,ID,FIRST_VALUE(ID) over (partition by id1 order by seqid) from cte



USE [Movies]
GO

/****** Object:  Table [dbo].[Film]    Script Date: 21-07-2021 18:26:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

with cte as (
Select Title,FilmID,ROW_NUMBER() Over (Partition by Title order by FilmID) id2 from [FilmIndex]
)
delete from cte where id2>1


Insert into [FilmIndex]

Select  * from dbo.Film where --FilmID=1147 and 
Title='The Adventures of Sherlock Holmes'
--group by Title
--having count(*)>1
Select * from [FilmIndex] where --FilmID=q236667 and 
Title='3:10 to Yuma'--'The Adventures of Sherlock Holmes'

Create Nonclustered index IX_Film_Title on Film (Title)
Create  clustered index IX_Film_Title on [FilmIndex] (Title)

drop index IX_Film_Title on [FilmIndex]
CREATE TABLE [dbo].[FilmIndex](
	[FilmID] [int]  NOT NULL, --IDENTITY(1,1)
	[Title] [nvarchar](255) NOT NULL,
	[ReleaseDate] [datetime] NULL,
	[DirectorID] [int] NULL,
	[StudioID] [int] NULL,
	[Review] [nvarchar](max) NULL,
	[CountryID] [int] NULL,
	[LanguageID] [int] NULL,
	[GenreID] [int] NULL,
	[RunTimeMinutes] [smallint] NULL,
	[CertificateID] [int] NULL,
	[BudgetDollars] [bigint] NULL,
	[BoxOfficeDollars] [bigint] NULL,
	[OscarNominations] [tinyint] NULL,
	[OscarWins] [tinyint] NULL,
--PRIMARY KEY CLUSTERED 
--(
--	[FilmID] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) --ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

Declare @i int 
SET @i=0
while @i<=33
begin
insert into [FilmIndex]
Select * from Film
SET @i+=1
end
--Declare cn cursor for Select * from Film

[_WA_Sys_00000001_5AEE82B9]


Use Movies
go

Create Table A (id int)
Create Table B (id int)
Insert into B
Select 1
union all
Select 2
union all
Select 2
union all
Select 4
union all Select NULL

select getdate()+NUll

Select * from A
Select * from B

select * from A join B on A.id=B.id
select * from A left join B on A.id=B.id
select * from A right join B on A.id=B.id
select * from A full outer join B on A.id=B.id

select * from A left join B on A.id=B.id where B.id is null


select * from A left join B on A.id<>B.id


select datepart(HH:MM:SS:,getdate())

select cast(getdate() as time)

Create View v_AB with schemabinding 
as 
select * from A left join B on A.id=B.id where B.id is null

SET CONCAT_NULL_YIELDS_NULL ON
Select 'abc'+NULL
select getdate()+null
SET CONCAT_NULL_YIELDS_NULL OFF
Select 'abc'+NULL
select getdate()+null

use DoctorWho
go
Create View Vw_EpDoctor with schemabinding as
select count(*) total,LEFT(EpisodeType,CHARINDEX(' ',EpisodeType,1)-1) firstcolumn,DoctorName from dbo.tblEpisode ep join dbo.tblDoctor doc
on ep.DoctorId=doc.DoctorId
group by LEFT(EpisodeType,CHARINDEX(' ',EpisodeType,1)-1),DoctorName


SET Statistics TIME ON

select count(*) total,LEFT(EpisodeType,CHARINDEX(' ',EpisodeType,1)-1) firstcolumn,DoctorName from dbo.tblEpisode ep join dbo.tblDoctor doc
on ep.DoctorId=doc.DoctorId
group by LEFT(EpisodeType,CHARINDEX(' ',EpisodeType,1)-1),DoctorName

Select * from Vw_EpDoctor

select distinct e.EpisodeID,e.Title,COUNT_BIG(*) cnt from tblEpisode e join tblEpisodeCompanion tc on e.EpisodeID=tc.EpisodeID
join tblCompanion c on tc.CompanionID=c.CompanionID
group by e.EpisodeID,e.Title
--having count(distinct tc.CompanionID)=1

drop view vw_EpisodeCompanion
create view vw_EpisodeCompanion with schemabinding as
select e.EpisodeID,e.Title,COUNT_BIG(*) cnt from dbo.tblEpisode e join dbo.tblEpisodeCompanion tc on e.EpisodeID=tc.EpisodeID
join dbo.tblCompanion c on tc.CompanionID=c.CompanionID
group by e.EpisodeID,e.Title
--having count(distinct tc.CompanionID)=1

drop view  vw_EpisodeCompanionTry
create view vw_EpisodeCompanionTry with schemabinding as
select e.EpisodeID,e.Title--,COUNT_BIG(*) cnt 
from dbo.tblEpisode e 
group by e.EpisodeID,e.Title

create view vw_EpisodeCompanionTry1 with schemabinding as
select e.EpisodeID,e.Title--,COUNT_BIG(*) cnt 
from dbo.tblEpisode e 
group by e.EpisodeID,e.Title

create unique clustered index IX_vwEpisodeComp on vw_EpisodeCompanionTry1(EpisodeID,Title)

select * from vw_EpisodeCompanionTry1
select * from tblEpisode
delete from vw_EpisodeCompanionTry where EpisodeId=2
SET IDENTITY_INSERT tblEpisode ON
insert into tblEpisode(EpisodeId,) values ('Rose')

sp_helptext 'vw_EpisodeCompanionTry'
 
select distinct e.EpisodeID,e.Title,COUNT_BIG(*) cnt from tblEpisode e join tblEpisodeCompanion tc on e.EpisodeID=tc.EpisodeID
join tblCompanion c on tc.CompanionID=c.CompanionID
group by e.EpisodeID,e.Title

SQL Server parse and compile time: 
   CPU time = 10 ms, elapsed time = 10 ms.

(117 rows affected)

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 2 ms.

Select * from vw_EpisodeCompanion


Select id,ISNULL(id,1),coalesce(id,null,2,3) from B

Use books
go


Create table A(id int)
Create table B(id int)

Alter table A
Add constraint con_Unique Unique( id)

with cte as (
select *,ROW_NUMBER() over (order by id) rown from A
)delete from cte where rown =1
insert into A(id) values
(1),(2),(3),(4),(null),(null)

insert into B values

(1),(1),(2),(2),(3),(null)

select count(*) from A
Select count(*) from B
Select * from A join b on A.id=b.id
Select * from A left join b on A.id=b.id
Select * from A right join b on A.id=b.id
Select * from A full outer join b on A.id=b.id
Select * from A cross join b --on A.id=b.id


Select * from A order by id asc
Select * from B

select * from A left join b on a.id=b.id where b.id is null

Select id from A
except
Select id from B

drop view achk
Create view achk with schemabinding as
select id,city,country--,b.id as id2 
from dbo.A where id=1
with check option;--join b on A.id=b.id

select * from achk
delete from achk where id1=1

select * from A
insert into achk values(1)

select * from A where 'Americas' in (geography,geography1)
Select sum(distinct 1) from A
Select sum(distinct 2) from A
Select sum(distinct 6) from A

alter table dbo.A
add geography1 varchar(255)

update dbo.A Set geography1='Americas'

exec sp_refreshview achk

Create view chkInsert as
select a.id as id1--,b.id as id2 
from A where id=2
union all
select a.id as id1--,b.id as id2 
from A

Drop view chkInsert
Select * from chkInsert

Insert into chkInsert values (1)

delete from chkInsert where id1=2
Create table Country(Name varchar(255))

Insert into Country values ('India'),('Pakistan'),('Australlia')

with a as (
select name,ROW_NUMBER() over (order by name asc) as num from Country
),b as (
select name,ROW_NUMBER() over (order by name asc) as num from Country
)
select a.name + ' vs '+ b.name from a join b on a.num>b.num --and a.name<>b.name

;with cte as (
Select c.name,d.name, c.Name +' vs '+ d.Name as matchgrp, NTILE(2) over (order by d.name  asc) as grpno from  Country C cross join Country d 
where c.name<>d.name)
select matchgrp from cte where grpno=1


Use [SSISHandson]
go

Select * from [dbo].[FilmsForLookupExercise]


CREATE TABLE #MonthlyTempsStl(MName varchar(15), AvgHighTempF INT, 
     AvgHighTempC INT)
INSERT INTO #MonthlyTempsStl(MName, AvgHighTempF, AvgHighTempC)
VALUES('Jan',40,4),('Feb',45, 7),('Mar',56, 13),('Apr',67, 20),
	  ('May',76,25),('Jun',85,30),('Jul',89,32),('Aug',88,31),
	  ('Sep',80,27),('Oct',69,20),('Nov',56,13),('Dec',43,6);
SELECT MName, AvgHighTempF,AvgHighTempC, 
   RANK() OVER(ORDER BY AvgHighTempF) AS Rank,
   PERCENT_RANK() OVER(ORDER BY AvgHighTempF)  AS PercentRank,
   CUME_DIST() OVER(ORDER BY AvgHighTempF)  AS CumeDist
FROM #MonthlyTempsStl;

--- whic temp ranks 50%
SELECT MName, AvgHighTempF,AvgHighTempC,
   RANK() OVER(ORDER BY AvgHighTempF) AS Rank,
   PERCENTILE_CONT(0.4) WITHIN GROUP(ORDER BY AvgHighTempF) 
      OVER() AS PercentileCont,
   PERCENTILE_DISC(0.4) WITHIN GROUP(ORDER BY AvgHighTempF) 
      OVER() AS PercentileDisc
FROM #MonthlyTempsStl;


CREATE TABLE #MarksTable(MName varchar(15), ID INT, 
     Marks INT)
INSERT INTO #MarksTable(MName, ID, Marks)
VALUES('Jan',1,10),('Feb',2, 50),('Mar',3, 40),('Apr',4, 49),
	  ('May',5,25),('Jun',6,30),('Jul',7,45),('Aug',8,38),
	  ('Sep',9,27),('Oct',10,40),('Nov',11,50),('Dec',12,47);
SELECT MName, ID,Marks, 
   RANK() OVER(ORDER BY Marks desc) AS Rank,   RANK() OVER(ORDER BY Marks asc) AS Rank2,
   PERCENT_RANK() OVER(ORDER BY Marks ) *100  AS PercentRank,
   CUME_DIST() OVER(ORDER BY Marks ) *100  AS CumeDist
FROM #MarksTable
order by  RANK() OVER(ORDER BY Marks desc);

50

total students 12
Select 900/12

Select 1100/11


create table #temp (id int) 

Select * from (
select distinct top 10 Marks from #MarksTable
order by 1 desc) a order by marks desc OFFSET 9 ROWS 
FETCH NEXT 1 ROW ONLY


select * from #MarksTable
order by marks desc

SELECT * FROM #MarksTable random(2); 
begin tran
truncate table #MarksTable

select * from #MarksTable
Rollback
commit

select ','+CAST(Marks as VArchar(20)) from #MarksTable

;with cte as (
select value from string_split('10,20,30,40,50',',')
)

SELECT STUFF((select ','+QUOTENAME(value) from cte
for xml PATH(''),TYPE).value('.','NVARCHAR(MAX)'),1,1,'')
,[10],[20],[30],[40],[50]

;with cte as (
select value from string_split('d, x, T, 8, a, 9, 6, 2, V',',')
)select value, case when upper(value)=lower(value)  then 'Fizz' else 'Buzz' end,upper(value),lower(value) from cte

Declare @inputDate date,@CurrentMonth int
Set @inputDate='2020-04-29'
Set @CurrentMonth=DatePart(Month,getdate())
Select case when @CurrentMonth between 4 and 9 and @inputDate between cast(Year(getdate())-1 as varchar(4))+'-04-01' and getdate() then 'Valid'
			when @CurrentMonth not between 4 and 9 and @inputDate between cast(Year(getdate()) as varchar(4))+'-04-01' and getdate() then 'Valid'
			else 'Invalid' end as DateValidation
			print @inputdate
--DatePart(Year,@inputDate) in (Year(getdate()),Year(getdate())-1) then 'Valid'
			--when @CurrentMonth not between 4 and 9 and DatePart(Year,@inputDate) in (Year(getdate())) then 'Valid'
--print @inputDate
--print @CurrentMonth

use Books
go

Create table BEmp (Empid int,name varchar(20),Managerid int)

Table B		
Empid	Name	ManagerID
1	a	3
2	b	1
3	c	null
4	d	1
5	e	2
6	f	5
insert into BEmp Values (1,'a',3),(2,'b',1),(3,'c',null),(4,'d',1),(5,'e',2),(6,'f',5)


;with cte as (
Select b.Empid,b.name,b.Managerid, c.name as Manager,
C.Managerid as manageri,
case when b.ManagerID is null then 0 else 1 end as Levelj
from BEmp b left join Bemp c on b.Managerid=c.Empid
union all
Select cte.Empid,cte.Name,cte.Managerid,cte.Manager,
BEmp.Managerid as manageri ,
cte.Levelj+1 as Levelj
from cte join BEmp on cte.Manageri=BEmp.Empid
)select  Empid,name,Managerid,Manager,Levelj from cte 
where cte.Manageri is  null
order by Levelj,1

option (MAXRECURSION 0)


create procedure inp (@input int = 1) 
as
begin
SET NOCOUNT ON;
declare @i int;
SET @i=1;
while @i<>10
begin
 print @i
 select  @i=&@i
end

end 


CREATE TABLE [dbo].[Employee](  
    [Emp_ID] [int] NOT NULL,  
    [Emp_Name] [nvarchar](50) NOT NULL,  
    [Emp_Salary] [int] NOT NULL,  
    [Emp_City] [nvarchar](50) NOT NULL,  
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED   
(  
    [Emp_ID] ASC  
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]  
) ON [PRIMARY]  
  
GO  

Insert into Employee  
Select 1,'Pankaj',25000,'Alwar' Union All  
Select 2,'Rahul',26000,'Alwar' Union All  
Select 3,'Sandeep',25000,'Alwar' Union All  
Select 4,'Sanjeev',24000,'Alwar' Union All  
Select 5,'Neeraj',28000,'Alwar' Union All  
Select 6,'Naru',20000,'Alwar' Union All  
Select 7,'Omi',23000,'Alwar'  


Insert into Employee  
Select 8,'Pankaj',25000,'Alwar'

  SELECT * FROM Employee 
  go

  EMP_ID: 4  EMP_NAME Sanjeev  EMP_SALARY 24000  EMP_CITY Alwar
SET NOCOUNT ON  
DECLARE @EMP_ID INT  
DECLARE @EMP_NAME NVARCHAR(MAX)  
DECLARE @EMP_SALARY INT  
DECLARE @EMP_CITY NVARCHAR(MAX)  
 
DECLARE EMP_CURSOR CURSOR  
LOCAL  FORWARD_ONLY  FOR  
SELECT * FROM Employee  
OPEN EMP_CURSOR  
FETCH NEXT FROM EMP_CURSOR INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
WHILE @@FETCH_STATUS = 0  
BEGIN  
PRINT  'EMP_ID: ' + CONVERT(NVARCHAR(MAX),@EMP_ID)+  '  EMP_NAME '+@EMP_NAME +'  EMP_SALARY '  +CONVERT(NVARCHAR(MAX),@EMP_SALARY)  +  '  EMP_CITY ' +@EMP_CITY  
FETCH NEXT FROM EMP_CURSOR INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
END  
CLOSE EMP_CURSOR  
DEALLOCATE EMP_CURSOR 


SET NOCOUNT ON  
DECLARE @EMP_ID INT  
DECLARE @EMP_NAME NVARCHAR(MAX)  
DECLARE @EMP_SALARY INT  
DECLARE @EMP_CITY NVARCHAR(MAX)  
  
DECLARE EMP_CURSOR CURSOR  
LOCAL  SCROLL  FOR  
SELECT * FROM Employee  
OPEN EMP_CURSOR  
FETCH NEXT FROM EMP_CURSOR INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
  --while @@FETCH_STATUS=0
  --begin
  PRINT  'EMP_ID: ' + CONVERT(NVARCHAR(MAX),@EMP_ID)+  '  EMP_NAME '+@EMP_NAME +'  EMP_SALARY '  +CONVERT(NVARCHAR(MAX),@EMP_SALARY)  +  '  EMP_CITY ' +@EMP_CITY  
--FETCH RELATIVE 2 FROM EMP_CURSOR INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
--PRINT  'EMP_ID: ' + CONVERT(NVARCHAR(MAX),@EMP_ID)+  '  EMP_NAME '+@EMP_NAME +'  EMP_SALARY '  +CONVERT(NVARCHAR(MAX),@EMP_SALARY)  +  '  EMP_CITY ' +@EMP_CITY  
FETCH ABSOLUTE  3 FROM EMP_CURSOR INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
  
PRINT  'EMP_ID: ' + CONVERT(NVARCHAR(MAX),@EMP_ID)+  '  EMP_NAME '+@EMP_NAME +'  EMP_SALARY '  +CONVERT(NVARCHAR(MAX),@EMP_SALARY)  +  '  EMP_CITY ' +@EMP_CITY  
--FETCH FIRST FROM EMP_CURSOR INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
--PRINT  'EMP_ID: ' + CONVERT(NVARCHAR(MAX),@EMP_ID)+  '  EMP_NAME '+@EMP_NAME +'  EMP_SALARY '  +CONVERT(NVARCHAR(MAX),@EMP_SALARY)  +  '  EMP_CITY ' +@EMP_CITY  
--FETCH LAST FROM EMP_CURSOR INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
--PRINT  'EMP_ID: ' + CONVERT(NVARCHAR(MAX),@EMP_ID)+  '  EMP_NAME '+@EMP_NAME +'  EMP_SALARY '  +CONVERT(NVARCHAR(MAX),@EMP_SALARY)  +  '  EMP_CITY ' +@EMP_CITY  
--FETCH PRIOR FROM EMP_CURSOR INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
--PRINT  'EMP_ID: ' + CONVERT(NVARCHAR(MAX),@EMP_ID)+  '  EMP_NAME '+@EMP_NAME +'  EMP_SALARY '  +CONVERT(NVARCHAR(MAX),@EMP_SALARY)  +  '  EMP_CITY ' +@EMP_CITY  
--FETCH NEXT FROM EMP_CURSOR INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
--PRINT  'EMP_ID: ' + CONVERT(NVARCHAR(MAX),@EMP_ID)+  '  EMP_NAME '+@EMP_NAME +'  EMP_SALARY '  +CONVERT(NVARCHAR(MAX),@EMP_SALARY)  +  '  EMP_CITY ' +@EMP_CITY  
--FETCH NEXT FROM EMP_CURSOR INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
--  end
  
CLOSE EMP_CURSOR  
DEALLOCATE EMP_CURSOR 




SET NOCOUNT ON  
DECLARE @EMP_ID INT  
DECLARE @EMP_NAME NVARCHAR(MAX)  
DECLARE @EMP_SALARY INT  
DECLARE @EMP_CITY NVARCHAR(MAX)  
  
DECLARE EMP_CURSOR1 CURSOR  
LOCAL dynamic scroll  
FOR  
SELECT  EMP_ID ,EMP_NAME,EMP_SALARY,EMP_CITY FROM Employee  order by Emp_Id  
OPEN EMP_CURSOR1  
IF @@CURSOR_ROWS > 0  
     BEGIN   
FETCH NEXT FROM EMP_CURSOR1 INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
WHILE @@FETCH_STATUS = 0  
BEGIN  
  
If @EMP_ID%2=0  
UPDATE Employee SET EMP_NAME='PANKAJ KUMAR CHOUDHARY' WHERE CURRENT OF EMP_CURSOR1  
FETCH NEXT FROM EMP_CURSOR1 INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
END  
END  
CLOSE EMP_CURSOR1  
DEALLOCATE EMP_CURSOR1  
SET NOCOUNT OFF  


SET NOCOUNT ON  
DECLARE @EMP_ID INT  
DECLARE @EMP_NAME NVARCHAR(MAX)  
DECLARE @EMP_SALARY INT  
DECLARE @EMP_CITY NVARCHAR(MAX)  
  
DECLARE EMP_CURSOR1 CURSOR  
GLOBAL KEYSET scroll  
FOR  
SELECT  EMP_ID ,EMP_NAME,EMP_SALARY,EMP_CITY FROM Employee  order by Emp_Id  
OPEN EMP_CURSOR1  
IF @@CURSOR_ROWS > 0  
     BEGIN   
FETCH NEXT FROM EMP_CURSOR1 INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
WHILE @@FETCH_STATUS = 0  
BEGIN  
  
If @EMP_ID%2=0  
UPDATE Employee SET EMP_NAME='PANKAJ KUMAR CHOUDHARY' WHERE CURRENT OF EMP_CURSOR1  
FETCH NEXT FROM EMP_CURSOR1 INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
END  
END  
CLOSE EMP_CURSOR1  
DEALLOCATE EMP_CURSOR1  
SET NOCOUNT OFF  


select * from EMployee

SET NOCOUNT ON  
DECLARE @EMP_ID INT  
DECLARE @EMP_NAME NVARCHAR(MAX)  
DECLARE @EMP_SALARY INT  
DECLARE @EMP_CITY NVARCHAR(MAX)  
  
DECLARE EMP_CURSOR1 CURSOR  
--LOCAL dynamic scroll  
FOR  
SELECT  EMP_ID ,EMP_NAME,EMP_SALARY,EMP_CITY FROM Employee  order by Emp_Id  
OPEN EMP_CURSOR1  

FETCH FIRST FROM EMP_CURSOR1 INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  

PRINT  'EMP_ID: ' + CONVERT(NVARCHAR(MAX),@EMP_ID)+  '  EMP_NAME '+@EMP_NAME +'  EMP_SALARY '  +CONVERT(NVARCHAR(MAX),@EMP_SALARY)  +  '  EMP_CITY ' +@EMP_CITY 
  CLOSE EMP_CURSOR1  
DEALLOCATE EMP_CURSOR1 

FETCH NEXT FROM EMP_CURSOR1 INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
PRINT  'EMP_ID: ' + CONVERT(NVARCHAR(MAX),@EMP_ID)+  '  EMP_NAME '+@EMP_NAME +'  EMP_SALARY '  +CONVERT(NVARCHAR(MAX),@EMP_SALARY)  +  '  EMP_CITY ' +@EMP_CITY 

FETCH LAST FROM EMP_CURSOR1 INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
PRINT  'EMP_ID: ' + CONVERT(NVARCHAR(MAX),@EMP_ID)+  '  EMP_NAME '+@EMP_NAME +'  EMP_SALARY '  +CONVERT(NVARCHAR(MAX),@EMP_SALARY)  +  '  EMP_CITY ' +@EMP_CITY 

 
SET NOCOUNT OFF 
--If @EMP_ID%2=0  
--UPDATE Employee SET EMP_NAME='PANKAJ KUMAR CHOUDHARY' WHERE CURRENT OF EMP_CURSOR1  
--FETCH NEXT FROM EMP_CURSOR1 INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
--END  
--END  

SET NOCOUNT ON  
DECLARE @EMP_ID INT  
DECLARE @EMP_NAME NVARCHAR(MAX)  
DECLARE @EMP_SALARY INT  
DECLARE @EMP_CITY NVARCHAR(MAX) 
FETCH NEXT FROM EMP_CURSOR1 INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
PRINT  'EMP_ID: ' + CONVERT(NVARCHAR(MAX),@EMP_ID)+  '  EMP_NAME '+@EMP_NAME +'  EMP_SALARY '  +CONVERT(NVARCHAR(MAX),@EMP_SALARY)  +  '  EMP_CITY ' +@EMP_CITY 

drop table #temp;
drop table ##temp;
select * into #temp from Employee
BEgin tran;

select * into #temp from Employee
select * into ##temp from Employee
--delete from #temp;
commit;

set transaction isolation level READ COMMITTED--REPEATABLE READ --ON 
begin tran

select * from ##temp with (NOLOCK) where emp_id=14
declare @i int ;
set @i=0;
--print @i
select @i=Emp_Salary from ##temp with (NOLOCK) where emp_id=14
--go
print @i
select * from ##temp with (NOLOCK);

--update 
--insert into #temp values(10,'Shivi',10000,'Mohali')
--go
--insert into ##temp values (10,'Shivi',10000,'Mohali')
--go
commit;
rollback;

select * from #temp
select * from ##temp;

if Object_ID(tempdb..@TableA) is not null 
begin
drop table @TableA
end
drop table #temp;
drop table ##temp;



--insert into @TableA
--select * from Employee;
begin tran

BEGIN TRY
if object_id('tempdb..#temp') is not null
begin
drop table #temp;
end
if object_id('tempdb..##temp') is not null
begin
drop table ##temp;
end
if object_id('tempdb..@TableA') is not null
begin
drop table ##temp;
end
Declare @TableA Table(Emp_id int primary key ,Emp_Name varchar(100),Emp_Salary int,Emp_City varchar(100))
insert into @TableA
select * from Employee;
--select * from @TableA;
select * into #temp from Employee
select * into ##temp from Employee
--create unique clustered index ix_tb on @TableA(Emp_id);
create clustered index ix_ltb on #temp(Emp_id);
create clustered index ix_gtb on ##temp(Emp_id);
create nonclustered index ix_gtbn on ##temp(Emp_Name);
create nonclustered index ix_ltbn on ##temp(Emp_Name);
--select * from #temp
--select * from ##temp;
update #temp set Emp_Salary=1 where Emp_id=1;
update ##temp set Emp_Salary=1 where Emp_id=1;
update @TableA set Emp_Salary=1 where Emp_id=1;
--select * from @TableA;
select 1/0;
END TRY
begin CATCH
rollback;
select * into #a from #temp;
select * into #b from ##temp;
select * into #c from @TableA;
End catch
select * from #a;
select * from #b;
select * from #c;
select * from #temp
select * from ##temp;
select * from @TableA;

drop  table #a
drop table #b
drop table #c

create view vw_emp as

select * from Employee

drop view vw_empsb

create view vw_empsb with SCHEMABINDING as

select EMP_ID,EMP_NAME,EMP_SALARY,EMp_City from dbo.Employee
where EMP_ID<5
WITH CHECK OPTION;

insert into vw_empsb values(14,'Shivi',10000,'Mohali')
select * from Employee
select * from vw_emp
Select * from vw_empsb

create unique clustered index ix_vw on vw_empsb(EMP_ID)
create nonclustered index ix_vwnc on vw_empsb(EMP_NAME)

use books
go

create table Product (PriceDate Date,ProdID int, Price int)

Insert into Product values (getdate()-1,101,100),(getdate()-2,101,200),(getdate()-3,101,300),(getdate()-4,101,250),(getdate()-5,101,200),(getdate()-6,101,270)
,(getdate()-1,102,100),(getdate()-2,102,200),(getdate()-3,102,300),(getdate()-4,102,250),(getdate()-5,102,200),(getdate()-6,102,270)



with cte as(
Select *,LAG(Price,1,0) over (partition by ProdID order by PriceDate asc) as [Previous Price],
case when LAG(Price,1,0) over (partition by ProdID order by PriceDate asc) =0 then 0 
	else 100*(1-cast(cast (Price as float)/cast(LAG(Price,1,0) over (partition by ProdID order by PriceDate asc) as float) as float)) end as [Drop %] ,
case when Price < LAG(Price,1,0) over (partition by ProdID order by PriceDate asc) then 1 
				end as ActualDrop
from Product
)
,cte2 as(
select *,ROW_NUMBER() over (partition by ProdID order by [Drop %] desc) as rown
from cte  where ActualDrop is not null
) select * from cte2 where rown<=2

begin tran

update top(1) Product with (UPDLOCK,ROWLOCK) set Price=100 where ProdID=101

select * from Product with (ROWLOCK,UPDLOCK) where ProdID=101 
where ProdID=102 
commit

SELECT CASE transaction_isolation_level 
WHEN 0 THEN 'Unspecified' 
WHEN 1 THEN 'ReadUncommitted' 
WHEN 2 THEN 'ReadCommitted' 
WHEN 3 THEN 'Repeatable' 
WHEN 4 THEN 'Serializable' 
WHEN 5 THEN 'Snapshot' END AS TRANSACTION_ISOLATION_LEVEL 
FROM sys.dm_exec_sessions 
where session_id = @@SPID

use [AdventureWorks2019]
go

begin tran

select * from Person.Person --with (READPAST)
where BusinessEntityID=2

select * from Person.Person WITH (READPAST) 

update Person.Person with (Rowlock,UPDlock)
set LastName='Aron'
where BusinessEntityID=2
rollback;

SELECT
OBJECT_NAME(p.OBJECT_ID) AS TableName,
resource_type, resource_description
FROM
sys.dm_tran_locks l
JOIN sys.partitions p ON l.resource_associated_entity_id = p.hobt_id
order by 2


SElect STUFF((SELECT distinct ',' + QUOTENAME(c.EpisodeType) 
            FROM tblEpisode c
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')
		
Select STUFF((Select top 10 
(','+QUOTENAME (LastName)) 
from Person.Person for XML PATH(''),TYPE).value('.','NVARCHAR(MAX)')
,1,1,'')

.Value('.','nvarchar(max)')

Select top 10 
STUFF((','+QUOTENAME (LastName)) 
from Person.Person for XML PATH(''),TYPE.VALUE('.','NVARCHAR(250)'),1,1,'')

declare @var varchar(max),@query varchar(max)
Select @var=STUFF((Select distinct  
(','+QUOTENAME (Year(ModifiedDate))) 
from Person.Person order by 1 for XML PATH(''),TYPE).value('.','NVARCHAR(MAX)')
,1,1,'')
--print @var
SET @query='select * from 
(select Year(ModifiedDate) as [Year],LastName from Person.Person
	) as t 
		pivot(
		count(lastName) for [Year] in ('+@var+')
		) as piv'
		--print @query
		execute(@query)

	select * from 
(select Year(ModifiedDate) as [Year],LastName from Person.Person
	) as t 
		pivot(
		count(lastName) for [Year] in ([2006],[2007],[2008],[2009],[2010],[2011],[2012],[2013],[2014],[2015])
		) as piv

		iF OBJECT_ID('tempdb..#temp') is not null 
		begin drop table #temp end
		declare @var varchar(max),@query varchar(max)
		set @query=''
		--select distinct (Year(ModifiedDate)) as Year into #temp from Person.Person --order by 1
		--select * from #temp order by 1
		select @query=@query+  case when @query='' then  QUOTENAME(Year) else ','+QUOTENAME(Year) end
		from (select distinct (Year(ModifiedDate)) as Year from Person.Person) as P order by Year --order by 1
		
		Select  @query

		use DoctorWho
		go
		
select * from 
(select ep.DoctorId,LEFT(EpisodeType,CHARINDEX(' ',EpisodeType,1)-1) firstcolumn,DoctorName from tblEpisode ep join tblDoctor doc
on ep.DoctorId=doc.DoctorId) as tbl
pivot(
count(DoctorID) for firstcolumn in ([50th],Autumn,Christmas,Easter,Normal)
)
as final

select * into #unpiv from 
(select Year(ModifiedDate) as [Year],LastName from Person.Person
	) as t 
		pivot(
		count(lastName) for [Year] in ([2006],[2007],[2008],[2009],[2010],[2011],[2012],[2013],[2014],[2015])
		) as piv

CREATE DATABASE School
GO

USE School
GO

CREATE TABLE Students
(
	Id INT PRIMARY KEY IDENTITY,
	StudentName VARCHAR (50),
	Course VARCHAR (50),
	Score INT
)
GO

INSERT INTO Students VALUES ('Sally', 'English', 95 )
INSERT INTO Students VALUES ('Sally', 'History', 82)
INSERT INTO Students VALUES ('Edward', 'English', 45)
INSERT INTO Students VALUES ('Edward', 'History', 78)

Select * from Students

select * into #un  from 
(
select StudentName,Course,Score from Students ) t 
pivot (
	MAX(Score) for Course in ([English],[History])
	) as piv

	select * from #un

	select * from (Select * from #un) as t unpivot (
	score for Course in ([English],[History])
	) as unpiv

	select sum(distinct 1) from #un

	
	select * into #tip from (
	select 'ABC' as Name,3 as AggCnt
	union All
	Select 'CDE',4
	union All
	Select 'XYZ',5) as t

	
	select *,ROW_NUMBER() Over(order by name asc) as rown into #tip1 from #tip

	create table #temp(id int,name varchar(10))
	go

	select * from #temp
	declare @totalrows int,@i int,@d int
	declare @counter int, @agg int
	declare @name varchar(10)
	set @counter=1;
	set @d=1;
	set @i=1;
	select @totalrows=count(*) from #tip1
	print @totalrows
	while (@i<=@totalrows)
	begin
	 select @agg=AggCnt, @name=name from #tip1 where rown=@i
	 print @agg
	 print @name
	 set @d=1
	 while (@d<=@agg)
	 begin

		insert into #temp values(@counter,	@name)
		SET @counter+=1
		SET @d+=1
	 end
	 set @i+=1
	end


	select *,sum(id) over (partition by name order by id) from #temp

	use AdventureWorks2019
	go

	Create table SQLIndex(ID int,Name varchar(250),City Varchar(250),Address Varchar(Max))

	insert into SQLIndex
	Select BusinessEntityID as ID,FirstName as Name,MiddleName as City,LastName as Address from Person.Person

	SET STATISTICS IO,TIME ON
	--SET IO ON
	go
	Select id,name,City,Address from SQLIndex
	where name='Aaron'

	select * from [Production].[BillOfMaterials]
	--Table Scan  - >  Select 
	--Scan count 1, logical reads 97, physical reads 0
	 --  CPU time = 16 ms,  elapsed time = 13 ms.

	
	create clustered index ix_name on SQLIndex(name)
	-- Clus Index Seek -> Select
	--Scan count 1, logical reads 3, physical reads 0,
	   --CPU time = 0 ms,  elapsed time = 0 ms.

	drop index ix_name on SQLIndex
		--create unique clustered index ix_U_name on SQLIndex(name)
	select count(*),count(distinct id) from SQLIndex --19974	19972

	select * from SQLIndex order by 2
	delete from SQLIndex where Name='Shivi'
	insert into SQLIndex values (2,'Shivi','Mohali','Sector 76')

	create nonclustered index ix_nc_name on SQLIndex(name)
	-- Non Clus Index Seek -> RID Lookup -> Join -> Select
   -- CPU time = 16 ms,  elapsed time = 52 ms.
   --Scan count 1, logical reads 2
	drop index ix_U_id on SQLIndex
	drop index ix_nc_name on SQLIndex
	
	create unique clustered index ix_U_id on SQLIndex(id)
	create nonclustered index ix_nc_name on SQLIndex(name)
	--Non Clus Index Seek -> KEY Lookup -> Join -> Select
	-- Scan count 1, logical reads 2
	-- CPU time = 0 ms,  elapsed time = 48 ms.

	create unique clustered index ix_U_id on SQLIndex(id)
	create nonclustered index ix_nc_name on SQLIndex(name) INCLUDE (City,Address)
	--Non Clus Index Seek -> Select
	--Scan count 1, logical reads 3
	--CPU time = 0 ms,  elapsed time = 0 ms.

	execute uspGetBillOfMaterials 3, '2010-07-08' 

	SELECT name AS AvailableFilegroups
FROM sys.filegroups
WHERE type = 'FG'


select * from SQLIndex_2 
from SQLIndex

drop view vw_sql
create view vw_sql with schemabinding as

select ID,name,City,Address from dbo.SQLIndex
union all
select ID,name,City,Address from dbo.SQLIndex_2

insert into vw_sql values (140,'Shivi','Mohali','Punjab')

Alter table dbo.SQLIndex 
--alter column ID int not null
Add Constraint PK_ID Primary Key ( ID)

Alter table dbo.SQLIndex_2 
--alter column ID int not null
Add Constraint PK_ID_2 Primary Key ( ID)


Select max(id)
from dbo.SQLIndex_2 where ID >=10791 --9985

select PERCENTILE_DISC(0.5) WITHIN GROUP(order by ID) OVER() from dbo.SQLIndex
order by 1

Alter table dbo.SQLIndex 
--alter column ID int not null
Add Constraint CHK_ID CHECK ( ID<10791)

Alter table dbo.SQLIndex_2 
--alter column ID int not null
Add Constraint CHK_ID_2 CHECK ( ID>=10791)

select *  from vw_sql where name='Shivi'

select * from SQLIndex_2 where id=140

select * into sql_part from vw_sql

Alter database AdventureWorks2019
add filegroup id10790
go

Alter database AdventureWorks2019
add filegroup id10791
go

ALTER DATABASE AdventureWorks2019
    ADD FILE 
    (
    NAME = [Part2],
    FILENAME = 'D:\id10791.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [id10791]


USE [AdventureWorks2019]
GO
BEGIN TRANSACTION
CREATE PARTITION FUNCTION [PFbyID](int) AS RANGE LEFT FOR VALUES (N'10790')


CREATE PARTITION SCHEME [PSbyID] AS PARTITION [PFbyID] TO ([id10790], [id10791])




CREATE CLUSTERED INDEX [ClusteredIndex_on_PSbyID_637642071485829329] ON [dbo].[sql_part]
(
	[ID]
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PSbyID]([ID])


DROP INDEX [ClusteredIndex_on_PSbyID_637642071485829329] ON [dbo].[sql_part]






COMMIT TRANSACTION


SELECT name AS AvailableFilegroups
FROM sys.filegroups
WHERE type = 'FG'



SELECT 
name as [FileName],
physical_name as [FilePath] 
FROM sys.database_files
where type_desc = 'ROWS'
GO

SELECT 
p.partition_number AS PartitionNumber,
f.name AS PartitionFilegroup, 
p.rows AS NumberOfRows 
FROM sys.partitions p
JOIN sys.destination_data_spaces dds ON p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(OBJECT_ID) = 'sql_part'


use AdventureWorks2019
go

select * from Person.Address where BusinessEntityID=1 or AddressID =1

BEGIN TRAN
 
UPDATE Person.Person  SET FirstName = 'John' WHERE BusinessEntityID = 1
WAITFOR DELAY '00:00:05'
UPDATE Person.Address SET StateProvinceID = 78 WHERE AddressID = 1
 
COMMIT TRAN
commit

Alter database AdventureWorks2019 SET COMPATIBILITY_LEVEL =150
ALTER DATABASE SCOPED CONFIGURATION SET BATCH_MODE_ON_ROWSTORE = ON
SET STATISTICS TIME ON
GO
DBCC DROPCLEANBUFFERS
GO
SELECT ModifiedDate,CarrierTrackingNumber , 
SUM(OrderQty*UnitPrice) FROM Sales.SalesOrderDetail
GROUP BY ModifiedDate,CarrierTrackingNumber


 SQL Server Execution Times:
   CPU time = 420 ms,  elapsed time = 651 ms.

   create table #A (id varchar(10))

   insert into #A values ('5'),('4'),('6'),('7'),('8'),('9'),('10')

   select id from #A where id like '%[a-zA-Z]%'
  -- order by 1
   union 
   select id from #A where id like '%[^a-zA-Z]%' and cast(id as int)>2
   order by 1  desc

     create table #B (id int)
	 insert into #B values (5),(4),(6),(7),(8),(9),(10),(3),(1),(2)

	 select * from (
	 (select * from #B where id>5 order by 1 desc)
	 union all
	 (select * from #B where id<=5)) as t
	 order by 1 asc

	 union gives sorted result

	 select count(*)
	 select sum(1)
	-- select sum(null)
	 select max('shivi')
	 select 5+null
	 select 1+'1'
	 select '1'+'1'

	 select * into #c from #B

	 delete from #B
	 select * from #b
	  insert into #B values (5),(4),(6),(7),(8),(9),(10),(3),(1),(2)
	  select * from #B

	  truncate table #c
	  select * from #c
	  insert into #c values (5),(4),(6),(7),(8),(9),(10),(3),(1),(2)
	  select * from #c

	 SELECT RIGHT('000'+ISNULL('123',''),3)

	 create table #d (id char(1))

	 insert into #d values ('A'),('A'),('A'),('B'),('B'),('C'),('C')

	 select id,row_number() over (order by id),DENSE_RANK() over (order by id),RANK() over (order by id) ,
	 NTILE(3) over(order by id), NTILE(2) over(order by id)
	 from #d

	 ; with CTE as  
(  
 select 1 Number  
 union all  
 select Number +1 from CTE where Number<100  
)  
  
select *from CTE  

delete from #b

select * into #e from #b

SELECT TOP (100) ROW_NUMBER() OVER (ORDER BY Object_id)

FROM master.sys.columns

insert into #b values (null),(0),(null),(1),(0),(1)
insert into #e values (null),(null),(0),(0),(1),(1),(null)

select b.id from #b b  join #e e
on b.id=e.id

use Adventureworks2019
go
create table partitioningtable(id int, period date, value char(15))

declare @i int
declare @p int ,@batch int
set @i=1
set @batch=1
set @p=10

	while(@p>=0)
	begin
		set @batch=1
		while (@batch<=100000)
		begin
			insert into partitioningtable values(@i, DATEADD(yyyy,@p*-1,getdate()),'Value'+cast(@i as varchar(100)))
			set @batch+=1
			set @i+=1
		end
		set @p=@p-1
	end

	select max(id) from partitioningtable

create table bulkpartitioningtable(id int, period date, value char(15))

;WITH mycte AS
(
SELECT 1000001 DataValue
UNION all
SELECT DataValue + 1
FROM    mycte   
WHERE   DataValue + 1 <= 1100000
)
--select * from mycte option (maxrecursion 0)
INSERT INTO bulkpartitioningtable(id,value,period)
SELECT 
        DataValue,
        'Value'+cast(DataValue as varchar(max)) AS RandValue,getdate()
FROM mycte m 
OPTION (MAXRECURSION 0)

select top 10 * from bulkpartitioningtable
create unique clustered index ix_id on bulkpartitioningtable(id)
update bulkpartitioningtable
with (rowlock,updlock)
set period=dateadd(yyyy,-1,getdate())
where id>900000 and id<=1000000

select period,count(*) from bulkpartitioningtable
group by period

ALTER DATABASE [AdventureWorks2019]
ADD FILEGROUP [Part2020]

post creating file group - add a ndf file to each file group where data would be stored

ALTER DATABASE [AdventureWorks2019]
    ADD FILE 
    (
    NAME = [Part2020],
    FILENAME = 'D:\AdventureWorks2020.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [Part2020]


	-- define ranges for each file group
USE AdventureWorks2019
GO
CREATE PARTITION FUNCTION [PF_YearlyPartition] (DATE)
AS RANGE RIGHT FOR VALUES 
(
  '2012-01-01', '2013-01-01', '2014-01-01', 
  '2015-01-01', '2016-01-01', '2017-01-01',
  '2018-01-01', '2019-01-01', '2020-01-01',
  '2021-01-01'
);


---link rangefunction and filegroup

USE AdventureWorks2019
GO
CREATE PARTITION SCHEME PS_YearWise
AS PARTITION PF_YearlyPartition
TO 
( 
  'Part2011', 'Part2012', 'Part2013',
  'Part2014', 'Part2015', 'Part2016',
  'Part2017', 'Part2018', 'Part2019',
  'Part2020','Primary'
);

ALTER PARTITION SCHEME PS_YearWise
AS PARTITION PF_YearlyPartition ALL TO ('Primary')
drop PARTITION SCHEME PS_YearWise
drop partition function PF_YearlyPartition
SELECT o.name objectname,i.name indexname, partition_id, partition_number, [rows]
FROM sys.partitions p
INNER JOIN sys.objects o ON o.object_id=p.object_id
INNER JOIN sys.indexes i ON i.object_id=p.object_id and p.index_id=i.index_id
WHERE o.name LIKE '%partitioningtable%'

drop index ix_id on bulkpartitioningtable

ALTER TABLE dbo.TABLE1 DROP CONSTRAINT PK_TABLE1
GO
ALTER TABLE dbo.TABLE1 ADD CONSTRAINT PK_TABLE1 PRIMARY KEY NONCLUSTERED  (pkcol)
   WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, 
         ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_TABLE1_partitioncol ON dbo.bulkpartitioningtable (Value)
  WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, 
        ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
  ON PS_YearWise(period)
GO

select * from bulkpartitioningtable where id=1000000 and
Period='2011-08-16' and Value='Value100000'

drop index IX_CID on dbo.bulkpartitioningtable
drop index IX_TABLE1_partitioncol ON dbo.bulkpartitioningtable 
create clustered index IX_CID on dbo.bulkpartitioningtable(id) on [PRIMARY]

SELECT name AS AvailableFilegroups
FROM sys.filegroups
WHERE type = 'FG'

SELECT 
name as [FileName],
physical_name as [FilePath] 
FROM sys.database_files
where type_desc = 'ROWS'
GO

SELECT 
p.partition_number AS PartitionNumber,
f.name AS PartitionFilegroup, 
p.rows AS NumberOfRows 
FROM sys.partitions p
JOIN sys.destination_data_spaces dds ON p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(OBJECT_ID) = 'bulkpartitioningtable'


create table #tbl1(id int,name varchar(100))
create table #tbl2(id int,name varchar(100))

insert into #tbl1 values (1,'XYZ'),(1,'XYZ'),(2,'ABC')

merge #tbl2 as Target 
using (select distinct id,Name from #tbl1) as Source on Target.id=Source.id
WHEN MATCHED THEN
UPDATE  SET TARGET.NAME=Source.NAME
WHEN NOT MATCHED BY TARGET THEN
INSERT(id,Name) VALUES(Source.id,Source.Name);

select * from #tbl2

Create table Items (ItemName varchar(50),DOI date, Quantity int)
Create table ItemMax(ItemName varchar(50), MaxQty int)

insert into Items values ('Item1','15 Aug 2021',105),('Item2','20 Aug 2021',45) 

insert into ItemMax values ('Item1',30)

select * from Items
select * from ItemMax

select 105/30,105%30


drop table #temp

select i.*,i.Quantity/im.MaxQty as div,i.Quantity%im.MaxQty as rem,im.MaxQty,
ROW_NUMBER() over (order by i.ItemName,i.DOI) as rowno
into #temp from Items i left join ItemMax im 
on i.ItemName=im.ItemName

select *,ROW_NUMBER() over (order by ItemName,DOI) as no from #temp
create table #temp2 (ItemName varchar(50),doi date, Quantity int)

delete from #temp2
select * from #temp
declare @lVar int,@trows int,@div int,@iloop int,@iname varchar(50),@iDate date,@mqty int,@rqty int 
set @lVar=1
select @trows=count(*) from #temp
print @trows
while (@lvar<=@trows)
	begin
		print @lvar
		Select @div=isnull(div,0),@iname=ItemName,@iDate=DOI,@mqty=isnull(MaxQty,Quantity),@rqty=rem from #temp where rowno=@lvar
		
		if(@div=0)
			begin
				insert into #temp2 values (@iname,@iDate,@mqty)
			print cast(@lvar as varchar(10)) + ' inside div zero div=' + cast(@div as varchar(10))  
			end
			
		else 
			begin
				set @iloop=1
				while (@iloop<=@div)
					begin
						print cast(@lvar as varchar(10)) + ' inside div non zero div=' + cast(@div as varchar(10)) +' loop='+cast(@iloop as varchar(10))
						insert into #temp2 values (@iname,@iDate,@mqty)
						set @iloop=@iloop+1
					end
				if (@rqty!=0)
					begin
						insert into #temp2 values(@iname,@idate,@rqty)
					end
			end
			set @lVar=@lVar+1
	end
select *,ROW_NUMBER() over (partition by ItemName,doi order by ItemName,doi) as SerialNo from #temp2


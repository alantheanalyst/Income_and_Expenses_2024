begin transaction 
delete from CaptiolOne2023
where month(Posted_Date) = '12'
commit

begin transaction 
delete from Chase2023
where month(Posting_Date) = '12'
commit


select 
month(Posting_Date) as 'Month',
round(sum(
case
	when Amount > 0 then abs(Amount)	
end), 0) as Earnings,
round(sum(
case
	when Amount < 0 then abs(Amount)	
end), 0) as Expenses
into #Chase2022Temp
from Chase2022
group by 
month(Posting_Date)

select 
month(Posted_Date) as 'Month',
round(sum(Debit), 0) as Expenses
into #CapitolOne2022Temp
from CapitolOne2022
group by 
month(Posted_Date)

select 
month(Posting_Date) as 'Month',
round(sum(
case
	when Amount > 0 then abs(Amount)
end), 0) as Earnings,
round(sum(
case
	when Amount < 0 then abs(Amount)
end), 0) as Expenses
into #Chase2023Temp
from Chase2023
group by 
month(Posting_Date)

select 
month(Posted_Date) as 'Month',
round(sum(Debit), 0) as Expenses
into #CapitolOne2023Temp
from CaptiolOne2023
group by 
month(Posted_Date)

select 
a.Month,
Earnings,
sum(a.Expenses + b.Expenses) as Expenses
from #Chase2022Temp a join #CapitolOne2022Temp b
on a.Month = b.Month
group by 
a.Month,
Earnings
union all
select 
a.Month,
Earnings,
sum(a.Expenses + b.Expenses) as Expenses
from #Chase2023Temp a join #CapitolOne2023Temp b
on a.Month = b.Month
group by 
a.Month,
Earnings

select 
sum(Earnings) as 'Total Earnings 2022',
sum(a.Expenses + b.Expenses) as 'Total Expenses 2022'
from #Chase2022Temp a join #CapitolOne2022Temp b
on a.Month = b.Month


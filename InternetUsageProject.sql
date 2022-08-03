
/*
Internet Usage Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/


-- This is to make sure that I imported the right tables that i will be working on in this project which are the Internet Price, Speed, and users.
Select *
From InternetPrice

Select * 
From InternetSpeed

Select *
From InternetUsers


--------------------------------------------------------------------------------------------------------------------------------------
--(1)
-- Using a Group by statement 
Select [Continental region], COUNT([continental region]) as CountOfUsage
from InternetPrice
Group by [Continental region]
Order by 2 

--------------------------------------------------------------------------------------------------------------------------------------
--(2)
-- Using a Partition by statement 
Select Country, [Avg _(Mbit/s)Ookla], COUNT (Country) over (partition by Country) as Total_Count
from InternetSpeed

--------------------------------------------------------------------------------------------------------------------------------------
--(3)
--Using the isnot Null statement 
Select *
From InternetPrice
Where [Continental region] is not null 
order by 3,4

--------------------------------------------------------------------------------------------------------------------------------------
--(4)
-- Select data that i will be working with in this project

Select Name, [Continental region], [NO# OF Internet Plans ], [Cheapest 1GB for 30 days (USD)], [Most expensive 1GB (USD)]
From InternetPrice
where [Continental region] IS NOT NULL
Order by 1, 5

--------------------------------------------------------------------------------------------------------------------------------------
--(5)
--Cheapest Plan vs Expensive Plan

Select  Name, [Continental region], [Cheapest 1GB for 30 days (USD)], [Most expensive 1GB (USD)], 
([Cheapest 1GB for 30 days (USD)]/[Most expensive 1GB (USD)])* 100 as Internet_Percentage
From InternetPrice
Where [Continental region] like '%America%'
and [Continental region] is not null 
order by 1,2


--------------------------------------------------------------------------------------------------------------------------------------
--(6)
-- Total Users vs Population
-- Shows what percentage of population uses the internet 

Select Country, Region, [Internet users], Population, ([Internet users]/Population)*100 as PercentOfUsers
from InternetUsers
where Region like '%Europe%'
Order by 1,2

--------------------------------------------------------------------------------------------------------------------------------------
--(7)
-- Top 10 Countries with Highest Usage

Select Top 10 Country, Region, [Internet users]
From InternetUsers
Order by 3 Desc


--------------------------------------------------------------------------------------------------------------------------------------
--(8)
-- To Join two table (Internet Price and Internet Speed) using an Inner Join

Select Country, [Continental region], [NO# OF Internet Plans ],[Avg _(Mbit/s)Ookla]
from WorldInternetUsage.dbo.InternetPrice as IntP
Inner Join WorldInternetUsage.dbo.InternetSpeed as IntS
On IntP.Name = IntS.Country
Order by 1, 2, 3

--------------------------------------------------------------------------------------------------------------------------------------
--(9)
-- To join the three tables together 
-- Using the Inner join and Left Join
use WorldInternetUsage
select *
from InternetPrice As P
join InternetSpeed As S
on P. Name = S.Country
Left Join InternetUsers As U
ON p.[Continental region] = U.Country


--------------------------------------------------------------------------------------------------------------------------------------
--(10)
-- To Union two tables
Select Name, [Continental region], [NO# OF Internet Plans ]
From WorldInternetUsage.dbo.InternetPrice
Union
Select Country, Region, [Internet users]
from WorldInternetUsage.dbo.InternetUsers
order by [Continental region]


--------------------------------------------------------------------------------------------------------------------------------------
--(11)
-- Using a case statment 
Select Name, [Continental region], [NO# OF Internet Plans ], [Average price of 1GB (USD)],
CASE 
	WHEN [NO# OF Internet Plans ] > 50 then 'High'
	WHEN [NO# OF Internet Plans ] <  20 then 'Low' 
	WHEN [NO# OF Internet Plans ] between 30 AND 48 then 'Medium' 

	Else 'Out of Range'
END  as HighVsLowMedium
from InternetPrice
Where [NO# OF Internet Plans ] is not NUll   
Order by [Continental region]


--------------------------------------------------------------------------------------------------------------------------------------
--(12)
-- Using CTE to perform Calculation on Partition By 

With CTE_InternetUsage As
(
SELECT Name, [Continental region], [NO# OF Internet Plans ], [Cheapest 1GB for 30 days (USD)], [Most expensive 1GB (USD)], [Avg _(Mbit/s)Ookla],
COUNT([NO# OF Internet Plans ]) OVER (Partition by [NO# OF Internet Plans ]) as Plans,
AVG ([Most expensive 1GB (USD)]) OVER (Partition by [Most expensive 1GB (USD)]) as AVGUsage
From InternetPrice as P
JOIN InternetSpeed as S
ON p.Name = S.Country
WHERE [NO# OF Internet Plans ] > 40
AND [Avg _(Mbit/s)Ookla] >= 30
)
SELECT *
FROM CTE_InternetUsage


--------------------------------------------------------------------------------------------------------------------------------------
--(13)
--Using Temp Table to perform Calculation on Partition By in previous query
DROP Table if exists #InternetUsage
CREATE Table #InternetUsage
(
Name nvarchar (255),
[Continental region] nvarchar (255),
[NO# OF Internet Plans ] float,
[Cheapest 1GB for 30 days (USD)] money,
[Most expensive 1GB (USD)] money,
[Avg _(Mbit/s)Ookla] float
)

INSERT INTO #InternetUsage
SELECT Name, [Continental region], [NO# OF Internet Plans ], [Cheapest 1GB for 30 days (USD)], [Most expensive 1GB (USD)], [Avg _(Mbit/s)Ookla],
COUNT([NO# OF Internet Plans ]) OVER (Partition by [NO# OF Internet Plans ]) as Plans,
AVG ([Most expensive 1GB (USD)]) OVER (Partition by [Most expensive 1GB (USD)]) as AVGUsage
From InternetPrice as P
JOIN InternetSpeed as S
ON p.Name = S.Country
WHERE [NO# OF Internet Plans ] > 40
AND [Avg _(Mbit/s)Ookla] >= 30

Select *
From #InternetUsage



--------------------------------------------------------------------------------------------------------------------------------------
--(1)
-- Creating View to store data for later visualizations

Create View InternetPlans as
Select Name, [Continental region], [NO# OF Internet Plans ], [Cheapest 1GB for 30 days (USD)], [Most expensive 1GB (USD)]
From InternetPrice
where [Continental region] IS NOT NULL
--Order by 1, 5

--------------------------------------------------------------------------------------------------------------------------------------
Create View InternetPercent as
Select  Name, [Continental region], [Cheapest 1GB for 30 days (USD)], [Most expensive 1GB (USD)], 
([Cheapest 1GB for 30 days (USD)]/[Most expensive 1GB (USD)])* 100 as Internet_Percentage
From InternetPrice
Where [Continental region] like '%America%'
and [Continental region] is not null 
--order by 1,2

--------------------------------------------------------------------------------------------------------------------------------------
Create view PopulationVsUsers as
Select Country, Region, [Internet users], Population, ([Internet users]/Population)*100 as PercentOfUsers
from InternetUsers
where Region like '%Europe%'
--Order by 1,2

--------------------------------------------------------------------------------------------------------------------------------------
Create view HigherUsers as
Select Top 10 Country, Region, [Internet users]
From InternetUsers
--Order by 3 Desc

--------------------------------------------------------------------------------------------------------------------------------------
Create view  HighLow_Medium as
Select Name, [Continental region], [NO# OF Internet Plans ], [Average price of 1GB (USD)],
CASE 
	WHEN [NO# OF Internet Plans ] > 50 then 'High'
	WHEN [NO# OF Internet Plans ] <  20 then 'Low' 
	WHEN [NO# OF Internet Plans ] between 30 AND 48 then 'Medium' 

	Else 'Out of Range'
END  as HighVsLowMedium
from InternetPrice
Where [NO# OF Internet Plans ] is not NUll   
--Order by [Continental region]


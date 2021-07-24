--Table 1 Query:
drop table if exists EmployeeDemographics
Create Table EmployeeDemographics (
	EmployeeID int, 
	FirstName varchar(50), 
	LastName varchar(50), 
	Age int, 
	Gender varchar(50)
)

--Table 2 Query:
drop table if exists EmployeeSalary
Create Table EmployeeSalary(
	EmployeeID int, 
	JobTitle varchar(50), 
	Salary int
)

--Table 1 Insert:
Insert into EmployeeDemographics VALUES
	(1001, 'Jim', 'Halpert', 30, 'Male'),
	(1002, 'Pam', 'Beasley', 30, 'Female'),
	(1003, 'Dwight', 'Schrute', 29, 'Male'),
	(1004, 'Angela', 'Martin', 31, 'Female'),
	(1005, 'Toby', 'Flenderson', 32, 'Male'),
	(1006, 'Michael', 'Scott', 35, 'Male'),
	(1007, 'Meredith', 'Palmer', 32, 'Female'),
	(1008, 'Stanley', 'Hudson', 38, 'Male'),
	(1009, 'Kevin', 'Malone', 31, 'Male')

--Table 2 Insert:
Insert Into EmployeeSalary VALUES
	(1001, 'Salesman', 45000),
	(1002, 'Receptionist', 36000),
	(1003, 'Salesman', 63000),
	(1004, 'Accountant', 47000),
	(1005, 'HR', 50000),
	(1006, 'Regional Manager', 65000),
	(1007, 'Supplier Relations', 41000),
	(1008, 'Salesman', 48000),
	(1009, 'Accountant', 42000)

select *
from SQLTutorial..EmployeeDemographics

select *
from SQLTutorial..EmployeeSalary

/* Inner join */

select *
from SQLTutorial.dbo.EmployeeDemographics
inner join SQLTutorial.dbo.EmployeeSalary
	on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

/* Full Outer join */

select *
from SQLTutorial.dbo.EmployeeDemographics
Full Outer Join SQLTutorial.dbo.EmployeeSalary
	on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

--Table 1 Insert:
Insert into SQLTutorial.dbo.EmployeeDemographics VALUES
	(1011, 'Ryan', 'Howard', 26, 'Male'),
	(NULL, 'Holly', 'Flax', NULL, NULL),
	(1013, 'Darryl', 'Philbin', NULL, 'Male')

--Table 3 Query:
Create Table WareHouseEmployeeDemographics (
	EmployeeID int, 
	FirstName varchar(50), 
	LastName varchar(50), 
	Age int, 
	Gender varchar(50)
)

--Table 3 Insert:
Insert into WareHouseEmployeeDemographics VALUES
	(1013, 'Darryl', 'Philbin', NULL, 'Male'),
	(1050, 'Roy', 'Anderson', 31, 'Male'),
	(1051, 'Hidetoshi', 'Hasagawa', 40, 'Male'),
	(1052, 'Val', 'Johnson', 31, 'Female')

select * from WareHouseEmployeeDemographics

/* Union */
select *
from SQLTutorial.dbo.EmployeeDemographics
union
select *
from WareHouseEmployeeDemographics

/* Union All */
select *
from SQLTutorial.dbo.EmployeeDemographics
union all
select *
from WareHouseEmployeeDemographics
order by EmployeeID

/* Case Statement */
--Example 1:
select FirstName, LastName, Age,
case 
	when Age > 30 then 'Old'
	when Age between 27 and 30 then 'Young'
	else 'Baby'
end
from SQLTutorial.dbo.EmployeeDemographics
where Age IS NOT NULL
order by Age

--Example 2:
select FirstName, LastName, JobTitle, Salary,
case
	when JobTitle = 'Salesman' then salary + (salary * .10)
	when JobTitle = 'Accountant' then salary + (salary * .05)
	when JobTitle = 'HR' then salary + (salary * .000001)
	else Salary + (Salary * .03)
end as SalaryAfterRaise
from SQLTutorial.dbo.EmployeeDemographics
join SQLTutorial.dbo.EmployeeSalary
	on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
order by Salary desc

/* Having Clause */
select JobTitle, avg(Salary)
from SQLTutorial.dbo.EmployeeDemographics
join SQLTutorial.dbo.EmployeeSalary
	on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
group by JobTitle
having avg(Salary) > 45000
order by avg(Salary)

/* Updating/Deleting Data */
select *
from SQLTutorial.dbo.EmployeeDemographics

update SQLTutorial.dbo.EmployeeDemographics
set Age = 31, Gender = 'Female'
where FirstName = 'Holly' and LastName = 'Flax'

delete from SQLTutorial.dbo.EmployeeDemographics
where EmployeeID = 1005

/* Partition By */
select FirstName, LastName, Gender, Salary,
count(Gender) over (partition by Gender) TotalGender
from SQLTutorial.dbo.EmployeeDemographics dem
join SQLTutorial.dbo.EmployeeSalary sal
	on dem.EmployeeID = sal.EmployeeID

select Gender, count(Gender) TotalGender
from SQLTutorial.dbo.EmployeeDemographics dem
join SQLTutorial.dbo.EmployeeSalary sal
	on dem.EmployeeID = sal.EmployeeID
group by Gender

/* CTE */
with CTE_Employee as
(select FirstName, LastName, Gender, Salary,
COUNT(Gender) over (PARTITION BY Gender) as TotalGender,
avg(Salary) over (PARTITION BY Gender) as AvgSalary
from SQLTutorial.dbo.EmployeeDemographics emp
join SQLTutorial.dbo.EmployeeSalary sal
	on emp.EmployeeID = sal.EmployeeID
where Salary > 45000
)
select FirstName, AvgSalary
from CTE_Employee

/* Temp Tables */
create table #temp_Employee(
	EmployeeID int,
	JobTitle varchar(100),
	Salary int
)

insert into #temp_Employee
select *
from SQLTutorial..EmployeeSalary

select *
from #temp_Employee

--Example 2:
drop table if exists #Temp_Employee2
create table #Temp_Employee2(
	JobTitle varchar(50),
	EmployeesPerJob int,
	AvgAge int,
	AvgSalary int
)

insert into #Temp_Employee2
select JobTitle, COUNT(JobTitle), avg(Age), avg(Salary)
from SQLTutorial..EmployeeDemographics emp
join SQLTutorial..EmployeeSalary sal
	on emp.EmployeeID = sal.EmployeeID
group by JobTitle

select *
from #Temp_Employee2

/* String Functions - TRIM, LTRIM, RTRIM, Replace, Substring, Upper, Lower */

drop table if exists EmployeeErrors
create table EmployeeErrors(
	EmployeeID varchar(50),
	FirstName varchar(50),
	LastName varchar(50)
)

insert into EmployeeErrors values
	('1001   ', 'Jimbo', 'Halbert'),
	('   1002', 'Pamela', 'Beasely'),
	('1005', 'TOby', 'Flenderson - Fired')

select * from EmployeeErrors

--Using TRIM, LTRIM, RTRIM
select EmployeeID, TRIM(EmployeeID) as IDTRIM
from EmployeeErrors

select EmployeeID, LTRIM(EmployeeID) as IDTRIM
from EmployeeErrors

select EmployeeID, RTRIM(EmployeeID) as IDTRIM
from EmployeeErrors

--Using Replace
select LastName, replace(LastName, '- Fired', '') as UpdatedLastName
from EmployeeErrors

--Using Substring
select err.FirstName, substring(err.FirstName, 1, 3), dem.FirstName, substring(dem.FirstName, 1, 3)
from EmployeeErrors err
join SQLTutorial..EmployeeDemographics dem
	on substring(err.FirstName, 1, 3) = substring(dem.FirstName, 1, 3)

--Using UPPER and lower
select FirstName, upper(FirstName)
from EmployeeErrors

select FirstName, LOWER(FirstName)
from EmployeeErrors

/* Stored Procedures */
--Example 1:
create procedure test
as
select *
from SQLTutorial..EmployeeDemographics

exec test

--Example 2:
create procedure Temp_Employee
as 
drop table if exists #temp_employee3
create table #temp_employee3(
	JobTitle varchar(100),
	EmployeesPerJob int,
	AvgAge int,
	AvgSalary int
)

insert into #temp_employee3
select JobTitle, COUNT(JobTitle), avg(Age), avg(Salary)
from SQLTutorial..EmployeeDemographics emp
join SQLTutorial..EmployeeSalary sal
	on emp.EmployeeID = sal.EmployeeID
group by JobTitle 

select *
from #temp_employee3

exec Temp_Employee @JobTitle = 'Salesman'

/* Subqueries (in the Select, From, and Where Statement) */
select *
from SQLTutorial..EmployeeSalary

--Subquery in Select
select EmployeeID, Salary, (select avg(Salary) from SQLTutorial..EmployeeSalary) as AllAvgSalary
from SQLTutorial..EmployeeSalary

--How to do it with Partition By
select EmployeeID, Salary, avg(Salary) over () as AllAvgSalary
from SQLTutorial..EmployeeSalary

--Why Group By doesn't works
select EmployeeID, Salary, avg(Salary) as AllAvgSalary
from SQLTutorial..EmployeeSalary
group by EmployeeID, Salary
order by 1, 2

--Subquery in From
select a.EmployeeID, a.AllAvgSalary
from (select EmployeeID, Salary, avg(Salary) over () as AllAvgSalary
	  from SQLTutorial..EmployeeSalary) a

--Subquery in Where
select EmployeeID, JobTitle, Salary
from SQLTutorial..EmployeeSalary
where EmployeeID in (
	select EmployeeID
	from SQLTutorial..EmployeeDemographics
	where Age > 30)
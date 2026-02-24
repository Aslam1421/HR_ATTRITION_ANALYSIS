select * from hr_data;
-- 1. How many total employees are in the company?

select count(*) as total_employees from hr_data;

--2️⃣ How many employees have Attrition = 'Yes'?

select count(*) as attrition_count from hr_data
where attrition = 'Yes';

--3️⃣ What is the overall attrition percentage?

select count(*) as total_employees ,
sum (
	case 
	when Attrition = 'No' then 1 else 0 end
)as employees_stayed,
sum (
	case 
	when Attrition = 'Yes' then 1 else 0 end
)as attrition_count ,
sum (
	case 
	when Attrition = 'Yes' then 1 else 0 end
) * 100 / count(*) as percentage 
from hr_data;

--4️⃣ How many unique departments are there?

select count(distinct department) as No_Of_Departments from hr_data;

--5️⃣ How many employees are in each department?

select department,count(*) as Employee_count from hr_data
group by department
order by Employee_count desc;

--6️⃣ Which department has the highest number of employees who left and the Attrition Percenatge ?

select department,
sum(
	case
	when Attrition = 'No' then 1 else 0 end) as employees_stayed,
sum(
	case 
	when Attrition = 'Yes' then 1 else 0 end) as Employees_left,
Round(sum(
	case 
	when Attrition = 'Yes' then 1 else 0 end)*100.0/count(*),2) as Attrition_Percentage
from hr_data
group by department
order by Attrition_percentage desc;

--7️⃣ What is the attrition count by JobRole?
-- select jobrole,
-- SUM(
-- 	CASE 
-- 	WHEN Attrition = 'Yes' then 1 else 0 end) as Attrition_Count,
-- ROUND(sum(
-- 	case 
-- 	when Attrition = 'Yes' then 1 else 0 end)*100.0/COUNT(*),2) as Attrition_Percent
-- from hr_data
-- group by jobrole
-- order by Attrition_Count Desc;

WITH jobrole_stats AS (
    SELECT 
        jobrole,
        COUNT(*) AS total_employees,
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left
    FROM hr_data
    GROUP BY jobrole
)

SELECT 
    jobrole,
    employees_left,
    total_employees,
    ROUND(employees_left * 100.0 / total_employees, 2) AS attrition_percentage
FROM jobrole_stats
ORDER BY attrition_percentage DESC;

--8️⃣ What is the average MonthlyIncome of: Employees who left & Employees who stayed

select COUNT(*)AS employee_count,attrition, 
ROUND(AVG(monthlyincome),2) as monthly_income
from hr_data
group by attrition
order by monthly_income desc;

-- Do employees who work overtime leave more?

select overtime,
count(*) as total_employees,
ROUND(sum(
	case 
	when Attrition = 'Yes' then 1 else 0 end)*100.0/count(*),2) as employee_left_percent
from hr_data
group by overtime
order by employee_left_percent desc;

--10 What is the average YearsAtCompany for employees who left?

select ROUND(avg(yearsatcompany),2) AS AVG_YEAR
from hr_data
where Attrition = 'Yes';

--11️ Is attrition higher among employees with:  WorkLifeBalance = 1 or 4?

select
worklifebalance,  
count(*) as no_of_employees,
ROUND(SUM(
	CASE
	WHEN Attrition = 'Yes' then 1 else 0 end)*100.0/count(*),2) as attrition_percentage
from hr_data
where worklifebalance in(1,4)
group by worklifebalance
order by attrition_percentage desc;
-- Employees with poor work-life balance (31.25%) and those working overtime (30.44%) show significantly higher attrition rates, 
-- indicating workload and burnout as key drivers of employee turnover.

-- 12 Which JobRole has the highest attrition rate (not just count)?

select jobrole,
count(*) as total_employees,
SUM(
	CASE
	WHEN Attrition = 'Yes' then 1 else 0 end) as attrition_count,
ROUND(SUM(
	CASE
	WHEN Attrition = 'Yes' then 1 else 0 end)*100.0/count(*),2) as attrition_percentage
from hr_data 
group by jobrole
order by attrition_percentage desc;

--13 Among employees with salary less than 4000,how many left?

with employee_stats as 
(
	select count(*) as total_employees,
	SUM(CASE
	   	WHEN Attrition = 'Yes' then 1 else 0 end)as employee_left
	from hr_data
	where monthlyincome<4000)
select 
total_employees,
employee_left,
ROUND(employee_left *100.0/total_employees)as attrition_percentage
from employee_stats;

-- 14 Do employees with less than 2 years at company leave more?

select 'Less than 2 Years' AS experience_group, 
count(*) as total_employees,
SUM(
	CASE
	WHEN Attrition = 'Yes' then 1 else 0 end) as employees_left,
ROUND(SUM(
	CASE
	WHEN Attrition = 'Yes' then 1 else 0 end)*100.0/count(*),2 )as employees_left_percent
from hr_data
where yearsatcompany<2

union 

select '2+ Years' AS experience_group,
count(*) as total_employees,
SUM(
	CASE
	WHEN Attrition = 'Yes' then 1 else 0 end) as employees_left,
ROUND(SUM(
	CASE
	WHEN Attrition = 'Yes' then 1 else 0 end)*100.0/count(*),2 )as employees_left_percent
from hr_data
where yearsatcompany>=2
ORDER BY employees_left_percent DESC;

-- 15 What is the average age of employees who left?

select ROUND(avg(age),2) as Avg_Age_left
from hr_data  
where Attrition ='Yes';
 
-- 16 What is the average age of employees who stayed ? 
select ROUND(avg(age),2) as Avg_Age_left
from hr_data 
where Attrition ='No'; 

-- Employees who leave have an average age of 33.61 compared to 37.56 for those who stay,
-- indicating higher attrition among relatively younger employees.



	
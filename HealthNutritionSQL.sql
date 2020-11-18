--First lets look at the entire dataset in the table
select * from us_population_2.demo_j; 

--Lets see how many number of observations there are
select COUNT(*) from us_population_2.demo_j;

--This is BEST practice to limit the number in each view
select * from us_population_2.demo_j limit 5;

--Develop a list of all the variable names
describe us_population_2.demo_j;

--Lets select the variables that are of interest to us
--We know the definition for each of the variable acronyms based on the data dictionary found at
--demongraphics: // https://wwwn.cdc.gov/nchs/nhanes/search/datapage.aspx?Component=Demographics&CycleBeginYear=2017
--SEQN identification number
--RIAGENDR gender of the participant.
--RIDAGEMN age in months of the participant at the time of screening
--RIDAGEYR Age in years of the participant at the time of screening(individuals 80 and over are topcoded at 80 years of age)	
--INDFMIN2 Total family income (reported as a range value in dollars)	

--Now lets change the names and follow the correct indentation syntax
select 
SEQN as 'patient_id',
RIAGENDR as 'gender',
RIDAGEMN as 'age_months',
RIDAGEYR as 'age_years',
INDFMIN2 as 'family_income' 
from us_population_2.demo_j
limit 10; 

--Lets perform a transformation 
SELECT 
    SEQN as 'patient_id',
    IF(RIAGENDR='1','Female', 'Male') AS 'Gender' 
from us_population_2.demo_j
limit 10;

--The ages are not whole integers, they appear to be floats lets change that and select a subgroup
SELECT 
SEQN as 'patient_id',
RIDAGEYR as 'age_years',
ROUND(RIDAGEYR) as 'age_years_round'
from us_population_2.demo_j
WHERE RIDAGEYR >= 21 && RIDAGEYR <= 65
limit 10; 

--Lets create a view that groups by gender and filters by age
CREATE VIEW temptab1 AS  
SELECT 
RIAGENDR as 'gender',
COUNT(*)
from us_population_2.demo_j
WHERE RIDAGEYR <= 21 && RIDAGEYR >=13 
GROUP BY RIAGENDR
limit 10; 

--Now lets work on some data from 2 different tables
select * 
from us_population_2.demo_j 
where SEQN = 93705;

select * 
from us_population_2.paq_j 
where SEQN = 93705;

select 
    d.SEQN as d_id, 
    p.SEQN as p_id 
from demo_j d
join paq_j p
where p.SEQN=d.SEQN
limit 5;

--Now we have a beautiful JOIN with information from 2 tables, but lets add a filter
select 
    d.SEQN as d_id, 
    d.RIDAGEYR as d_age,
    p.SEQN as p_id 
from demo_j d
join paq_j p
where p.SEQN=d.SEQN
limit 5; 

Use covid_19;

select * from coviddeaths;

select* from covidvaccinations;

select location,date,total_cases,new_cases,total_deaths,population
from coviddeaths
where continent is not null
order by location,date;

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_rate
from coviddeaths
where continent is not null
order by location,date;

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_rate
from coviddeaths
where location like "%India%" and continent is not null
order by location,date;

select location,date,total_cases,population,(total_cases/population)*100 as contracted_covid
from coviddeaths
where location like "%India%" and continent is not null
order by location,date;

Select  location, population, MAX(total_cases) as highest_infection_count,MAX( (total_cases/population))*100 AS per_pop_infected
From coviddeaths
Where continent is not null
Group by location, population
Order by per_pop_infected DESC; 

select continent, sum(new_deaths) as Total_death_count
from coviddeaths
where continent is not null
Group by continent
order by Total_death_count desc;

select location, sum(new_deaths) as Total_death_count
from coviddeaths
where continent is not null
Group by location
order by Total_death_count desc;

Select location, sum(new_deaths) as total_death_count
From coviddeaths
Where continent is  null
Group by location
Order by total_death_count DESC;

Select  SUM(new_cases) as total_new_cases, SUM(new_deaths) as total_new_deaths,( SUM(new_deaths)/SUM(new_cases)) *100 as gloabl_percentage
From coviddeaths
Where continent is not null;

Select  date,SUM(new_cases) as total_new_cases, SUM(new_deaths) as total_new_deaths,( SUM(new_deaths)/SUM(new_cases)) *100 as gloabl_percentage
From coviddeaths
Where continent is not null
group by date
order by date;

Select * 
From coviddeaths as cd
Inner Join covidvaccinations as cv
on cd.location = cv.location
and cd.date = cv.date;


Select cd.continent, cd.location, cd.date, cd.population, cd.total_deaths,cv.new_vaccinations,
SUM(cv.new_vaccinations) Over(partition by location Order by cd.location,date) as rolling_total_vaccinations 
From coviddeaths as cd                                        
Inner Join covidvaccinations as cv
on cd.location = cv.location
and cd.date = cv.date
Where cd.continent is not null
Order by 2,3;

With popvsvac as (
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(cv.new_vaccinations) Over(partition by location Order by cd.location,date) as rolling_total_vaccinations
From coviddeaths as cd                                        
Inner Join covidvaccinations as cv
on cd.location = cv.location
and cd.date = cv.date
Where cd.continent is not null
Order by 2,3)
Select *, (rolling_total_vaccinations/population) * 100 as percent_vaccinated
From popvsvac;


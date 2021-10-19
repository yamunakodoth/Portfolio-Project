select * 
from [Portfolio Project]..[covid deaths]
where continent is not null
order by 3,4


--select * 
--from [Portfolio Project]..[covid vaccinations]
--order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from [Portfolio Project]..[covid deaths]
where continent is not null
order by 1,2

--Total cases Vs Total Deaths
--shows likelyhood of dying if you contract covid in your country
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from [Portfolio Project]..[covid deaths]
where location like 'India'
order by 1,2

--looking total cases vs population

select location,date,population,total_cases,(total_cases/population)*100 as DeathPercentage
from [Portfolio Project]..[covid deaths]
where location like 'India'
order by 1,2

--looking for countries with highest infection rate compared to population

select location,population,MAX(total_cases) as HighestInfectionCount,(MAX(total_cases)/population)*100 as PercentPopulationInfected
from [Portfolio Project]..[covid deaths]
group by location,population
order by PercentPopulationInfected desc

--showing countries with highest death count per population

select location,MAX(cast (total_deaths as int)) as TotalDeathCount
from [Portfolio Project]..[covid deaths]
where continent is not null
group by location
order by TotalDeathCount desc


--breaking by continent 

select continent,MAX(cast (total_deaths as int)) as TotalDeathCount
from [Portfolio Project]..[covid deaths]
where continent is not null
group by continent
order by TotalDeathCount desc

--showing continents with highest death count per population


select continent,MAX(cast (total_deaths as int)) as TotalDeathCount
from [Portfolio Project]..[covid deaths]
where continent is not null
group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS


select date,sum(new_cases) as total_Cases,sum(cast(new_deaths as int)) as total_Deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from [Portfolio Project]..[covid deaths]
where continent is not null
group by date
order by 1,2

--total population vs vaccination 
with popvsvac (continent, location, date, population , new_vaccination , rollingpeoplevaccinated) as 
(
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location,
dea.date) as rollingpeoplevaccinated 
from [Portfolio Project]..[covid deaths] dea
Join [Portfolio Project]..[covid vaccinations] vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select * , (rollingpeoplevaccinated/population)*100
from popvsvac




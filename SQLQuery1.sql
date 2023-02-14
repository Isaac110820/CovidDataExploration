-- Select everthing from the covid deaths file and order by location and date
Select * 
from PortfolioProject..CovidDeaths
where continent is not null
order by 3, 4

--Select * 
--from PortfolioProject..CovidVaccinations
--order by 3, 4

-- Select Data that we are going to be using and order by location and date
Select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1, 2


-- Looking at the Total Cases vs Total Deaths in the United States. What percent of cases ended in death?
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1, 2

-- Looking at Total Cases vs Population.  What percent of the population got covid
-- Shows what percentage of the population got Covid
Select location, date, total_cases, (total_cases/population)*100 as CovidPercentage
from PortfolioProject..CovidDeaths
--where location = 'United States'
order by 1, 2

-- Looking at countries with the highest infection rate as a proportion of thier population with the highest proportion countires listed first
Select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population)*100) as PercentPopulationInfected
from PortfolioProject..CovidDeaths
group by location, population
order by PercentPopulationInfected desc

-- Looking at countries with the highest death rate as a proportion of thier population with the highest proportion countires listed first
Select location, max(total_deaths) as TotalDeathCount, max((total_deaths/population)*100) as PercentPopulationDeaths
from PortfolioProject..CovidDeaths
group by location, population
order by PercentPopulationDeaths desc

-- Looking at countries with the highest death rate.
Select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc

-- BREAKING IT DOWN BY CONTINENT
-- Looking at continents with the highest death rate.
Select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

-- Global numbers
select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, 
sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1, 2


-- Join the covid deaths table with the covid vaccinations table
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
,sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null 
order by 2, 3



--USE CTE
with PopvsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null 
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac


-- Creating view to store data for later visualizations
create view PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
,sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null 

select * 
from PercentPopulationVaccinated







Select *
from PortfolioProject..CovidDeaths
where continent is not null 
order by 3,4

--Select *
--from PortfolioProject..CovidVaccinations
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths 
order by 1,2

--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases, (total_deaths/total_cases) *100 as DeathPercentage
From PortfolioProject..CovidDeaths 
where location like '%africa%'
order by 1,2


--Looking at Total Cases vs Population
--Shows what percentage of population got covid

Select Location, date, Population, total_cases, (total_cases/population)*100 as DeathPercentage
From PortfolioProject..CovidDeaths 
where location like '%africa%'
order by 1,2

--Looking at Countries with Highest Infection Rate compared to Population

Select Location,Population, MAX(total_cases) as HighestInfectionCount, MAX(total_deaths/total_cases) *100 as
     PercentPopulationInfected
From PortfolioProject..CovidDeaths 
--where location like '%africa%'
Group by Location, Population 
order by PercentPopulationInfected desc


--Showing Countries with Highest Death Count per Population

Select Location, MAX(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths 
--where location like '%africa%'
where continent is not null
Group by Location 
order by TotalDeathCount desc


--LET'S BREAK THINGS DOWN BY CONTINENT

--Showing Continents with Highest Death Count per Population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths 
--where location like '%africa%'
where continent is not null
Group by continent 
order by TotalDeathCount desc


--GLOBAL NUMBERS 

Select Sum(new_cases), as total_cases, Sum(cast(new_deaths as int)) as total_deaths, Sum(cast,
    (new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths 
--where location like '%africa%'
where continent is not null
order by 1,2

--Looking at Total Population vs Vaccinations

--USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
  dea.date) as RollingPeopleVaccinated
  , (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date 
where dea.continent is not null
order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac 



--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated 
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, vac.new_vaccinations
, Sum(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
  dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date 
where dea.continent is not null
--order by 2,3

--Creating view to store data for later visualization

Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
  dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date 
where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated





















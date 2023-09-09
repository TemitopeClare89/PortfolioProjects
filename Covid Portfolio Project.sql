Select *
from PortfolioProject..CovidDeaths
where continent is not null 
order by 3,4

--Select *
--from PortfolioProject..CovidVaccinations
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths 
From PortfolioProject..CovidDeaths 
order by 1,2

Select Location, date, total_cases, (total_deaths/total_cases) *100 as DeathPercentage
From PortfolioProject..CovidDeaths 
--where location like '%states%'
order by 1,2

Select Location, MAX(total_cases) as HighestInfectionCount, MAX(total_deaths/total_cases) *100 as
     PercentPopulationInfected
From PortfolioProject..CovidDeaths 
--where location like '%states%'
Group by Location 
order by PercentPopulationInfected desc

Select Location, MAX(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths 
--where location like '%states%'
where continent is not null
Group by Location 
order by TotalDeathCount desc


Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths 
--where location like '%states%'
where continent is not null
Group by continent 
order by TotalDeathCount desc

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths 
--where location like '%states%'
where continent is not null
Group by continent 
order by TotalDeathCount desc

Select Sum(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths, Sum(cast,
    (new_deaths as bigint))/Sum(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths 
--where location like '%states%'
where continent is not null
order by 1,2

(
Select dea.continent, dea.location, dea.date, vac.new_vaccinations
, Sum(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
  dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date 
where dea.continent is not null
order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac 

--Temp Table

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
Select dea.continent, dea.location, dea.date, vac.new_vaccinations
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





















/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
  FROM [PortfolioProject].[dbo].[CovidVaccination]
  order by 3,4

  select *
  from PortfolioProject..CovidVaccination
  order by 3,4

  -- Select DAta that we are going to be using

  select Location, date, total_cases, new_cases, total_deaths, population
  from PortfolioProject..CovisDeaths
  order by 1,2

  -- Looking at Total Cases vs Total Deaths
  -- shows likelihood of dying if you contract covid in your country

  select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
  from PortfolioProject..CovisDeaths
  Where location like '%states%'
  order by 1,2

  -- looking at the Tota Cases vs Population
  -- percentage of population with covid

  select Location, date, Population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
  from PortfolioProject..CovisDeaths
  --Where location like '%states%'

  --order by 1,2

  -- Looking at Countries with Highest Infection Rate compared to Population

  select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
  from PortfolioProject..CovisDeaths
  --Where location like '%states%'
  Group by Location, Population
  order by PercentPopulationInfected desc

  -- Countries with Highest Death Count per Population
  select Location, Max(cast(total_deaths as int)) as TotalDeathCount
  from PortfolioProject..CovisDeaths
  Where continent is not null
  Group by Location
  order by TotalDeathCount desc

  --break things down by continent
  Select Location, Max(cast(total_deaths as int)) as TotalDeathCount
  from PortfolioProject..CovisDeaths
  Where continent is null
  Group by Location
  order by TotalDeathCount desc

  Select continent, Max(cast(total_deaths as int)) as TotalDeathCount
  from PortfolioProject..CovisDeaths
  Where continent is not null
  Group by continent
  order by TotalDeathCount desc

  -- continents with highest death count per population
  Select continent, Max(cast(total_deaths as int)) as TotalDeathCount
  From PortfolioProject..CovisDeaths
  Where continent is not null
  Group by continent
  order by TotalDeathCount desc

  -- Global numbers
  Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast
  (new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
  from PortfolioProject..CovisDeaths
  Where continent is not null
  order by 1,2


-- looking at total population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_Vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated,
jj j 
From PortfolioProject..CovisDeaths dea
Join PortfolioProject..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3
  

  -- Creating View to store data for later visualization

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations))
OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovisDeaths dea
Join PortfolioProject..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null


select *
From PercentPopulationVaccinated

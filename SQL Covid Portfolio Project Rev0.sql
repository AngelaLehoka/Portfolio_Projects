
-- DATA EXPLORATION OF COVID-19

-- Data source: OWID
-- Date sourced: 26 April 2022


-- Select the data that I am going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProjectCovid..CovidDeaths
WHERE continent is not null
ORDER BY 1,2

-- What is the total death percentage in relation to the population?

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProjectCovid..CovidDeaths
WHERE continent is not null
ORDER BY 1,2

-- What is the total death percentage in relation to the population in South Africa?

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProjectCovid..CovidDeaths
WHERE location='South Africa' AND continent is not null
ORDER BY 1,2


-- What is the percentage of the population who contracted Covid-19?

SELECT location, date, total_cases, total_deaths, population, (total_cases/population)*100 as CasePercentage
FROM PortfolioProjectCovid..CovidDeaths
WHERE continent is not null
ORDER BY 1,2

-- What is the percentage of the population who contracted Covid-19 in South Africa?

SELECT location, date, total_cases, total_deaths, population, (total_cases/population)*100 as CasePercentage
FROM PortfolioProjectCovid..CovidDeaths
WHERE location='South Africa' AND continent is not null
ORDER BY 1,2


-- What is the percentage of the population who contracted Covid-19 in South Africa?

SELECT location, date, total_cases, total_deaths, population, (total_cases/population)*100 as CasePercentage
FROM PortfolioProjectCovid..CovidDeaths
WHERE location='South Africa' AND continent is not null
ORDER BY 1,2

-- What country has the highest infection rate in relation to the population?

SELECT location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as HighestInfectionRate
FROM PortfolioProjectCovid..CovidDeaths
WHERE continent is not null
GROUP BY location, population
ORDER BY HighestInfectionRate DESC

-- What country has the highest death count in relation to the population?

SELECT location, max(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProjectCovid..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Breaking things down by continent


-- Showing the continents with the highest deaths counts

SELECT continent, max(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProjectCovid..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC


-- What are the global numbers?

-- Sum of cases per day

SELECT date, sum(total_cases)
FROM PortfolioProjectCovid..CovidDeaths as GlobalCases
WHERE continent is not null
GROUP BY date
ORDER BY 1,2

-- Sum of deaths per day

SELECT date, sum(cast(total_deaths as int)) as GlobalDeaths
FROM PortfolioProjectCovid..CovidDeaths
WHERE continent is not null
GROUP BY date
ORDER BY 1,2


-- Global death rate per day

SELECT date, sum(new_cases) as NewCases, sum(cast(new_deaths as int)) as NewDeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as GlobalDeathRate
FROM PortfolioProjectCovid..CovidDeaths
WHERE continent is not null
GROUP BY date
ORDER BY 1,2

-- Global death rate

SELECT sum(new_cases) as NewCases, sum(cast(new_deaths as int)) as NewDeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as GlobalDeathRate
FROM PortfolioProjectCovid..CovidDeaths
WHERE continent is not null
ORDER BY 1,2


-- join the 2 tables together

SELECT *
FROM PortfolioProjectCovid..CovidDeaths dea
Join PortfolioProjectCovid..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date

	-- look at population vs vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location ORDER BY dea.date) as CumulativeVaccinated
FROM PortfolioProjectCovid..CovidDeaths dea
Join PortfolioProjectCovid..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

-- use CTE 


WITH PopvsVac (continent, location, date, population, new_vaccinations, CumulativeVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location ORDER BY dea.date) as CumulativeVaccinated
FROM PortfolioProjectCovid..CovidDeaths dea
Join PortfolioProjectCovid..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
)
SELECT * , (CumulativeVaccinated/population)*100 as PercentageVaccinated
FROM PopvsVac


-- use temp tables

DROP table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255), 
date datetime, 
population int, 
new_vaccinations bigint, 
CumulativeVaccinated bigint
)
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location ORDER BY dea.date) as CumulativeVaccinated
FROM PortfolioProjectCovid..CovidDeaths dea
Join PortfolioProjectCovid..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null

SELECT *
FROM #PercentPopulationVaccinated



-- creating view to store data for later visualization

Create view PercentPopulationVaccinated as

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location ORDER BY dea.date) as CumulativeVaccinated
FROM PortfolioProjectCovid..CovidDeaths dea
Join PortfolioProjectCovid..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null



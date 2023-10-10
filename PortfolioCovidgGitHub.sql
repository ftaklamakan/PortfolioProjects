-- Exploring 2020-2021 Covid Global Data 

SELECT *

	FROM PortfolioProject.CovidDeaths

    order by 3,4;
--     
-- SELECT *

-- 	FROM PortfolioProject.covidvaccination
--     order by 3,4
--     
-- Selecting data that we are going to use


Select location, date, total_cases, new_cases, total_deaths, population
	FROM PortfolioProject.CovidDeaths
    order by 1,2;
    total_deaths
-- looking at Total Cases vs Total Deaths
-- shows likelihood of dying if you contact covid in your country
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
	FROM PortfolioProject.CovidDeaths
    WHERE location like '%France%'
    order by 1,2;
    
-- looking at Total Cases vs Population
Select location, date, population, total_cases, total_deaths, (total_deaths/population)*100 as DeathPercentage
	FROM PortfolioProject.CovidDeaths
    WHERE location like '%France%'
    order by 1,2;
    
-- looking at countries highest infection rate compared to population
Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as InfectionPercentage
	FROM PortfolioProject.CovidDeaths
    
    GROUP BY location, population
    order by InfectionPercentage DESC;
    
    
-- -- looking at countries with highest death rate 
SELECT location, SUM(new_deaths) AS totalDeaths
	FROM PortfolioProject.CovidDeaths
	WHERE length(continent) > 0
    GROUP BY location
    order by totalDeaths DESC;
    
    
    -- -- looking at countries with highest death per population 

    SELECT location, SUM(new_deaths) AS totalDeaths, (SUM(new_deaths)/MAX(population))*100 as DeathPercentage, MAX(population)
	FROM PortfolioProject.CovidDeaths
	WHERE length(continent) > 0 
    GROUP BY location
    order by totalDeaths DESC;
    
    - -- looking at regions with highest death per population  - region , where continent is empty and location indicated as the region, but the case is not valid for asia

		SELECT location, SUM(new_deaths) AS totalDeaths, (SUM(new_deaths)/MAX(population))*100 as DeathPercentage, MAX(population)
		FROM PortfolioProject.CovidDeaths
		WHERE length(continent) < 1 
        GROUP BY location
		order by totalDeaths DESC;
        
        -- asia information is different, no 'only asia contient info'
        
	SELECT continent, SUM(new_deaths) AS totalDeaths, (SUM(new_deaths)/MAX(population))*100 as DeathPercentage, MAX(population)
		FROM PortfolioProject.CovidDeaths
		-- WHERE length(continent) < 1 OR -- 
        WHERE continent is not null
        GROUP BY continent 
		order by totalDeaths DESC;
        
	-- GLOBAL INFO
SELECT date, SUM(new_cases) as totalCases, SUM(new_deaths) AS totalDeaths, (SUM(new_deaths)/MAX(population))*100 as DeathPercentage
	FROM PortfolioProject.CovidDeaths
-- WHERE length(continent) < 1 OR -- 
	WHERE continent is not null
	GROUP BY date 
	order by 1,2;
    
    
    
-- Vaccinations Join
	SELECT *
	FROM PortfolioProject.coviddeaths dea
    JOIN PortfolioProject.covidvaccinations vac
		ON dea.location = vac.location
        and dea.date = vac.date
        
-- looking at Total Population vs Vaccinations
    SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	FROM PortfolioProject.coviddeaths dea
    JOIN PortfolioProject.covidvaccinations vac
		ON dea.location = vac.location
        and dea.date = vac.date
	WHERE length(dea.continent) > 0
		order by 2,3;

-- looking at Total Population vs Vaccinations
-- total vaccination
-- multiple vaccinations, so more than > 100% 
-- CONVERT(int, vac.new_vaccinations)
    SELECT dea.location, SUM(vac.new_vaccinations), MAX(dea.population), (SUM(vac.new_vaccinations)/MAX(dea.population))*100
	FROM PortfolioProject.coviddeaths dea
    JOIN PortfolioProject.covidvaccinations vac
		ON dea.location = vac.location
        and dea.date = vac.date
	WHERE length(dea.continent) > 0
    GROUP BY dea.location
		order by 4 DESC;
        
-- add over rolling count
  SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
	FROM PortfolioProject.coviddeaths dea
    JOIN PortfolioProject.covidvaccinations vac
		ON dea.location = vac.location
        and dea.date = vac.date
	WHERE length(dea.continent) > 0
		order by 2,3;
        


-- CTE
-- CTE number of columns should be same with inner data
With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
  SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
	FROM PortfolioProject.coviddeaths dea
    JOIN PortfolioProject.covidvaccinations vac
		ON dea.location = vac.location
        and dea.date = vac.date
	WHERE length(dea.continent) > 0
	-- order by 2,3;
        )
SELECT *, (RollingPeopleVaccinated/population)*100 as VaccinatedPopulationPerc
FROM PopvsVac
        
-- TEMP table :

DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent varchar(255),
location varchar(255),
date varchar(255),
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
  SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
	FROM PortfolioProject.coviddeaths dea
    JOIN PortfolioProject.covidvaccinations vac
		ON dea.location = vac.location
        and dea.date = vac.date
	-- WHERE length(dea.continent) > 0
	-- order by 2,3;
        
SELECT *, (RollingPeopleVaccinated/population)*100 as VaccinatedPopulationPerc
FROM #PercentPopulationVaccinated
  
  
  -- create a VIEW to store data for later visualizations

Create VIEW PercentPopulationVaccinated AS
  SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.locatiopercentpopulationvaccinatedn, dea.date) AS RollingPeopleVaccinated
	FROM PortfolioProject.coviddeaths dea
    JOIN PortfolioProject.covidvaccinations vac
		ON dea.location = vac.location
        and dea.date = vac.date
	WHERE length(dea.continent) > 0
	-- order by 2,3;
    
    
    
-- VIEW QUERY

SELECT *
FROM PercentPopulationVaccinated
        

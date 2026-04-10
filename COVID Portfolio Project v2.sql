SELECT *
FROm PortfolioProject..covidDeaths$
WHERE continent is Not NULL
ORDER BY 3,4

SELECT *
FROm PortfolioProject..CovidVaccinations$
ORDER BY 3,4

SELECT location, date,total_cases,new_cases,total_deaths,population
FROM PortfolioProject..covidDeaths$
ORDER BY 3,4

SELECT location, date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..covidDeaths$
ORDER BY 1,2

SELECT location, date,total_cases,population,(total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..covidDeaths$
WHERE Location Like '%India%'
ORDER BY 1,2

SELECT location, date,total_cases,population,(total_cases/population)*100 as PercentPopulationInfected
FROM PortfolioProject..covidDeaths$
--WHERE Location Like '%India%'
ORDER BY 1,2

SELECT location,population,MAX(total_cases) as HighestInfectionCount,MAX((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject..covidDeaths$
--WHERE Location Like '%India%'
GROUP BY location,population
ORDER BY PercentPopulationInfected desc

SELECT location,MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..covidDeaths$
--WHERE Location Like '%India%'
GROUP BY location
ORDER BY TotalDeathCount desc

SELECT location,MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..covidDeaths$
--WHERE Location Like '%India%'
WHERE Continent is Not NUll
GROUP BY location
ORDER BY TotalDeathCount desc

SELECT continent,MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..covidDeaths$
--WHERE Location Like '%India%'
WHERE Continent is Not NUll
GROUP BY continent
ORDER BY TotalDeathCount desc

SELECT location,MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..covidDeaths$
--WHERE Location Like '%India%'
WHERE Continent is NUll
GROUP BY location
ORDER BY TotalDeathCount desc 

SELECT SUM(new_cases) as total_cases,SUM(CAST(new_deaths as int)) as total_deaths,SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..covidDeaths$
--WHERE Location Like '%India%'
WHERE Continent is not Null
ORDER BY 1,2

   SELECT *
   FROM PortfolioProject..CovidVaccinations$

   
 SELECT *
FROM PortfolioProject..covidDeaths$ dea
JOIN PortfolioProject..covidVaccinations$ vac
ON dea.location=vac.location
and dea.date=vac.date


 SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
FROM PortfolioProject..covidDeaths$ dea
JOIN PortfolioProject..covidVaccinations$ vac
ON dea.location=vac.location
and dea.date=vac.date
Where dea.continent is not null
ORDER BY 2,3


 SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(CONVERT(int, vac.new_vaccinations )) OVER (partition by dea.location ORDER BY dea.location,dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..covidDeaths$ dea
ON dea.location=vac.location
and dea.date=vac.date
Where dea.continent is not null
ORDER BY 2,3


WITH PopvsVac(continent,location,Date,Population,New_Vaccinations,RollingPeopleVaccinated)
as
(
 SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(CONVERT(int, vac.new_vaccinations )) OVER (partition by dea.location ORDER BY dea.location,dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..covidDeaths$ dea
JOIN PortfolioProject..covidVaccinations$ vac
ON dea.location=vac.location
and dea.date=vac.date
Where dea.continent is not null
)

SELECT *,(RollingPeopleVaccinated/Population)*100
FROM PopVSVac

DROP TABLE IF exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
 SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(CONVERT(int, vac.new_vaccinations )) OVER (partition by dea.location ORDER BY dea.location,dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths$ dea
JOIN PortfolioProject..CovidVaccinations$ vac
ON dea.location=vac.location
and dea.date=vac.date
--Where dea.continent is not null

SELECT *,(RollingPeopleVaccinated / Population)*100
FROM #PercentPopulationVaccinated

 CREATE View PercentPopulationVaccinated as
 SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(CONVERT(int, vac.new_vaccinations )) OVER (partition by dea.location ORDER BY dea.location,dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths$ dea
JOIN PortfolioProject..CovidVaccinations$ vac
ON dea.location=vac.location
and dea.date=vac.date
Where dea.continent is not null

SELECT *
FROM PercentPopulationVaccinated
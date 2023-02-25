SELECT *
FROM CovidDeaths$
WHERE continent is not null
ORDER BY 3,4

--SELECT *
--FROM CovidVaccinations$
--ORDER BY 3,4

-- Selecting Data that is going to be used

SELECT location,date, total_cases,new_cases,total_deaths, population
FROM CovidDeaths$
WHERE continent is not null
ORDER BY 1,2

-- Looking at Total Cases vs Total Deaths

SELECT location,date, total_cases, total_deaths, ROUND((total_deaths / total_cases) *100,2) as Death_Pct
FROM CovidDeaths$
WHERE location like '%states%' and continent is not null
ORDER BY 1,2  
-- Shows what percentage of infected patients died from covid


-- Looking at Total Cases vs Population

SELECT location,date, total_cases, population, (total_cases / population) *100  as Cases_Pct
FROM CovidDeaths$
ORDER BY 1,2
-- Shows what percentage of the total population is infected with covid


-- Looking at countries with highest infection rate compared to population

SELECT location, MAX(total_cases) as HighestInfectionCount, population, MAX((total_cases) / population) *100  as Population_Pct
FROM CovidDeaths$
GROUP BY location,population
ORDER BY Population_Pct desc
-- Shows highest percentages of Infected by Location



-- Looking at countries with highest death count

SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM CovidDeaths$
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc
-- Shows the United States has the highest death count


-- Showing contintents with the highest death count per population

Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeaths$
WHERE continent is null
Group by location
order by TotalDeathCount desc
--Shows Europe has the highest death count



-- Looking at global numbers (total_cases, total_deaths and death pct)

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as Death_Pct
From CovidDeaths$
where continent is not null 
order by 1,2
-- Shows the total death percent of the whole world is 2.11%



-- Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths$ dea
Join CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3
-- Shows Percentage of Population that has recieved at least one Covid Vaccine



-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths$ dea
Join CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
SELECT *, (RollingPeopleVaccinated/Population)*100 AS Vaccinated_Pct
FROM PopvsVac



 
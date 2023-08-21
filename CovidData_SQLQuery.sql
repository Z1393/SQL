SELECT *
FROM coviddata..Deaths
order by 3,4


--SELECT *
--FROM coviddata..Vaccinations
--order by 3,4

SELECT location,date, new_cases, total_deaths, population
FROM coviddata..Deaths
order by 1,2




-- Total Cases vs Population
-- Shows what percentage of population infected with Covid
Select location, date, population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
FROM coviddata..Deaths
Where location like '%Pakistan%'
order by 1,2

-- Countries with Highest Infection Rate compared to Population
Select location, population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
FROM coviddata..Deaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

-- Countries with Highest Death Count per Population
Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM coviddata..Deaths
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc

-- BREAKING THINGS DOWN BY CONTINENT
-- Showing contintents with the highest death count per population
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM coviddata..Deaths
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc

-- GLOBAL NUMBERS across the world cases,deaths and deaths percentages
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM coviddata..Deaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

--Total population VS vaccination using joins,partitions 
Select Deaths.continent, Deaths.location, Deaths.date, Deaths.population, Vaccinations.new_vaccinations, SUM(CONVERT(BIGINT, Vaccinations.new_vaccinations))
OVER (Partition by Deaths.location )as PeopleVaccinated
FROM coviddata..Deaths
join coviddata..Vaccinations
on Deaths.location= Vaccinations.location
and Deaths.date= Vaccinations.date
where Deaths.continent is not null
order by 2,3

-- Using CTE to perform Calculation on Partition By in previous query
With PopvsVac (Continent, location, date, Population, New_Vaccinations, PeopleVaccinated)
as
(
Select Deaths.continent, Deaths.location, Deaths.date, Deaths.population, Vaccinations.new_vaccinations
, SUM(CONVERT(BIGINT, Vaccinations.new_vaccinations)) OVER (Partition by Deaths.location ) as PeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM coviddata..Deaths
join coviddata..Vaccinations
on Deaths.location= Vaccinations.location
and Deaths.date= Vaccinations.date
where Deaths.continent is not null 
)
Select *, (PeopleVaccinated/population)*100
From PopvsVac

--Temp Table

DROP TABLE if exists #PercentPopulationVaccinated

CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
PeopleVaccinated numeric
)
INSERT into #PercentPopulationVaccinated
Select Deaths.continent, Deaths.location, Deaths.date, Deaths.population, Vaccinations.new_vaccinations
, SUM(CONVERT(BIGINT, Vaccinations.new_vaccinations)) OVER (Partition by Deaths.location ) as PeopleVaccinated
FROM coviddata..Deaths
join coviddata..Vaccinations
on Deaths.location= Vaccinations.location
and Deaths.date= Vaccinations.date
where Deaths.continent is not null 
Select *, (PeopleVaccinated/population)*100
From #PercentPopulationVaccinated



-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated1 as
Select Deaths.continent, Deaths.location, Deaths.date, Deaths.population, Vaccinations.new_vaccinations
, SUM(CONVERT(int,Vaccinations.new_vaccinations)) OVER (Partition by Deaths.Location ) as PeopleVaccinated

From coviddata..Deaths 
Join coviddata..Vaccinations 
	On Deaths.location = Vaccinations.location
	and Deaths.date = Vaccinations.date
where Deaths.continent is not null 



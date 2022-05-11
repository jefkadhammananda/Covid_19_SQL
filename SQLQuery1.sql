Select *
From PortofolioProject..CovidDeaths
Where continent is not null 
order by 3,4


-- melihat dataset

Select Location, date, total_cases, new_cases, total_deaths, population
From PortofolioProject..CovidDeaths
Where continent is not null 
order by 1,2


-- melihat hubungan Total Cases vs Total Deaths pada negara united states

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortofolioProject..CovidDeaths
Where location like '%states%'
and continent is not null 
order by 1,2


-- melihat hubungan total cases dengan population

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From PortofolioProject..CovidDeaths
order by 1,2


-- melihat negara yang paling banyak terinfeksi virus terhadap populasi 

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortofolioProject..CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc

-- melihat negara dengan total kematian akibat virus terbanyak

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortofolioProject..CovidDeaths
Where continent is not null 
Group by Location
order by TotalDeathCount desc

-- melihat total kematian terbanyak terhadap continents 

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortofolioProject..CovidDeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc


-- melihat data secara global

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortofolioProject..CovidDeaths
where continent is not null 
order by 1,2

-- menunjukan persentasi dari populasi yang menerima paling tidak 1 vaksin

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortofolioProject..CovidDeaths dea
Join PortofolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- menggunakan CTE untuk melakukan kalkulasi partisi pada query sebelumnya

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortofolioProject..CovidDeaths dea
Join PortofolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


-- menggunakan temp table untuk melakukan kalkulasi partisi pada query sebelumnya

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
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortofolioProject..CovidDeaths dea
Join PortofolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date


Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



-- membuat view

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortofolioProject..CovidDeaths dea
Join PortofolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

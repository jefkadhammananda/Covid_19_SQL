
--menjalankan tiap query dan melakukan copy table hasil query dan paste ke excel
--pada query ini ganti nilai NULL yang ada menjadi nilai 0 agar tipe data nya menjadi numerik

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortofolioProject..CovidDeaths
where continent is not null 

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortofolioProject..CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortofolioProject..CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc

Select Location, Population, date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortofolioProject..CovidDeaths
Group by Location, Population, date
order by PercentPopulationInfected desc

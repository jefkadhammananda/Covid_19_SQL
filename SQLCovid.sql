-- melihat dataset

Select *
From PortofolioProject..CovidDeaths
order by 2

Select Location, date, total_cases, new_cases, total_deaths, population
From PortofolioProject..CovidDeaths
Where continent is not null 
order by 1,2

-- melihat persentase kematian dari orang yang terkena kasus covid untuk negara indonesia

Select Location, date, total_deaths,total_cases, (total_deaths/total_cases)*100 as DeathPercentage
From PortofolioProject..CovidDeaths
Where location like 'indonesia' and total_deaths is not null
order by 2

-- melihat persentase orang yang terinfeksi terhadap keseluruhan populasi untuk negara indonesia

Select Location, date, total_cases, Population,  (total_cases/population)*100 as PercentPopulationInfected
From PortofolioProject..CovidDeaths
Where location like 'indonesia'
order by 2

-- melihat persentase negara yang warga negaranya paling banyak terinfeksi virus terhadap populasinya

Select Location, Population, date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortofolioProject..CovidDeaths
Group by Location, Population, date
order by PercentPopulationInfected desc

-- melihat negara dengan total kematian warganya akibat covid yang terbanyak
-- menggunakan cast untuk mengganti tipe data menjadi integer

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

-- melihat persentase kematian terhadap kasus covid secara global

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortofolioProject..CovidDeaths
where continent is not null 

-- melihat total jumlah orang yang sudah divaksinasi pada setiap negara
-- melakukan join tabel CovidDeaths dengan CovidVaccinations
-- menggunakan query 'partition by' agar perhitungan vaksinasi menggunakan SUM dapat dihitung berdasarkan setiap negara

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortofolioProject..CovidDeaths dea
Join PortofolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

-- melihat persentase orang yang sudah melakukan vaksinasi terhadap populasi di setiap negara
-- menggunakan CTE, fungsi pertama untuk melihat jumlah orang yang sudah divaksinasi pada setiap negara dan selanjutnya dilakukan perhitungan persentase terhadap populasi dari negara tersebut

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortofolioProject..CovidDeaths dea
Join PortofolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
From PopvsVac

-- membuat view pada SQL

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortofolioProject..CovidDeaths dea
Join PortofolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 



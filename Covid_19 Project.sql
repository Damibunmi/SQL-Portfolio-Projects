SELECT * FROM dbo.CovidDeaths
ORDER BY 3,4

SELECT * FROM dbo.CovidVaccinations
ORDER BY 3,4

---Selecting Relevant Data to Use

SELECT location,
       date,
       total_cases,
       new_cases,
       total_deaths,
       population
FROM dbo.CovidDeaths
 

---DECLARE @ConvertedDate DATE = CONVERT(DATE, 'date', 120)

--- Total Cases and Total Deaths by Country and Year
SELECT DISTINCT location,
       YEAR([date]) AS Year,
       SUM (total_cases) AS TotalCases,
       SUM (total_deaths) AS TotalDeaths,
       SUM (population) AS TotalPopulation
       ---SUM (total_deaths/total_cases)*100 AS DeathPercentage
FROM dbo.CovidDeaths
    GROUP BY location, YEAR([date])
        ORDER BY 1

---Total cases & Total Death vs Total Population in Africa
SELECT location,
       date,
       population,
       total_cases,
       total_deaths,
       (total_cases/population)*100 AS CasesPercentage,
       (total_deaths/total_cases)*100 AS DeathPercentage
FROM dbo.CovidDeaths
    WHERE location = 'Africa'
        ORDER BY 2

---TOP 10 COUNTIRES WITH THE HIGHEST COVID CASES 2020
SELECT TOP 20 
       location,
       YEAR([date]) AS Year,
       SUM(population) AS TotalPopulation,
       SUM(total_cases) AS TotalCases
FROM dbo.CovidDeaths
    WHERE continent  IS NOT NULL  AND YEAR([date]) = '2020'
    Group BY location, YEAR([date])
        ORDER BY TotalCases DESC
        

---DAILY PERCENTAGE INCREASE IN NEW CASES
SELECT date,
       population,
       new_cases AS PreviousCases,
       LEAD(new_cases,1) OVER (ORDER BY date) AS NextdayCases,
       (LEAD(new_cases,1) OVER (ORDER BY date)-new_cases)/NULLIF(new_cases, 0)*100 AS PercentageIncreaseNewcase
FROM dbo.CovidDeaths
    WHERE location = 'Africa'
        ORDER BY 1

    
---DAILY PERCENTAGE INCREASE IN DEATH CASES
SELECT date,
       population,
       new_deaths AS NextdayDeath,
       LAG(new_deaths,1) OVER (ORDER BY date) AS PreviousDayDeath,
       (new_deaths-LAG(new_deaths,1) OVER (ORDER BY date))/NULLIF(LAG(new_deaths,1) OVER (ORDER BY date), 0)*100 AS PercentageIncreaseDeathcase
FROM dbo.CovidDeaths
    WHERE location = 'Africa'
        ORDER BY 1

---TOTAL POPULATION VACCINATED
SELECT d.location,
       YEAR(v.[date]) AS Year,
       SUM(d.population) AS TotalPopulation,
       SUM(v.total_vaccinations) AS TotalVaccinated 
FROM dbo.CovidDeaths d
JOIN dbo.CovidVaccinations v 
    ON d.iso_code = v.iso_code
GROUP BY d.[location], YEAR(v.[date])
    ORDER BY 1,2













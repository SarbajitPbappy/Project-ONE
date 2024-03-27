-- Show the translated data
SELECT * FROM city_population_translated;

-- Rename the 'Abbr.' column to 'Abbreviation'
ALTER TABLE `city_population_translated` CHANGE COLUMN `Abbr.` abbreviation VARCHAR(255);

-- Rename the 'Abbr.' column to 'Abbreviation'
ALTER TABLE `city_population_translated` CHANGE COLUMN `Area(Km^2)` Area VARCHAR(255);

-- Show the all Division and their district and sort them Descending order
SELECT Division, COUNT(Name) AS Districts_Count
FROM city_population_translated
GROUP BY Division
ORDER BY COUNT(Name) DESC;

-- Sort Division By established Date Ascending
SELECT Division, Established FROM city_population_translated
ORDER BY Established ASC;

-- Showing the district that are established in same year
SELECT 
  Established, 
  GROUP_CONCAT(Name ORDER BY Name SEPARATOR ', ') AS Districts,
  COUNT(Name) AS Total
FROM city_population_translated
GROUP BY Established
HAVING COUNT(Name) > 1
UNION ALL
SELECT 
  'All Years', 
  'Overall Total', 
  (SELECT COUNT(*) 
   FROM city_population_translated
   WHERE Established IN (
       SELECT Established
       FROM city_population_translated
       GROUP BY Established
       HAVING COUNT(*) > 1)
  ) AS Total
FROM DUAL;

-- Showing the district that are established in distinct year year
SELECT 
  Established, 
  GROUP_CONCAT(Name ORDER BY Name SEPARATOR ', ') AS Districts,
  COUNT(Name) AS Total
FROM city_population_translated
GROUP BY Established
HAVING COUNT(Name) = 1
UNION ALL
SELECT 
  'All Unique Years' AS Established, 
  'Total Districts in Unique Years' AS Districts, 
  COUNT(*) AS Total
FROM (
  SELECT Established
  FROM city_population_translated
  GROUP BY Established
  HAVING COUNT(Name) = 1
) AS UniqueYears;

-- Showing the area in Square Killo-meter district wise
-- The area column is stored as a VARCHAR type insted of INT
-- As I am casting it to Decimal Type To Sort Them Correctly
SELECT 
  Name AS District, 
  CAST(Area AS DECIMAL(10,2)) AS Area
FROM city_population_translated
ORDER BY CAST(Area AS DECIMAL(10,2)) ASC;

-- Showing the result of Area in km^2 According to the Division
SELECT 
  Division, 
  SUM(Area) AS TotalAreaKm2
FROM city_population_translated
GROUP BY Division
ORDER BY TotalAreaKm2 DESC;

-- Showing The Result of overall Area Of Bangladesh
SELECT 
  SUM(Area) AS TotalAreaKm2
FROM city_population_translated;

-- Population Sector
-- District Wise Population Sort 1991
SELECT 
  Name AS District, 
  Population_1991
FROM city_population_translated
ORDER BY Population_1991 DESC;

-- Division Wise Sort
SELECT 
  Division AS Name, 
  SUM(Population_1991) AS Total_Population
FROM city_population_translated
GROUP BY Division
ORDER BY Total_Population DESC;

-- Total Population Of Bangladesh in 1991
SELECT 
  SUM(Population_1991) AS Total_Population_1991
FROM city_population_translated;

-- District Wise Population Sort 2001
SELECT 
  Name AS District, 
  Population_2001
FROM city_population_translated
ORDER BY Population_2001 DESC;

-- Division Wise Sort
SELECT 
  Division AS Name, 
  SUM(Population_2001) AS Total_Population
FROM city_population_translated
GROUP BY Division
ORDER BY Total_Population DESC;

-- Total Population Of Bangladesh in 2001
SELECT 
  SUM(Population_2001) AS Total_Population_2001
FROM city_population_translated;

-- Population Growrth Rate
-- District-Wise Growth Rate
SELECT 
  Name AS District, 
  Division, 
  Population_2001, 
  Population_1991, 
  ((Population_2001 - Population_1991) / Population_1991) * 100 AS Growth_Rate_Percent
FROM city_population_translated
ORDER BY Growth_Rate_Percent DESC;

-- Division-Wise Growth Rate
SELECT 
  Division, 
  SUM(Population_2001) AS Total_Population_2001, 
  SUM(Population_1991) AS Total_Population_1991, 
  ((SUM(Population_2001) - SUM(Population_1991)) / SUM(Population_1991)) * 100 AS Growth_Rate_Percent
FROM city_population_translated
GROUP BY Division
ORDER BY Growth_Rate_Percent DESC;

-- Overall Bangladesh Growth Rate
SELECT 
  ((SUM(Population_2001) - SUM(Population_1991)) / SUM(Population_1991)) * 100 AS Growth_Rate_Percent
FROM city_population_translated;

-- Highest populated District Along with Division 2001
SELECT 
  Name AS District, 
  Division, 
  Population_2001
FROM city_population_translated
ORDER BY Population_2001 DESC
LIMIT 15;

-- Population Density of 2001 Base 16 People / Square Kilometer
SELECT 
  Name AS District, 
  Division,
  Population_2001,
  Area,
  (Population_2001 / Area) AS DensityPerSqKm
FROM city_population_translated
WHERE Area > 0 AND Population_2001 / Area > 16
ORDER BY DensityPerSqKm DESC
LIMIT 10;

-- Not Over Populated Area
SELECT 
  Name AS District, 
  Division,
  Population_2001,
  Area AS Area,
  (Population_2001 / Area) AS DensityPerSqKm
FROM city_population_translated
WHERE Area > 0 AND (Population_2001 / Area) <= 16
ORDER BY DensityPerSqKm
LIMIT 10;

-- Conclude that All the Area of Bangladesh is over populated on the basis of 16 people 
-- for each square kilometer in 2001

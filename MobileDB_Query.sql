SELECT * FROM mobiles

--View total rows in the dataset
SELECT COUNT(*) AS Total_Rows FROM mobiles

--View total columns in the dataset
SELECT COUNT(*) as Total_Columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'mobiles'

--Count the number of null values in the dataset
SELECT 
    SUM(CASE WHEN Company_Name IS NULL THEN 1 ELSE 0 END) AS Company_Name_Count,
    SUM(CASE WHEN Model_Name IS NULL THEN 1 ELSE 0 END) AS Model_Name_Count,
	SUM(CASE WHEN Mobile_Weight_g IS NULL THEN 1 ELSE 0 END) AS Mobile_Weight_Count,
	SUM(CASE WHEN RAM_GB IS NULL THEN 1 ELSE 0 END) AS RAM_COUNT,
	SUM(CASE WHEN Front_Camera IS NULL THEN 1 ELSE 0 END) AS Front_Camera_Count,
	SUM(CASE WHEN Back_Camera IS NULL THEN 1 ELSE 0 END) AS Back_Camera_Count,
	SUM(CASE WHEN Processor IS NULL THEN 1 ELSE 0 END) AS Processor_Count,
	SUM(CASE WHEN Battery_Capacity_mAh IS NULL THEN 1 ELSE 0 END) AS Battery_Capacity_Count,
	SUM(CASE WHEN Screen_Size_inch IS NULL THEN 1 ELSE 0 END) AS Screen_Size_Count,
	SUM(CASE WHEN Launched_Price_PKR IS NULL THEN 1 ELSE 0 END) AS Launched_Price_Pakistan_Count,
	SUM(CASE WHEN Launched_Price_INR IS NULL THEN 1 ELSE 0 END) AS Launched_Price_India_Count,
	SUM(CASE WHEN Launched_Price_CNY IS NULL THEN 1 ELSE 0 END) AS Launched_Price_China_Count,
	SUM(CASE WHEN Launched_Price_USD IS NULL THEN 1 ELSE 0 END) AS Launched_Price_USA_Count,
	SUM(CASE WHEN Launched_Price_AED IS NULL THEN 1 ELSE 0 END) AS Launched_Price_Dubai_Count,
	SUM(CASE WHEN Launched_Year IS NULL THEN 1 ELSE 0 END) AS Launched_Year_Count
	FROM mobiles;


--Removing currency values from all currency columns
UPDATE mobiles
SET Launched_Price_PKR = REPLACE(Launched_Price_PKR, 'PKR', '');

UPDATE mobiles
SET Launched_Price_INR = REPLACE(Launched_Price_INR, 'INR', '');

UPDATE mobiles
SET Launched_Price_CNY = REPLACE(Launched_Price_CNY, 'CNY', '');

UPDATE mobiles
SET Launched_Price_USD = REPLACE(Launched_Price_USD, 'USD', '');

UPDATE mobiles
SET Launched_Price_AED = REPLACE(Launched_Price_AED, 'AED', '');



--Checking for non-numeric data in all price columns
SELECT Launched_Price_PKR, Launched_Price_INR, Launched_Price_USD, Launched_Price_CNY, Launched_Price_AED
FROM mobiles
WHERE ISNUMERIC(Launched_Price_CNY) = 0   
    OR ISNUMERIC(Launched_Price_INR) = 0
    OR ISNUMERIC(Launched_Price_USD) = 0
    OR ISNUMERIC(Launched_Price_CNY) = 0
    OR ISNUMERIC(Launched_Price_AED) = 0;


--Removing non-numeric data from all currency columns
DELETE FROM mobiles
WHERE Launched_Price_PKR = 'Not available' 
	  OR
	  Launched_Price_CNY LIKE '%?%';

--Removing all trailing and leading whitespace from all currency columns for conversion
UPDATE mobiles
SET Launched_Price_PKR = TRIM(Launched_Price_PKR);

UPDATE mobiles
SET Launched_Price_INR = TRIM(Launched_Price_INR);

UPDATE mobiles
SET Launched_Price_CNY = TRIM(Launched_Price_CNY);

UPDATE mobiles
SET Launched_Price_USD = TRIM(Launched_Price_USD);

UPDATE mobiles
SET Launched_Price_AED = TRIM(Launched_Price_AED);




--Removing commas from all currency columns for conversion
UPDATE mobiles
SET Launched_Price_PKR = REPLACE(Launched_Price_PKR, ',', '');

UPDATE mobiles
SET Launched_Price_INR = REPLACE(Launched_Price_INR, ',', '');

UPDATE mobiles
SET Launched_Price_CNY = REPLACE(Launched_Price_CNY, ',', '');

UPDATE mobiles
SET Launched_Price_USD = REPLACE(Launched_Price_USD, ',', '');

UPDATE mobiles
SET Launched_Price_AED = REPLACE(Launched_Price_AED, ',', '');


--Setting all currency columns to type FlOAT
ALTER TABLE mobiles
ALTER COLUMN Launched_Price_PKR NUMERIC(10,2);

ALTER TABLE mobiles
ALTER COLUMN Launched_Price_INR NUMERIC(10,2);

ALTER TABLE mobiles
ALTER COLUMN Launched_Price_CNY NUMERIC(10,2);

ALTER TABLE mobiles
ALTER COLUMN Launched_Price_USD NUMERIC(10,2);

ALTER TABLE mobiles
ALTER COLUMN Launched_Price_AED NUMERIC(10,2);



--Removing g from Mobile_Weight_g column
UPDATE mobiles
SET Mobile_Weight_g = REPLACE(Mobile_Weight_g, 'g', '');

--Convert Mobile_Weight_g column to FLOAT
ALTER TABLE mobiles
ALTER COLUMN Mobile_Weight_g FLOAT;


--Removing rows with 8GB/12GB from the dataset to convert RAM column to type Int 

--Count rows with mixed RAM values
SELECT COUNT(*) AS mixed_ram_count
FROM mobiles
WHERE RAM_GB LIKE '%/%';

--Remove rows with mixed RAM values
DELETE FROM mobiles
WHERE RAM_GB LIKE '%/%';

--Removing GB from RAM column
UPDATE mobiles
SET RAM_GB = REPLACE(RAM_GB, 'GB', '');


--Convert RAM_GB column to FLOAT
ALTER TABLE mobiles
ALTER COLUMN RAM_GB FLOAT;

--Removing mAh and , from Battery_Capacity 
UPDATE mobiles
SET Battery_Capacity_mAh = REPLACE(REPLACE(Battery_Capacity_mAh, ',', ''), 'mAh', '');

--Changing Battery_Capacity_mAh column to type Int
ALTER TABLE mobiles
ALTER COLUMN Battery_Capacity_mAh INT;


--Removing all strings from Screen_Size_inch 
UPDATE mobiles 
SET Screen_Size_inch = CAST(LEFT(Screen_Size_inch, CHARINDEX(' ', Screen_Size_inch + ' ') - 1) AS FLOAT);

--Changing Screen_Size column to FLOAT
ALTER TABLE mobiles
ALTER COLUMN Screen_Size_inch FLOAT;


--Count identical models with different specifications
SELECT Company_Name, Model_Name, COUNT(*) AS Duplicates
FROM mobiles
GROUP BY Company_Name, Model_Name
HAVING COUNT(*) > 1;


--Removing outlier from the dataset
DELETE FROM mobiles
WHERE Launched_Price_USD = 39622.00;




--Average/Min/Max RAM
SELECT CAST(AVG(RAM_GB) AS DECIMAL(10,2)) as AVG_RAM_GB, MIN(RAM_GB) AS Min_RAM, MAX(RAM_GB) AS Max_RAM
FROM mobiles;


--Average/Min/Max Screen Size
SELECT CAST(AVG(Screen_Size_inch) AS DECIMAL(10,2)) as AVG_Screen_Size_inch, MIN(Screen_Size_inch) AS Min_Screen_Size_inch, MAX(Screen_Size_inch) AS Max_Screen_Size_inch
FROM mobiles;



--Average/Min/Max Battery Capacity
SELECT AVG(Battery_Capacity_mAh) as AVG_Capacity_mah, MIN(Battery_Capacity_mAh) AS Min_Battery_Capacity_mAh, MAX(Battery_Capacity_mAh) AS Max_Battery_Capacity_mAh
FROM mobiles;


--Average/Min/Max Weight
SELECT CAST(AVG(Mobile_Weight_g) AS DECIMAL(10,2)) AS AVG_Weight_g, MIN(Mobile_Weight_g) AS Min_Mobile_Weight_g, MAX(Mobile_Weight_g) AS Max_Mobile_Weight_g
FROM mobiles;



--Most common screen size
SELECT Screen_Size_inch, COUNT(*) AS Count
FROM mobiles
GROUP BY Screen_Size_inch
ORDER BY Count DESC;

--Most common weight
SELECT Mobile_Weight_g, COUNT(*) AS Count
FROM mobiles
GROUP BY Mobile_Weight_g
ORDER BY Count DESC;


--Most common battery capacity
SELECT Battery_Capacity_mAh, COUNT(*) AS Count
FROM mobiles
GROUP BY Battery_Capacity_mAh
ORDER BY Count DESC;


--Most common ram
SELECT RAM_GB, COUNT(*) AS Count
FROM mobiles
GROUP BY RAM_GB
ORDER BY Count DESC;



--Overview of all models from each company 
SELECT Company_Name, Model_Name
FROM mobiles
GROUP BY Company_Name, Model_Name


--Total distinct models for each company
SELECT Company_Name, COUNT(DISTINCT Model_Name) AS Total_Models
FROM mobiles
GROUP BY Company_Name
ORDER BY COUNT(DISTINCT Model_Name) DESC;


--Most common Front_Camera 
SELECT Front_Camera, COUNT(*) as Count
FROM mobiles
GROUP BY Front_Camera
ORDER BY Count DESC

--Most common Back_Camera 
SELECT Back_Camera, COUNT(*) as Count
FROM mobiles
GROUP BY Back_Camera
ORDER BY Count DESC



--List of the heaviest phone vs the lightest phone
SELECT Company_Name, Model_Name, Mobile_Weight_g
FROM mobiles
WHERE Mobile_Weight_g = (SELECT MAX(Mobile_Weight_g) FROM mobiles) 
	  OR 
	  Mobile_Weight_g = (SELECT MIN(Mobile_Weight_g) FROM mobiles);


--List of phones with the highest battery capacity vs the lowest battery capacity compared to the average battery capacity
SELECT Company_Name, Model_Name, Battery_Capacity_mAh, (SELECT AVG(Battery_Capacity_mAh) FROM mobiles) as Avg_capacity
FROM mobiles
WHERE Battery_Capacity_mAh = (SELECT MAX(Battery_Capacity_mAh) FROM mobiles) OR Battery_Capacity_mAh = (SELECT MIN(Battery_Capacity_mAh) FROM mobiles);


--List of phones with the largest RAM Together with phones having the largest screen_size
SELECT Company_Name, Model_Name, RAM_GB, Screen_Size_inch, 'Largest RAM' as TYPE
FROM mobiles
WHERE RAM_GB = (SELECT MAX(RAM_GB) FROM mobiles)
UNION ALL
SELECT Company_Name, Model_Name, RAM_GB, Screen_Size_inch, 'Largest Screen' as TYPE
FROM mobiles
WHERE Screen_Size_inch = (SELECT MAX(Screen_Size_inch) FROM mobiles)


--List of the most expensive phone models for each year in USD
WITH Price_Ranking AS (
SELECT Company_Name, Model_Name, Mobile_Weight_g, Battery_Capacity_mAh, RAM_GB, Screen_Size_inch, Front_Camera, Back_Camera, Launched_Price_USD, Launched_Year,
	   RANK() OVER (PARTITION BY Launched_Year ORDER BY Launched_Price_USD DESC) as Ranking
FROM mobiles)
SELECT Company_Name, Model_Name, Mobile_Weight_g, Battery_Capacity_mAh, RAM_GB, Screen_Size_inch, Front_Camera, Back_Camera, Launched_Price_USD, Launched_Year FROM Price_Ranking
WHERE Ranking = 1;


--List of the least expensive phone models for each year in USD
WITH Price_Ranking AS (
SELECT Company_Name, Model_Name, Mobile_Weight_g, Battery_Capacity_mAh, RAM_GB, Screen_Size_inch, Front_Camera, Back_Camera, Launched_Price_USD, Launched_Year,
	   RANK() OVER (PARTITION BY Launched_Year ORDER BY Launched_Price_USD ASC) as Ranking
FROM mobiles)
SELECT Company_Name, Model_Name, Mobile_Weight_g, Battery_Capacity_mAh, RAM_GB, Screen_Size_inch, Front_Camera, Back_Camera, Launched_Price_USD, Launched_Year FROM Price_Ranking
WHERE Ranking = 1;




--Total number of phone models launched each year for each company
SELECT Company_Name, Count(DISTINCT Model_Name) as Total_Models, Launched_Year
FROM mobiles
GROUP BY Company_Name,Launched_Year
ORDER BY Launched_Year, Count(DISTINCT Model_Name) DESC;



--Overview of how average battery capacity, screen size, ram and price(USD) has changed over the years
SELECT AVG(Battery_Capacity_mAh) as avg_capacity_mAh, ROUND(AVG(Screen_Size_inch),2) as avg_screen_size_inch, 
	   ROUND(AVG(RAM_GB),2) as avg_ram_gb, FORMAT(AVG(Launched_Price_USD),'N2') as avg_price_usd, Launched_Year
FROM mobiles
GROUP BY Launched_Year
ORDER BY Launched_Year;



--Overview of how average battery capacity, screen size, ram and price(USD) has changed over the years for each company
SELECT Company_Name, AVG(Battery_Capacity_mAh) as avg_capacity_mAh, ROUND(AVG(Screen_Size_inch),2) as avg_screen_size_inch, 
	   ROUND(AVG(RAM_GB),2) as avg_ram_gb, FORMAT(AVG(Launched_Price_USD),'N2') as avg_price_usd, Launched_Year
FROM mobiles
GROUP BY Company_Name, Launched_Year
ORDER BY Company_Name;



--Average price of mobile phones for each company in USD 
SELECT Company_Name, AVG(Launched_Price_USD) as Avg_price_USD
FROM mobiles
GROUP BY Company_Name
ORDER BY Avg_price_USD DESC;


--Average price of mobile phones for each company in PKR
SELECT Company_Name, AVG(Launched_Price_PKR) as Avg_price_PKR
FROM mobiles
GROUP BY Company_Name
ORDER BY Avg_price_PKR DESC;




--Ranking the top 3 most expensive phones for each company(USD)
With RankedMobiles AS (
SELECT Company_Name, Model_Name, Launched_Price_USD, Launched_Year, 
	   DENSE_RANK() OVER (PARTITION BY Company_Name ORDER BY Launched_Price_USD DESC) AS Ranking
FROM mobiles )
SELECT * FROM RankedMobiles 
WHERE Ranking < 4



--Listing the most expensive phones for each currency
SELECT 'PKR' AS Currency, Company_Name, Model_Name, Launched_Price_PKR AS Price
FROM mobiles
WHERE Launched_Price_PKR = (SELECT MAX(Launched_Price_PKR) FROM mobiles)

UNION ALL

SELECT 'AED', Company_Name, Model_Name, Launched_Price_AED
FROM mobiles
WHERE Launched_Price_AED = (SELECT MAX(Launched_Price_AED) FROM mobiles)

UNION ALL

SELECT 'CNY', Company_Name, Model_Name, Launched_Price_CNY
FROM mobiles
WHERE Launched_Price_CNY = (SELECT MAX(Launched_Price_CNY) FROM mobiles)

UNION ALL

SELECT 'INR', Company_Name, Model_Name, Launched_Price_INR
FROM mobiles
WHERE Launched_Price_INR = (SELECT MAX(Launched_Price_INR) FROM mobiles)

UNION ALL

SELECT 'USD', Company_Name, Model_Name, Launched_Price_USD
FROM mobiles
WHERE Launched_Price_USD = (SELECT MAX(Launched_Price_USD) FROM mobiles);


--Listing the least expensive phones for each currency
SELECT 'PKR' AS Currency, Company_Name, Model_Name, Launched_Price_PKR AS Price
FROM mobiles
WHERE Launched_Price_PKR = (SELECT MIN(Launched_Price_PKR) FROM mobiles)

UNION ALL

SELECT 'AED', Company_Name, Model_Name, Launched_Price_AED
FROM mobiles
WHERE Launched_Price_AED = (SELECT MIN(Launched_Price_AED) FROM mobiles)

UNION ALL

SELECT 'CNY', Company_Name, Model_Name, Launched_Price_CNY
FROM mobiles
WHERE Launched_Price_CNY = (SELECT MIN(Launched_Price_CNY) FROM mobiles)

UNION ALL

SELECT 'INR', Company_Name, Model_Name, Launched_Price_INR
FROM mobiles
WHERE Launched_Price_INR = (SELECT MIN(Launched_Price_INR) FROM mobiles)

UNION ALL

SELECT 'USD', Company_Name, Model_Name, Launched_Price_USD
FROM mobiles
WHERE Launched_Price_USD = (SELECT MIN(Launched_Price_USD) FROM mobiles);



--Comparing least expensive vs most expensive phone
SELECT Company_Name, Model_Name, Mobile_Weight_g, RAM_GB, Front_Camera, Back_Camera, Processor, Battery_Capacity_mAh, Screen_Size_inch, 'Least Expensive' AS Price
FROM mobiles
WHERE Model_Name = 'Smart HD 32GB'

UNION ALL 

SELECT Company_Name, Model_Name, Mobile_Weight_g, RAM_GB, Front_Camera, Back_Camera, Processor, Battery_Capacity_mAh, Screen_Size_inch, 'Most Expensive'
FROM mobiles
WHERE Model_Name = 'Mate XT 512GB'




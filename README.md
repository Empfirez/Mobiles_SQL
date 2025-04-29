# Mobiles_SQL


## Table of Contents
- [Project Overview](#project-overview)
- [Data Sources](#data-sources)
- [Tools](#tools)
- [Data Cleaning/Preparation](#data-cleaningpreparation)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [Data Analysis](#data-analysis)
- [Results/Findings](#resultsfindings)
- [Recommendations](#recommendations)
- [Limitations](#limitations)





### Project Overview

This data analysis project aims to analyze how mobile features such as camera quality, RAM, battery capacity and weight can affect pricing. By uncovering the relationship between these features, we can not only help companies 
optimize their pricing strategy but also assist consumers in making more informed decisons based on product specifications.






### Data Sources

The primary dataset used for this analysis is the "Mobiles_Dataset(2025).csv" file, containing mobile models for various companies along with their features. This dataset is downloaded from Kaggle.


### Tools

- SQL Server (Data Analysis/Data Exploration)
  
- Power BI (Data Visualization)




### Data Cleaning/Preparation

In the data preparation phase of the project, we performed the following tasks:
1.  Data loading and inspection (in SQL server)
2.  Handling of missing values from the dataset and checking for any inconsistencies (removing non-numeric values from currency column)
3.  Data cleaning and formatting (changing column type and value)

### Exploratory Data Analysis

EDA is used to summarize the sales data and allows us to gain insights into the dataset. It answers key questions such as:
-  What is the average screen size, ram, battery capacity and weight?
-  What is the most common screen size, ram, battery capacity and weight?
-  Which company releases the most amount of models per year and which company releases the least?
-  Which company has the most expensive mobile model and which company has the cheapest model?
-  Is there a correlation between mobile weight/RAM/Screen size and price?
-  Are mobile prices increasing over time?
-  Which company produces the best value for money phones?
-  How have mobile features evolved over the years?



### Data Analysis

List of phones with the highest battery capacity vs the lowest battery capacity compared to the average battery capacity:

    SELECT Company_Name, Model_Name, Battery_Capacity_mAh, 
           (SELECT AVG(Battery_Capacity_mAh) FROM mobiles) AS Avg_capacity
    FROM mobiles
    WHERE Battery_Capacity_mAh = (SELECT MAX(Battery_Capacity_mAh) FROM mobiles) 
          OR
          Battery_Capacity_mAh = (SELECT MIN(Battery_Capacity_mAh) FROM mobiles);
          

List of phones with the largest RAM Together with phones having the largest screen_size:

    SELECT Company_Name, Model_Name, RAM_GB, Screen_Size_inch, 'Largest RAM' as TYPE
    FROM mobiles
    WHERE RAM_GB = (SELECT MAX(RAM_GB) FROM mobiles)
    UNION ALL
    SELECT Company_Name, Model_Name, RAM_GB, Screen_Size_inch, 'Largest Screen' as TYPE
    FROM mobiles
    WHERE Screen_Size_inch = (SELECT MAX(Screen_Size_inch) FROM mobiles)


Overview of how average battery capacity, screen size, ram and price(USD) has changed over the years for each company:

    SELECT Company_Name, AVG(Battery_Capacity_mAh) as avg_capacity_mAh, ROUND(AVG(Screen_Size_inch),2) as avg_screen_size_inch, 
    	     ROUND(AVG(RAM_GB),2) as avg_ram_gb, FORMAT(AVG(Launched_Price_USD),'N2') as avg_price_usd, Launched_Year
    FROM mobiles
    GROUP BY Company_Name, Launched_Year
    ORDER BY Company_Name;


Average price of mobile phones for each company in USD:

    SELECT Company_Name, AVG(Launched_Price_USD) as Avg_price_USD
    FROM mobiles
    GROUP BY Company_Name
    ORDER BY Avg_price_USD DESC;



Ranking the top 3 most expensive phones for each company(USD):

    With RankedMobiles AS (
    SELECT Company_Name, Model_Name, Launched_Price_USD, Launched_Year, 
    	   DENSE_RANK() OVER (PARTITION BY Company_Name ORDER BY Launched_Price_USD DESC) AS Ranking
    FROM mobiles )
    SELECT * FROM RankedMobiles 
    WHERE Ranking < 4





### Results/Findings

After careful analysis, the results are as follows:
1. The RAM for all models averages around 7.78GB, with the most common RAM being around 8GB, minimum being 1GB and maximum being 8GB. 
2. The weight for all models averages at 228.30g with the most common weight being 190g, minimum being 135g and maximum being 732g.
3. The screen size for all models averages around 7.08 inches with the most common size being 6.7 inches, minimum being 5 inches and maximum being 14.6 inches
4. The battery capacity for all models averages around 5027 mAh with the most common capacity being 5000 mAh, minimum being 2000 mAh and maximum being 11200 mAh.
5. Oppo has the most number of models at 115 total models, followed by Apple at 97 and Honor at 91.
6. iQOO has the least number of models at 3.
7. On average, battery capacity, screen size and ram are generally increasing over the years with strong upward trends while prices are showing an upward trend from $169 in 2014 to a peak of $850 in 2022 and dipping to a price of $429 in 2025.
8. Nokia has the highest average price of mobile phones at $3760 followed by Sony at $1132 and Huawei at $1112.
9. Infinix has the lowest average price of mobile phones at $245.
10. 
  


### Recommendations

Based on analysis above, here are some recommended actions to take in order to increase sales revenue:
1. Offering special promotions during peak seasons to maximise revenue and attract more customers.
2. Analyzing the differences between Store 20 and Store 33 to figure out the reasons behind the large discrepancy in sales. For instance promotions, propduct placement, store environment, customer service, location.
3. As sales drop during hotter days, Walmart can run targeted promotions on specific products such as beverages, cooling applicances and swimwear.
4. During hotter days where customers are reluctant to shop in physical stores, Walmart can increase sales by offering discount vouchers whenever consumers shop online. 
5. As sales are the highest in moderate temperatures, more emphasis should be placed on outdoor products such as gardening tools, sports apparel as well as sports equipment. Beauty products may also see a rise in sales
   as people tend to repair their damaged skin and hair after cold periods.
6. Since CPI and fuel prices do not affect sales significantly, Walmart should focus on their customer service and increasing customer satisfaction so as to build a more loyal consumer base.  




### Limitations

- Converted fuel_price and CPI column to 2 decimal places for easier analysis and readability.
- Created a new column for temperature called temperature_celcius as the original temperature column was recorded in Kelvin. The newly created column was then populated with values in Celcius after conversion.
  

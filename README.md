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


![image](https://github.com/user-attachments/assets/3e1b9b32-d139-480c-99f5-811da380a723)



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
-  Is there a correlation between mobile weight/RAM/Screen size/battery capacity and price?
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
1.  The RAM for all models averages around 7.78GB, with the most common RAM being around 8GB, minimum being 1GB and maximum being 8GB. 
2.  The weight for all models averages at 228.30g with the most common weight being 190g, minimum being 135g and maximum being 732g.
3.  The screen size for all models averages around 7.08 inches with the most common size being 6.7 inches, minimum being 5 inches and maximum being 14.6 inches.
4.  The battery capacity for all models averages around 5027 mAh with the most common capacity being 5000 mAh, minimum being 2000 mAh and maximum being 11200 mAh.
5.  The most common front camera quality is 16MP and the most common back camera quality is 50MP.
6.  There is a weak positive correlation between screen size and weight on price while RAM strongly correlates with price. 
7.  There is no strong positive correlation between battery capacity and price, suggesting other factors determine price instead.
8.  Oppo has the most number of models at 115 total models, followed by Apple at 97 and Honor at 91.
9.  iQOO has the least number of models at 3.
10. On average, battery capacity, screen size and ram are generally increasing over the years with strong upward trends while prices are showing an upward trend from $169 in 2014 to a peak of $850 in 2022 and dipping to $429 in 2025.
11. Sony has the highest average price of mobile phones at $1132, followed by Huawei at $1112 and Apple at $1028.
12. Infinix has the lowest average price of mobile phones at $245.
    

    
  

### Recommendations

Based on the analysis above, here are some recommended actions to take:
1. Since RAM affects price the most, companies should strategize their RAM offerings to optimize cost and be more price competitive.
2. As screen size and weight has a slight positive impact on price, companies should focus on optimal size and weight ranges for common models while offering larger screens for higher end products.
3. Companies like Oppo, Apple and Honor dominate the market in terms of the number of models released, indicating that they are targetting multiple customer segments from budget to premium users.Brands like iQOO could try to capture a larger
   market share by expanding their product line to appeal to a wider audience.
4. Brands like Sony, Huawei and Apple have high average prices for their mobile phones, meaning that they mostly target the medium-high income groups. Therefore, such companies should differentiate themselves from more budget-friendly brands by
   investing in premium features such as larger screen sizes, larger RAM and higher quality cameras to justify the higher cost.
5. On the other hand, brands such as Infinix and Nokia focus on affordable prices which appeals to first-time users or price sensitive users. Thus, instead of having excessive RAM or large screen sizes, these companies should prioritize larger
   battery capacities as well as durability while not forsaking performance in the process. Durability and affordability should be the main selling points for these companies.
   




### Limitations

- I had to remove one particular model from Nokia due to it having an exceedingly large value of $39622(USD), making it an extreme outlier. Upon removing the model and calculating the average value again, it was discovered that the
  average price had dropped significantly to $174, which aligns more closely to Nokia's budget-friendly brand. This indicates that the value of $39622 could be an error during data entry as it does not fall in line with the average pricing pattern of other models.
  Having such an extreme outlier heavily skews the average price of Nokia which can lead to misleading intepretations during analysis. 







  

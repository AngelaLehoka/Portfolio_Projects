

/* CASE STUDY: Mental Health Data Exploration

Data source: OWID

The data is going to be explored to answer the following questions:

	1. What was the prevalence of depression in the year 2019 in South Africa?

	2. What was the average prevalence of depression in the year 2019, worldwide?

	3. What is the highest prevalence of depression in the year 2019, worldwide?

	4. What is the lowest prevalence of depression in the year 2019, worldwide?

	5. What are the top 5 entities that have the highest prevalence of depression?

	   	   	   	  
*/

SELECT *
FROM MentalHealthExploration..DepressionStats

-- 1. What was the prevalence of depression in the year 2019 in South Africa?

SELECT *
FROM MentalHealthExploration..DepressionStats
WHERE Entity = 'South Africa' AND Year = '2019'

-- The prevalence of depression in the year 2019 was 4.45% in South Africa.

--2. What was the average prevalence of depression in the year 2019, worldwide?

SELECT AVG(Percentage) as AveragePercentage
FROM MentalHealthExploration..DepressionStats
WHERE Year = '2019'

-- The worldwide percentage in 2019 was 3.92%. South Africa's rate of depression amongst its population was above the world average.

-- 3. What is the highest prevalence of depression in the year 2019, worldwide?

SELECT MAX(Percentage) as HighestPercentage
FROM MentalHealthExploration..DepressionStats
WHERE Year = '2019'

-- The highest percentage of depression prevalence in the world was 6.69% in 2019.

--4. What is the lowest prevalence of depression in the year 2019, worldwide?

SELECT MIN(Percentage) as LowestPercentage
FROM MentalHealthExploration..DepressionStats
WHERE Year = '2019'

-- The lowest percentage of depression prevalence in the world was 1.73% in 2019.

--5. What are the top 5 entities that have the highest prevalence of depression?

SELECT Entity, Percentage
FROM MentalHealthExploration..DepressionStats
WHERE Year = '2019'
ORDER BY Percentage DESC

-- The 5 top entities with the highest prevalence of depression are: Uganda, Palestine, Greenland, Central African Republic, and Equatorial Guinea.



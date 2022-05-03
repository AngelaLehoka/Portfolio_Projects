
-- ONLINE RETAIL STORE DATA CLEANING PROJECT!


--Data source: Kaggle
--Client wants to know all the stock sold in 2010.
--SQL will be used to clean the data.

SELECT *
FROM [Online Retail Project]..OnlineRetail

SELECT InvoiceDate, Quantity, Price
FROM [Online Retail Project]..OnlineRetail

-- Cleaning the InvoiceDate column to be more user friendly

SELECT InvoiceDate
FROM [Online Retail Project]..OnlineRetail


SELECT CONVERT(varchar(10),[InvoiceDate],106) AS [ConvertedDate], Quantity, Price 
FROM [Online Retail Project]..OnlineRetail
WHERE InvoiceDate like '%2010%' AND Quantity is not null AND Price is not null


-- Result is table showing ConvertedDate, Quantity, and Price.
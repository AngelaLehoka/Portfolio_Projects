-- WELCOME TO MY DATA CLEANING PROJECT!

-- The aim is to clean the data to make it easier to analyze.
-- The data is about Nashville Housing. 
-- Data Source: Kaggle


-- See all columns and see the type of data they hold.


SELECT
*
FROM
PortfolioProjectNashville..NashvilleHousing


-- The SaleDate column includes both the date and time in one column, it would be easier to analyze it as just the date.
-- I am going to add a column where the format of the date is going to be converted to YYYY-MM-DD format.

SELECT
SaleDate, CONVERT(Date,SaleDate) AS SaleDateConverted
FROM
PortfolioProjectNashville..NashvilleHousing


-- The PropertyAddress column contained the house number, street address, and city all in one column.
-- This is going to be cleaned to be easier to work with.


SELECT
PropertyAddress
FROM
PortfolioProjectNashville..NashvilleHousing
WHERE
PropertyAddress is null

-- there are null values
-- I notice that the parcel ID is always linked to the property address.

SELECT
*
FROM
PortfolioProjectNashville..NashvilleHousing
ORDER BY
ParcelID


-- using the ParcelID to populate the property address columns


SELECT
a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM
PortfolioProjectNashville..NashvilleHousing a
JOIN PortfolioProjectNashville..NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress is null


-- Update the table to show the complete addresses


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM
PortfolioProjectNashville..NashvilleHousing a
JOIN PortfolioProjectNashville..NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]



--Separating the property address into different columns


SELECT
PropertyAddress
FROM
PortfolioProjectNashville..NashvilleHousing


-- This looks for everything before the comma, including the comma


SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)) AS Address
FROM
PortfolioProjectNashville..NashvilleHousing


-- To remove the commma, add a minus 1 (to remove the 1 position)


SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS Address
FROM
PortfolioProjectNashville..NashvilleHousing

-- create new columns

ALTER TABLE PortfolioProjectNashville..NashvilleHousing
Add PropertySplitAddress2 Nvarchar(255);

UPDATE
PortfolioProjectNashville..NashvilleHousing
SET PropertySplitAddress2 = SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1)


ALTER TABLE PortfolioProjectNashville..NashvilleHousing
Add PropertySplitCity2 Nvarchar(255)

UPDATE
PortfolioProjectNashville..NashvilleHousing
SET PropertySplitCity2 = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


SELECT
*
FROM PortfolioProjectNashville..NashvilleHousing


-- Separating the owner address into different columns

SELECT
OwnerAddress
FROM
PortfolioProjectNashville..NashvilleHousing


SELECT 
PARSENAME(REPLACE(OwnerAddress, ', ', '.'),3),
PARSENAME(REPLACE(OwnerAddress, ', ', '.'),2),
PARSENAME(REPLACE(OwnerAddress, ', ', '.'),1)
FROM
PortfolioProjectNashville..NashvilleHousing


-- Now I update the table by adding these columns.


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255)

UPDATE
NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ', ', '.'),3)



ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255)

UPDATE
NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ', ', '.'),2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255)

UPDATE
NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ', ', '.'),1)


-- Changing Y and N to Yes and No

SELECT DISTINCT(SoldAsVacant)
FROM
PortfolioProjectNashville..NashvilleHousing

-- The SoldAsVacant column has Y, N, Yes, and No. I am going to keep only to Yes and No for consistency.


SELECT SoldAsVacant,
CASE When SoldAsVacant = 'Y' THEN 'Yes'
When SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
FROM
PortfolioProjectNashville..NashvilleHousing



UPDATE
NashvilleHousing
SET SoldAsVacant = 
CASE When SoldAsVacant = 'Y' THEN 'Yes'
When SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END



-- Remove duplicates (not standard practice to delete data from database!!!)

WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY 
ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
ORDER BY UniqueID ) row_num
FROM
PortfolioProjectNashville..NashvilleHousing 
)


DELETE
FROM RowNumCTE
WHERE row_num > 1


-- the "1" under row_num column means there are no duplicates. If it is more than 1, then there are duplicates.







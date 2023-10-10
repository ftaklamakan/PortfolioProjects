-- Cleaning Nashville Housing Data via SQL


SELECT *
FROM PortfolioProject.dbo.NashvilleHousing


SELECT SaleDate, CAST(SaleDate as date)
FROM PortfolioProject.dbo.NashvilleHousing

------------------------------------------------------------------------------------

--
-- Populate Property Address Data

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
WHERE PropertyAddress is NULL


SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
ORDER BY ParcelID
------------------------------------------
------------------------------------------

-- * Cleaning Null Addresses
-- Parcel Going to be same with the PropertyAddress
-- detect
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
    WHERE a.PropertyAddress is NULL

-- Parcel Going to be same with the PropertyAddress

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) as Filled
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
    WHERE a.PropertyAddress is NULL
-- UPDATE
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
    WHERE a.PropertyAddress is NULL
------------------------------------------
------------------------------------------

-- Breaking out Address into Individual Columns

SELECT PropertyAddress, SUBSTRING(PropertyAddress, 0, CHARINDEX(',', PropertyAddress)) as NewAddress, 
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as City
FROM PortfolioProject.dbo.NashvilleHousing

-- Add values in

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertySplitAddress NVARCHAR(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 0, CHARINDEX(',', PropertyAddress))

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertySplitCity NVARCHAR(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

------------------------------------------

-- Using PARSENAME (uses periods, not commas) , and does backwards

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress NVARCHAR(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitCity NVARCHAR(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitState NVARCHAR(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

------

-- Change Y and N to Yes and No in 'Sold in Vacant' field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant,
    CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
    END
FROM PortfolioProject.dbo.NashvilleHousing

UPDATE PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
    END

-----------------------------------

-- Remove Duplicates: Better to do in elsewhere, practicing purposes

SELECT *,
    ROW_NUMBER() OVER (
        PARTITION BY ParcelID,
                    PropertyAddress,
                    SalePrice,
                    SaleDate,
                    LegalReference
                    ORDER BY 
                        UniqueID
    ) row_num
FROM PortfolioProject.dbo.NashvilleHousing
ORDER BY row_num DESC

-- if row_num equals 2, it is a duplicate, CTE 

WITH RowNumCTE AS (
SELECT *,
    ROW_NUMBER() OVER (
        PARTITION BY ParcelID,
                    PropertyAddress,
                    SalePrice,
                    SaleDate,
                    LegalReference
                    ORDER BY 
                        UniqueID
    ) row_num
FROM PortfolioProject.dbo.NashvilleHousing
)
-- ORDER BY row_num DESC
SELECT *
--DELETE
FROM RowNumCTE
WHERE row_num > 1
-- ORDER BY UniqueID

-----------------------------
---
---

-- Delete Unused Columns, not to on raw data, practical purpose
-- Delete ex. Old Addresses and Tax District

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

---------------------------------------------





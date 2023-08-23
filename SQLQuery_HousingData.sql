Select *
From housingdata..Sheet1$

--Change date format
 SELECT SaleDate, CONVERT(Date, SaleDate) as SaleDateConverted
 From housingdata..Sheet1$

 Update Sheet1$
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE Sheet1$
Add SaleDateConverted Date;

Update Sheet1$
SET SaleDateConverted = CONVERT(Date,SaleDate)

--check null values in propertyaddress
SELECT ParcelID, PropertyAddress
From housingdata..Sheet1$
where PropertyAddress is null
--remove null values and populate

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM  housingdata..Sheet1$ a
JOIN housingdata..Sheet1$ b
on a.ParcelID=  b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null --when a property is null, populate it with b

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM  housingdata..Sheet1$ a
JOIN housingdata..Sheet1$ b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--check propertyaddress 
 Select PropertyAddress
 FROM  housingdata..Sheet1$
 --divide propertyaddress in (Address, City, State)
 Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
 FROM  housingdata..Sheet1$
 --make multiple cols for address
ALTER TABLE Sheet1$
Add PropertySplitAddress Nvarchar(255);

Update Sheet1$
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE Sheet1$
Add PropertySplitCity Nvarchar(255);

Update Sheet1$
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

 Select *
From housingdata.dbo.Sheet1$
Select OwnerAddress
From housingdata.dbo.Sheet1$

--split owner address
Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3) --parsename does it opposite so using 3,2,1
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM  housingdata..Sheet1$

ALTER TABLE Sheet1$
Add OwnerSplitAddress Nvarchar(255);

Update Sheet1$
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update Sheet1$
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE Sheet1$
Add OwnerSplitState Nvarchar(255);

Update Sheet1$
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

 --Change Y and N to Yes and No in "Sold as Vacant" field
Select SoldAsVacant
From housingdata.dbo.Sheet1$
Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From housingdata.dbo.Sheet1$
Update Sheet1$
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
	   Update Sheet1$
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


	   -- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From housingdata.dbo.Sheet1$
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From housingdata.dbo.Sheet1$
---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From housingdata.dbo.Sheet1$


ALTER TABLE housingdata.dbo.Sheet1$
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate









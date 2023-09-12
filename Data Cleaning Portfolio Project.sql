Select *
From PortfolioProject.dbo.NashvilleHousing


--Standardize Date Format

Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)



--Populated Property Address Data


Select *
From PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID,b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null


Update  a
Set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null



--Breaking out Address into Individual Columns (Adrress, City, State)


Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing 
--where PropertyAddress is null
--order by ParcelID

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
 , SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address
 
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))

Select *
From PortfolioProject.dbo.NashvilleHousing



Select OwnerAddress 
From PortfolioProject.dbo.NashvilleHousing

Select 
PARSENAME(Replace(OwnerAddress, ',', '.') ,3)
, PARSENAME(Replace(OwnerAddress, ',', '.') ,2)
, PARSENAME(Replace(OwnerAddress, ',', '.') ,1)
From PortfolioProject.dbo.NashvilleHousing 



--Change Y and N to YEs and No in 'Sold in Vacant' field

 

Select SoldAsVacant
 ,CASE when SoldAsVacant = 'Y' THEN 'Yes'
       when SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
       when SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END 



--Remove Duplicates

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

From PortfolioProject.dbo.NashvilleHousing
--ORDER BY ParcelID
) 
Select *
From RowNumCTE
where row_num > 1
order by PropertyAddress
 



Select *
From PortfolioProject.dbo.NashvilleHousing



--Delete Unused Columns


Select *
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate














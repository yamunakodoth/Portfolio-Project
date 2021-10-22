--Cleaning the data

select * 
from [Portfolio Project].dbo.nashvillehousing

--Standardized date format

select SaleDate, convert(Date,SaleDate)
from [Portfolio Project].dbo.nashvillehousing

Update NashvilleHousing
SET SaleDate = convert (Date,SaleDate)

--Populate Property Address Data 

select *
from [Portfolio Project].dbo.nashvillehousing
--where PropertyAddress is null
order by ParcelID


select a.ParcelID,a.propertyaddress,b.parcelid, b.propertyaddress, ISNULL(a.propertyaddress,b.propertyaddress)
from [Portfolio Project].dbo.nashvillehousing a
JOIN [Portfolio Project].dbo.nashvillehousing b
     on a.ParcelId = b.ParcelId
	 and a.uniqueid != b.uniqueid
where a.propertyaddress is null


UPDATE A
SET PropertyAddress = ISNULL(a.propertyaddress,b.propertyaddress)
from [Portfolio Project].dbo.nashvillehousing a
JOIN [Portfolio Project].dbo.nashvillehousing b
     on a.ParcelId = b.ParcelId
	 and a.uniqueid != b.uniqueid
where a.propertyaddress is null


--Breaking out Address into individual columns ( Address,City,State)

select PropertyAddress
from [Portfolio Project].dbo.nashvillehousing
--where PropertyAddress is null
--order by ParcelID

select 
substring(PropertyAddress, 1 , CHARINDEX(',',PropertyAddress)-1) as Address
,substring(PropertyAddress,CHARINDEX(',',PropertyAddress),LEN(PropertyAddress)) as Address
from [Portfolio Project].dbo.nashvillehousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1 , CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitCity = substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) 

select OwnerAddress
from [Portfolio Project].dbo.NashvilleHousing

select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
From [Portfolio Project]..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)


ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);

UPDATE NashvilleHousing
SET  OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)

--Change Y and N to Yes in 'Sold as Vacant' field

select distinct(soldasvacant),count(soldasvacant)
from [Portfolio Project]..NashvilleHousing
group by SoldAsVacant
order by 2


select soldasvacant
,CASE when SoldAsVacant= 'Y' then 'Yes' 
      when SoldAsVacant= 'N' then 'No' 
      else soldasvacant
      end
from [Portfolio Project]..NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant= CASE when SoldAsVacant= 'Y' then 'Yes' 
      when SoldAsVacant= 'N' then 'No' 
      else soldasvacant
      end

--REMOVE DUPLICATES

WITH RowNumCTE AS(
select *,
   ROW_NUMBER() OVER (
   Partition BY ParcelID,
			    PropertyAddress,
			    SalePrice,
			    SaleDate,
			    LegalReference
			    ORDER BY 
			        UniqueID
			        )row_num
From [Portfolio Project]..NashvilleHousing
--Order by ParcelID
)
select *
From RowNumCTE
where row_num > 1
order by PropertyAddress


--DELETE

	select*
	from [Portfolio Project]..NashvilleHousing

ALTER TABLE [Portfolio Project]..NashvilleHousing
DROP COLUMN OwnerAddress,TaxDistrict, PropertyAddress

ALTER TABLE [Portfolio Project]..NashvilleHousing
DROP COLUMN SaleDate



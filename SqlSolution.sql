/*==============================================================*/
/* CREATING DATABASE                                               */
/*==============================================================*/

--CREATE DATABASE [Digitas_RemoteSQL_Practical_Test]
--GO
USE Digitas_RemoteSQL_Practical_Test
GO

/*==============================================================*/
/* CREATING AND LOADING TABLES FROM CSVs                                               */
/*==============================================================*/

/*==============================================================*/
/* Table: Customer                                              */
/*==============================================================*/
CREATE TABLE Customer 
(
   Id                   int                  not null,
   FirstName            nvarchar(40)         not null,
   LastName             nvarchar(40)         not null,
   City                 nvarchar(40)         null,
   Country              nvarchar(40)         null,
   Phone                nvarchar(20)         null   
)
GO

BULK INSERT Customer
FROM 'D:\RemoteSQLPracticalTest\Data\Customer.CSV'
WITH 
(
FORMAT = 'CSV',
FIRSTROW = 2,
FIELDTERMINATOR = ';'
)
GO

/*==============================================================*/
/* Table: CustomerCard                                              */
/*==============================================================*/

CREATE TABLE CustomerCard 
(
   CustomerId           int                  not null,
   CardNo				bigint				 not null   
)
GO


BULK INSERT CustomerCard
FROM 'D:\RemoteSQLPracticalTest\Data\CustomerCard.CSV'
WITH 
(
FORMAT = 'CSV',
FIRSTROW = 2,
FIELDTERMINATOR = ';' 
)
GO


/*==============================================================*/
/* Table: "Order"                                               */
/*==============================================================*/
CREATE TABLE "Order" 
(
   Id                   int                  not null,
   OrderDate            datetime             not null default getdate(),
   OrderNumber          nvarchar(10)         null,
   CardNo           	bigint               not null,
   TotalAmount          decimal(12,2)        null default 0
)
GO

BULK INSERT "Order"
FROM 'D:\RemoteSQLPracticalTest\Data\Order.CSV'
WITH 
(
FORMAT = 'CSV',
FIRSTROW = 2,
FIELDTERMINATOR = ';' 
)
GO


/*==============================================================*/
/* Table: OrderItem                                             */
/*==============================================================*/
CREATE TABLE OrderItem 
(
   Id                   int                  not null,
   OrderId              int                  not null,
   ProductId            int                  not null,
   UnitPrice            decimal(12,2)        not null default 0,
   Quantity             int                  not null default 1
)
GO

BULK INSERT OrderItem
FROM 'D:\RemoteSQLPracticalTest\Data\OrderItem.CSV'
WITH 
(
FORMAT = 'CSV',
FIRSTROW = 2,
FIELDTERMINATOR = ';' 
)
GO


/*==============================================================*/
/* Table: Product                                               */
/*==============================================================*/
CREATE TABLE Product 
(
   Id                   int                  not null,
   ProductName          nvarchar(50)         not null,
   SupplierId           int                  not null,
   UnitPrice            decimal(12,2)        null default 0,
   [Package]            nvarchar(30)         null,
   --- Uploading True/False as bit is giving error
   --- Threfore upload the CSV using nvarchar and then Alter Table back to bit  
   IsDiscontinued		nvarchar(10)	     not null --default 0,
   	
)
GO

BULK INSERT Product
FROM 'D:\RemoteSQLPracticalTest\Data\Product.CSV'
WITH 
(
FORMAT = 'CSV',
FIRSTROW = 2,
FIELDTERMINATOR = ';' 
)
GO
--- Altering the Data Type of IsDiscontinued Coloum to bit from nvarchar
ALTER TABLE Product
ALTER COLUMN IsDiscontinued bit not null 
GO





/*==============================================================*/
/* NORMALISING TABLES                                        */
/*==============================================================*/


/*==============================================================*/
/* Creating Normalised Country, City & Customer Tables          */
/*==============================================================*/


/*==============================================================*/
/* Table: Country						                        */
/*==============================================================*/

--- Creating Temporary Table with Distinct Country Names 
SELECT DISTINCT
Country AS "CountryName" 
INTO Temp_Country
FROM Customer	
GO

--- Assigning Ids to Country Names
SELECT 
ROW_NUMBER() Over (Order By CountryName) AS Id,
CountryName  
INTO Country
FROM Temp_Country
GO

--- Dropping Temp Table
DROP TABLE Temp_Country
GO

--- Assigning Primary Key Constrainst to Id
ALTER TABLE Country
ALTER COLUMN Id int not null

ALTER TABLE Country
ADD PRIMARY KEY (Id)
GO 

/*==============================================================*/
/* Table: City							                        */
/*==============================================================*/

--- Creating Temporary Table with Distinct City Names with Respective Countries
SELECT DISTINCT City,Country
INTO Temp_City
FROM
Customer
ORDER By City	

--- Assigning Ids to City Names and Country_Id from Country Table 
SELECT 
ROW_NUMBER() Over (Order By City) AS Id,
City, 
c.Id AS Country_Id 
INTO City
FROM Temp_City tc
INNER JOIN Country c
ON c.CountryName=tc.Country

--- Assigning Primary Key Contraint to Ids  
ALTER TABLE City
ALTER COLUMN Id int not null

ALTER TABLE City
ADD PRIMARY KEY (Id)
GO 

--- Assigning Foreign Key Contraint to Country_Id  
ALTER TABLE City
ADD FOREIGN KEY (Country_Id) REFERENCES Country(Id)
GO


/*==============================================================*/
/* Table: Customer						                        */
/*==============================================================*/

--- Dropping City Names and Country and Assigning City_Id as Foreign Key  

SELECT
cust.Id, cust.FirstName, cust.LastName, cust.Phone, 
c.Id AS City_Id
INTO Temp_Customer
FROM Customer cust
INNER JOIN City c
ON c.City=cust.City
GO

DROP TABLE Customer
SELECT * INTO Customer FROM Temp_Customer
DROP TABLE Temp_Customer

--- Assigning Primary Key Contraint to Ids  
ALTER TABLE Customer
ALTER COLUMN Id int not null
GO

ALTER TABLE Customer
ADD PRIMARY KEY (Id)
GO 

--- Assigning Foreign Key Contraint to City_Id  
ALTER TABLE Customer
ADD FOREIGN KEY (City_Id) REFERENCES City(Id)
GO


/*==============================================================*/
/* Table: CustomerCard					                        */
/*==============================================================*/

--- Assigning Primary Key Contraint to Ids  
ALTER TABLE CustomerCard
ALTER COLUMN CardNo int not null
GO

ALTER TABLE CustomerCard
ADD PRIMARY KEY (CardNo)
GO 

--- Assigning Foreign Key Contraint to Customer_Id  
ALTER TABLE CustomerCard
ADD FOREIGN KEY (CustomerId) REFERENCES Customer(Id)
GO


/*==============================================================*/





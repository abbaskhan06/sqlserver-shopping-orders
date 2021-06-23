/*==============================================================*/
/* CREATING DATABASE                                               */
/*==============================================================*/

CREATE DATABASE [Digitas_RemoteSQL_Practical_Test]
GO
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





/*==============================================================*/
/* Table: Customer                                              */
/*==============================================================*/
create table Customer (
   Id                   int                  not null,
   FirstName            nvarchar(40)         not null,
   LastName             nvarchar(40)         not null,
   City                 nvarchar(40)         null,
   Country              nvarchar(40)         null,
   Phone                nvarchar(20)         null   
)
go


/*==============================================================*/
/* Table: CustomerCard                                              */
/*==============================================================*/
create table CustomerCard (
   CustomerId           int                  not null,
   CardNo				bigint				 not null   
)
go



/*==============================================================*/
/* Table: "Order"                                               */
/*==============================================================*/
create table "Order" (
   Id                   int                  not null,
   OrderDate            datetime             not null default getdate(),
   OrderNumber          nvarchar(10)         null,
   CardNo           	bigint               not null,
   TotalAmount          decimal(12,2)        null default 0
)
go


/*==============================================================*/
/* Table: OrderItem                                             */
/*==============================================================*/
create table OrderItem (
   Id                   int                  not null,
   OrderId              int                  not null,
   ProductId            int                  not null,
   UnitPrice            decimal(12,2)        not null default 0,
   Quantity             int                  not null default 1
)
go



/*==============================================================*/
/* Table: Product                                               */
/*==============================================================*/
create table Product (
   Id                   int                  not null,
   ProductName          nvarchar(50)         not null,
   SupplierId           int                  not null,
   UnitPrice            decimal(12,2)        null default 0,
   [Package]              nvarchar(30)         null,
   IsDiscontinued       bit                  not null default 0
)
go


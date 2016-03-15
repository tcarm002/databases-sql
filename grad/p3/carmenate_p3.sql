--Triana Carmenate
--COP 5725- Project 3
--11/10/2015


-- -----------------------------------------------------
-- Table Addresses
-- -----------------------------------------------------
DROP TABLE IF EXISTS Addresses CASCADE;
DROP SEQUENCE IF EXISTS aid_seq CASCADE;
CREATE SEQUENCE aid_seq;

CREATE TABLE Addresses (
  aid INTEGER PRIMARY KEY DEFAULT  nextval('aid_seq'),
  street VARCHAR(45) NOT NULL,
  city VARCHAR(45) NOT NULL,
  state VARCHAR(45),
  country VARCHAR(45) NOT NULL,
  zip VARCHAR(45) NOT NULL,
  apt VARCHAR(45)
);


-- -----------------------------------------------------
-- Table Customer
-- -----------------------------------------------------
DROP TABLE IF EXISTS Customer CASCADE;
DROP SEQUENCE IF EXISTS customerID_seq CASCADE;
CREATE SEQUENCE customerID_seq;

CREATE TABLE Customer (
  customerID INTEGER PRIMARY KEY DEFAULT nextval('customerID_seq'),
  email VARCHAR(60) NOT NULL UNIQUE,
  phone VARCHAR(15),
  fname VARCHAR(45) NOT NULL,
  mname VARCHAR(45),
  lname VARCHAR(45) NOT NULL,
  password VARCHAR(45) NOT NULL,
  store_credit_bal NUMERIC NOT NULL CHECK(store_credit_bal >= 0)
);


-- -----------------------------------------------------
-- Table Credit_Cards
-- -----------------------------------------------------
DROP TABLE IF EXISTS Credit_Cards CASCADE;
DROP SEQUENCE IF EXISTS cc_id_seq CASCADE;
CREATE SEQUENCE cc_id_seq;

CREATE TABLE  Credit_Cards (
  cc_id INTEGER PRIMARY KEY DEFAULT  nextval('cc_id_seq'),
  cc_co VARCHAR(45) NOT NULL,
  exp_y INTEGER NOT NULL,
  exp_m INTEGER NOT NULL,
  num VARCHAR(16) NOT NULL,
  defaultCC BOOLEAN NOT NULL,
  aid INTEGER NOT NULL,
  customerID INTEGER REFERENCES Customer (customerID)
);


-- -----------------------------------------------------
-- Table Suppliers
-- -----------------------------------------------------
DROP TABLE IF EXISTS Suppliers CASCADE;
DROP SEQUENCE IF EXISTS supplier_id_seq CASCADE;
CREATE SEQUENCE supplier_id_seq;


CREATE TABLE  Suppliers (
  supplier_id INTEGER PRIMARY KEY DEFAULT  nextval('supplier_id_seq'),
  co_name VARCHAR(45) NOT NULL UNIQUE,
  discount INTEGER CHECK (discount >= 0),
  rep_lname VARCHAR(45) NOT NULL,
  rep_fname VARCHAR(45) NOT NULL,
  rep_contact VARCHAR(45) NOT NULL,
  aid INTEGER NOT NULL REFERENCES Addresses (aid)
);


-- -----------------------------------------------------
-- Table Category
-- -----------------------------------------------------
DROP TABLE IF EXISTS Category CASCADE;
DROP SEQUENCE IF EXISTS categoryId_seq CASCADE;
CREATE SEQUENCE categoryId_seq;

CREATE TABLE  Category (
  categoryId INTEGER PRIMARY KEY DEFAULT  nextval('categoryId_seq'),
  name VARCHAR(45) NOT NULL UNIQUE,
  level VARCHAR(45) NOT NULL,
  parentId INTEGER NULL REFERENCES Category (categoryId)
);


-- -----------------------------------------------------
-- Table Products
-- -----------------------------------------------------
DROP TABLE IF EXISTS Products CASCADE;
DROP SEQUENCE IF EXISTS pid_seq CASCADE;
CREATE SEQUENCE pid_seq;

CREATE TABLE  Products (
  pid INTEGER PRIMARY KEY DEFAULT  nextval('pid_seq'),
  name VARCHAR(45) NOT NULL,
  hazardous BOOLEAN NOT NULL,
  weight NUMERIC NOT NULL CHECK(weight > 0),
  version VARCHAR(45) NOT NULL,
  description VARCHAR(45) NOT NULL,
  combine_ship BOOLEAN NOT NULL,
  picture VARCHAR(45),
  size VARCHAR(45),
  low_inv_thresh INTEGER NOT NULL CHECK(low_inv_thresh >= 0),
  categoryId INTEGER NOT NULL REFERENCES Category (categoryId)
);



-- -----------------------------------------------------
-- Table Orders
-- -----------------------------------------------------
DROP TABLE IF EXISTS Orders CASCADE;
DROP SEQUENCE IF EXISTS oid_seq CASCADE;
CREATE SEQUENCE oid_seq;

CREATE TABLE  Orders (
  oid INTEGER PRIMARY KEY DEFAULT  nextval('oid_seq'),
  -- cc_amt NUMERIC NOT NULL,
  date DATE NOT NULL,
  customerID INTEGER NOT NULL REFERENCES Customer (customerID)
  -- cc_id INTEGER NOT NULL REFERENCES Credit_Cards (cc_id)
);

-- -----------------------------------------------------
-- Table Product_Supplier
-- -----------------------------------------------------
DROP TABLE IF EXISTS Product_Supplier CASCADE;
DROP SEQUENCE IF EXISTS supplierId_seq CASCADE;
CREATE SEQUENCE supplierId_seq;

CREATE TABLE  Product_Supplier (
  supplierId INTEGER PRIMARY KEY DEFAULT  nextval('supplierId_seq'),
  price NUMERIC NOT NULL CHECK(price > 0),
  qty INTEGER NOT NULL,
  supplier_id INTEGER NOT NULL REFERENCES Suppliers (supplier_id) on delete cascade,
  pid INTEGER NOT NULL REFERENCES Products (pid) on delete cascade
);


-- -----------------------------------------------------
-- Table Shopping_Cart
-- -----------------------------------------------------
DROP TABLE IF EXISTS Shopping_Cart CASCADE;
DROP SEQUENCE IF EXISTS sid_seq CASCADE;
CREATE SEQUENCE sid_seq;

CREATE TABLE  Shopping_Cart (
  sid INTEGER PRIMARY KEY DEFAULT  nextval('sid_seq'),
  customerID INTEGER NOT NULL UNIQUE REFERENCES Customer (customerID)
);


-- -----------------------------------------------------
-- Table Cart_Items
-- -----------------------------------------------------
DROP TABLE IF EXISTS Cart_Items CASCADE;
DROP SEQUENCE IF EXISTS cartID_seq CASCADE;
CREATE SEQUENCE cartID_seq;

CREATE TABLE  Cart_Items (
  cartID INTEGER PRIMARY KEY DEFAULT  nextval('cartID_seq'),
  qty INTEGER NOT NULL CHECK (qty >0),
  pid INTEGER NOT NULL REFERENCES Products (pid) on delete cascade,
  sid INTEGER NOT NULL REFERENCES Shopping_Cart (sid)
);



-- -----------------------------------------------------
-- Table Returns
-- -----------------------------------------------------
DROP TABLE IF EXISTS Returns CASCADE;
DROP SEQUENCE IF EXISTS rma_seq CASCADE;
CREATE SEQUENCE rma_seq;

CREATE TABLE  Returns (
  rma INTEGER PRIMARY KEY DEFAULT  nextval('rma_seq'),
  date DATE NOT NULL,
  partial BOOLEAN NOT NULL,
  refunded_amt NUMERIC NOT NULL,
  status VARCHAR(45) NOT NULL,
  customerID INTEGER NOT NULL REFERENCES Customer (customerID),
  oid INTEGER NOT NULL REFERENCES Orders (oid),
  cc_id INTEGER NOT NULL REFERENCES Credit_Cards (cc_id)
);

-- -----------------------------------------------------
-- Table Charges
-- -----------------------------------------------------
DROP TABLE IF EXISTS Charges CASCADE;
DROP SEQUENCE IF EXISTS chargeID_seq CASCADE;
CREATE SEQUENCE chargeID_seq;

CREATE TABLE  Charges (
  chargeID INTEGER PRIMARY KEY DEFAULT nextval('chargeID_seq'),
  oid INTEGER NOT NULL REFERENCES Orders (oid),
  customerID INTEGER NOT NULL REFERENCES Customer (customerID),
  date DATE NOT NULL,
  cc_amt NUMERIC NOT NULL,
  store_credit_bal NUMERIC NOT NULL,
  qty INTEGER NOT NULL,
  supplierId INTEGER NOT NULL REFERENCES Product_Supplier(supplierId),
  cc_id INTEGER NOT NULL REFERENCES Credit_Cards (cc_id)
);


-- -----------------------------------------------------
-- Table Shipments
-- -----------------------------------------------------
DROP TABLE IF EXISTS Shipments CASCADE;
DROP SEQUENCE IF EXISTS ship_id_seq CASCADE;
CREATE SEQUENCE ship_id_seq;

CREATE TABLE  Shipments (
  ship_id INTEGER PRIMARY KEY DEFAULT nextval('ship_id_seq'),
  partial BOOLEAN NOT NULL,
  ship_date DATE NOT NULL,
  aid INTEGER NOT NULL,
  oid INTEGER NOT NULL REFERENCES Orders (oid),
  customerID INTEGER NOT NULL REFERENCES Customer (customerID)
);


-- -----------------------------------------------------
-- Table Carriers
-- -----------------------------------------------------
DROP TABLE IF EXISTS Carriers CASCADE;
DROP SEQUENCE IF EXISTS carrier_id_seq CASCADE;
CREATE SEQUENCE carrier_id_seq;

CREATE TABLE  Carriers (
  carrier_id INTEGER PRIMARY KEY DEFAULT  nextval('carrier_id_seq'),
  hazardous BOOLEAN NOT NULL,
  name VARCHAR(45) NOT NULL,
  ship_type VARCHAR(45) NOT NULL
);


-- -----------------------------------------------------
-- Table Customer_Addresses
-- -----------------------------------------------------
DROP TABLE IF EXISTS Customer_Addresses CASCADE;
DROP SEQUENCE IF EXISTS customerAddressId_seq CASCADE;
CREATE SEQUENCE customerAddressId_seq;

CREATE TABLE  Customer_Addresses (
  customerAddressId INTEGER PRIMARY KEY DEFAULT  nextval('customerAddressId_seq'),
  preferred BOOLEAN NOT NULL,
  aid INTEGER NOT NULL REFERENCES Addresses (aid),
  customerID INTEGER NOT NULL REFERENCES Customer (customerID)
);


-- -----------------------------------------------------
-- Table Item_List
-- -----------------------------------------------------
DROP TABLE IF EXISTS Item_List CASCADE;
DROP SEQUENCE IF EXISTS itemListId_seq CASCADE;
CREATE SEQUENCE itemListId_seq;

CREATE TABLE  Item_List (
  itemListId INTEGER PRIMARY KEY DEFAULT nextval('itemListId_seq'),
  returned BOOLEAN NOT NULL,
  qty INTEGER NOT NULL CHECK (qty >0),
  shipped BOOLEAN NOT NULL,
  price NUMERIC NOT NULL,
  oid INTEGER NOT NULL REFERENCES Orders (oid ) on delete cascade,
  supplierId INTEGER NOT NULL REFERENCES Product_Supplier(supplierId)
);


-- -----------------------------------------------------
-- Table Shipment_List
-- -----------------------------------------------------
DROP TABLE IF EXISTS Shipment_List CASCADE;
DROP SEQUENCE IF EXISTS shipListId_seq CASCADE;
CREATE SEQUENCE shipListId_seq;

CREATE TABLE  Shipment_List (
  shipListId INTEGER PRIMARY KEY DEFAULT  nextval('shipListId_seq'),
  qty INTEGER NOT NULL CHECK (qty >0),
  ship_id INTEGER NOT NULL REFERENCES Shipments (ship_id),
  carrier_id INTEGER NOT NULL REFERENCES Carriers (carrier_id),
  itemListId INTEGER NOT NULL REFERENCES Item_List (itemListId)
);


-- -----------------------------------------------------
-- Table Return_List
-- -----------------------------------------------------
DROP TABLE IF EXISTS Return_List CASCADE;
DROP SEQUENCE IF EXISTS returnListId_seq CASCADE;
CREATE SEQUENCE returnListId_seq;

CREATE TABLE  Return_List (
  returnListId INTEGER PRIMARY KEY DEFAULT  nextval('returnListId_seq'),
  qty INTEGER NOT NULL CHECK (qty >0),
  rma INTEGER NOT NULL REFERENCES Returns (rma),
  itemListId INTEGER NOT NULL REFERENCES Item_List (itemListId)
);



-- -----------------------------------------------------
-- Table Exchanges
-- -----------------------------------------------------
DROP TABLE IF EXISTS Exchanges CASCADE;
DROP SEQUENCE IF EXISTS exchangeId_seq CASCADE;
CREATE SEQUENCE exchangeId_seq;

CREATE TABLE  Exchanges (
  exchangeId INTEGER PRIMARY KEY DEFAULT  nextval('exchangeId_seq'),
  qty INTEGER NOT NULL CHECK (qty >0),
  difference NUMERIC NOT NULL,
  itemListId INTEGER NOT NULL REFERENCES Item_List (itemListId)
);


-- -----------------------------------------------------
-- Table Restock
-- -----------------------------------------------------
DROP TABLE IF EXISTS Restock CASCADE;
DROP SEQUENCE IF EXISTS restock_id_seq CASCADE;
CREATE SEQUENCE restock_id_seq;


CREATE TABLE  Restock (
  restock_id INTEGER PRIMARY KEY DEFAULT nextval('restock_id_seq'),
  supplierID INTEGER NOT NULL,
  pid INTEGER NOT NULL,
  qty INTEGER NOT NULL,
  price NUMERIC NOT NULL
);


INSERT INTO Customer (email,phone,fname,lname,password,store_credit_bal)
VALUES ('one@hotmail.com','3053480136','Bill','Baxter','123',100.0);

INSERT INTO Customer (email,phone,fname,mname,lname,password,store_credit_bal)
VALUES ('two@hotmail.com','3053486412','Mary','Sue','Purple','123',100.0);

INSERT INTO Customer (email,phone,fname,lname,password,store_credit_bal)
VALUES ('three@hotmail.com','3053480814','Jimmy','White','123',100.0);

INSERT INTO Customer (email,phone,fname,lname,password,store_credit_bal)
VALUES ('four@hotmail.com','3053480999','Reny','Black','123',100.0);

INSERT INTO Customer (email,phone,fname,mname,lname,password,store_credit_bal)
VALUES ('five@hotmail.com','3053480140','Michelle','Leigh','Pink','123',100.0);



INSERT INTO Category(name,level)
VALUES ('Office Supplies',1);

INSERT INTO Category(name,level,parentId)
VALUES ('Stationary',2,1);

INSERT INTO Category(name,level)
VALUES ('Electronics',1);

INSERT INTO Category(name,level,parentId)
VALUES ('Audio Players',2,3);

INSERT INTO Category(name,level)
VALUES ('Cleaning',1);




INSERT INTO Products (name,hazardous,weight,version,description,combine_ship,picture,size,low_inv_thresh,categoryId)
VALUES ('Banana Pencil','0',0.02,1,'A banana themed pencil','1','webshop.com/bpencil','Tiny',400,2);

INSERT INTO Products (name,hazardous,weight,version,description,combine_ship,picture,size,low_inv_thresh,categoryId)
VALUES ('Banana Case','0',0.5,1,'A banana themed pencil','1','webshop.com/bpcase','Tiny',100,2);

INSERT INTO Products (name,hazardous,weight,version,description,combine_ship,picture,size,low_inv_thresh,categoryId)
VALUES ('Strawberry Pencil','0',0.02,1,'A strawberry themed pencil','1','webshop.com/spencil','Tiny',400,2);

INSERT INTO Products (name,hazardous,weight,version,description,combine_ship,picture,size,low_inv_thresh,categoryId)
VALUES ('CD Player','0',3,2,'A portable CD Player','1','webshop.com/cdplay','Small',25,4);

INSERT INTO Products (name,hazardous,weight,version,description,combine_ship,picture,size,low_inv_thresh,categoryId)
VALUES ('Cleaning Spray','1',0.75,1,'A Strong chemical cleaner','0','webshop.com/clean','Medium',50,5);


INSERT INTO Addresses(street,city,state,country,zip,apt)
VALUES ('11200 SW 8th Street','Miami','FL','USA','33166','ECS 232');

INSERT INTO Addresses(street,city,state,country,zip,apt)
VALUES ('11200 SW 8th Street','Miami','FL','USA','33166','VH 100');

INSERT INTO Addresses(street,city,state,country,zip,apt)
VALUES ('100 Big Apple Lane','New York','NY','USA','23412','St 300');

INSERT INTO Addresses(street,city,country,zip,apt)
VALUES ('3 K. Lane','Seoul','Korea','908777','Unit B');

INSERT INTO Addresses(street,city,state,country,zip)
VALUES ('5000 Cherry Lane','Houston','TX','USA','34512');

INSERT INTO Addresses(street,city,state,country,zip)
VALUES ('5000 Apple Lane','Miami','TX','USA','34512');

INSERT INTO Addresses(street,city,state,country,zip)
VALUES ('5000 Berry Lane','Dallas','TX','USA','34512');

INSERT INTO Addresses(street,city,state,country,zip)
VALUES ('6000 Strawberry Lane','Houston','TX','USA','34512');

INSERT INTO Addresses(street,city,state,country,zip)
VALUES ('5500 Pear Lane','Dallas','TX','USA','34561');

INSERT INTO Addresses(street,city,state,country,zip)
VALUES ('5000 Plum Lane','Austin','TX','USA','34512');



INSERT INTO Customer_Addresses(preferred,aid,customerID)
VALUES ('0',1,1);

INSERT INTO Customer_Addresses(preferred,aid,customerID)
VALUES ('1',2,2);

INSERT INTO Customer_Addresses(preferred,aid,customerID)
VALUES ('1',3,3);

INSERT INTO Customer_Addresses(preferred,aid,customerID)
VALUES ('0',4,4);


INSERT INTO Customer_Addresses(preferred,aid,customerID)
VALUES ('0',5,5);


INSERT INTO Credit_Cards(cc_co,exp_y,exp_m,num,defaultCC,aid,customerID)
VALUES ('AMEX',2018,1,'123456789','1',1,1);

INSERT INTO Credit_Cards(cc_co,exp_y,exp_m,num,defaultCC,aid,customerID)
VALUES ('MC',2016,2,'987654321','1',2,2);

INSERT INTO Credit_Cards(cc_co,exp_y,exp_m,num,defaultCC,aid,customerID)
VALUES ('MC',2016,3,'111111111','1',3,3);

INSERT INTO Credit_Cards(cc_co,exp_y,exp_m,num,defaultCC,aid,customerID)
VALUES ('VISA',2017,9,'222222222','0',4,4);

INSERT INTO Credit_Cards(cc_co,exp_y,exp_m,num,defaultCC,aid,customerID)
VALUES ('VISA',2018,9,'995566443','0',5,1);



INSERT INTO Suppliers(co_name,discount,rep_lname,rep_fname,rep_contact,aid)
VALUES('Yellow Stationary Co.',10,'Plum','Mary','1234567890',6);

INSERT INTO Suppliers(co_name,discount,rep_lname,rep_fname,rep_contact,aid)
VALUES('Red Audio',4,'Grape','Roger','1234567894',10);

INSERT INTO Suppliers(co_name,discount,rep_lname,rep_fname,rep_contact,aid)
VALUES('Green and Green',5,'Apple','Joe','1234567891',7);

INSERT INTO Suppliers(co_name,discount,rep_lname,rep_fname,rep_contact,aid)
VALUES('Blue Electronics',2,'White','Bob','1234567892',8);

INSERT INTO Suppliers(co_name,discount,rep_lname,rep_fname,rep_contact,aid)
VALUES('Purple Cleaning Supplies',11,'Black','Tammy','1234567893',9);




INSERT INTO Product_Supplier(price,qty,supplier_id,pid)
VALUES(0.10,1000000,1,1);

INSERT INTO Product_Supplier(price,qty,supplier_id,pid)
VALUES(9.98,1000000,1,2);

INSERT INTO Product_Supplier(price,qty,supplier_id,pid)
VALUES(0.10,1000000,3,3);

INSERT INTO Product_Supplier(price,qty,supplier_id,pid)
VALUES(59.99,1000000,2,4);

INSERT INTO Product_Supplier(price,qty,supplier_id,pid)
VALUES(4.95,1000000,5,5);



INSERT INTO Orders(date,customerID)
VALUES('2015-11-11',1);

INSERT INTO Orders(date,customerID)
VALUES('2015-10-1',2);

INSERT INTO Orders(date,customerID)
VALUES('2014-1-20',3);

INSERT INTO Orders(date,customerID)
VALUES('2014-10-20',4);

INSERT INTO Orders(date,customerID)
VALUES('2015-2-15',5);


INSERT INTO Returns(date,partial,refunded_amt,status,customerID,oid,cc_id) VALUES( '2015-11-1','0',25, 'Complete',1,1,1);
INSERT INTO Returns(date,partial,refunded_amt,status,customerID,oid,cc_id) VALUES( '2015-11-1','0',35.5, 'Complete',2,2,2);
INSERT INTO Returns(date,partial,refunded_amt,status,customerID,oid,cc_id) VALUES( '2015-11-3','0',5, 'Complete',3,3,3);
INSERT INTO Returns(date,partial,refunded_amt,status,customerID,oid,cc_id) VALUES( '2015-11-4','0',600, 'Complete',4,4,4);
INSERT INTO Returns(date,partial,refunded_amt,status,customerID,oid,cc_id) VALUES( '2015-11-5','1',215.15, 'Complete',5,5,5);


INSERT INTO Shopping_Cart(customerID) VALUES(1);
INSERT INTO Shopping_Cart(customerID) VALUES(2);
INSERT INTO Shopping_Cart(customerID) VALUES(3);
INSERT INTO Shopping_Cart(customerID) VALUES(4);
INSERT INTO Shopping_Cart(customerID) VALUES(5);



INSERT INTO Cart_Items(qty,pid,sid) VALUES(200,1,1);
INSERT INTO Cart_Items(qty,pid,sid) VALUES(100,3,2);
INSERT INTO Cart_Items(qty,pid,sid) VALUES(2000,1,3);
INSERT INTO Cart_Items(qty,pid,sid) VALUES(20,5,4);
INSERT INTO Cart_Items(qty,pid,sid) VALUES(50,4,5);


INSERT INTO Item_List(returned,qty,shipped,price,oid,supplierId) VALUES('0',200,'1',20,1,1);
INSERT INTO Item_List(returned,qty,shipped,price,oid,supplierId) VALUES('0',1,'1',9.98,2,2);
INSERT INTO Item_List(returned,qty,shipped,price,oid,supplierId) VALUES('0',25000,'1',2500,3,3);
INSERT INTO Item_List(returned,qty,shipped,price,oid,supplierId) VALUES('0',1,'1',59.99,4,4);
INSERT INTO Item_List(returned,qty,shipped,price,oid,supplierId) VALUES('0',1,'1',9.98,4,2);
INSERT INTO Item_List(returned,qty,shipped,price,oid,supplierId) VALUES('0',25,'1',123.75,5,4);


INSERT INTO Return_List(qty,rma,itemListId) VALUES(1,1,1);
INSERT INTO Return_List(qty,rma,itemListId) VALUES(25,2,2);
INSERT INTO Return_List(qty,rma,itemListId) VALUES(1,3,3);
INSERT INTO Return_List(qty,rma,itemListId) VALUES(1,4,4);
INSERT INTO Return_List(qty,rma,itemListId) VALUES(16,5,5);


INSERT INTO Carriers(hazardous,name,ship_type) VALUES('0', 'Easy Ship', 'International');
INSERT INTO Carriers(hazardous,name,ship_type) VALUES('0', 'DHL', 'International');
INSERT INTO Carriers(hazardous,name,ship_type) VALUES('0', 'UPS', 'International');
INSERT INTO Carriers(hazardous,name,ship_type) VALUES('0', 'USPS', 'International');
INSERT INTO Carriers(hazardous,name,ship_type) VALUES('1', 'Chem-Ship', 'Domestic');


INSERT INTO Exchanges(qty,difference,itemListId) VALUES(20,0,2);
INSERT INTO Exchanges(qty,difference,itemListId) VALUES(10,10,1);
INSERT INTO Exchanges(qty,difference,itemListId) VALUES(1,0,1);
INSERT INTO Exchanges(qty,difference,itemListId) VALUES(1,0,4);
INSERT INTO Exchanges(qty,difference,itemListId) VALUES(1,0,5);





INSERT INTO Shipments(partial,ship_date,aid,oid,customerID) VALUES('0', '2015-10-10',1,1,1);
INSERT INTO Shipments(partial,ship_date,aid,oid,customerID) VALUES('0', '2014-1-10',2,2,2);
INSERT INTO Shipments(partial,ship_date,aid,oid,customerID) VALUES('0', '2015-1-20',4,4,3);
INSERT INTO Shipments(partial,ship_date,aid,oid,customerID) VALUES('1', '2014-9-12',3,3,4);
INSERT INTO Shipments(partial,ship_date,aid,oid,customerID) VALUES('0', '2015-10-20',5,5,5);
INSERT INTO Shipments(partial,ship_date,aid,oid,customerID) VALUES('1', '2014-9-13',3,3,4);



INSERT INTO Shipment_List(qty,ship_id,carrier_id,itemListId) VALUES(20,1,1,1);
INSERT INTO Shipment_List(qty,ship_id,carrier_id,itemListId) VALUES(100,2,2,2);
INSERT INTO Shipment_List(qty,ship_id,carrier_id,itemListId) VALUES(25,3,3,3);
INSERT INTO Shipment_List(qty,ship_id,carrier_id,itemListId) VALUES(20,4,4,4);
INSERT INTO Shipment_List(qty,ship_id,carrier_id,itemListId) VALUES(105,5,5,5);
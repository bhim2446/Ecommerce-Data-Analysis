-- Correct Customers Table
SELECT * FROM customers where rownum <=5;
desc customers;
SELECT count(*) from customers;
select Unique count(Customer_Unique_id) from Customers;
-- Drop Customer_Unique_id no need of it alread have Customer_id
ALTER TABLE customers Drop COLUMN Customer_Unique_id;

-- Add Pk
Alter TABLE Customers Add CONSTRAINT Customers_pk PRIMARY Key(Customer_id);


-- Correct Geolocation Table
Desc Geolocation;
select * from geolocation where rownum <5;
--Check for Pk Column
select Count(*) from Geolocation;--1000163
select * from geolocation where geolocation_zip_code_prefix is NULL;
select geolocation_zip_code_prefix, Count(*) from Geolocation
GROUP BY geolocation_zip_code_prefix HAVING geolocation_zip_code_prefix>1;
--Add Pk
SELECT COUNT(*) AS unique_locations
FROM (
    SELECT DISTINCT GEOLOCATION_LAT , GEOLOCATION_LNG
    FROM Geolocation
);
--No Candidate for dublicate
SELECT COUNT(DISTINCT GEOLOCATION_LAT || ',' || GEOLOCATION_LNG || GEOLOCATION_ZIP_CODE_PREFIX || ',' || GEOLOCATION_CITY ||',' ||GEOLOCATION_STATE ) AS unique_locations
FROM Geolocation;

DELETE FROM Geolocation
WHERE ROWID IN (
    SELECT ROWID
    FROM (
        SELECT ROWID,
               ROW_NUMBER() OVER (
                   PARTITION BY GEOLOCATION_LAT, GEOLOCATION_LNG, GEOLOCATION_ZIP_CODE_PREFIX, GEOLOCATION_CITY, GEOLOCATION_STATE
                   ORDER BY ROWID
               ) AS rn
        FROM Geolocation
    )
    WHERE rn > 1
);

--Alter TABLE Geolocation Add CONSTRAINT geoloc_pk PRIMARY Key(GEOLOCATION_LAT,GEOLOCATION_LNG);
--Alter TABLE Geolocation Add CONSTRAINT geoloc_pk PRIMARY Key(GEOLOCATION_ZIP_CODE_PREFIX);

-- Correct Order_itmes Table
Desc Order_items;
select * from Order_items where rownum < 5;

--SHIPPING_LIMIT_DATE is varchar we need to chage it to timestamp
ALTER TABLE Order_items ADD SHIPPING_LIMIT_DATE1 TIMESTAMP;
-- Add value to new column
UPDATE order_items SET SHIPPING_LIMIT_DATE1 = TO_TIMESTAMP(SHIPPING_LIMIT_DATE, 'YYYY-MM-DD HH24:MI:SS');
-- Check null Error
select SHIPPING_LIMIT_DATE, SHIPPING_LIMIT_DATE1 from order_items where SHIPPING_LIMIT_DATE is NULL;
-- Drop Old Column
Alter TABLE order_items Drop COLUMN SHIPPING_LIMIT_DATE;
--Rename new column to Old
ALTER TABLE Order_items RENAME COLUMN SHIPPING_LIMIT_DATE1 TO SHIPPING_LIMIT_DATE;

-- Add Pk Order_items
Alter Table Order_Items Add CONSTRAINT pk_order_item Primary Key(Order_id, Order_item_id);
--Foreign Key
ALTER TABLE ORDER_ITEMS ADD CONSTRAINT fk_orderitems_order
FOREIGN KEY (ORDER_ID) REFERENCES ORDERS(order_id);

ALTER TABLE ORDER_ITEMS ADD CONSTRAINT fk_orderitems_product
FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCTS(product_id);

ALTER TABLE ORDER_ITEMS ADD CONSTRAINT fk_orderitems_seller
FOREIGN KEY (SELLER_ID) REFERENCES SELLERS(seller_id);

-- Correct Orders Table
Desc Orders;
select * from Orders where rownum <5;

-- Add new Columns
ALTER Table Orders 
Add (ORDER_PURCHASE_TIMESTAMP1 Timestamp, 
ORDER_APPROVED_AT1 Timestamp,
RDER_DELIVERED_CARRIER_DATE1 Timestamp,
ORDER_DELIVERED_CUSTOMER_DATE1 Timestamp,
ORDER_ESTIMATED_DELIVERY_DATE1 Date);

-- Add values to new columns
UPDATE orders SET 
ORDER_PURCHASE_TIMESTAMP1 = TO_TIMESTAMP(ORDER_PURCHASE_TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS'),
ORDER_APPROVED_AT1 = TO_TIMESTAMP(ORDER_APPROVED_AT, 'YYYY-MM-DD HH24:MI:SS'),
RDER_DELIVERED_CARRIER_DATE1 = TO_TIMESTAMP(ORDER_DELIVERED_CARRIER_DATE, 'YYYY-MM-DD HH24:MI:SS'),
ORDER_DELIVERED_CUSTOMER_DATE1 = TO_TIMESTAMP(ORDER_DELIVERED_CUSTOMER_DATE, 'YYYY-MM-DD HH24:MI:SS');
UPDATE orders Set
ORDER_ESTIMATED_DELIVERY_DATE1 = TO_DATE(ORDER_ESTIMATED_DELIVERY_DATE, 'YYYY-MM-DD HH24:MI:SS');

--Drop Old Columns 
ALTER TABLE orders
DROP (ORDER_PURCHASE_TIMESTAMP,
      ORDER_APPROVED_AT,
      ORDER_DELIVERED_CARRIER_DATE,
      ORDER_DELIVERED_CUSTOMER_DATE,
      ORDER_ESTIMATED_DELIVERY_DATE);

-- Rename new columns to the original names
ALTER TABLE orders RENAME COLUMN ORDER_PURCHASE_TIMESTAMP1 TO ORDER_PURCHASE_TIMESTAMP;
ALTER TABLE orders RENAME COLUMN ORDER_APPROVED_AT1 TO ORDER_APPROVED_AT;
ALTER TABLE orders RENAME COLUMN RDER_DELIVERED_CARRIER_DATE1 TO ORDER_DELIVERED_CARRIER_DATE;
ALTER TABLE orders RENAME COLUMN ORDER_DELIVERED_CUSTOMER_DATE1 TO ORDER_DELIVERED_CUSTOMER_DATE;
ALTER TABLE orders RENAME COLUMN ORDER_ESTIMATED_DELIVERY_DATE1 TO ORDER_ESTIMATED_DELIVERY_DATE;

-- Add Pk and fk
ALTER TABLE orders
ADD CONSTRAINT orders_pk PRIMARY KEY (order_id);
ALTER TABLE orders 
Add Constraint Order_fk FOREIGN KEY (CUSTOMER_ID) REFERENCES Customers(CUSTOMER_ID);

-- Correct Payment Table
Desc payments;
Select * from payments;
--ALTER TABLE payments Add CONSTRAINT payments_pk PRIMARY KEY(ORDER_ID);
ALTER TABLE Payments Add CONSTRAINT payments_fk Foreign Key(Order_id);

Alter Table Payments Add CONSTRAINT Payment_pk Primary Key(Order_id,PAYMENT_SEQUENTIAL);
REFERENCES Orders(Order_id);
select count(*) from payments;

--Correct Products Table
Desc Products;
ALTER TABLE Products Add CONSTRAINT Products_pk PRIMARY KEY(PRODUCT_ID);
SELECT * from products;
--Correct Sellers Table
Desc Sellers;
select * from Sellers where rownum <5;
ALTER TABLE Sellers Add CONSTRAINT seller_pk PRIMARY KEY(Seller_ID);
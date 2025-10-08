--Queries 
-- 1. List all unique cities where customers are located.

SELECT distinct count(customer_city) from customers;
SELECT distinct customer_city from customers where rownum <5;
--or
--select unique count(customer_city) from customers;
--select C.Customer_id , O.Customer_id from customers C INNER JOIN orders O ON O.Customer_id = C.Customer_id where rownum <5;
 
 -- 2. Count the number of orders placed in 2017.
select count(Order_purchase_timestamp) from Orders where To_Number(To_char(Order_purchase_timestamp, 'YYYY'))=2017;

select count ( Distinct PRODUCT_CATEGORY) from Products; --32341

--3. Find the total sales per category
select * from Order_items where Rownum <5;

select P.PRODUCT_CATEGORY, Count(*) from ORDER_ITEMS O Inner JOIN 
products P ON P.PRODUCT_ID=O.PRODUCT_ID 
group By P.PRODUCT_CATEGORY;

select P.PRODUCT_CATEGORY, count(*),Sum(Py.PAYMENT_VALUE) from ORDER_ITEMS O Inner JOIN 
products P ON P.PRODUCT_ID=O.PRODUCT_ID  Inner Join payments py ON O.ORDER_ID=Py.ORDER_ID
group By P.PRODUCT_CATEGORY Order By Count(*) Desc;

-- 4. Calculate the percentage of orders that were paid in installments.
Select count(Distinct Order_ID) Total_Orders from Payments;
select Count(Distinct Order_ID) Installment_Orders from Payments where Order_id in (select Order_ID from payments Group BY Order_ID having Count(payment_installments)>1);


select count(Distinct order_id) from Payments where  PAYMENT_INSTALLMENTS>1;--51170
select Count(DISTINCT Order_id) from payments;--99440
select Round((51170/99440)*100,2) from Dual;

SELECT 
    ROUND(
        (COUNT(CASE WHEN max_installments > 1 THEN 1 END) * 100.0) 
        / COUNT(*),
        2
    ) AS pct_orders_in_installments
FROM (
    SELECT order_id, MAX(payment_installments) AS max_installments
    FROM payments
    GROUP BY order_id
);

-- 5. Count the number of customers from each state.
select CUSTOMER_STATE, Count(Customer_ID) Num_Customer from Customers Group By CUSTOMER_STATE;

--6. Calculate the number of orders per month in 2018.
SELECT 
    TO_CHAR(TO_DATE(Month1, 'MM'), 'Month') AS Month_Name,
    COUNT(ORDER_ID) AS Total_Orders
FROM (
    SELECT 
        TO_CHAR(ORDER_PURCHASE_TIMESTAMP, 'MM') AS Month1,
        ORDER_ID
    FROM ORDERS
    WHERE TO_CHAR(ORDER_PURCHASE_TIMESTAMP, 'YYYY') = '2018'
)
GROUP BY Month1
ORDER BY Month1;
-- 7. Find the average number of products per order, grouped by customer city.
--select MAX(ORDER_ITEM_ID) Order_it from Order_items GROUP By Order_id Order By Order_it DESC;
--Select Count(PRODUCT_ID) Order_it from  Order_items GROUP By Order_id Order By Count(PRODUCT_ID) DESC;

Select City, Round(AVG(order_item_count),2) Avg_Order from
(SELECT 
        O.ORDER_ID,
        C.CUSTOMER_CITY City,
        Max(OT.ORDER_ITEM_ID) AS order_item_count
    FROM ORDER_ITEMS OT
    INNER JOIN ORDERS O 
        ON OT.ORDER_ID = O.ORDER_ID
    INNER JOIN CUSTOMERS C 
        ON C.CUSTOMER_ID = O.CUSTOMER_ID
    GROUP BY O.ORDER_ID, C.CUSTOMER_CITY Order By C.CUSTOMER_CITY Desc, order_item_count Desc) Group By City Order By Avg_Order Desc;











-- display all columns from all rows
select * from employees;  -- the * refers to all columns

-- select <column names separated by commas> from <table name>
select firstName,lastName,email from employees

-- select columns from table and rename the column headers
select firstName as 'First Name',lastName as 'Last Name',email as 'Email' from employees

-- use where to filter the rows
select * from employees where officeCode = 1;


-- extra example. When in doubt put '' when specifying field value of where 
SELECT city AS 'City',addressLine1 AS 'Address Line 1',addressLine2 AS 'Address Line 2',country  AS 'Country' 
FROM offices where country="USA";

-- Matches exactly to field value specified. LIKE can be used
SELECT * FROM employees where jobTitle = "Sales Rep";

-- USE LIKE with wildcard(i.e %) for partial strings
-- LIKE allows string matching.% is like wildcard. matching for strings that start with sales
select * from employees where jobTitle like "Sales%";
-- LIKE allows string matching.% is like wildcard. matching for strings that end with sales
select * from employees where jobTitle like "%Sales";
-- LIKE allows string matching.% is like wildcard. matching for strings that contain the word sales
select * from employees where jobTitle like "%Sales%";
-- no case sensitivity in mySQL

-- find all products which name begins with 1969
SELECT * FROM products where productName LIKE "1969%";
-- find all products which name contains the string 'Davidson'
SELECT * FROM products where productName LIKE "%Davidson%";

-- can include more than one string condition in LIKE
SELECT * FROM products where productName LIKE "%1969%davidson%";
SELECT * FROM products where productName LIKE "%davidson%El%";

-- filter for multiple conditions using logical operators
-- finding rows based on more than 1 condition
    -- AND
    -- 
    SELECT * FROM employees where officeCode=1 AND jobTitle LIKE "Sales Rep";

    -- OR
    SELECT * FROM employees where officeCode=1 OR officeCode=2;

    -- OR has lower priority than AND
    SELECT * FROM employees where jobTitle Like "Sales Rep" AND (officeCode=1 OR officeCode=2);


-- show all customers from USA in the state NV who have credit limit more than 5000 
-- or all customers from any country which credit limit is more than 100000
    SELECT * FROM customers where (country="USA" AND state="NV"AND creditLimit>5000) 
    OR creditLimit>100000;

-- a temporary table is created when tables are joined
SELECT * FROM employees JOIN offices
	ON employees.officeCode = offices.officeCode
	;

-- find results based on required parameters after joining tables
SELECT firstName,lastName,city,addressLine1,addressLine2 FROM employees JOIN offices
	ON employees.officeCode = offices.officeCode
	where Country="USA"
	;

-- show customerName with firstName,lastName and email of their salesRep
SELECT customerName,firstName,lastName,email FROM customers JOIN employees
	ON customers.salesRepEmployeeNumber = employees.employeeNumber;

-- show customerName with firstName,lastName and email of their salesRep, customers located in country USA
SELECT customerName,firstName,lastName,email,country FROM customers JOIN employees
	ON customers.salesRepEmployeeNumber = employees.employeeNumber
	where country="USA";

-- show customerName with firstName,lastName and email of their salesRep, customers located in country USA and customerName includes the word gift
SELECT customerName,firstName,lastName,email,country FROM customers JOIN employees
	ON customers.salesRepEmployeeNumber = employees.employeeNumber
	where country="USA" AND customerName LIKE "%gift%";

-- WHEN BOTH TABLES HAVE SAME FIELD HEADER NAME
SELECT firstName,lastName,employees.officeCode,city FROM employees JOIN offices
ON employees.officeCode = offices.officeCode
;

-- returns the total number of data in the table
SELECT Count(*) from customers;

-- BY DEFAULT IS INNERJOIN, if you put join
-- INNERJOIN, the join function does not include rows that does not have a value (i.e null value)
-- show the customerName along with the firstName, lastName and email of their sales rep
-- only for customers that have a sales rep
select customerName, salesRepEmployeeNumber, firstName, lastName, email
from customers join employees
on customers.salesRepEmployeeNumber = employees.employeeNumber

-- OUTER LEFT JOIN
--show all customers with their sales rep info, regardless of
--whether the customers have a sales repo or not
-- show the customerName along with the firstName, lastName and email of their sales rep
select customerName, firstName, lastName, email
from customers left join employees
on customers.salesRepEmployeeNumber = employees.employeeNumber

-- OUTER RIGHT JOIN
-- show the customerName along with the firstName, lastName and email of their sales rep
-- will show for all employees regardless of whether they have customers
-- (customers with no sales rep won't show up)
select customerName, firstName, lastName, email
from customers right join employees
on customers.salesRepEmployeeNumber = employees.employeeNumber

-- full outer join == left join + right join

-- for each customer in the USA, show the name of the sales rep and their office number
select customerName AS "Customer Name", customers.country as "Customer Country", firstName, lastName, offices.phone from customers JOIN employees
  ON customers.salesRepEmployeeNumber = employees.employeeNumber
  JOIN offices ON employees.officeCode = offices.officeCode
  WHERE customers.country = "USA";



-- DATE MANIPULATION
    --  CURDATE() --> tells you current date on server
    select curdate ();
    -- NOW() --> tells you date and time now
    select now();

    -- find payments made after 2003-06-30
    SELECT * FROM payments WHERE paymentDate>"2003-06-30";

    -- find payments made between 2003-01-01 and 2003-06-30
    SELECT * FROM payments WHERE paymentDate>="2003-01-01" AND paymentDate<="2003-06-30";
        -- alternatively
        SELECT * FROM payments WHERE paymentDate BETWEEN "2003-01-01" AND "2003-06-30";

    -- Display the year for a payment made
    SELECT checkNumber, year(paymentDate) FROM payments;
    -- show all payments made in the year 2003
    SELECT checkNumber, year(paymentDate) FROM payments WHERE year (paymentDate) = 2003;
    -- Display year, month and day separately frmo a single field paymentDate. the data type for this field MUST BE date/datetime
    SELECT checkNumber, year(paymentDate), month(paymentDate), day(paymentDate) FROM payments;


-- 1 - Find all the offices and display only their city, phone and country
Select city,phone,country from offices;
-- 2 - Find all rows in the orders table that mentions FedEx in the comments.
SELECT * FROM orders where comments like "%FedEx%";
-- 3 - Show the contact first name and contact last name of all customers in descending order by the customer's name
-- IMPLICITLY it is ASC if not stated
SELECT customerName,contactFirstName,contactLastName FROM customers ORDER BY customerName DESC;
-- 4 - Find all sales rep who are in office code 1, 2 or 3 and their first name or last name contains the substring 'son'
SELECT firstName,lastName,officeCode,jobTitle FROM employees
WHERE (officeCode=1 OR officeCode=2 OR officeCode=3) 
AND (firstName LIKE "%son%" OR lastName LIKE "%son%")
AND jobTitle="Sales Rep";
-- 5 - Display all the orders bought by the customer with the customer number 124, along with the customer name, the contact's first name and contact's last name.
SELECT customerName,contactFirstName,contactLastName,orders.customerNumber,orders.orderNumber,orderdetails.productCode FROM orders JOIN customers
ON orders.customerNumber = customers.customerNumber
JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber
WHERE orders.customerNumber=124;
-- 6 - Show the name of the product, together with the order details,  for each order line from the orderdetails table
SELECT orderdetails.*,productName FROM orderdetails LEFT JOIN products
ON orderdetails.productCode = products.productCode;
SELECT count(*) FROM orderdetails LEFT JOIN products
ON orderdetails.productCode = products.productCode;


-- 15 JULY 2022
-- AGGREGATE FUNCTIONS--> AKA REDUCER
-- taking multiple data to return 1 result
-- IF combined with JOIN, JOIN HAPPENS FIRST, THEN AGGREGATE FUNCTIONS

-- # 1 count: counts how many rows of data there are
-- select count(*) from <table name>
SELECT count(*) FROM orderdetails;

-- # 2 sum: allows you to add all together
-- select sum(columnName) from <table name>
SELECT sum(quantityOrdered) FROM orderdetails;
SELECT sum(quantityOrdered) FROM orderdetails
	WHERE productCode = "S18_1749";

-- # 2 *: multiplication
SELECT sum(quantityOrdered * priceEach) FROM orderdetails
	WHERE productCode = "S18_1749";

-- # 3 GROUP BY: count/sum of each criteria for all groups (e.g for each country of all countries)
-- instead of each country at a time when using count(*) or sum(<column name>)
-- Select <column name criteria> , AGGREGATE FUNCTION FROM <table name>
-- GROUP BY <column name criteria>
    -- ORDER of precedence:
    -- 1) table is selected 
    -- 2) JOIN happens before WHERE --> to join
    -- 3) WHERE happens before GROUP BY --> to filter
    -- 4) GROUP BY happens before SELECT --> table is grouped by criteria (column name) into individual tables 
    -- 5) HAVING happens before SELECT criteria
    -- 5) SELECT criteria (column name) and aggregate functions happens in each group
    -- 6) ORDER BY happens last --> works on the results of the group by

    -- GROUP BY EXAMPLE:
        -- get total number of customers by country
            SELECT country,count(*) FROM customers 
            GROUP BY country;
        -- get average creditLimit for customers by country
            SELECT country,avg(creditLimit) FROM customers 
            GROUP BY country;
        -- get average creditLimit for customers and the number of customers per country
            SELECT country,avg(creditLimit),count(*) FROM customers 
            GROUP BY country;
        -- get average creditLimit for customers and the number of customers per country for employee number 1504
            SELECT country, avg(creditLimit),count(*)
            FROM customers 
            WHERE salesRepEmployeeNumber = 1504
            GROUP BY country;
        -- 
            SELECT country,avg(creditLimit),count(*)
            FROM customers 
            JOIN employees on customers.salesRepEmployeeNumber = employees.employeeNumber
            WHERE salesRepEmployeeNumber = 1504
            GROUP BY country;
        -- plus sorting
            SELECT country, firstName,lastName,email, avg(creditLimit),count(*)
            FROM customers 
            JOIN employees on customers.salesRepEmployeeNumber = employees.employeeNumber
            WHERE salesRepEmployeeNumber = 1504
            GROUP BY country, firstName,lastName,email
            ORDER BY avg(creditLimit);
        -- plus sorting, plus limit
            SELECT country, firstName,lastName,email, avg(creditLimit),count(*)
            FROM customers 
            JOIN employees on customers.salesRepEmployeeNumber = employees.employeeNumber
            WHERE salesRepEmployeeNumber = 1504
            GROUP BY country, firstName,lastName,email
            ORDER BY avg(creditLimit) DESC
            LIMIT 3;
        -- plus sorting, plus limit, plus filtering of the GROUPS
            SELECT country, firstName,lastName,email, avg(creditLimit),count(*)
            FROM customers 
            JOIN employees on customers.salesRepEmployeeNumber = employees.employeeNumber
            WHERE salesRepEmployeeNumber = 1504
            GROUP BY country, firstName,lastName,email
            HAVING ....
            ORDER BY avg(creditLimit) DESC
            LIMIT 3;

-- SUBQUERY (OPTIONAL)
-- query on returned table
-- continued from Q11 --> show product code of product ordered the most times
SELECT productCode from (
	SELECT products.productCode,productName,count(*) AS "times_ordered" FROM orderdetails JOIN products
        ON orderdetails.productCode = products.productCode
        GROUP BY products.productCode,productName
        ORDER BY times_ordered DESC
        LIMIT 1
 ) AS sub;   

-- find all customers whose credit limit is above the average
-- when select returns 1 value only, it is treated as a primitive
 SELECT * FROM customers WHERE creditLimit > (SELECT avg(creditLimit) FROM customers)
 ORDER BY creditLimit;

-- distinct(column name) --> returns one of each value, removes duplicates
select * from products where productCode 
NOT IN (SELECT distinct(productCode) FROM orderdetails);

-- for each sales Rep, show the customers that contribute to more than 10% of sales of the Company
SELECT employeeNumber,firstName,lastName, sum(amount) FROM employees 
JOIN customers ON employees.employeeNumber = customers.salesRepEmployeeNumber
JOIN payments ON customers.customerNumber = payments.customerNumber 
GROUP BY employees.employeeNumber
HAVING sum(amount) > (select sum(amount)*0.1 FROM payments)


-- QUESTIONS
    -- find the total amount paid by customers in the month of June 2003
    SELECT sum(amount) FROM payments WHERE year(paymentDate)=2003 AND month(paymentDate)=6 ;
    -- OR
    SELECT sum(amount) FROM payments WHERE paymentDate BETWEEN "2003-06-01" AND "2003-06-30" ;

    -- 7 - Display sum of all the payments made by each company from the USA. 
        SELECT customerName,country, sum(amount) FROM payments JOIN customers
        ON payments.customerNumber = customers.customerNumber
        WHERE country = "USA"
        GROUP BY customerName, country;
        -- OR --> ensures that there are customers with the same name are displayed separately
        SELECT payments.customerNumber,customerName,country, sum(amount) FROM payments JOIN customers
        ON payments.customerNumber = customers.customerNumber
        WHERE country = "USA"
        GROUP BY payments.customerNumber,customerName, country;


    -- 8 - Show how many employees are there for each state in the USA		
        SELECT state,count(*) AS "employee_count" FROM employees
        JOIN offices
        ON employees.officeCode = offices.officeCode
        WHERE country="USA"
        GROUP BY state;

    -- 9 - From the payments table, display the average amount spent by each customer. Display the name of the customer as well.
        SELECT payments.customerNumber,customerName,avg(amount) FROM payments JOIN customers
        ON payments.customerNumber = customers.customerNumber
        GROUP BY payments.customerNumber,customerName;

    -- 10 - From the payments table, display the average amount spent by each customer but only if the customer has spent a minimum of 10,000 dollars.
        SELECT payments.customerNumber,customerName,avg(amount),sum(amount) 
		FROM payments JOIN customers
        ON payments.customerNumber = customers.customerNumber
        GROUP BY payments.customerNumber,customerName
        HAVING sum(amount)>=10000
        ORDER BY sum(amount);

    -- 11  - For each product, display how many times it was ordered, 
    -- and display the results with the most orders first and only show the top ten.
        SELECT products.productCode,count(*) AS "times_ordered" FROM orderdetails JOIN products
        ON orderdetails.productCode = products.productCode
        GROUP BY products.productCode
        ORDER BY times_ordered DESC
        LIMIT 10;

    -- 12 - Display all orders made between Jan 2003 and Dec 2003
        SELECT * FROM orders WHERE year(orderDate)=2003;

    -- 13 - Display all the number of orders made, per month, between Jan 2003 and Dec 2003
        SELECT month(orderDate),count(*) FROM orders 
        WHERE year(orderDate)=2003
        GROUP BY month(orderDate);


-- CLASSIC MODEL QUESTIONS
    -- Prepare a list of offices sorted by country, state, city.
        SELECT * FROM offices
        ORDER BY country ASC, state ASC, city ASC;
    -- How many customers are there in the company?
        SELECT count(*) FROM customers; 
    -- What is the total of payments received in the year 2004?
        SELECT sum(amount) FROM payments
        WHERE year(paymentDate)=2004;
    -- List the product lines that contain 'Cars'.
        SELECT * FROM productlines WHERE productLine LIKE "%cars%";
    -- Show products that have been purchased at least ten times 
        SELECT orderdetails.productCode,count(*) FROM orderdetails JOIN products
        ON orderdetails.productCode = products.productCode
        GROUP BY orderdetails.productCode
        HAVING count(*)>=10
        ORDER BY count(*) ASC;
    -- Report total payments for October 28, 2004 for all customers in USA
        SELECT sum(amount) FROM payments JOIN customers
        ON payments.customerNumber = customers.customerNumber
        WHERE paymentDate="2004-10-28" AND country="USA";
    -- Report those payments greater than $100,000.


    -- List the products in each product line.



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
SELECT customerName,contactFirstName,contactLastName FROM customers ORDER BY customerName DESC;
-- 4 - Find all sales rep who are in office code 1, 2 or 3 and their first name or last name contains the substring 'son'
SELECT firstName,lastName,officeCode FROM employees
WHERE (officeCode=1 OR officeCode=2 OR officeCode=3) AND (firstName LIKE "%son%" OR lastName LIKE "%son%");
-- 5 - Display all the orders bought by the customer with the customer number 124, along with the customer name, the contact's first name and contact's last name.
SELECT customerName,contactFirstName,contactLastName,orders.customerNumber FROM orders JOIN customers
ON orders.customerNumber = customers.customerNumber
WHERE orders.customerNumber=124;
-- 6 - Show the name of the product, together with the order details,  for each order line from the orderdetails table
SELECT count(*) FROM orderdetails LEFT JOIN products
ON orderdetails.productCode = products.productCode;
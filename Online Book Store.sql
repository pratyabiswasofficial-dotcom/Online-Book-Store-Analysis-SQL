--Create Database
CREATE DATABASE OnlineBookStore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books(
    Book_id SERIAL PRIMARY KEY,
	Title VARCHAR(100),
	Author VARCHAR(100),
	Genre VARCHAR(50),
	Published_year INT,
	Price NUMERIC(10,2),
	Stock INT
);

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers(
     Customer_id SERIAL PRIMARY KEY,
	 Name VARCHAR(100),
	 Email VARCHAR(100),
	 Phone VARCHAR(15),
	 City VARCHAR(50),
	 Country varchar(150)
);

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders(
     Order_id SERIAL PRIMARY KEY,
     Customer_id INT REFERENCES Customers(Customer_id),
	 Book_id INT REFERENCES Books(book_id),
	 Order_date DATE,
	 Quantity INT,
	 Total_amount NUMERIC(10,2)
);

COPY Books(Book_id,Title,Author,Genre,Published_year,Price,Stock)
FROM 'C:\Users\Pratya Biswas\Documents\CSV files\books.csv'
CSV HEADER;

COPY Customers(Customer_id,name,email,phone,city,country)
FROM 'C:\Users\Pratya Biswas\Documents\CSV files\customers.csv'
CSV HEADER;

COPY Orders(Order_id,Customer_id,Book_id,Order_date,Quantity,Total_amount)
FROM 'C:\Users\Pratya Biswas\Documents\CSV files\orders.csv'
CSV HEADER;

SELECT * FROM Books;

SELECT * FROM Customers;

SELECT * FROM Orders;

--                                         Basics Quearies

-- 1) Retrieve all the books in the "Fiction" genre:

SELECT * FROM Books WHERE genre='Fiction';

-- 2) Find books published after the 1950:

SELECT * FROM Books  WHERE published_year>1950 ORDER BY published_year ASC;

-- 3) List all customers from the Canada.

SELECT * FROM Customers WHERE country='Canada';

-- 4) Show order placed in November 2023.

SELECT * FROM Orders WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available.

SELECT SUM(Stock) AS Total_stock FROM Books;

-- 6) Find the details of the most expensive book.

SELECT * FROM Books ORDER BY price DESC LIMIT 1;

-- 7) Show all customers who ordered more than 1quantity of a book.

SELECT * FROM Orders WHERE quantity>1;

-- 8) Retrieve all orders where the total amount exceed $20.

SELECT * FROM Orders WHERE total_amount>20;

-- 9) List all genres available in the Books table

SELECT DISTINCT genre FROM Books;

-- 10) Find the book with the lowest stock

SELECT * FROM Books ORDER BY stock ASC LIMIT 1;

-- 11) Calculate the toal revenue generated from all orders.

SELECT SUM(total_amount) AS total_revenue FROM Orders;


--                                              Advance Quearies

-- 1) Retrieve the total number of books sold for each genre.

SELECT * FROM Orders;

SELECT b.genre, SUM(o.quantity) AS total_number_of_book_sold
FROM Orders o
JOIN Books b ON b.book_id=o.book_id
GROUP BY b.genre;

-- 2) Find the average price of books in the "Fantasy" genre.

SELECT AVG(price) AS Average_price_of_books
FROM Books
WHERE genre='Fantasy';

-- 3) List customers who have placed at leaset 2 orders.

SELECT * FROM Orders;

SELECT customer_id, COUNT(order_id) AS At_least_2_orders
FROM Orders
GROUP BY customer_id
HAVING COUNT(order_id)>=2;

-- Get the customer name

SELECT o.customer_id, c.name, COUNT(o.order_id) AS At_least_2_orders
FROM Orders o
JOIN Customers c ON o.customer_id=c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(order_id)>=2;

-- 4) Find the most frequently ordered books.

SELECT book_id, COUNT(order_id) AS most_frequent_ordered
FROM Orders
GROUP BY book_id
ORDER BY most_frequent_ordered DESC LIMIT 1;

-- Get the book title

SELECT o.book_id, b.title, COUNT(o.order_id) AS most_frequent_ordered
FROM Orders o
JOIN Books b ON o.book_id=b.book_id
GROUP BY o.book_id, b.title
ORDER BY most_frequent_ordered DESC LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre.

SELECT * FROM Books
WHERE genre='Fantasy'
ORDER BY price DESC LIMIT 3;

-- 6) Retrieve the total quantity of books sold by each author.

SELECT b.author, SUM(o.quantity) AS total_quantity_of_book_sold
FROM Orders o
JOIN Books b ON b.book_id=o.book_id
GROUP BY b.author;

-- 7) List the cities where customers who spent over $30 are loc

SELECT DISTINCT c.city, total_amount
FROM Customers c
JOIN Orders o ON c.customer_id=o.customer_id
WHERE o.total_amount>30;

-- 8) Find the customer who spent the most on orders.

SELECT c.customer_id,c.name, SUM(o.total_amount) AS total_spent
FROM Orders o
JOIN Customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC LIMIT 1;

-- 9) Calculate the stock remaining after fulfilling all orders.

SELECT b.book_id,b.title,b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity
FROM Books b
LEFT JOIN Orders o ON o.book_id=b.book_id
GROUP BY b.book_id; 

-- Get Remainging quantity order by book_id

SELECT b.book_id,b.title,b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,
       b.stock-COALESCE(SUM(o.quantity),0) AS Remaining_quantity
FROM Books b
LEFT JOIN Orders o ON o.book_id=b.book_id
GROUP BY b.book_id ORDER BY b.book_id; 




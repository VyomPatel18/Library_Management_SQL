--- Library Management Project ---

-- Creating Tables --
drop table if exists branch;

CREATE TABLE BRANCH (
	BRANCH_ID VARCHAR(20) PRIMARY KEY,
	MANAGER_ID VARCHAR(20),
	BRANCH_ADDRESS VARCHAR(50),
	CONTACT_NO VARCHAR(20)
)

CREATE TABLE EMPLOYES (
	EMP_ID VARCHAR(20) PRIMARY KEY,
	EMP_NAME VARCHAR(20),
	POSITION VARCHAR(20),
	SALARY INT,
	BRANCH_ID VARCHAR (20) --fk
)

CREATE TABLE BOOKS (
	ISBN VARCHAR(30) PRIMARY KEY,
	BOOK_TITLE VARCHAR(60),
	CATEGORY VARCHAR(20),
	RENTAL_PRICE FLOAT,
	STATUS VARCHAR(20),
	AUTHOR VARCHAR(30),
	PUBLISHER VARCHAR(30)
)

CREATE TABLE MEMBERS (
	MEMBER_ID VARCHAR(20) PRIMARY KEY,
	MEMBER_NAME VARCHAR(20),
	MEMBER_ADDRESS VARCHAR(20),
	REG_DATE DATE
)

CREATE TABLE ISSUED_STATUS (
	ISSUED_ID VARCHAR(20) PRIMARY KEY,
	ISSUED_MEMBER_ID VARCHAR(20), --fk
	ISSUED_BOOK_NAME VARCHAR(60),
	ISSUED_DATE DATE,
	ISSUED_BOOK_ISBN VARCHAR(30), --fk
	ISSUED_EMP_ID VARCHAR(20) --fk
)

CREATE TABLE RETURN_STATUS (
	RETURN_ID VARCHAR(20) PRIMARY KEY,
	ISSUED_ID VARCHAR(20), --fk
	RETURN_BOOK_NAME VARCHAR(70),
	RETURN_DATE DATE,
	RETURN_BOOK_ISBN VARCHAR(20)
)


--FOREIGN KEY --
ALTER TABLE ISSUED_STATUS
DROP CONSTRAINT FK_MEMBERS;

ALTER TABLE ISSUED_STATUS
ADD CONSTRAINT FK_MEMBERS FOREIGN KEY (ISSUED_MEMBER_ID) REFERENCES MEMBERS(MEMBER_ID)

ALTER TABLE ISSUED_STATUS
ADD CONSTRAINT FK_BOOKS FOREIGN KEY (ISSUED_BOOK_ISBN) REFERENCES  BOOKS(ISBN)

ALTER TABLE ISSUED_STATUS
ADD CONSTRAINT FK_EMPLOYES FOREIGN KEY (ISSUED_EMP_ID) REFERENCES  EMPLOYES(EMP_ID)

ALTER TABLE EMPLOYES
ADD CONSTRAINT FK_BRANCH FOREIGN KEY (BRANCH_ID) REFERENCES  BRANCH(BRANCH_ID)

ALTER TABLE RETURN_STATUS
ADD CONSTRAINT FK_ISSUED_STATUS FOREIGN KEY (ISSUED_ID) REFERENCES  ISSUED_STATUS(ISSUED_ID)


-- Show Imported Data --
select * from books;
select * from branch;
select * from employes;
select * from issued_status;
select * from members;
select * from return_status;


-- Project Tasks --

--- CRUD Operations ---
-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO
	BOOKS (
		ISBN,
		BOOK_TITLE,
		CATEGORY,
		RENTAL_PRICE,
		STATUS,
		AUTHOR,
		PUBLISHER
	)
VALUES
	(
		'978-1-60129-456-2',
		'To Kill a Mockingbird',
		'Classic',
		6.00,
		'yes',
		'Harper Lee',
		'J.B. Lippincott & Co.'
	)
	
-- Extra one for prectice 
INSERT INTO
	BOOKS (
		ISBN,
		BOOK_TITLE,
		CATEGORY,
		RENTAL_PRICE,
		STATUS,
		AUTHOR,
		PUBLISHER
	)
VALUES
	(
		'978-1-70139-466-3',
		'To Be Hero',
		'Classic',
		7.50,
		'yes',
		'Hayper leo',
		'Scribner'
	)
	
-- Task 2: Update an Existing Member's Address
UPDATE MEMBERS
SET
	MEMBER_ADDRESS = '102 oakly St'
WHERE
	MEMBER_ID = 'C105'

-- Extra one for prectice 
UPDATE MEMBERS
SET
	MEMBER_NAME = 'Jony'
WHERE
	MEMBER_ID = 'C119'
	
-- Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
DELETE FROM ISSUED_STATUS
WHERE
	ISSUED_ID = 'IS121'

-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
SELECT
	*
FROM
	ISSUED_STATUS
WHERE
	ISSUED_EMP_ID = 'E101'

-- Extra one for prectice 
SELECT
	issued_book_name
FROM
	ISSUED_STATUS
WHERE
	ISSUED_EMP_ID = 'E101' 
	
-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
SELECT
	ISSUED_MEMBER_ID,
	COUNT(ISSUED_BOOK_NAME) AS TOTAL_BOOK_ISSUED
FROM
	ISSUED_STATUS
GROUP BY
	ISSUED_MEMBER_ID
HAVING
	COUNT(ISSUED_BOOK_NAME) > 1;


--- CTAS (Create Table As Select) ---
-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

CREATE TABLE TOTAL_BOOK_ISSUED_CNT AS
SELECT
	BKS.ISBN,bks.book_title,
	COUNT(IST.ISSUED_ID) AS NO_ISSUED
FROM
	BOOKS AS BKS
	JOIN ISSUED_STATUS AS IST ON IST.ISSUED_BOOK_ISBN = BKS.ISBN
GROUP BY
	1, 2;

SELECT * from total_book_issued_cnt

	
--- Data Analysis & Findings ---
-- Task 7: Retrieve All Books in a Specific Category:
SELECT
	CATEGORY,
	BOOK_TITLE
FROM
	BOOKS
WHERE
	CATEGORY = 'Fiction'
	OR CATEGORY = 'Classic'
ORDER BY
	CATEGORY;
	
-- Task 8: Find Total Rental Income by Category:
SELECT DISTINCT
	CATEGORY,
	SUM(RENTAL_PRICE)
FROM
	ISSUED_STATUS AS IST
	JOIN BOOKS AS B ON B.ISBN = IST.ISSUED_BOOK_ISBN
GROUP BY
	1
ORDER BY
	CATEGORY;

-- Task 9: List Members Who Registered in the Last 180 Days:
SELECT
	*
FROM
	MEMBERS
WHERE
	REG_DATE >= CURRENT_DATE - INTERVAL '180days'

insert into members(member_id,member_name, member_address, reg_date) VALUES ('C120','same', '120 point st', '2025-05-12'),('C121','roy', '120 xxx st', '2025-04-12')

-- Task 10: List Employees with Their Branch Manager's Name and their branch details:
SELECT
	E1.EMP_ID,
	E1.EMP_NAME,
	E1.POSITION,
	B.MANAGER_ID,
	E2.EMP_NAME AS MANAGER_NAME,
	E2.POSITION
FROM
	EMPLOYES AS E1
	JOIN BRANCH AS B ON B.BRANCH_ID = E1.BRANCH_ID
	JOIN EMPLOYES AS E2 ON B.MANAGER_ID = E2.EMP_ID;
-- select * from employes as e1 join branch as b on b.branch_id = e1.branch_id join employes as e2 on b.manager_id = e2.emp_id

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 8 USD:
CREATE TABLE EXPENSIVE_BOOKS AS
SELECT
	*
FROM
	BOOKS
WHERE
	RENTAL_PRICE >= 8
ORDER BY
	BOOKS.RENTAL_PRICE DESC

SELECT * FROM EXPENSIVE_BOOKS

-- Task 12: Retrieve the List of Books Not Yet Returned
SELECT
	*
FROM
	ISSUED_STATUS AS IST
	LEFT JOIN RETURN_STATUS AS RS ON RS.ISSUED_ID = IST.ISSUED_ID
WHERE
	RS.RETURN_ID IS NULL


--- Advanced SQL Operations ---

/*Task 13: Identify Members with Overdue Books
 Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue. */

SELECT
	M.MEMBER_ID,
	M.MEMBER_NAME,
	BK.BOOK_TITLE,
	IST.ISSUED_DATE,
	RS.RETURN_DATE,
	CURRENT_DATE - IST.ISSUED_DATE AS OVERDUE_DATE
FROM
	ISSUED_STATUS AS IST
	JOIN MEMBERS AS M ON M.MEMBER_ID = IST.ISSUED_MEMBER_ID
	JOIN BOOKS AS BK ON BK.ISBN = IST.ISSUED_BOOK_ISBN
	LEFT JOIN RETURN_STATUS AS RS ON RS.ISSUED_ID = IST.ISSUED_ID
WHERE
	RS.RETURN_DATE IS NULL
	AND (CURRENT_DATE - IST.ISSUED_DATE) > 30
ORDER BY
	1

	
/*Task 14: Update Book Status on Return
-- Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table). */

CREATE OR REPLACE PROCEDURE ADD_RETURN_RECORD (
	P_RETURN_ID VARCHAR(20),
	P_ISSUED_ID VARCHAR(20),
	P_BOOK_QUALITY VARCHAR(20)
) LANGUAGE PLPGSQL AS $$

DECLARE
-- datatype of the variable
V_ISBN varchar(30);
V_BOOK_NAME varchar(60);

BEGIN
-- all logic and code--
 -- 1. Insert return record
INSERT INTO
	RETURN_STATUS (return_id, issued_id, RETURN_DATE, book_quality)
VALUES
	(p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

-- 2. Fetch ISBN and book title for the issued book
SELECT
	ISSUED_BOOK_ISBN,
	issued_book_name INTO --variable 
	V_ISBN,
	V_BOOK_NAME
FROM
	ISSUED_STATUS
WHERE
	ISSUED_ID = P_ISSUED_ID;
	
 -- 3. Update book status to 'yes' using fetched ISBN
UPDATE BOOKS
SET
	STATUS = 'yes'
WHERE
	ISBN = V_ISBN;
 -- 4. Notify user
RAISE NOTICE 'Thank You For Returning the Book: % ',
V_BOOK_NAME;

END
$$


-- calling function 
CALL add_return_record('RS138', 'IS135', 'Good');

-- calling function 
CALL add_return_record('RS148', 'IS140', 'Good');


-- Task 15: Branch Performance Report
-- Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

CREATE TABLE BRANCH_REPORTS AS
SELECT
	BR.BRANCH_ID,
	COUNT(IST.ISSUED_ID) AS TOTAL_BOOK_ISSUED,
	COUNT(RS.RETURN_ID) AS TOTAL_BOOK_RETURN,
	SUM(B.RENTAL_PRICE) AS TOTAL_REVENUE
FROM
	ISSUED_STATUS AS IST
	JOIN EMPLOYES AS E ON E.EMP_ID = IST.ISSUED_EMP_ID
	JOIN BRANCH AS BR ON BR.BRANCH_ID = E.BRANCH_ID
	LEFT JOIN RETURN_STATUS AS RS ON RS.ISSUED_ID = IST.ISSUED_ID
	JOIN BOOKS AS B ON B.ISBN = IST.ISSUED_BOOK_ISBN
GROUP BY
	1;

SELECT
	*
FROM
	BRANCH_REPORTS;

-- Task 16: CTAS: Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.
create table active_members as 
SELECT
	*
FROM
	MEMBERS
WHERE
	MEMBER_ID IN (
		SELECT DISTINCT
			ISSUED_MEMBER_ID
		FROM
			ISSUED_STATUS
		WHERE
			ISSUED_DATE >= CURRENT_DATE - INTERVAL '2 months'
);

select * from  active_members

INSERT INTO
	ISSUED_STATUS (
		ISSUED_ID,
		ISSUED_MEMBER_ID,
		ISSUED_BOOK_NAME,
		ISSUED_DATE,
		ISSUED_BOOK_ISBN,
		ISSUED_EMP_ID
	)
VALUES
	(
		'IS141',
		'C106',
		'Animal Farm',
		'2025-04-10',
		'978-0-330-25864-8',
		'E105'
	)

/*Task 17: Find Employees with the Most Book Issues Processed
 Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch. */
 
SELECT
	E.EMP_NAME,
	E.EMP_ID,
	BR.*,
	COUNT(IST.ISSUED_ID) AS NO_BOOK_ISSUED,
	COUNT(DISTINCT IST.ISSUED_BOOK_NAME) AS TOTAL_SAME_NAME_BOOK_ISSUED
FROM
	ISSUED_STATUS AS IST
	JOIN EMPLOYES AS E ON E.EMP_ID = IST.ISSUED_EMP_ID
	JOIN BRANCH AS BR ON BR.BRANCH_ID = E.BRANCH_ID
GROUP BY
	1,
	2,3
ORDER BY
	NO_BOOK_ISSUED DESC
LIMIT
	3;

/*Task 18: Identify Members Issuing High-Risk Books
Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. Display the member name, book title, and the number of times they have issued damaged books.*/

-- we have to insert book_quality with it's values like Good and Damaged remdomly to perform this task
ALTER TABLE issued_status
ADD COLUMN book_quality VARCHAR(20);

UPDATE issued_status
SET book_quality = 
    CASE 
        WHEN RANDOM() < 0.5 THEN 'Good'
        ELSE 'Damaged'
    END;

-- Now perform the task
SELECT
	IST.ISSUED_MEMBER_ID,
	M.MEMBER_NAME,
	COUNT(*) FILTER (WHERE IST.BOOK_QUALITY = 'Damaged') AS DAMAGED_BOOKS_COUNT
FROM
	ISSUED_STATUS AS IST
	JOIN MEMBERS AS M ON M.MEMBER_ID = IST.ISSUED_MEMBER_ID
GROUP BY
	1,
	2
HAVING
	COUNT(*) FILTER (WHERE IST.BOOK_QUALITY = 'Damaged') > 2;

/*Task 19: Stored Procedure Objective: Create a stored procedure to manage the status of books in a library system. 
 Description: Write a stored procedure that updates the status of a book in the library based on its issuance. The procedure should function as follows: The stored procedure should take the book_id as an input parameter. The procedure should first check if the book is available (status = 'yes'). If the book is available, it should be issued, and the status in the books table should be updated to 'no'. If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available. */

CREATE OR REPLACE PROCEDURE ISSUED_BOOKS (
	P_ISSUED_ID VARCHAR(20),
	P_ISSUED_MEMBER_ID VARCHAR(20),
	P_ISSUED_BOOK_ISBN VARCHAR(30),
	P_ISSUED_EMP_ID VARCHAR(20)
) LANGUAGE PLPGSQL AS $$

DECLARE
-- datatype of the variable
v_status VARCHAR(20);

BEGIN
-- all logic and code--
-- 1. Insert return record
SELECT
	STATUS into v_status
FROM
	BOOKS
WHERE
	ISBN = P_ISSUED_BOOK_ISBN;
	
IF v_STATUS = 'yes' THEN
INSERT INTO
	issued_status (
		ISSUED_ID,
		ISSUED_MEMBER_ID,
		ISSUED_DATE,
		ISSUED_BOOK_ISBN,
		ISSUED_EMP_ID
	)
VALUES
	(
		P_ISSUED_ID,
		P_ISSUED_MEMBER_ID,
		CURRENT_DATE,
		P_ISSUED_BOOK_ISBN,
		P_ISSUED_EMP_ID
	);
	
 -- 2. Update book status to 'yes' using fetched ISBN
UPDATE BOOKS
SET
	STATUS = 'no'
WHERE
	ISBN = p_issued_book_isbn;
	
 -- 3. Notify user
RAISE NOTICE 'Book records added successfully for book isbn : %', p_issued_book_isbn;

    ELSE
        RAISE NOTICE 'Sorry to inform you the book you have requested is unavailable book_isbn: %', p_issued_book_isbn;
    END IF;

END
$$
-- calling function 
CALL issued_books('IS155', 'C108', '978-0-553-29698-2', 'E104');
CALL issued_books('IS156', 'C108', '978-0-375-41398-8', 'E104');

select * from books where isbn = '978-0-375-41398-8'

/* Task 20: Create Table As Select (CTAS) Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.
-- Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include: The number of overdue books. The total fines, with each day's fine calculated at $0.50. The number of books issued by each member. The resulting table should show: Member ID Number of overdue books Total fines */


CREATE TABLE overdue_books_summary AS
SELECT
	M.MEMBER_ID,
	M.MEMBER_NAME,
	
	COUNT(*) AS OVERDUE_BOOKS,
	sum(current_date - ist.issued_date) as overdue_days,
	SUM((CURRENT_DATE - IST.ISSUED_DATE) * 0.5) AS TOTAL_FINE,
	(SELECT COUNT(*) FROM ISSUED_STATUS IS2 WHERE IS2.ISSUED_MEMBER_ID = M.MEMBER_ID) AS TOTAL_BOOKS_ISSUED
FROM
	ISSUED_STATUS AS IST
	JOIN MEMBERS AS M ON M.MEMBER_ID = IST.ISSUED_MEMBER_ID
	LEFT JOIN RETURN_STATUS AS RS ON RS.ISSUED_ID = IST.ISSUED_ID
WHERE
	RS.RETURN_DATE IS NULL
	AND (CURRENT_DATE - IST.ISSUED_DATE) > 30
GROUP BY
	M.MEMBER_ID,
	M.MEMBER_NAME
ORDER BY
	M.MEMBER_ID;

select * from overdue_books_summary

-- End of the Project
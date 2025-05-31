# Library Management System SQL

# Project Overview
This project demonstrates the implementation of a Library Management System using SQL. It covers database design, CRUD operations, CTAS (Create Table As Select), and advanced querying. The system manages data for library branches, employees, members, books, issued books, and returned books.

# Objectives
- Setup the Library Management Database: Create and populate tables for branches, employees, members, books, issued status, and return status.
- CRUD Operations: Perform Create, Read, Update, and Delete operations on the tables.
- CTAS (Create Table As Select): Generate new tables from existing data using CTAS queries.
- Advanced SQL Queries: Develop complex queries for detailed analysis and reporting.

# Project Structure
*1. Database Setup*
- Created a database named `library_db`.
- Defined relationships and constraints between tables.
<img width="984" alt="Screenshot 2025-05-31 at 3 01 15 PM" src="https://github.com/user-attachments/assets/848858a8-e1b7-415c-bf5e-d0c728761d85" />

*2. CRUD Operations*
- *Create*: Inserted sample data into the `books` table.
- *Read*: Retrieved data from multiple tables to display information.
- *Update*: Updated records, e.g., employee details.
- *Delete*: Removed records, e.g., from the `members` table.

*Sample Tasks*
- Create a new book record: `'978-1-60129-456-2'`, `'To Kill a Mockingbird'`, `'Classic'`, `6.00`, `'yes'`, `'Harper Lee'`, `'J.B. Lippincott & Co.'`
- Update a member's address.
- Delete an issued record with `issued_id` = `'IS121'`.
- Retrieve all books issued by employee `emp_id` = `'E101'`.
- List members who have issued more than one book.

*3. CTAS (Create Table As Select)*
- Created summary tables showing each book and total number of times issued.

*4. Data Analysis & Findings*
- Retrieve books by category.
- Calculate total rental income by category.
- List members registered in the last 180 days.
- Display employees with their branch managers and branch details.
- Create tables of books above certain rental price thresholds.
- Find books not yet returned.

*5. Advanced SQL Operations*
- Identify members with overdue books (assuming 30-day return policy).
- Update book availability status upon return.
- Generate branch performance reports (books issued, returned, revenue).
- Create a table of active members who issued books in the last 2 months.
- Find top 3 employees processing the most book issues.
- Identify members issuing damaged books more than twice.
- Create a stored procedure to manage book issuance and update status.
- Create a CTAS table identifying overdue books with calculated fines.

# Reports
- Detailed database schema with table structures and relationships.
- Data analysis on book categories, employee performance, member registrations, and issued books.
- Aggregated reports on high-demand books and employee efficiency.

# Conclusion
This project demonstrates practical application of SQL skills to build and manage a Library Management System. It covers from database creation to advanced queries and stored procedures, providing a solid foundation in data management and analysis for real-world library scenarios.

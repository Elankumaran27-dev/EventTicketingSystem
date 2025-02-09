🎫 Event Ticketing System
    
    A database-driven event ticketing management system that allows users to purchase, 
    reserve, and track event tickets efficiently.

📜 Features

    ✅ Manage events, tickets, and customer reservations
    ✅ Track ticket availability and sales
    ✅ Generate sales reports
    ✅ Use SQL concepts like Joins, Views, Subqueries, and Stored Procedures

🛠 Database Schema
   
      The system includes the following tables:

    Events – Stores event details (ID, name, date, location)

    Tickets – Stores ticket details (ID, event ID, type, price, availability)

    Customers – Stores customer details (ID, name, email, phone number, address)

    Reservations – Stores ticket reservations (ID, ticket ID, customer ID, reservation date, quantity)

    Sales – Stores ticket sales (ID, ticket ID, customer ID, sale date, quantity, total price)

📂 SQL Features Used
                
    Joins: To retrieve detailed information about reservations and ticket sales
    Views: To generate a summary of sales for each event
    Subqueries: To fetch events with high-priced VIP ticket sales
    Stored Procedures: To calculate total sales for a specific event

💾 Installation & Setup
   
    1️⃣ Clone the repository:

        sh
        Copy
        Edit
        git clone https://github.com/yourusername/EventTicketingSystem.git
        
    2️⃣ Import the SQL script into MySQL:

        sh
        Copy
        Edit
        mysql -u root -p < EventTicketingSystem.sql
        
    3️⃣ Run queries to interact with the system

📊 Sample Queries
     
    Retrieve All Reservations with Customer & Ticket Details
     sql
     Copy
     Edit

    SELECT r.reservation_id, c.name AS customer_name, t.ticket_type, 
       e.event_name, r.reservation_date, r.quantity 
    FROM Reservations r
    JOIN Customers c ON r.customer_id = c.customer_id
    JOIN Tickets t ON r.ticket_id = t.ticket_id
    JOIN Events e ON t.event_id = e.event_id;

    View Sales Summary
    sql
    Copy
    Edit
    CREATE VIEW SalesSummary AS 
    SELECT s.sale_id, c.name AS customer_name, e.event_name, 
       t.ticket_type, s.quantity, s.total_price, s.sale_date 
    FROM Sales s
    JOIN Customers c ON s.customer_id = c.customer_id
    JOIN Tickets t ON s.ticket_id = t.ticket_id
    JOIN Events e ON t.event_id = e.event_id;
    Stored Procedure: Get Total Sales for an Event
    sql
    Copy
    Edit
    DELIMITER $$
    CREATE PROCEDURE GetEventSales(IN eventID INT)
    BEGIN
    SELECT e.event_name, SUM(s.total_price) AS total_sales
    FROM Sales s
    JOIN Tickets t ON s.ticket_id = t.ticket_id
    JOIN Events e ON t.event_id = e.event_id
    WHERE e.event_id = eventID
    GROUP BY e.event_name;
    END $$
    DELIMITER ;
    Execute the procedure:
    sql
    Copy
    Edit
    CALL GetEventSales(1);

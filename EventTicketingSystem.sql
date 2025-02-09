create database eventsTicketingsystem;
use eventsTicketingsystem;

-- Create Tables for EventTicketingSystem:-
 -- Events Table:-
  create table Events(event_id int AUTO_INCREMENT primary key,event_name varchar(255) NOT NULL,
  event_date DATETIME NOT NULL,location varchar(255) NOT NULL);
    
 -- Tickets Table:-
  create table Tickets(ticket_id int AUTO_INCREMENT primary key,event_id INT,ticket_type varchar(100),
  price DECIMAL(10,2),availability int,FOREIGN KEY (event_id) REFERENCES Events(event_id) ON DELETE CASCADE);
  
-- Customers Table:-
  create table Customers(
  customer_id int AUTO_INCREMENT PRIMARY KEY,name varchar(100),email varchar(100) UNIQUE,
  phone_number varchar(20),address TEXT); 
  
-- Reservation Table:-
  create table Reservations(reservation_id int AUTO_INCREMENT primary key,ticket_id int,
    customer_id int,reservation_date DATETIME DEFAULT NOW(),quantity int,
    FOREIGN KEY (ticket_id) REFERENCES Tickets(ticket_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
  );
  
-- Sales Table:-
  create table Sales(
    sale_id int AUTO_INCREMENT primary key,ticket_id int,customer_id int,
    sale_date DATETIME DEFAULT NOW(),quantity int,total_price decimal(10,2),
    FOREIGN KEY (ticket_id) REFERENCES Tickets(ticket_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
);

-- Insert Data:-
  -- Insert Events:-
   insert into Events (event_name, event_date, location) 
   values ('Yuvan - Live in Concert','2025-02-14 19:00:00','Nmndhanam'),
          ("Harris Jayaraj's Music Concert",'2025-02-16 18:00:00','Nehru stadium');
 
  -- Insert Tickets:-
   insert into tickets(event_id,ticket_type,price,availability) values(1,'VIP',1500.00,200);
   insert into tickets(event_id,ticket_type,price,availability) values(1,'General',500.00,400);
   insert into tickets(event_id,ticket_type,price,availability) values(2,'VIP',1700.00,'150');
   insert into tickets(event_id,ticket_type,price,availability) values(2,'General',600.00,350);
 
  -- Insert Customers:-
   insert into Customers(name,email,phone_number,address) values('Elan','elan11@gmail.com',9856804948,'11-c,AGS Colony,velachery,Chennai');
   insert into Customers (name, email, phone_number, address)
   values('Satya', 'satya29@gmail.com', '7896543038', 'Vadapalani, Chennai');

  -- Insert Reservations:-
   insert into Reservations (ticket_id, customer_id, reservation_date, quantity)
   values (1, 1, NOW(), 2); -- 2 Vip tickets for Elan
   insert into Reservations (ticket_id, customer_id, reservation_date, quantity)
   values(2, 2, NOW(), 4); -- 4 General tickets for Satya

 -- Insert Sales:-
  insert into Sales (ticket_id, customer_id, sale_date, quantity, total_price)
  values(1, 1, NOW(), 2, 3000.00);
  insert into Sales (ticket_id, customer_id, sale_date, quantity, total_price)
  values(2, 2, NOW(), 4, 2400.00);
  insert into sales (ticket_id,customer_id,sale_date,quantity,total_price)
  values(3, 1, now(), 1, 1700.00);
  insert into sales (ticket_id,customer_id,sale_date,quantity,total_price)
  values(4, 2, now(), 3, 1800.00);

-- Queries for Reports & Analysis:-
  -- Join Query: Get All Reservations with Customer & Ticket Details:-
   select r.reservation_id, c.name as customer_name, t.ticket_type, 
   e.event_name, r.reservation_date, r.quantity from Reservations r
   join Customers c on r.customer_id = c.customer_id
   join Tickets t on r.ticket_id = t.ticket_id
   join Events e on t.event_id = e.event_id;

 -- View: Create a View for Sales Summary:-
  create view SalesSummary as 
  select s.sale_id, c.name AS customer_name, e.event_name, 
  t.ticket_type, s.quantity, s.total_price, s.sale_date from Sales s
  join Customers c on s.customer_id = c.customer_id
  join Tickets t on s.ticket_id = t.ticket_id
  join Events e on t.event_id = e.event_id;

-- To Fetch Data from the View by using order by ascending:-
    select * from SalesSummary order by sale_id asc;
    
-- Subquery Find Events with VIP Ticket Sales Over $1000:-
  select event_name FROM Events 
  where event_id IN (
  select event_id FROM Tickets 
  where ticket_type = 'VIP' AND price > 1000);
  
-- Stored Procedure:Get sales for all Events:-
    DELIMITER $$
    create procedure GetAllEventSales()
    begin
    select e.event_name, SUM(s.total_price) as total_sales
    from Sales s
    join Tickets t on s.ticket_id = t.ticket_id
    join Events e on t.event_id = e.event_id
    group by e.event_name;
    end $$
   DELIMITER ;
	
 -- Get Sales for All Events:-
     call GetAllEventSales();
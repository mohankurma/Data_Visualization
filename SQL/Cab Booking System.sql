create database cab_booking;

use cab_booking;


CREATE TABLE Users (
  user_id INT PRIMARY KEY,
  user_type ENUM('customer','driver'),
  name VARCHAR(100),
  email VARCHAR(100)
);

INSERT INTO Users VALUES
(1,'customer','Alice','alice@example.com'),
(2,'customer','Bob','bob@example.com'),
(3,'customer','Carol','carol@example.com'),
(4,'customer','Dave','dave@example.com'),
(5,'driver','Eve','eve@example.com'),
(6,'driver','Frank','frank@example.com'),
(7,'driver','Grace','grace@example.com'),
(8,'driver','Heidi','heidi@example.com'),
(9,'driver','Ivan','ivan@example.com'),
(10,'driver','Judy','judy@example.com');

CREATE TABLE Vehicles (
  vehicle_id INT PRIMARY KEY,
  driver_id INT,
  model VARCHAR(100),
  plate_number VARCHAR(50),
  capacity INT,
  FOREIGN KEY (driver_id) REFERENCES Users(user_id)
);

INSERT INTO Vehicles VALUES
(201,5,'Toyota Prius','KA01AB1234',4),
(202,6,'Honda City','KA02BC2345',4),
(203,7,'Maruti Swift','KA03CD3456',4),
(204,8,'Hyundai i10','KA04DE4567',4),
(205,9,'Toyota Innova','KA05EF5678',6),
(206,10,'Mahindra XUV','KA06FG6789',6);

CREATE TABLE Bookings (
  booking_id INT PRIMARY KEY,
  customer_id INT,
  driver_id INT,
  vehicle_id INT,
  request_time DATETIME,
  start_time DATETIME,
  end_time DATETIME,
  pickup_loc VARCHAR(255),
  dropoff_loc VARCHAR(255),
  status ENUM('requested','accepted','completed','cancelled'),
  fare DECIMAL(10,2),
  FOREIGN KEY (customer_id) REFERENCES Users(user_id),
  FOREIGN KEY (driver_id) REFERENCES Users(user_id),
  FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id)
);

INSERT INTO Bookings VALUES
(301,1,5,201,'2025-07-01 08:00:00','2025-07-01 08:10:00','2025-07-01 08:40:00','Home','Airport','completed',350.00),
(302,2,6,202,'2025-07-01 09:00:00',NULL,NULL,'Office','Mall','cancelled',0),
(303,3,7,203,'2025-07-02 10:00:00','2025-07-02 10:05:00','2025-07-02 10:30:00','Mall','Station','completed',200.00),
(304,4,8,204,'2025-07-03 11:00:00','2025-07-03 11:10:00','2025-07-03 11:40:00','Airport','Hotel','completed',400.00),
(305,1,9,205,'2025-07-04 12:00:00',NULL,NULL,'Home','Stadium','cancelled',0),
(306,2,10,206,'2025-07-04 13:00:00','2025-07-04 13:15:00','2025-07-04 13:50:00','Office','Home','completed',300.00),
(307,3,5,201,'2025-07-05 14:00:00','2025-07-05 14:05:00','2025-07-05 14:35:00','Station','Home','completed',180.00),
(308,4,6,202,'2025-07-06 15:00:00',NULL,NULL,'Hotel','Airport','cancelled',0),
(309,1,7,203,'2025-07-06 16:00:00','2025-07-06 16:10:00','2025-07-06 16:40:00','Mall','Office','completed',250.00),
(310,2,8,204,'2025-07-07 17:00:00','2025-07-07 17:10:00','2025-07-07 17:50:00','Stadium','Mall','completed',220.00),
(311,3,9,205,'2025-07-08 18:00:00',NULL,NULL,'Station','Office','cancelled',0),
(312,4,10,206,'2025-07-09 19:00:00','2025-07-09 19:15:00','2025-07-09 19:45:00','Airport','Home','completed',450.00);


CREATE TABLE Payments (
  payment_id INT PRIMARY KEY,
  booking_id INT,
  amount DECIMAL(10,2),
  payment_method ENUM('cash','card','wallet'),
  payment_status ENUM('pending','completed','failed'),
  FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);

INSERT INTO Payments VALUES
(401,301,350.00,'card','completed'),
(402,303,200.00,'cash','completed'),
(403,304,400.00,'wallet','completed'),
(404,306,300.00,'card','completed'),
(405,307,180.00,'cash','completed'),
(406,309,250.00,'wallet','completed'),
(407,310,220.00,'card','completed'),
(408,312,450.00,'wallet','completed'),
(409,302,0,'card','failed'),
(410,305,0,'cash','failed');




CREATE TABLE Reviews (
  review_id INT PRIMARY KEY,
  booking_id INT,
  rating INT,     -- 1 to 5
  comment TEXT,
  FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);

INSERT INTO Reviews VALUES
(501,301,5,'Great ride!'),
(502,303,4,'Good service'),
(503,304,5,'On-time and clean'),
(504,306,3,'Average experience'),
(505,307,4,'Comfortable'),
(506,309,5,'Excellent driver'),
(507,310,4,'Pleasant trip'),
(508,312,5,'Five stars'),
(509,308,1,'Roadside cancellation'),
(510,302,1,'No show');



#querys



SELECT COUNT(*) AS completed_trips FROM Bookings WHERE status = 'completed';




SELECT ROUND(100.0 * SUM(status = 'cancelled') / COUNT(*),2) AS cancel_rate FROM Bookings;


SELECT DATE_FORMAT(start_time,'%Y-%m') AS month, SUM(fare) AS revenue
FROM Bookings WHERE status = 'completed'
GROUP BY month;


SELECT customer_id, COUNT(*) AS rides
FROM Bookings WHERE status = 'completed'
GROUP BY customer_id ORDER BY rides DESC LIMIT 5;





SELECT vehicle_id, AVG(fare) AS avg_fare
FROM Bookings WHERE status = 'completed'
GROUP BY vehicle_id;



SELECT u.user_id AS driver_id, AVG(r.rating) AS avg_rating
FROM Users u JOIN Bookings b ON u.user_id = b.driver_id
JOIN Reviews r ON b.booking_id = r.booking_id
WHERE u.user_type='driver'
GROUP BY u.user_id;


SELECT payment_method, SUM(amount) AS total_amt
FROM Payments GROUP BY payment_method;




SELECT AVG(TIMESTAMPDIFF(MINUTE, start_time, end_time)) AS avg_duration
FROM Bookings WHERE status='completed';




SELECT vehicle_id, COUNT(*) AS trips
FROM Bookings WHERE status='completed'
GROUP BY vehicle_id ORDER BY trips DESC;




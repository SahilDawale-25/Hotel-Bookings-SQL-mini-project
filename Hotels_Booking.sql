-- =========================
-- HOTEL BOOKING SYSTEM
-- =========================

-- =========================
-- 1. Create Tables
-- =========================

-- Hotels Table
CREATE TABLE Hotels (
    hotel_id INT PRIMARY KEY AUTO_INCREMENT,
    hotel_name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    rating DECIMAL(2,1),
    total_rooms INT
);

-- Rooms Table
CREATE TABLE Rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    hotel_id INT NOT NULL,
    room_type VARCHAR(50),
    price DECIMAL(10,2),
    is_available BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (hotel_id) REFERENCES Hotels(hotel_id)
);

-- Guests Table
CREATE TABLE Guests (
    guest_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone_number VARCHAR(15)
);

-- Bookings Table
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in DATE,
    check_out DATE,
    total_price DECIMAL(10,2),
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (guest_id) REFERENCES Guests(guest_id),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id)
);


-- Payments Table (Optional)
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    amount DECIMAL(10,2),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_mode VARCHAR(50),
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);

-- =========================
-- 2. Insert Sample Data
-- =========================

-- Hotels
INSERT INTO Hotels (hotel_name, location, rating, total_rooms) VALUES
('Ocean View', 'Mumbai', 4.5, 50),
('Mountain Retreat', 'Pune', 4.2, 40),
('City Inn', 'Mumbai', 4.0, 30),
('Royal Palace', 'Delhi', 4.8, 60);

-- Rooms
INSERT INTO Rooms (hotel_id, room_type, price, is_available) VALUES
(1, 'Single', 2000.00, TRUE),
(1, 'Double', 3500.00, TRUE),
(1, 'Suite', 6000.00, TRUE),
(2, 'Single', 1800.00, TRUE),
(2, 'Double', 3200.00, TRUE),
(3, 'Single', 1500.00, TRUE),
(3, 'Double', 2800.00, TRUE),
(4, 'Suite', 7000.00, TRUE);

-- Guests
INSERT INTO Guests (full_name, email, phone_number) VALUES
('Sahil Dawale', 'sahil@gmail.com', '9876543210'),
('Tanavi Kadam', 'tanavi@gmail.com', '9123456780'),
('Saniya Dawale', 'sanu@gmail.com', '91236780'),
('Amit Kumar', 'amit@gmail.com', '9988776655');

-- Bookings
INSERT INTO Bookings (guest_id, room_id, check_in, check_out, total_price) VALUES
(1, 1, '2025-10-20', '2025-10-22', 4000.00),
(2, 2, '2025-10-21', '2025-10-23', 7000.00),
(3, 4, '2025-10-19', '2025-10-20', 1800.00);

-- Payments
INSERT INTO Payments (booking_id, amount, payment_mode) VALUES
(1, 4000.00, 'Card'),
(2, 7000.00, 'UPI'),
(3, 1800.00, 'Cash');


-- 1. List all hotels in Mumbai
SELECT hotel_name, location, rating
FROM Hotels
WHERE location = 'Mumbai';

-- 2. Find available rooms for a date range
SELECT r.room_id, r.room_type, r.price, h.hotel_name
FROM Rooms r
JOIN Hotels h ON r.hotel_id = h.hotel_id
WHERE r.is_available = TRUE
AND r.room_id NOT IN (
    SELECT room_id
    FROM Bookings
    WHERE (check_in <= '2025-10-25' AND check_out >= '2025-10-20')
);


-- 3. Calculate total revenue per hotel
SELECT h.hotel_name, SUM(b.total_price) AS total_revenue
FROM Hotels h
JOIN Rooms r ON h.hotel_id = r.hotel_id
JOIN Bookings b ON r.room_id = b.room_id
GROUP BY h.hotel_name;


-- 4. Top 5 guests by number of bookings
SELECT g.full_name, COUNT(*) AS total_bookings
FROM Guests g
JOIN Bookings b ON g.guest_id = b.guest_id
GROUP BY g.full_name
ORDER BY total_bookings DESC
LIMIT 5;

-- 5. Average rating per hotel
SELECT hotel_name, rating
FROM Hotels
ORDER BY rating DESC;

-- 6. Booking details with guest and room info
SELECT b.booking_id, g.full_name, h.hotel_name, r.room_type, b.check_in, b.check_out, b.total_price
FROM Bookings b
JOIN Guests g ON b.guest_id = g.guest_id
JOIN Rooms r ON b.room_id = r.room_id
JOIN Hotels h ON r.hotel_id = h.hotel_id;
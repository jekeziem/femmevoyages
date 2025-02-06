CREATE DATABASE Femme_Voyage;

USE Femme_Voyage;

CREATE TABLE users (
    user_id INTEGER PRIMARY KEY,
    user_name VARCHAR(50),
    user_email VARCHAR(50)
);

INSERT INTO users (user_name, user_email) VALUES 
('Jenny Ekeziem', 'jennyekeziem@gmail.com'),
('Julie Redding', 'julieredding@gmail.com'),
('May Popping', 'poppingmay@gmail.com'),
('Faith Sosan', 'sosofaith@gmail.com'),
('Rebecca Fergie', 'fergierebecs@gmail.com');

CREATE TABLE locations (
    location_id INTEGER PRIMARY KEY,
    country VARCHAR(50),
    city VARCHAR(50)
);

INSERT INTO locations (location_id, country, city) VALUES 
(1, 'france', 'paris'),
(2, 'italy', 'venice'),
(3, 'usa', 'new york'),
(4, 'japan', 'tokyo'),
(5, 'australia', 'sydney');

CREATE TABLE bucketlist_items (
    item_id INTEGER PRIMARY KEY,
    user_id INTEGER,
    location_id INTEGER,
    description VARCHAR(150) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

INSERT INTO bucketlist_items (user_id, location_id, description) VALUES 
(1, 1, 'visit the eiffel tower in paris'),
(1, 2, 'ride gondola in venice'),
(2, 3, 'see times square in new york'),
(3, 4, 'eat ramen in tokyo'),
(4, 5, 'go to the sydney opera house');

CREATE TABLE trips_completed (
    trip_id INTEGER PRIMARY KEY,
    user_id INTEGER,
    item_id INTEGER,
    completed_when DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (item_id) REFERENCES bucketlist_items(item_id)
);

INSERT INTO trips_completed (user_id, item_id, completed_when) VALUES 
(1, 1, '2024-06-15'),
(2, 3, '2024-02-20'),
(3, 4, '2024-03-10'),
(4, 5, '2024-04-05'),
(5, 6, '2024-05-01');

CREATE TABLE reviewsNratings (
    review_id INTEGER PRIMARY KEY,
    trip_id INTEGER,
    review_text VARCHAR(150),
    ratings INTEGER CHECK (ratings BETWEEN 1 AND 5),
    FOREIGN KEY (trip_id) REFERENCES trips_completed(trip_id)
);

INSERT INTO reviewsNratings (trip_id, review_text, ratings) VALUES 
(1, 'Amazing experience! The Eiffel Tower is breathtaking.', 5),
(2, 'Times Square is so vibrant, but too crowded for my taste.', 3),
(3, 'The ramen in Tokyo was delicious! Must try!', 4),
(4, 'The Sydney Opera House is a must-see, beautiful architecture!', 5),
(5, 'Riding the gondola in Venice was magical!', 4);

CREATE TABLE cost (
    cost_id INTEGER PRIMARY KEY,
    item_id INTEGER,
    cost_description VARCHAR(150),
    FOREIGN KEY (item_id) REFERENCES bucketlist_items(item_id)
);

INSERT INTO cost (item_id, cost_description) VALUES 
(1, 'Entry ticket: €25'),
(2, 'Gondola ride: €100'),
(3, 'Times Square tour: €50'),
(4, 'Ramen meal: €15'),
(5, 'Opera House tour: €30');

CREATE VIEW completed_trips AS
SELECT 
    u.user_name,
    b.description AS bucket_item,
    t.completed_when
FROM 
    users u
JOIN 
    bucketlist_items b ON u.user_id = b.user_id
JOIN 
    trips_completed t ON b.item_id = t.item_id;

DELIMITER //
CREATE FUNCTION total_completed_trips(userId INT) 
RETURNS INT
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total
    FROM trips_completed
    WHERE user_id = userId;
    RETURN total;
END //
DELIMITER ;

SELECT total_completed_trips(3);

SELECT u.user_name
FROM users u
WHERE u.user_id IN (
    SELECT user_id
    FROM trips_completed
    GROUP BY user_id
    HAVING COUNT(trip_id) > 1
);









 

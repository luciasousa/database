CREATE SCHEMA FLIGHT_RESERVATION;
GO

/*
DROP TABLE can_land
DROP TABLE seat
DROP TABLE fare
DROP TABLE leg_instance
DROP TABLE airplane
DROP TABLE airplane_type
DROP TABLE flight_leg
DROP TABLE flight
DROP TABLE airport
*/

CREATE TABLE airport(
	airport_code INT PRIMARY KEY NOT NULL,
	city VARCHAR(40) NOT NULL,
	state_airport VARCHAR(40) NOT NULL,
	name_airport VARCHAR(40) NOT NULL
);

CREATE TABLE airplane_type(
	airplane_type_name VARCHAR(40) PRIMARY KEY NOT NULL,
	company VARCHAR(40) NOT NULL,
	max_seats INT NOT NULL CHECK (max_seats > 0)
);

CREATE TABLE can_land(
	airport_code INT REFERENCES airport(airport_code) NOT NULL,
	airplane_type_name VARCHAR(40) REFERENCES airplane_type(airplane_type_name) NOT NULL,
	PRIMARY KEY(airport_code,airplane_type_name)
);

CREATE TABLE airplane(
	airplane_id INT PRIMARY KEY NOT NULL,
	total_no_of_seats INT NOT NULL CHECK (total_no_of_seats > 0),
	type_name_airplane VARCHAR(40) NOT NULL 
);

CREATE TABLE flight(
	number INT PRIMARY KEY NOT NULL,
	airline VARCHAR(40) NOT NULL,
	weekdays VARCHAR(40) NOT NULL
); 

CREATE TABLE flight_leg(
	flight_number INT REFERENCES flight(number) NOT NULL,
	leg_no INT NOT NULL,
	scheduled_dep_time TIME NOT NULL,
	scheduled_arr_time TIME NOT NULL,
	dep_airport INT REFERENCES airport(airport_code) NOT NULL,
	arr_airport INT REFERENCES airport(airport_code) NOT NULL,
	PRIMARY KEY(flight_number,leg_no)
); 

CREATE TABLE fare(
	code INT NOT NULL,
	flight_no INT REFERENCES flight(number) NOT NULL,
	restrictions VARCHAR(40),
	amount INT CHECK (amount > 0),
	PRIMARY KEY(code,flight_no)
);

CREATE TABLE leg_instance(
	leg_no INT NOT NULL,
	flight_no INT NOT NULL,
	date_leg_instance DATE NOT NULL,
	no_of_avail_seats INT NOT NULL CHECK(no_of_avail_seats > 0),
	dep_time TIME NOT NULL,
	arr_time TIME NOT NULL,
	dep_airport INT REFERENCES airport(airport_code) NOT NULL,
	arr_airpot INT REFERENCES airport(airport_code) NOT NULL,
	FOREIGN KEY(flight_no,leg_no) REFERENCES flight_leg(flight_number,leg_no),
	PRIMARY KEY(leg_no,flight_no,date_leg_instance)
);

CREATE TABLE seat(
	date_seat DATE NOT NULL,
	flight_no INT NOT NULL,
	seat_no INT NOT NULL CHECK(seat_no > 0),
	leg_no INT NOT NULL,
	costumer_name VARCHAR(40) NOT NULL,
	cphone INT NOT NULL CHECK(cphone > 0),
	FOREIGN KEY (leg_no,flight_no,date_seat) REFERENCES leg_instance(leg_no,flight_no,date_leg_instance),
	PRIMARY KEY(flight_no,leg_no,seat_no,date_seat)
);
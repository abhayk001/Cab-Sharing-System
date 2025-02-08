-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 08, 2021 at 02:25 PM
-- Server version: 10.4.21-MariaDB
-- PHP Version: 8.0.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cab_sharing_system`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `book_rides` (IN `date_today` DATE, IN `time_now` TIME, IN `sub_time` TIME, IN `add_time` TIME)  BEGIN
	DECLARE src VARCHAR(100);
    DECLARE dstn VARCHAR(100);
    DECLARE available_car VARCHAR(10);
    DECLARE cbserv VARCHAR(50);
    DECLARE rideID VARCHAR(50);
    DECLARE finish INT DEFAULT 0;
    DECLARE curs CURSOR FOR
    SELECT DISTINCT r.source, r.destination, r.desired_cab_service
    FROM ride_booked r, student s WHERE
	r.reg_no = s.reg_no
	AND r.date_booked = date_today
	AND r.time_booked >= sub_time AND r.time_booked <= add_time
    AND r.want_carpooling = 1;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finish=1;
    
    OPEN curs;
    
        
        looplabel: LOOP
            FETCH curs INTO src, dstn, cbserv;
            IF finish = 1 THEN
                LEAVE looplabel;
            END IF;
            SELECT car_number_plate INTO available_car FROM cab WHERE available = 1 AND cab_service = cbserv LIMIT 1;

            UPDATE cab SET available = 0 WHERE car_number_plate = available_car;

            SET rideID = MD5(RAND());

            INSERT INTO final_ride(ride_id, source, destination, car_number_plate, date_of_ride, time_of_ride)
            VALUES(rideID, src, dstn, available_car, date_today, time_now);
            
            
			CALL set_passengers(rideID, date_today, add_time, sub_time, src, dstn, cbserv);
            
            END LOOP looplabel;
    CLOSE curs;
    
    CALL book_rides_non_carpooling(date_today, time_now, add_time, sub_time);
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `book_rides_non_carpooling` (IN `date_today` DATE, IN `time_now` TIME, IN `add_time` TIME, IN `sub_time` TIME)  BEGIN
	DECLARE src VARCHAR(100);
    DECLARE dstn VARCHAR(100);
    DECLARE available_car VARCHAR(10);
    DECLARE cbserv VARCHAR(50);
    DECLARE rideID VARCHAR(50);
    DECLARE rno VARCHAR(10);
    DECLARE finish INT DEFAULT 0;
    DECLARE curs CURSOR FOR
    SELECT DISTINCT r.source, r.destination, r.desired_cab_service, s.reg_no
    FROM ride_booked r, student s WHERE
	r.reg_no = s.reg_no
	AND r.date_booked = date_today
	AND r.time_booked >= sub_time AND r.time_booked <= add_time
    AND r.want_carpooling = 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finish=1;
    
    OPEN curs;
    
        
        looplabel: LOOP
            FETCH curs INTO src, dstn, cbserv, rno;
            IF finish = 1 THEN
                LEAVE looplabel;
            END IF;
            SELECT car_number_plate INTO available_car FROM cab WHERE available = 1 AND cab_service = cbserv LIMIT 1;

            UPDATE cab SET available = 0 WHERE car_number_plate = available_car;

            SET rideID = MD5(RAND());

            INSERT INTO final_ride(ride_id, source, destination, car_number_plate, date_of_ride, time_of_ride)
            VALUES(rideID, src, dstn, available_car, date_today, time_now);
            
            INSERT INTO passengers
            VALUES (rno, rideID);
            
            END LOOP looplabel;
    CLOSE curs;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `set_passengers` (IN `rideID` VARCHAR(50), IN `date_today` DATE, IN `add_time` TIME, IN `sub_time` TIME, IN `src` VARCHAR(50), IN `dstn` VARCHAR(50), IN `cbserv` VARCHAR(50))  BEGIN
DECLARE finish_2 INT DEFAULT 0;
        DECLARE rno VARCHAR(10);
    	DECLARE cur_2 CURSOR FOR
        SELECT reg_no
    FROM ride_booked
    WHERE
	date_booked = date_today
	AND time_booked >= sub_time AND time_booked <= add_time
    AND want_carpooling = 1
    AND source = src AND destination = dstn
    AND desired_cab_service = cbserv;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finish_2=1;


OPEN cur_2;
            looplabel_2: LOOP
            
            	FETCH cur_2 INTO rno;
                IF finish_2 = 1 THEN
                	LEAVE looplabel_2;
                END IF;
                
                INSERT INTO passengers
                VALUES(rno, rideID);
            
            END LOOP looplabel_2;
            CLOSE cur_2;
END$$

DELIMITER ;


/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

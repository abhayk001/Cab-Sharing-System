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

--
-- Dumping data for table `cab`
--

INSERT INTO `cab` (`car_number_plate`, `driver_name`, `driver_phno`, `cab_service`, `max_seating_capacity`, `available`) VALUES
('AK47-6969', 'Crank McSwag', '6847294829', 'Lao', 4, 0),
('AP06-0342', 'Kangana Roshan', '1343666633', 'Prince', 6, 0),
('GJ03-8942', 'Krishna Johnson', '1245244224', 'Lao', 3, 0),
('KA01-3444', 'Ashok Murthy', '9999888898', 'Remu', 4, 0),
('KH04-3532', 'King Kumar', '4984283824', 'Remu', 4, 1),
('KL04-2345', 'Manjunath Hegde', '2413542424', 'Prince', 4, 1),
('LM01-4444', 'Kwame Nkrumah', '9385938211', 'Prince', 6, 1),
('MH02-5422', 'John Abraham', '7483829584', 'Remu', 3, 1),
('PB04-3949', 'Ibrahim Lodi', '4628592939', 'Lao', 5, 1),
('PB42-4552', 'King Johnson', '3235553355', 'Remu', 6, 1),
('RT95-1445', 'Qwerty Man', '124536789', 'Prince', 6, 1),
('TN03-3234', 'Elon Musk', '6942044443', 'Lao', 4, 1),
('WB33-3333', 'Lan Mo', '2333233223', 'Lao', 4, 1);

--
-- Dumping data for table `final_ride`
--

INSERT INTO `final_ride` (`ride_id`, `source`, `destination`, `car_number_plate`, `date_of_ride`, `time_of_ride`) VALUES
('4c2e2840d84f08e5cdb3bbc3198bf54d', 'VIT Chennai', 'Chennai International Airport', 'AP06-0342', '2021-12-03', '13:13:32'),
('6f2c79104cdd0b65107741f716aa42c6', 'VIT Chennai', 'Chennai International Airport', 'KA01-3444', '2021-12-03', '13:09:07'),
('dc919c304996874ac0701f0646b3d7d1', 'VIT Chennai', 'Chennai International Airport', 'AK47-6969', '2021-12-03', '11:33:11'),
('dd808eaf408d6b29cd4f4aa8cea01c0e', 'VIT Chennai', 'Chennai International Airport', 'GJ03-8942', '2021-12-03', '11:33:11');

--
-- Dumping data for table `passengers`
--

INSERT INTO `passengers` (`reg_no`, `ride_id`) VALUES
('19BLC1123', 'dc919c304996874ac0701f0646b3d7d1'),
('31BLC1001', 'dc919c304996874ac0701f0646b3d7d1'),
('19BLC1129', 'dd808eaf408d6b29cd4f4aa8cea01c0e'),
('19BLC1129', '6f2c79104cdd0b65107741f716aa42c6'),
('31BLC1001', '4c2e2840d84f08e5cdb3bbc3198bf54d'),
('19BLC1129', '4c2e2840d84f08e5cdb3bbc3198bf54d');

--
-- Dumping data for table `ride_booked`
--

INSERT INTO `ride_booked` (`source`, `destination`, `date_booked`, `time_booked`, `desired_cab_service`, `want_carpooling`, `reg_no`) VALUES
('VIT Chennai', 'Chennai International Airport', '2021-12-03', '11:35:00', 'Lao', 1, '19BLC1123'),
('VIT Chennai', 'Chennai International Airport', '2021-12-03', '11:40:00', 'Lao', 1, '31BLC1001'),
('VIT Chennai', 'Chennai International Airport', '2021-12-03', '11:38:00', 'Lao', 0, '19BLC1129'),
('VIT Chennai', 'Chennai International Airport', '2021-12-03', '13:01:00', 'Remu', 1, '31BLC1001'),
('VIT Chennai', 'Chennai International Airport', '2021-12-03', '13:03:00', 'Remu', 1, '19BLC1129'),
('VIT Chennai', 'Chennai International Airport', '2021-12-03', '13:11:00', 'Prince', 1, '31BLC1001'),
('VIT Chennai', 'Chennai International Airport', '2021-12-03', '13:10:00', 'Prince', 1, '19BLC1129');

--
-- Dumping data for table `student`
--

INSERT INTO `student` (`reg_no`, `name`, `phno`, `password`) VALUES
('19BCE1517', 'Sourab A', '123456789', 'b3daa77b4c04a9551b8781d03191fe098f325e67'),
('19BLC1094', 'Shubham Bhoite', '987654321', 'a1881c06eec96db9901c7bbfe41c42a3f08e9cb4'),
('19BLC1123', 'Mayank Kumar', '3874429482', 'd033e22ae348aeb5660fc2140aec35850c4da997'),
('19BLC1129', 'Abhay K', '8971304282', 'f865b53623b121fd34ee5426c792e5c33af8c227'),
('19BLC1134', 'Krishnarjun L', '5938574829', '38f078a81a2b033d197497af5b77f95b50bfcfb8'),
('31BLC1001', 'John Christian', '9375747323', '4b32d5db4eeccacbd39e447db5450a5aae96eda6');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

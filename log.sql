--One of the coolest exercises in Harvard's CS50 course!

--There has been a robbery in the city of Fiftyville and the mission is to solve the mystery by consulting information in an SQLite database. All that is known is that the robbery occurred on July 28, 2020 on Chamberlin Street. Authorities believe that shortly after the robbery, the thief flew out of town with the help of an accomplice.

--The objective is to identify: who the thief is, which city he fled to and who the accomplice who helped him escape.

--The DB contains data tables about the city such as security records, phone calls, bank transactions, license plates and airport flight information.

----------------------------------------------------------------------------------------------------------

SELECT description FROM crime_scene_reports WHERE month = 7 AND day = 28 AND street = "Chamberlin Street";
-- Theft of the CS50 duck took place at 10:15am at the Chamberlin Street courthouse. Interviews were conducted today with three witnesses who were present at the time — each of their interview transcripts mentions the courthouse.

SELECT name, transcript FROM interviews WHERE month = 7 AND day = 28 AND year = 2020 AND transcript LIKE "%thief%";
--Ruth: Sometime within ten minutes of the theft, I saw the thief get into a car in the courthouse parking lot and drive away. If you have security footage from the courthouse parking lot, you might want to look for cars that left the parking lot in that time frame.                                                      |
--Eugene: I don't know the thief's name, but it was someone I recognized. Earlier this morning, before I arrived at the courthouse, I was walking by the ATM on Fifer Street and saw the thief there withdrawing some money.                                                                                                      |
--Raymond: As the thief was leaving the courthouse, they called someone who talked to them for less than a minute. In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow. The thief then asked the person on the other end of the phone to purchase the flight ticket.

SELECT name, phone_number, passport_number, activity, c.license_plate
    FROM courthouse_security_logs AS c
    JOIN people as p ON p.license_plate = c.license_plate
    WHERE month = 7 AND day = 28 AND year = 2020 AND hour = 10 AND minute BETWEEN 15 AND 25 AND activity = "exit"
    ORDER BY p.name ASC;
-- People who left the Courthouse within 10 minutes
--+-----------+----------------+-----------------+----------+---------------+
--|   name    |  phone_number  | passport_number | activity | license_plate |
--+-----------+----------------+-----------------+----------+---------------+
--| Amber     | (301) 555-4174 | 7526138472      | exit     | 6P58WS2       |
--| Danielle  | (389) 555-5198 | 8496433585      | exit     | 4328GD8       |
--| Elizabeth | (829) 555-5269 | 7049073643      | exit     | L93JTIZ       |
--| Ernest    | (367) 555-5533 | 5773159633      | exit     | 94KL13X       |
--| Evelyn    | (499) 555-9472 | 8294398571      | exit     | 0NTHK55       |
--| Patrick   | (725) 555-4692 | 2963008352      | exit     | 5P2BI95       |
--| Roger     | (130) 555-0289 | 1695452385      | exit     | G412CB7       |
--| Russell   | (770) 555-1861 | 3592750733      | exit     | 322W7JE       |
--+-----------+----------------+-----------------+----------+---------------+

SELECT name, phone_number, passport_number, license_plate, atm.account_number
    FROM atm_transactions as atm
    JOIN bank_accounts as b ON atm.account_number = b.account_number
    JOIN people as p ON p.id = b.person_id
    WHERE atm_location = "Fifer Street" AND month = 7 AND day = 28 AND year = 2020 AND transaction_type = "withdraw"
    ORDER BY p.name;
-- People who withdraw Money
--+-----------+----------------+-----------------+---------------+----------------+
--|   name    |  phone_number  | passport_number | license_plate | account_number |
--+-----------+----------------+-----------------+---------------+----------------+
--| Bobby     | (826) 555-1652 | 9878712108      | 30G67EN       | 28296815       |
--| Danielle  | (389) 555-5198 | 8496433585      | 4328GD8       | 28500762       |
--| Elizabeth | (829) 555-5269 | 7049073643      | L93JTIZ       | 25506511       |
--| Ernest    | (367) 555-5533 | 5773159633      | 94KL13X       | 49610011       |
--| Madison   | (286) 555-6063 | 1988161715      | 1106N58       | 76054385       |
--| Roy       | (122) 555-4581 | 4408372428      | QX4YZN3       | 16153065       |
--| Russell   | (770) 555-1861 | 3592750733      | 322W7JE       | 26013199       |
--| Victoria  | (338) 555-6650 | 9586786673      | 8X428L0       | 81061156       |
--+-----------+----------------+-----------------+---------------+----------------+
-- Prime suspects Danielle, Elizabeth, Ernest, Russel

SELECT c.name AS caller_name, caller, r.name AS receiver_name, pc.receiver, pc.duration
    FROM people AS c
    JOIN phone_calls AS pc ON pc.caller = c.phone_number
    JOIN people AS r ON pc.receiver = r.phone_number
    WHERE duration <= 60 AND month = 7 AND day = 28 AND year = 2020
    ORDER BY caller_name;
-- People who made and received a call
--+-------------+----------------+---------------+----------------+----------+
--| caller_name |     caller     | receiver_name |    receiver    | duration |
--+-------------+----------------+---------------+----------------+----------+
--| Bobby       | (826) 555-1652 | Doris         | (066) 555-9701 | 55       |
--| Ernest      | (367) 555-5533 | Berthold      | (375) 555-8161 | 45       |
--| Evelyn      | (499) 555-9472 | Larry         | (892) 555-8872 | 36       |
--| Evelyn      | (499) 555-9472 | Melissa       | (717) 555-1342 | 50       |
--| Kathryn     | (609) 555-5876 | Danielle      | (389) 555-5198 | 60       |
--| Kimberly    | (031) 555-6622 | Jacqueline    | (910) 555-3251 | 38       |
--| Madison     | (286) 555-6063 | James         | (676) 555-6554 | 43       |
--| Roger       | (130) 555-0289 | Jack          | (996) 555-8899 | 51       |
--| Russell     | (770) 555-1861 | Philip        | (725) 555-3243 | 49       |
--| Victoria    | (338) 555-6650 | Anna          | (704) 555-2131 | 54       |
--+-------------+----------------+---------------+----------------+----------+
-- Thief prime suspects Ernest, Russel / Accomplice prime suspects Berthold, Philip

SELECT * FROM airports WHERE city = "Fiftyville";
--+----+--------------+-----------------------------+------------+
--| id | abbreviation |          full_name          |    city    |
--+----+--------------+-----------------------------+------------+
--| 8  | CSF          | Fiftyville Regional Airport | Fiftyville |
--+----+--------------+-----------------------------+------------+

SELECT f.id AS flight_id, f.origin_airport_id, f.destination_airport_id, f.hour, f.minute
    FROM airports AS a
    JOIN flights AS f ON a.id = f.origin_airport_id
    WHERE f.month = 7 AND f.day = 29 AND f.year = 2020 AND f.origin_airport_id = 8
    ORDER BY f.hour, f.minute
    LIMIT 1;
--+-----------+-------------------+------------------------+------+--------+
--| flight_id | origin_airport_id | destination_airport_id | hour | minute |
--+-----------+-------------------+------------------------+------+--------+
--| 36        | 8                 | 4                      | 8    | 20     |
--+-----------+-------------------+------------------------+------+--------+
-- First flight tomorrow

-- #1 Solution - Query by query

SELECT pe.name, pa.passport_number, seat FROM passengers AS pa
    JOIN flights AS f ON pa.flight_id = f.id
    JOIN people AS pe ON pe.passport_number = pa.passport_number
    WHERE flight_id = 36 AND pe.name = "Ernest" OR pe.name = "Russel";
--+--------+-----------------+------+
--|  name  | passport_number | seat |
--+--------+-----------------+------+
--| Ernest | 5773159633      | 4A   |
--+--------+-----------------+------+

-- #2 Solution - All queries together

SELECT name FROM people AS pe
    JOIN passengers AS pa ON pa.passport_number = pe.passport_number
    JOIN flights AS f ON f.id = pa.flight_id
    WHERE (f.month = 7 AND f.day = 29 AND f.year = 2020 AND flight_id = 36)
    AND name IN (SELECT name FROM people as p
        JOIN courthouse_security_logs AS c ON p.license_plate = c.license_plate
        WHERE month = 7 AND day = 28 AND year = 2020 AND hour = 10 AND minute BETWEEN 15 AND 25 AND activity = "exit"
        ORDER BY p.name ASC)
    AND name IN (SELECT name FROM people AS p
        JOIN bank_accounts AS b ON p.id = b.person_id JOIN atm_transactions AS atm ON atm.account_number = b.account_number
        WHERE atm_location = "Fifer Street" AND month = 7 AND day = 28 AND year = 2020 AND transaction_type = "withdraw"
        ORDER BY p.name)
    AND name IN (SELECT c.name AS caller_name FROM people AS c
        JOIN phone_calls AS pc ON pc.caller = c.phone_number
        JOIN people AS r ON pc.receiver = r.phone_number
        WHERE duration <= 60 AND month = 7 AND day = 28 AND year = 2020
        ORDER BY caller_name);
--+--------+
--|  name  |
--+--------+
--| Ernest |
--+--------+

SELECT * FROM airports WHERE id = 4;
--+----+--------------+------------------+--------+
--| id | abbreviation |    full_name     |  city  |
--+----+--------------+------------------+--------+
--| 4  | LHR          | Heathrow Airport | London |
--+----+--------------+------------------+--------+

-- The THIEF is: Ernest
-- The thief ESCAPED TO: Heathrow Airport, London
-- The ACCOMPLICE is: Berthold
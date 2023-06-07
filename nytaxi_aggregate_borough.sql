#Same as the aggregation in nytaxi_aggregate_data.sql, but with additional aggregation by start borough
#Will then save table as a .csv file in the main directary


##############################
###Total number of payments###
##############################

DROP TABLE IF EXISTS borough_agr_total_rides;

CREATE TABLE borough_agr_total_rides
SELECT 
	start_borough AS borough,
	COUNT(*) AS total_rides,
    SUM(IF(payment_type = "Cash", 1, 0)) AS paid_cash,
    SUM(IF(payment_type = "Card", 1, 0)) AS paid_card,
    SUM(IF(payment_type = "Other", 1, 0)) AS paid_other
FROM taxi_data_proc
GROUP BY borough
ORDER BY borough ASC;

SELECT 'borough', 'total_rides', 'paid_cash', 'paid_card', 'paid_other'
UNION ALL
SELECT *
FROM borough_agr_total_rides
INTO OUTFILE 'C:\\Users\\thoma\\Documents\\Data analysis\\nytaxi\\borough_agr_total_rides.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';



############################
###Rides per calendar day###
############################

DROP TEMPORARY TABLE IF EXISTS Bronx;
CREATE TEMPORARY TABLE Bronx
SELECT
	date AS day,
    SUM(IF(payment_type = "Cash", 1, 0)) AS paid_cash,
    SUM(IF(payment_type = "Card", 1, 0)) AS paid_card
FROM taxi_data_proc
WHERE YEAR(date) = 2021 and start_borough = 'Bronx'
GROUP BY day
ORDER BY day ASC;

DROP TEMPORARY TABLE IF EXISTS Brooklyn;
CREATE TEMPORARY TABLE Brooklyn
SELECT
	date AS day,
    SUM(IF(payment_type = "Cash", 1, 0)) AS paid_cash,
    SUM(IF(payment_type = "Card", 1, 0)) AS paid_card
FROM taxi_data_proc
WHERE YEAR(date) = 2021 and start_borough = 'Brooklyn'
GROUP BY day
ORDER BY day ASC;

DROP TEMPORARY TABLE IF EXISTS EWR;
CREATE TEMPORARY TABLE EWR
SELECT
	date AS day,
    SUM(IF(payment_type = "Cash", 1, 0)) AS paid_cash,
    SUM(IF(payment_type = "Card", 1, 0)) AS paid_card
FROM taxi_data_proc
WHERE YEAR(date) = 2021 and start_borough = 'EWR'
GROUP BY day
ORDER BY day ASC;

DROP TEMPORARY TABLE IF EXISTS Manhattan;
CREATE TEMPORARY TABLE Manhattan
SELECT
	date AS day,
    SUM(IF(payment_type = "Cash", 1, 0)) AS paid_cash,
    SUM(IF(payment_type = "Card", 1, 0)) AS paid_card
FROM taxi_data_proc
WHERE YEAR(date) = 2021 and start_borough = 'Manhattan'
GROUP BY day
ORDER BY day ASC;

DROP TEMPORARY TABLE IF EXISTS Queens;
CREATE TEMPORARY TABLE Queens
SELECT
	date AS day,
    SUM(IF(payment_type = "Cash", 1, 0)) AS paid_cash,
    SUM(IF(payment_type = "Card", 1, 0)) AS paid_card
FROM taxi_data_proc
WHERE YEAR(date) = 2021 and start_borough = 'Queens'
GROUP BY day
ORDER BY day ASC;

DROP TEMPORARY TABLE IF EXISTS Staten_Island;
CREATE TEMPORARY TABLE Staten_Island
SELECT
	date AS day,
    SUM(IF(payment_type = "Cash", 1, 0)) AS paid_cash,
    SUM(IF(payment_type = "Card", 1, 0)) AS paid_card
FROM taxi_data_proc
WHERE YEAR(date) = 2021 and start_borough = 'Staten Island'
GROUP BY day
ORDER BY day ASC;

DROP TEMPORARY TABLE IF EXISTS Bronx2;
CREATE TEMPORARY TABLE Bronx2
SELECT * FROM Bronx;
DROP TEMPORARY TABLE IF EXISTS Brooklyn2;
CREATE TEMPORARY TABLE Brooklyn2
SELECT * FROM Brooklyn;
DROP TEMPORARY TABLE IF EXISTS EWR2;
CREATE TEMPORARY TABLE EWR2
SELECT * FROM EWR;
DROP TEMPORARY TABLE IF EXISTS Manhattan2;
CREATE TEMPORARY TABLE Manhattan2
SELECT * FROM Manhattan;
DROP TEMPORARY TABLE IF EXISTS Queens2;
CREATE TEMPORARY TABLE Queens2
SELECT * FROM Queens;
DROP TEMPORARY TABLE IF EXISTS Staten_Island2;
CREATE TEMPORARY TABLE Staten_Island2
SELECT * FROM Staten_Island;

CREATE TABLE borough_agr_date
SELECT
	Bronx.day as date,
    Bronx.paid_cash AS Bronx_cash,
    Bronx.paid_card AS Bronx_card,
    Brooklyn.paid_cash AS Brooklyn_cash,
    Brooklyn.paid_card AS Brooklyn_card,
    EWR.paid_cash AS EWR_cash,
    EWR.paid_card AS EWR_card,
    Manhattan.paid_cash AS Manhattan_cash,
    Manhattan.paid_card AS Manhattan_card,
    Queens.paid_cash AS Queens_cash,
    Queens.paid_card AS Queens_card,
    Staten_Island.paid_cash AS Staten_Island_cash,
    Staten_Island.paid_card AS Staten_Island_card
FROM Bronx
LEFT JOIN Brooklyn ON Bronx.day = Brooklyn.day
LEFT JOIN EWR ON Bronx.day = EWR.day
LEFT JOIN Manhattan ON Bronx.day = Manhattan.day
LEFT JOIN Queens ON Bronx.day = Queens.day
LEFT JOIN Staten_Island ON Bronx.day = Staten_Island.day
UNION 
SELECT
	Bronx2.day as date,
    Bronx2.paid_cash AS Bronx_cash,
    Bronx2.paid_card AS Bronx_card,
    Brooklyn2.paid_cash AS Brooklyn_cash,
    Brooklyn2.paid_card AS Brooklyn_card,
    EWR2.paid_cash AS EWR_cash,
    EWR2.paid_card AS EWR_card,
    Manhattan2.paid_cash AS Manhattan_cash,
    Manhattan2.paid_card AS Manhattan_card,
    Queens2.paid_cash AS Queens_cash,
    Queens2.paid_card AS Queens_card,
    Staten_Island2.paid_cash AS Staten_Island_cash,
    Staten_Island2.paid_card AS Staten_Island_card
FROM Bronx2
LEFT JOIN Brooklyn2 ON Bronx2.day = Brooklyn2.day
LEFT JOIN EWR2 ON Bronx2.day = EWR2.day
LEFT JOIN Manhattan2 ON Bronx2.day = Manhattan2.day
LEFT JOIN Queens2 ON Bronx2.day = Queens2.day
LEFT JOIN Staten_Island2 ON Bronx2.day = Staten_Island2.day
ORDER BY date ASC;

SELECT 'date', 'Bronx_cash', 'Bronx_card', 'Brooklyn_cash', 'Brooklyn_card', 'EWR_cash', 'EWR_card', 'Manhattan_cash', 'Manhattan_card', 'Queens_cash', 'Queens_card', 'Staten_Island_cash', 'Staten_Island_card'
UNION ALL
SELECT *
FROM borough_agr_date
INTO OUTFILE 'C:\\Users\\thoma\\Documents\\Data analysis\\nytaxi\\borough_agr_date.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';




#################
###Time of day###
#################

DROP TEMPORARY TABLE IF EXISTS Bronx;
CREATE TEMPORARY TABLE Bronx
SELECT
	TIME_FORMAT(start_time, '%H:%i') AS time_of_day,
    SUM(IF(payment_type = "Cash", 1, 0)) AS paid_cash,
    SUM(IF(payment_type = "Card", 1, 0)) AS paid_card
FROM taxi_data_proc
WHERE start_borough = 'Bronx'
GROUP BY time_of_day
ORDER BY time_of_day ASC;

DROP TEMPORARY TABLE IF EXISTS Brooklyn;
CREATE TEMPORARY TABLE Brooklyn
SELECT
	TIME_FORMAT(start_time, '%H:%i') AS time_of_day,
    SUM(IF(payment_type = "Cash", 1, 0)) AS paid_cash,
    SUM(IF(payment_type = "Card", 1, 0)) AS paid_card
FROM taxi_data_proc
WHERE start_borough = 'Brooklyn'
GROUP BY time_of_day
ORDER BY time_of_day ASC;

DROP TEMPORARY TABLE IF EXISTS EWR;
CREATE TEMPORARY TABLE EWR
SELECT
	TIME_FORMAT(start_time, '%H:%i') AS time_of_day,
    SUM(IF(payment_type = "Cash", 1, 0)) AS paid_cash,
    SUM(IF(payment_type = "Card", 1, 0)) AS paid_card
FROM taxi_data_proc
WHERE start_borough = 'EWR'
GROUP BY time_of_day
ORDER BY time_of_day ASC;

DROP TEMPORARY TABLE IF EXISTS Manhattan;
CREATE TEMPORARY TABLE Manhattan
SELECT
	TIME_FORMAT(start_time, '%H:%i') AS time_of_day,
    SUM(IF(payment_type = "Cash", 1, 0)) AS paid_cash,
    SUM(IF(payment_type = "Card", 1, 0)) AS paid_card
FROM taxi_data_proc
WHERE start_borough = 'Manhattan'
GROUP BY time_of_day
ORDER BY time_of_day ASC;

DROP TEMPORARY TABLE IF EXISTS Queens;
CREATE TEMPORARY TABLE Queens
SELECT
	TIME_FORMAT(start_time, '%H:%i') AS time_of_day,
    SUM(IF(payment_type = "Cash", 1, 0)) AS paid_cash,
    SUM(IF(payment_type = "Card", 1, 0)) AS paid_card
FROM taxi_data_proc
WHERE start_borough = 'Queens'
GROUP BY time_of_day
ORDER BY time_of_day ASC;

DROP TEMPORARY TABLE IF EXISTS Staten_Island;
CREATE TEMPORARY TABLE Staten_Island
SELECT
	TIME_FORMAT(start_time, '%H:%i') AS time_of_day,
    SUM(IF(payment_type = "Cash", 1, 0)) AS paid_cash,
    SUM(IF(payment_type = "Card", 1, 0)) AS paid_card
FROM taxi_data_proc
WHERE start_borough = 'Staten Island'
GROUP BY time_of_day
ORDER BY time_of_day ASC;

DROP TEMPORARY TABLE IF EXISTS Bronx2;
CREATE TEMPORARY TABLE Bronx2
SELECT * FROM Bronx;
DROP TEMPORARY TABLE IF EXISTS Brooklyn2;
CREATE TEMPORARY TABLE Brooklyn2
SELECT * FROM Brooklyn;
DROP TEMPORARY TABLE IF EXISTS EWR2;
CREATE TEMPORARY TABLE EWR2
SELECT * FROM EWR;
DROP TEMPORARY TABLE IF EXISTS Manhattan2;
CREATE TEMPORARY TABLE Manhattan2
SELECT * FROM Manhattan;
DROP TEMPORARY TABLE IF EXISTS Queens2;
CREATE TEMPORARY TABLE Queens2
SELECT * FROM Queens;
DROP TEMPORARY TABLE IF EXISTS Staten_Island2;
CREATE TEMPORARY TABLE Staten_Island2
SELECT * FROM Staten_Island;

DROP TABLE IF EXISTS borough_agr_timeofday;
CREATE TABLE borough_agr_timeofday
SELECT
	Bronx.time_of_day as timeofday,
    Bronx.paid_cash AS Bronx_cash,
    Bronx.paid_card AS Bronx_card,
    Brooklyn.paid_cash AS Brooklyn_cash,
    Brooklyn.paid_card AS Brooklyn_card,
    EWR.paid_cash AS EWR_cash,
    EWR.paid_card AS EWR_card,
    Manhattan.paid_cash AS Manhattan_cash,
    Manhattan.paid_card AS Manhattan_card,
    Queens.paid_cash AS Queens_cash,
    Queens.paid_card AS Queens_card,
    Staten_Island.paid_cash AS Staten_Island_cash,
    Staten_Island.paid_card AS Staten_Island_card
FROM Bronx
LEFT JOIN Brooklyn ON Bronx.time_of_day = Brooklyn.time_of_day
LEFT JOIN EWR ON Bronx.time_of_day = EWR.time_of_day
LEFT JOIN Manhattan ON Bronx.time_of_day = Manhattan.time_of_day
LEFT JOIN Queens ON Bronx.time_of_day = Queens.time_of_day
LEFT JOIN Staten_Island ON Bronx.time_of_day = Staten_Island.time_of_day
UNION 
SELECT
	Bronx2.time_of_day as timeofday,
    Bronx2.paid_cash AS Bronx_cash,
    Bronx2.paid_card AS Bronx_card,
    Brooklyn2.paid_cash AS Brooklyn_cash,
    Brooklyn2.paid_card AS Brooklyn_card,
    EWR2.paid_cash AS EWR_cash,
    EWR2.paid_card AS EWR_card,
    Manhattan2.paid_cash AS Manhattan_cash,
    Manhattan2.paid_card AS Manhattan_card,
    Queens2.paid_cash AS Queens_cash,
    Queens2.paid_card AS Queens_card,
    Staten_Island2.paid_cash AS Staten_Island_cash,
    Staten_Island2.paid_card AS Staten_Island_card
FROM Bronx2
LEFT JOIN Brooklyn2 ON Bronx2.time_of_day = Brooklyn2.time_of_day
LEFT JOIN EWR2 ON Bronx2.time_of_day = EWR2.time_of_day
LEFT JOIN Manhattan2 ON Bronx2.time_of_day = Manhattan2.time_of_day
LEFT JOIN Queens2 ON Bronx2.time_of_day = Queens2.time_of_day
LEFT JOIN Staten_Island2 ON Bronx2.time_of_day = Staten_Island2.time_of_day
ORDER BY timeofday ASC;

SELECT 'timeofday', 'Bronx_cash', 'Bronx_card', 'Brooklyn_cash', 'Brooklyn_card', 'EWR_cash', 'EWR_card', 'Manhattan_cash', 'Manhattan_card', 'Queens_cash', 'Queens_card', 'Staten_Island_cash', 'Staten_Island_card'
UNION ALL
SELECT *
FROM borough_agr_timeofday
INTO OUTFILE 'C:\\Users\\thoma\\Documents\\Data analysis\\nytaxi\\borough_agr_timeofday.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';


##############
###Duration###
##############

DROP TEMPORARY TABLE IF EXISTS Bronx;
CREATE TEMPORARY TABLE Bronx
SELECT
	ROUND(duration_min*12)/12 as duration,
    SUM(IF(payment_type = "Cash", 1, 0)) AS paid_cash,
    SUM(IF(payment_type = "Card", 1, 0)) AS paid_card
FROM taxi_data_proc
WHERE start_borough = 'Bronx'
GROUP BY duration
ORDER BY duration ASC;

DROP TEMPORARY TABLE IF EXISTS Brooklyn;
CREATE TEMPORARY TABLE Brooklyn
SELECT
	ROUND(duration_min*12)/12 as duration,
    SUM(IF(payment_type = "Cash", 1, 0)) AS paid_cash,
    SUM(IF(payment_type = "Card", 1, 0)) AS paid_card
FROM taxi_data_proc
WHERE start_borough = 'Brooklyn'
GROUP BY duration
ORDER BY duration ASC;

DROP TEMPORARY TABLE IF EXISTS EWR;
CREATE TEMPORARY TABLE EWR
SELECT
	ROUND(duration_min*12)/12 as duration,
    SUM(IF(payment_type = "Cash", 1, 0)) AS paid_cash,
    SUM(IF(payment_type = "Card", 1, 0)) AS paid_card
FROM taxi_data_proc
WHERE start_borough = 'EWR'
GROUP BY duration
ORDER BY duration ASC;

DROP TEMPORARY TABLE IF EXISTS Manhattan;
CREATE TEMPORARY TABLE Manhattan
SELECT
	ROUND(duration_min*12)/12 as duration,
    SUM(IF(payment_type = "Cash", 1, 0)) AS paid_cash,
    SUM(IF(payment_type = "Card", 1, 0)) AS paid_card
FROM taxi_data_proc
WHERE start_borough = 'Manhattan'
GROUP BY duration
ORDER BY duration ASC;

DROP TEMPORARY TABLE IF EXISTS Queens;
CREATE TEMPORARY TABLE Queens
SELECT
	ROUND(duration_min*12)/12 as duration,
    SUM(IF(payment_type = "Cash", 1, 0)) AS paid_cash,
    SUM(IF(payment_type = "Card", 1, 0)) AS paid_card
FROM taxi_data_proc
WHERE start_borough = 'Queens'
GROUP BY duration
ORDER BY duration ASC;

DROP TEMPORARY TABLE IF EXISTS Staten_Island;
CREATE TEMPORARY TABLE Staten_Island
SELECT
	ROUND(duration_min*12)/12 as duration,
    SUM(IF(payment_type = "Cash", 1, 0)) AS paid_cash,
    SUM(IF(payment_type = "Card", 1, 0)) AS paid_card
FROM taxi_data_proc
WHERE start_borough = 'Staten Island'
GROUP BY duration
ORDER BY duration ASC;

DROP TEMPORARY TABLE IF EXISTS Bronx2;
CREATE TEMPORARY TABLE Bronx2
SELECT * FROM Bronx;
DROP TEMPORARY TABLE IF EXISTS Brooklyn2;
CREATE TEMPORARY TABLE Brooklyn2
SELECT * FROM Brooklyn;
DROP TEMPORARY TABLE IF EXISTS EWR2;
CREATE TEMPORARY TABLE EWR2
SELECT * FROM EWR;
DROP TEMPORARY TABLE IF EXISTS Manhattan2;
CREATE TEMPORARY TABLE Manhattan2
SELECT * FROM Manhattan;
DROP TEMPORARY TABLE IF EXISTS Queens2;
CREATE TEMPORARY TABLE Queens2
SELECT * FROM Queens;
DROP TEMPORARY TABLE IF EXISTS Staten_Island2;
CREATE TEMPORARY TABLE Staten_Island2
SELECT * FROM Staten_Island;

DROP TABLE IF EXISTS borough_agr_duration;
CREATE TABLE borough_agr_duration
SELECT
	Bronx.duration as mduration,
    Bronx.paid_cash AS Bronx_cash,
    Bronx.paid_card AS Bronx_card,
    Brooklyn.paid_cash AS Brooklyn_cash,
    Brooklyn.paid_card AS Brooklyn_card,
    EWR.paid_cash AS EWR_cash,
    EWR.paid_card AS EWR_card,
    Manhattan.paid_cash AS Manhattan_cash,
    Manhattan.paid_card AS Manhattan_card,
    Queens.paid_cash AS Queens_cash,
    Queens.paid_card AS Queens_card,
    Staten_Island.paid_cash AS Staten_Island_cash,
    Staten_Island.paid_card AS Staten_Island_card
FROM Bronx
LEFT JOIN Brooklyn ON Bronx.duration = Brooklyn.duration
LEFT JOIN EWR ON Bronx.duration = EWR.duration
LEFT JOIN Manhattan ON Bronx.duration = Manhattan.duration
LEFT JOIN Queens ON Bronx.duration = Queens.duration
LEFT JOIN Staten_Island ON Bronx.duration = Staten_Island.duration
UNION 
SELECT
	Bronx2.duration as mduration,
    Bronx2.paid_cash AS Bronx_cash,
    Bronx2.paid_card AS Bronx_card,
    Brooklyn2.paid_cash AS Brooklyn_cash,
    Brooklyn2.paid_card AS Brooklyn_card,
    EWR2.paid_cash AS EWR_cash,
    EWR2.paid_card AS EWR_card,
    Manhattan2.paid_cash AS Manhattan_cash,
    Manhattan2.paid_card AS Manhattan_card,
    Queens2.paid_cash AS Queens_cash,
    Queens2.paid_card AS Queens_card,
    Staten_Island2.paid_cash AS Staten_Island_cash,
    Staten_Island2.paid_card AS Staten_Island_card
FROM Bronx2
LEFT JOIN Brooklyn2 ON Bronx2.duration = Brooklyn2.duration
LEFT JOIN EWR2 ON Bronx2.duration = EWR2.duration
LEFT JOIN Manhattan2 ON Bronx2.duration = Manhattan2.duration
LEFT JOIN Queens2 ON Bronx2.duration = Queens2.duration
LEFT JOIN Staten_Island2 ON Bronx2.duration = Staten_Island2.duration
ORDER BY mduration ASC;

SELECT 'duration', 'Bronx_cash', 'Bronx_card', 'Brooklyn_cash', 'Brooklyn_card', 'EWR_cash', 'EWR_card', 'Manhattan_cash', 'Manhattan_card', 'Queens_cash', 'Queens_card', 'Staten_Island_cash', 'Staten_Island_card'
UNION ALL
SELECT *
FROM borough_agr_duration
INTO OUTFILE 'C:\\Users\\thoma\\Documents\\Data analysis\\nytaxi\\borough_agr_duration.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';


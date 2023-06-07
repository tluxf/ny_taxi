#All parts will create tables aggregating the data from taxi_data_proc in different ways
#Will then save table as a .csv file in the main directary


##############################
###Total number of payments###
##############################

DROP TABLE IF EXISTS agr_total_rides;

CREATE TABLE agr_total_rides
SELECT 
	COUNT(*) AS total_rides,
    SUM(IF(payment_type = "Cash", 1, 0)) AS paid_cash,
    SUM(IF(payment_type = "Card", 1, 0)) AS paid_card,
    SUM(IF(payment_type = "Other", 1, 0)) AS paid_other
FROM taxi_data_proc;

SELECT 'total_rides', 'paid_cash', 'paid_card', 'paid_other'
UNION ALL
SELECT *
FROM agr_total_rides
INTO OUTFILE 'C:\\Users\\thoma\\Documents\\Data analysis\\nytaxi\\agr_total_rides.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';


############################
###Rides per calendar day###
############################

#removes dates not in 2021. Most likely the date was entered incorrectly and shouldn't affect any tables other than this one

DROP TABLE IF EXISTS agr_date;

CREATE TABLE agr_date
SELECT
	date AS day,
    SUM(IF(payment_type = "Cash", 1, 0)) AS paid_cash,
    SUM(IF(payment_type = "Card", 1, 0)) AS paid_card
FROM taxi_data_proc
WHERE YEAR(date) = 2021 
GROUP BY day
ORDER BY day ASC;

SELECT 'day', 'paid_cash', 'paid_card'
UNION ALL
SELECT *
FROM agr_date
INTO OUTFILE 'C:\\Users\\thoma\\Documents\\Data analysis\\nytaxi\\agr_date.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';


#########################
###Rides by start time###
#########################

#strips seconds off of start time and gives as hh:mm. Rounded down.

DROP TABLE IF EXISTS agr_time;

CREATE TABLE agr_time
SELECT 
	TIME_FORMAT(start_time, '%H:%i') AS time_of_day,
    SUM(IF(payment_type = "Cash", 1, 0)) AS paid_cash,
    SUM(IF(payment_type = "Card", 1, 0)) AS paid_card
FROM taxi_data_proc
GROUP BY time_of_day
ORDER BY time_of_day ASC;

SELECT 'time', 'paid_cash', 'paid_card'
UNION ALL
SELECT *
FROM agr_time
INTO OUTFILE 'C:\\Users\\thoma\\Documents\\Data analysis\\nytaxi\\agr_time.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';


############################
###Rides by ride duration###
############################

#rounds duration to nearest minute
#removes rides with negative ride duration 

DROP TABLE IF EXISTS agr_duration;

CREATE TABLE agr_duration
SELECT
    ROUND(duration_min*12)/12 as duration,
    SUM(IF(payment_type = "Cash", 1, 0)) AS paid_cash,
    SUM(IF(payment_type = "Card", 1, 0)) AS paid_card
FROM taxi_data_proc
WHERE duration_min >= 0
GROUP BY duration
ORDER BY duration ASC;

SELECT 'duration', 'paid_cash', 'paid_card'
UNION ALL
SELECT *
FROM agr_duration
INTO OUTFILE 'C:\\Users\\thoma\\Documents\\Data analysis\\nytaxi\\agr_duration2.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';



############################
###Rides by ride distance###
############################

#rounds ride duration to one decimal place

DROP TABLE IF EXISTS agr_distance;

CREATE TABLE agr_distance
SELECT
    ROUND(distance_km,1) AS distance,
    SUM(IF(payment_type = "Cash", 1, 0)) AS paid_cash,
    SUM(IF(payment_type = "Card", 1, 0)) AS paid_card
FROM taxi_data_proc
GROUP BY distance
ORDER BY distance ASC
;

SELECT 'distance', 'paid_cash', 'paid_card'
UNION ALL
SELECT *
FROM agr_distance
INTO OUTFILE 'C:\\Users\\thoma\\Documents\\Data analysis\\nytaxi\\agr_distance.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';


########################
###Rides by ride fare###
########################

#rounds ride fare to the nearest half-integer
#filters out rides with negative fares

DROP TABLE IF EXISTS agr_fare;

CREATE TABLE agr_fare
SELECT
    round(fare*2)/2 AS ride_fare,
    SUM(IF(payment_type = "Cash", 1, 0)) AS paid_cash,
    SUM(IF(payment_type = "Card", 1, 0)) AS paid_card
FROM taxi_data_proc
WHERE fare >= 0
GROUP BY ride_fare
ORDER BY ride_fare ASC;

SELECT 'fare', 'paid_cash', 'paid_card'
UNION ALL
SELECT *
FROM agr_fare
INTO OUTFILE 'C:\\Users\\thoma\\Documents\\Data analysis\\nytaxi\\agr_fare.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';


##################
###Rides by tip###
##################

#rounds ride fare to the nearest half-integer
#filters out rides with negative fares

DROP TABLE IF EXISTS agr_tip;

CREATE TABLE agr_tip
SELECT
    round(tip*2)/2 AS ride_tip,
    SUM(IF(payment_type = "Cash", 1, 0)) AS paid_cash,
    SUM(IF(payment_type = "Card", 1, 0)) AS paid_card
FROM taxi_data_proc
WHERE tip >= 0
GROUP BY ride_tip
ORDER BY ride_tip ASC;

SELECT 'tip', 'paid_cash', 'paid_card'
UNION ALL
SELECT *
FROM agr_tip
INTO OUTFILE 'C:\\Users\\thoma\\Documents\\Data analysis\\nytaxi\\agr_tip.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';


#Creates new table with only the important fields
#Joins data from the taxi ride data table and the zone lookup table

DROP TABLE IF EXISTS taxi_data_proc;
SET @rank=0;
CREATE TABLE taxi_data_proc
SELECT 
	@rank := @rank+1 AS id,	#unique id, got from row in table as it is entered
    IF(ride.payment_type = 1, "Card", IF(ride.payment_type = 2, "Cash", "Other")) AS payment_type,	#payment type, converted from number to string, 1=card, 2=cash, other=other
    STR_TO_DATE(LEFT(ride.tpep_pickup_datetime,10), '%m/%d/%Y') AS date,	#gets date from pickup datetime
    TIME(STR_TO_DATE(ride.tpep_pickup_datetime, '%m/%d/%Y %r')) AS start_time, #gets pickup time
    ROUND(TIMESTAMPDIFF(SECOND, STR_TO_DATE(ride.tpep_pickup_datetime, '%m/%d/%Y %r'), STR_TO_DATE(ride.tpep_dropoff_datetime, '%m/%d/%Y %r'))/60, 2) as duration_min, #gets duration of ride in minutes
    ROUND(ride.trip_distance * 1.60934, 2) AS distance_km, #gets trip distance and converts to km
    MID(start_zn.Borough, 2, LENGTH(start_zn.Borough)-2) AS start_borough,	#start borough removes quotes
    MID(start_zn.Zone, 2, LENGTH(start_zn.Zone)-2) AS start_zone,	#start zone removes quotes
    MID(end_zn.Borough, 2, LENGTH(end_zn.Borough)-2) AS end_borough,	#end borough removes quotes
    MID(end_zn.Zone, 2, LENGTH(end_zn.Zone)-2) AS end_zone,	#end zone removes quotes
    ride.fare_amount AS fare,
    ride.tip_amount AS tip
FROM taxi_data_raw as ride
LEFT JOIN zone_lookup AS start_zn ON ride.PULocationID = start_zn.LocationID
LEFT JOIN zone_lookup AS end_zn ON ride.DOLocationID = end_zn.LocationID
;
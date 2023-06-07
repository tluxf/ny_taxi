################################################
#Creates table and loads taxi trip data into it#
################################################

#Enable loading in file
set GLOBAL local_infile = 1;

#Drop table if it exists
DROP TABLE IF EXISTS taxi_data_raw;

#Create empty table for taxi data
CREATE TABLE taxi_data_raw(
VendorID TEXT,
tpep_pickup_datetime VARCHAR(32),
tpep_dropoff_datetime VARCHAR(32),
passenger_count INT,
trip_distance FLOAT,
RatecodeID INT,
store_and_fwd_flag CHAR,
PULocationID INT,
DOLocationID INT,
payment_type INT,
fare_amount FLOAT,
extra FLOAT,
mta_tax FLOAT,
tip_amount FLOAT,
tolls_amount FLOAT,
improvement_surcharge FLOAT,
total_amount FLOAT,
congestion_surcharge FLOAT
);

#Load data from the csv file into the table
LOAD DATA LOCAL	
	INFILE "C:\\Users\\thoma\\Documents\\Data analysis\\nytaxi\\2021_Yellow_Taxi_Trip_Data.csv"
	INTO TABLE taxi_data_raw
    FIELDS TERMINATED BY ','
    lines terminated by '\n'
    IGNORE 1 rows;

############################################
#Creates table and loads taxi zones into it#
############################################

#Drop table if it exists
DROP TABLE IF EXISTS zone_lookup;
    
#Create empty table for taxi zones
CREATE TABLE zone_lookup(
LocationID INT, 
Borough VARCHAR(255), 
Zone VARCHAR(255), 
service_zone VARCHAR(255)
);

#Load data from the csv file into the table
LOAD DATA LOCAL
	INFILE "C:\\Users\\thoma\\Documents\\Data analysis\\nytaxi\\taxi+_zone_lookup.csv"
    INTO TABLE zone_lookup
    FIELDS TERMINATED BY ','
	LINES TERMINATED BY "\n"
    IGNORE 1 rows;


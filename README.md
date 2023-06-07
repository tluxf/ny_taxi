# ny_taxi
Data analysis project for New York City taxi rides in 2021

# Data Acquisition

The dataset was downloaded from https://catalog.data.gov/dataset/2021-yellow-taxi-trip-data-jan-jul in a file called ‘021_Yellow_Taxi_Trip_Data.csv’. A guide for the dataset is available at https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf The file was 2.9 GB, and contained 30,904,074 rows and 18 columns. Each row contained information about an individual taxi ride. The columns contained various attributes about the rides. The pickup and dropoff locations were given as integers, which corresponded to a borough and area, described by a lookup table, ‘taxi+_zone_lookup.csv’, which was downloaded from https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page. 

# Data Processing 

The taxi trip data file and the taxi zone lookup file were loaded into MySQL Workbench using the code in ‘nytaxi_load_to_sql.sql’. 

Using the code in ‘nytaxi_aggregate.sql’, a new data table was created, which imported only the important fields from the taxi ride data table. During the import, the following changes to the data were made: A new unique identifier column was created. The payment type was converted from an integer value to a string for increased readability. The ride start datetime were converted from a string to separate fields with the date and time. The duration of the ride in minutes was obtained from the start and end datetime fields. The start and end borough and zone for each ride was obtained from the zone lookup table. The fare and tip amounts were imported with no additional processing.

The processed data table was then aggregated in several different ways using the code in ‘nytaxi_aggregate.sql’ to produce smaller data sets which could be more easily analysed. The data was aggregated by cash and card payments, in addition to: total number of rides, rides per calendar day, rides by start time of day, rides by ride duration, rides by ride distance, rides by ride fare, and rides by tip amount. Each set of aggregated data was saved as a data table, and also exported as a .csv file. 

The processed data table was also aggregated in several more ways using the code in ‘nytaxi_aggregate_borough.sql’. In these aggregations, the data was aggregated by cash and card payments, the start borough, and one of the following: total number of payments, rides per calendar day, rides by time of day, and rides by ride duration. These were also saved as data tables and exported as .csv files.

# Data Analysis and Processing

All the .csv files exported during the aggregation of the data were imported into the excel workbook ‘taxi_data_analysis.xlsx’. Each data set was plotted as one or more graphs. 

For the distributions of ride duration, ride distance, ride fare, and ride duration broken down by borough, the modal average was determined by fitting a Gaussian function to the distributions using the ‘Solver’ add-in program of Excel.


--Creating database
create database citibike;

--Creating a new table
create or replace table trips
  (tripduration integer,
   starttime timestamp,
   stoptime timestamp,
   start_station_id integer,
   start_station_name string,
   start_station_latitude float,
   start_station_longitude float,
   end_station_id integer,
   end_station_name string,
   end_station_latitude float,
   end_station_longitude float,
   bikeid integer,
   membership_type string,
   usertype string,
   birth_year integer,
   gender integer);

--Grant usage on the database:
GRANT USAGE ON DATABASE <database> TO ROLE <role>;

--Grant usage on the schema:
GRANT USAGE ON SCHEMA <database>.<schema> TO ROLE <role>;

--Create stage from AWS C3 location
CREATE STAGE "CITIBIKE"."PUBLIC".citibike_trips URL = 's3://snowflake-workshop-lab/citibike-trips';

--To check the content of the staged file
list @citibike_trips;

--To create the file format
CREATE FILE FORMAT "CITIBIKE"."PUBLIC".CSV
  TYPE = 'CSV'
  COMPRESSION = 'AUTO'
  FIELD_DELIMITER = ','
  RECORD_DELIMITER = '\n'
  SKIP_HEADER = 0
  FIELD_OPTIONALLY_ENCLOSED_BY = '\042'
  TRIM_SPACE = FALSE
  ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
  ESCAPE = 'NONE'
  ESCAPE_UNENCLOSED_FIELD = '\134'
  DATE_FORMAT = 'AUTO'
  TIMESTAMP_FORMAT = 'AUTO'
  NULL_IF = ('');

--To load the data from stage to Table
copy into trips from @citibike_trips file_format=CSV;

--Truncate table trips;
truncate table trips;
